function ni --wraps=nb --description 'Helper for `nb` ideas/ folder'
    set parsed_args (_nb_parse_note_args $argv)
    set parsed_args (string split "\n" $parsed_args)
    set path $parsed_args[1]
    set filename $parsed_args[2]
    set content $parsed_args[3]
    # Turn content into a task
    test -n "$content" && set content "- [ ] $content"
    if test -n "$filename"
        set filename (string replace ".md" "" $filename)
        set todo_item (nb tasks ideas/inbox.md $filename)
        if test -n "$todo_item"
            if string match -q -r "ideas/\d.*\ .*$filename.*\ .*\[.*\ .*\]" $todo_item
                nb do ideas/inbox.md $filename
                return 0
            else
                nb undo ideas/inbox.md $filename
                return 0
            end
        end
    else if test -z "$path" -a -n "$content"
        # If only content is provided
        nb list ideas/inbox.md && nb edit ideas/inbox.md --content "$content" || nb add ideas/inbox.md --content "$content"
        # If both path and content are provided
    else if test -n "$path" -a -n "$content"
        nb list ideas/$path && nb edit ideas/$path --content $content || nb add ideas/$path --content $content
    else if test -n "$path" -a -z "$content"
        nb list ideas/$path && nb edit ideas/$path || nb add ideas/$path --edit
    else
        nb tasks open ideas/
        return 0
    end
end
