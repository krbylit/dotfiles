function prs --description 'Search GitHub PRs authored by me or requesting my review'
    # Template for formatting output (matches gh's original style)
    set -l format_template '{{tablerow (autocolor "blue+u" "REPO") (autocolor "blue+u" "ID") (autocolor "blue+u" "TITLE") (autocolor "blue+u" "UPDATED") (autocolor "blue+u" "URL")}}{{range .}}{{tablerow .repository.nameWithOwner (printf "#%v" .number | autocolor "green") .title (timeago .updatedAt | autocolor "white+d") (hyperlink .url .url)}}{{end}}{{tablerender}}'168c9a5

    switch $argv[1]
        case me
            gh search prs --author=@me --state=open --json number,title,repository,updatedAt,url --template $format_template
        case req
            # PRs requesting review where you haven't started reviewing at all (no reviews)
            set -l username (gh api user -q .login)
            set -l all_prs_json (gh search prs --review-requested=@me --state=open --json number,title,repository,updatedAt,url)

            # Filter: include PRs with NO reviews from you at all
            set -l filtered_prs_json (echo $all_prs_json | jq -c '.[]' | while read -l pr
                set -l repo (echo $pr | jq -r '.repository.nameWithOwner')
                set -l number (echo $pr | jq -r '.number')

                # Check if user has any reviews at all
                set -l review_count (gh api "repos/$repo/pulls/$number/reviews" -q "[.[] | select(.user.login == \"$username\")] | length")

                if test "$review_count" = "0"
                    echo $pr
                end
            end | jq -s '.')

            # Use miller for clean table formatting, then colorize
            if test "$filtered_prs_json" != "[]"
                set -l term_width (tput cols)
                set -l max_title_width (math "$term_width - 119")
                if test $max_title_width -lt 20
                    set max_title_width 20
                end

                echo $filtered_prs_json | jq -c --argjson max_title "$max_title_width" '.[] | {
                    repo: .repository.nameWithOwner,
                    id: ("#" + (.number | tostring)),
                    title: (if (.title | length) > $max_title then (.title[0:$max_title-3] + "...") else .title end),
                    updated: (.updatedAt | fromdateiso8601 |
                        (now - .) |
                        if . < 60 then "just now"
                        elif . < 3600 then ((. / 60 | floor | tostring) + " minutes ago")
                        elif . < 86400 then ((. / 3600 | floor | tostring) + " hours ago")
                        elif . < 2592000 then ((. / 86400 | floor | tostring) + " days ago")
                        else ((. / 2592000 | floor | tostring) + " months ago")
                        end),
                    url: .url
                }' | mlr --ijson --opprint cat | awk '
                    NR==1 {
                        # Colorize header with blue underline
                        gsub(/repo/, "\033[34;4mrepo\033[0m")
                        gsub(/id/, "\033[34;4mid\033[0m")
                        gsub(/title/, "\033[34;4mtitle\033[0m")
                        gsub(/updated/, "\033[34;4mupdated\033[0m")
                        gsub(/url/, "\033[34;4murl\033[0m")
                        print
                        next
                    }
                    {
                        # Colorize PR numbers (green) and timestamps (dimmed)
                        gsub(/#[0-9]+/, "\033[32m&\033[0m")
                        gsub(/[0-9]+ (hours?|days?|months?) ago|just now/, "\033[37;2m&\033[0m")
                        print
                    }
                '
            else
                echo "No PRs found"
            end
        case todo
            # PRs where you have ONLY pending/draft reviews (not submitted)
            set -l username (gh api user -q .login)
            set -l all_prs_json (gh search prs --review-requested=@me --state=open --json number,title,repository,updatedAt,url)

            # Filter: include PRs with ONLY PENDING reviews (has reviews, but all are PENDING)
            set -l filtered_prs_json (echo $all_prs_json | jq -c '.[]' | while read -l pr
                set -l repo (echo $pr | jq -r '.repository.nameWithOwner')
                set -l number (echo $pr | jq -r '.number')

                # Check review states
                set -l review_count (gh api "repos/$repo/pulls/$number/reviews" -q "[.[] | select(.user.login == \"$username\")] | length")
                set -l pending_count (gh api "repos/$repo/pulls/$number/reviews" -q "[.[] | select(.user.login == \"$username\" and .state == \"PENDING\")] | length")

                # Include if: has reviews AND all are PENDING
                if test "$review_count" != "0" -a "$review_count" = "$pending_count"
                    echo $pr
                end
            end | jq -s '.')

            # Use gh's formatting by writing to temp file and using gh pr list with ids
            if test "$filtered_prs_json" != "[]"
                # Use miller for clean table formatting, then colorize
                set -l term_width (tput cols)
                # Calculate max title width: terminal - repo(30) - id(6) - updated(15) - url(60) - gaps(8) = ~100
                set -l max_title_width (math "$term_width - 119")
                if test $max_title_width -lt 20
                    set max_title_width 20
                end

                echo $filtered_prs_json | jq -c --argjson max_title "$max_title_width" '.[] | {
                    repo: .repository.nameWithOwner,
                    id: ("#" + (.number | tostring)),
                    title: (if (.title | length) > $max_title then (.title[0:$max_title-3] + "...") else .title end),
                    updated: (.updatedAt | fromdateiso8601 |
                        (now - .) |
                        if . < 60 then "just now"
                        elif . < 3600 then ((. / 60 | floor | tostring) + " minutes ago")
                        elif . < 86400 then ((. / 3600 | floor | tostring) + " hours ago")
                        elif . < 2592000 then ((. / 86400 | floor | tostring) + " days ago")
                        else ((. / 2592000 | floor | tostring) + " months ago")
                        end),
                    url: .url
                }' | mlr --ijson --opprint cat | awk '
                    NR==1 {
                        # Colorize header with blue underline
                        gsub(/repo/, "\033[34;4mrepo\033[0m")
                        gsub(/id/, "\033[34;4mid\033[0m")
                        gsub(/title/, "\033[34;4mtitle\033[0m")
                        gsub(/updated/, "\033[34;4mupdated\033[0m")
                        gsub(/url/, "\033[34;4murl\033[0m")
                        print
                        next
                    }
                    {
                        # Colorize PR numbers (green) and timestamps (dimmed)
                        gsub(/#[0-9]+/, "\033[32m&\033[0m")
                        gsub(/[0-9]+ (hours?|days?|months?) ago|just now/, "\033[37;2m&\033[0m")
                        print
                    }
                '
            else
                echo "No PRs found"
            end
        case done
            # PRs requesting review where you have actually submitted a review (not just pending)
            set -l username (gh api user -q .login)
            set -l all_prs_json (gh search prs --review-requested=@me --state=open --json number,title,repository,updatedAt,url)

            # Filter: only PRs with non-PENDING reviews
            set -l filtered_prs_json (echo $all_prs_json | jq -c '.[]' | while read -l pr
                set -l repo (echo $pr | jq -r '.repository.nameWithOwner')
                set -l number (echo $pr | jq -r '.number')

                # Check if user has any non-PENDING reviews
                set -l has_submitted (gh api "repos/$repo/pulls/$number/reviews" -q "[.[] | select(.user.login == \"$username\" and .state != \"PENDING\")] | length > 0")

                if test "$has_submitted" = true
                    echo $pr
                end
            end | jq -s '.')

            # Use miller for clean table formatting, then colorize
            if test "$filtered_prs_json" != "[]"
                set -l term_width (tput cols)
                # Calculate max title width: terminal - repo(30) - id(6) - updated(15) - url(60) - gaps(8) = ~100
                set -l max_title_width (math "$term_width - 119")
                if test $max_title_width -lt 20
                    set max_title_width 20
                end

                echo $filtered_prs_json | jq -c --argjson max_title "$max_title_width" '.[] | {
                    repo: .repository.nameWithOwner,
                    id: ("#" + (.number | tostring)),
                    title: (if (.title | length) > $max_title then (.title[0:$max_title-3] + "...") else .title end),
                    updated: (.updatedAt | fromdateiso8601 |
                        (now - .) |
                        if . < 60 then "just now"
                        elif . < 3600 then ((. / 60 | floor | tostring) + " minutes ago")
                        elif . < 86400 then ((. / 3600 | floor | tostring) + " hours ago")
                        elif . < 2592000 then ((. / 86400 | floor | tostring) + " days ago")
                        else ((. / 2592000 | floor | tostring) + " months ago")
                        end),
                    url: .url
                }' | mlr --ijson --opprint cat | awk '
                    NR==1 {
                        # Colorize header with blue underline
                        gsub(/repo/, "\033[34;4mrepo\033[0m")
                        gsub(/id/, "\033[34;4mid\033[0m")
                        gsub(/title/, "\033[34;4mtitle\033[0m")
                        gsub(/updated/, "\033[34;4mupdated\033[0m")
                        gsub(/url/, "\033[34;4murl\033[0m")
                        print
                        next
                    }
                    {
                        # Colorize PR numbers (green) and timestamps (dimmed)
                        gsub(/#[0-9]+/, "\033[32m&\033[0m")
                        gsub(/[0-9]+ (hours?|days?|months?) ago|just now/, "\033[37;2m&\033[0m")
                        print
                    }
                '
            else
                echo "No PRs found"
            end
        case '*'
            echo "Usage: prs [me|req|todo|done]"
            echo "  me       - List PRs authored by you"
            echo "  req      - List PRs requesting your review (not started yet)"
            echo "  todo     - List PRs where you have pending/draft reviews (started but not submitted)"
            echo "  done     - List PRs where you have submitted reviews"
            return 1
    end
end
