function prs --description 'Search GitHub PRs authored by me or requesting my review'
    # Collect all filter types from arguments
    set -l filters
    for arg in $argv
        if contains $arg me req todo done
            set -a filters $arg
        end
    end

    # Default to help if no valid filters
    if test (count $filters) -eq 0
        echo "Usage: prs [me|req|todo|done]..."
        echo "  me       - List PRs authored by you"
        echo "  req      - List PRs requesting your review (not started yet)"
        echo "  todo     - List PRs where you have pending/draft reviews (started but not submitted)"
        echo "  done     - List PRs where you have submitted reviews"
        echo ""
        echo "You can combine filters: prs req todo"
        return 1
    end

    # Process 'me' separately (different data source)
    set -l me_prs_json "[]"
    if contains me $filters
        set me_prs_json (gh search prs --author=@me --state=open --json number,title,repository,updatedAt,url)
        if not printf '%s\n' $me_prs_json | jq -e 'type == "array"' >/dev/null 2>&1
            set me_prs_json "[]"
        end
    end

    # Process review-related filters (req, todo, done) - same data source
    set -l review_filters
    if contains req $filters
        set -a review_filters req
    end
    if contains todo $filters
        set -a review_filters todo
    end
    if contains done $filters
        set -a review_filters done
    end

    set -l review_prs_json "[]"
    if test (count $review_filters) -gt 0
        set -l username (gh api user -q .login)
        set -l all_review_prs_json (gh search prs --review-requested=@me --state=open --json number,title,repository,updatedAt,url)

        if printf '%s\n' $all_review_prs_json | jq -e 'type == "array"' >/dev/null 2>&1
            if test "$all_review_prs_json" != "[]"
                # Filter PRs based on review states
                set review_prs_json (printf '%s\n' $all_review_prs_json | jq -c '.[]' | while read -l pr
                    test -n "$pr" || continue
                    printf '%s\n' "$pr" | jq -e '. | has("repository")' >/dev/null 2>&1 || continue

                    set -l repo (printf '%s\n' "$pr" | jq -r '.repository.nameWithOwner' 2>/dev/null)
                    set -l number (printf '%s\n' "$pr" | jq -r '.number' 2>/dev/null)

                    set -l review_count (gh api "repos/$repo/pulls/$number/reviews" -q "[.[] | select(.user.login == \"$username\")] | length")
                    set -l pending_count (gh api "repos/$repo/pulls/$number/reviews" -q "[.[] | select(.user.login == \"$username\" and .state == \"PENDING\")] | length")
                    set -l has_submitted (gh api "repos/$repo/pulls/$number/reviews" -q "[.[] | select(.user.login == \"$username\" and .state != \"PENDING\")] | length > 0")

                    set -l include false
                    # Check each filter
                    if contains req $review_filters
                        # No reviews at all
                        if test "$review_count" = "0"
                            set include true
                        end
                    end
                    if contains todo $review_filters
                        # Has reviews AND all are PENDING
                        if test "$review_count" != "0" -a "$review_count" = "$pending_count"
                            set include true
                        end
                    end
                    if contains done $review_filters
                        # Has non-PENDING reviews
                        if test "$has_submitted" = true
                            set include true
                        end
                    end

                    if test "$include" = true
                        printf '%s\n' "$pr"
                    end
                end | jq -sc '. // []')
            end
        end
    end

    # Merge, deduplicate, and sort PRs from both sources by updated date (most recent first)
    set -l combined_prs_json (printf '%s\n%s\n' "$me_prs_json" "$review_prs_json" | jq -s 'add | unique_by(.repository.nameWithOwner + "-" + (.number | tostring)) | sort_by(.updatedAt) | reverse')

    # Display results
    if test "$combined_prs_json" != "[]"
        set -l term_width (tput cols)
        set -l max_title_width (math "$term_width - 119")
        if test $max_title_width -lt 20
            set max_title_width 20
        end

        begin
            printf '"repo","id","title","updated","url"\n'
            printf '%s\n' "$combined_prs_json" | jq -r --argjson max_title "$max_title_width" '
            .[] | [
                .repository.nameWithOwner,
                ("#" + (.number | tostring)),
                (if (.title | length) > $max_title then (.title[0:$max_title-3] + "...") else .title end),
                (.updatedAt | fromdateiso8601 |
                    (now - .) |
                    if . < 60 then "just now"
                    elif . < 3600 then ((. / 60 | floor | tostring) + " minutes ago")
                    elif . < 86400 then ((. / 3600 | floor | tostring) + " hours ago")
                    elif . < 2592000 then ((. / 86400 | floor | tostring) + " days ago")
                    else ((. / 2592000 | floor | tostring) + " months ago")
                    end),
                .url
            ] | @csv
        '
        end | tbl --header-color blue \
            --column-color 2:green \
            --column-dim 4 \
            --style rounded \
            --max-width $term_width
    else
        echo "No PRs found"
    end
end
