function prs --description 'Search GitHub PRs authored by me or requesting my review'
    switch $argv[1]
        case me
            gh search prs --author=@me --state=open --json number,title,repository,updatedAt,url --template '{{tablerow (autocolor "blue+u" "REPO") (autocolor "blue+u" "ID") (autocolor "blue+u" "TITLE") (autocolor "blue+u" "UPDATED") (autocolor "blue+u" "URL")}}{{range .}}{{tablerow .repository.nameWithOwner (printf "#%v" .number | autocolor "green") .title (timeago .updatedAt | autocolor "white+d") (hyperlink .url .url)}}{{end}}{{tablerender}}'
        case req
            gh search prs --review-requested=@me --state=open --json number,title,repository,updatedAt,url --template '{{tablerow (autocolor "blue+u" "REPO") (autocolor "blue+u" "ID") (autocolor "blue+u" "TITLE") (autocolor "blue+u" "UPDATED") (autocolor "blue+u" "URL")}}{{range .}}{{tablerow .repository.nameWithOwner (printf "#%v" .number | autocolor "green") .title (timeago .updatedAt | autocolor "white+d") (hyperlink .url .url)}}{{end}}{{tablerender}}'
        case todo
            # PRs requesting review where you haven't submitted a review yet
            gh search prs --review-requested=@me --state=open --json number,title,repository,updatedAt,url --template '{{tablerow (autocolor "blue+u" "REPO") (autocolor "blue+u" "ID") (autocolor "blue+u" "TITLE") (autocolor "blue+u" "UPDATED") (autocolor "blue+u" "URL")}}{{range .}}{{tablerow .repository.nameWithOwner (printf "#%v" .number | autocolor "green") .title (timeago .updatedAt | autocolor "white+d") (hyperlink .url .url)}}{{end}}{{tablerender}}' -- "-reviewed-by:@me"
        case done
            # PRs requesting review where you have submitted a review
            # NOTE: Pending/draft reviews that are open but not submitted are counted as submitted here
            gh search prs --review-requested=@me --reviewed-by=@me --state=open --json number,title,repository,updatedAt,url --template '{{tablerow (autocolor "blue+u" "REPO") (autocolor "blue+u" "ID") (autocolor "blue+u" "TITLE") (autocolor "blue+u" "UPDATED") (autocolor "blue+u" "URL")}}{{range .}}{{tablerow .repository.nameWithOwner (printf "#%v" .number | autocolor "green") .title (timeago .updatedAt | autocolor "white+d") (hyperlink .url .url)}}{{end}}{{tablerender}}'
        case '*'
            echo "Usage: prs [me|req|todo|done]"
            echo "  me       - List PRs authored by you"
            echo "  req      - List PRs requesting your review (all)"
            echo "  todo  - List PRs requesting your review (not yet done/submitted)"
            echo "  done - List PRs requesting your review (already reviewed/submitted)"
            return 1
    end
end
