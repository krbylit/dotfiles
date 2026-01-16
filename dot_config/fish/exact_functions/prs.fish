function prs --description 'Search GitHub PRs authored by me or requesting my review'
    switch $argv[1]
        case me
            gh search prs --author=@me --state=open
        case req
            gh search prs --review-requested=@me --state=open
        case todo
            # PRs requesting review where you haven't submitted a review yet
            gh search prs --review-requested=@me --state=open -- "-reviewed-by:@me"
        case done
            # PRs requesting review where you have submitted a review
            # NOTE: Pending/draft reviews that are open but not submitted are counted as submitted here
            gh search prs --review-requested=@me --reviewed-by=@me --state=open
        case '*'
            echo "Usage: prs [me|req|pending|reviewed]"
            echo "  me       - List PRs authored by you"
            echo "  req      - List PRs requesting your review (all)"
            echo "  pending  - List PRs requesting your review (not yet reviewed/submitted)"
            echo "  reviewed - List PRs requesting your review (already reviewed/submitted)"
            return 1
    end
end
