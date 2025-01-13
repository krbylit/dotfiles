function _nb_parse_todo_args
    # Initialize variables
    set -l path ""
    set -l todo_id "" # General, used for todos and tasks
    set -l title ""
    set -l description ""
    set -l tasks ""
    set -l related ""
    set -l tags ""
    set -l cmd ""

    for arg in $argv
        if string match -q -r "^do\$" $arg || string match -q -r "^(un|undo)\$" $arg || string match -q -r "^(e|ed|edit)\$" $arg || string match -q -r "^move\$" $arg || string match -q -r "^(d|del|delete)\$" $arg || string match -q -r "^(l|list)\$" $arg || string match -q -r "^(a|add)\$" $arg
            # Set $cmd
            set cmd $arg
            continue
        else if string match -q "/*" $arg || string match -q "*/" $arg
            # Set $path and $todo_id
            set todo_id (string match -r --groups-only ".*/(.*)\$" $arg)
            set path (string match -r --groups-only "(.*/).*\$" $arg)
            # Set empty path instead of "/"
            if test (string length $path) -eq 1
                set path ""
            end
            continue
        else if string match -q "\-*" $arg
            # Set $tasks
            # Replace commas with newlines since later we will need to input them one-by-one
            set tasks (string replace -r -q "-\s*" "" $arg)
            set tasks (string replace -q "," "\n" $arg)
            continue
        else if string match -q "[[*]]" $arg
            # Set $related reference
            set related (string replace -q "\[\[" "" $arg)
            set related (string replace -q "\]\]" "" $arg)
            continue
        else if string match -q "http?://" $arg
            # Set $related URL
            set related $arg
            continue
        else if string match -q "#*" $arg
            # Set $tags
            set tags (string replace -r -q "#\s*" "" $arg)
            # set tags (string replace -r -q "#\s*" "" $arg)
            # set tags (string replace -q "," "\n" $arg)
            continue
        else if string match -q -r "^\*" $arg
            # Set $description
            set description $arg
            continue
        else
            # Set $title as fallback since it is just a bare string
            set title $arg
            set cmd add
            continue
        end

    end

    if test -z "$cmd"
        # if test -n "$title"
        #     set cmd add
        # end

        # if test -z "$todo_id"
        #     if test -z "$title" && test -n "$path"
        #         set cmd list
        #     end
        #     set cmd add
        # else if test -n "$todo_id"
        #     set cmd edit
        # end

        set full_path (string join "" $path $todo_id)
        if test (nb list todos/$full_path)
            set todo_item (nb list todos/$full_path)
            if test -n "$todo_id"
                if string match -q -r "todos/$full_path.*\[\ \]" $todo_item
                    set cmd do
                else
                    set cmd undo
                end
                # TODO: possibly add handling for being able to edit with `nt path/id/` but default behavior should be toggle do/undo
                # set cmd edit
            else
                set cmd list
            end
        else
            set cmd "folders add"
        end
    end
    if test -z "$todo_id" && test -n "$path"
        set path (string match -r --groups-only "(.*)/\$" $path)
    end

    # Output results
    echo -e "$path\n$todo_id\n$title\n$description\n$tasks\n$related\n$tags\n$cmd"
end
