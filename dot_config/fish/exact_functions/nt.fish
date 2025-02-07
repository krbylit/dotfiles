# Add fn: 
# We may want to use `nb tasks` as base command instead of `nb todos` so we can list/operate on tasks
# Args get appended to base `nb todos todos/ <argv>`, so we store all todos in the 'todos' folder.
# Main idea is that `nt` provides wrapper to always work on the 'todos/' folder so they stay organized in there. Should enable basic functionality like `nt` to list all todos in 'todos/' (this would run `nb todos todos/`), `nt <do|undo> <todoID>` (would run `nb <do|undo> todos/<todoID>`.
# All functionality should account for 'folders' arg if provided, so `nt <do|undo> <todoID> <folder>` would run `nb <do|undo> todos/<folder>/<todoID>`.
# First arg must either be title or <do|undo>. If neither are provided but a folder/taskID is, then we should list todos if just folder given or edit the todo if taskID is present (possible to give folder path to taskID as well).
# If we get <do|undo> as first arg, we short circuit and just look for a <folder/taskID> arg (required). Folder is optional but taskID is required, if not present then it's an error.
# So we need to parse args similarly to our `nq` func, must identify folders by trailing '/' and taskIDs by leading '/' with no subsequent '/' following.
# If a taskID is present, we should be calling `nb todos edit` instead of `nb todos add`
# May have to provide special handling for tasks, which take the form of `<todoID> <taskID>`, so we'll have to parse on the space.
# arg1: title (req)
# perhaps parse addtl args on text so we can pass them in in any order
# arg2: description (opt) (look for basic string after arg1. gets `--description "<desc>"`)
# arg3: tasks (opt) (parse on '-', allowing multiple tasks in one string. each '- <task>' gets `--task "<task>"`. also parse to allow no space, unquoted arg like `-task1,-task2`, separate on comma)
# arg4: related (opt) (parse on 'http' or '[[]]'. each gets `--related "<url|selector>"`)
# arg5: tags (opt) (parse on '#', similar to tasks. also allow no space, unquoted arg like '#tag1,#tag2', separate on comma. all tags get collected into `--tags <tag1>,<tag2>`)
# arg6: folders/path (opt) (parse for any '/' in arg. appended to the base 'todos/' folder arg e.g. `nb todos todos/<arg6> <argv>`)
function nt
    switch (count $argv)
        case 0
            nb todos open todos/
            return 0
        case 1
            if string match -q -r "^l\$" $argv[1]
                nb list todos/
                return 0
            else if string match -q -r "^c\$" $argv[1]
                nb todos closed todos/
                return 0
            else if string match -q -r "^o\$" $argv[1]
                nb todos open todos/
                return 0
            else
                # break
            end
    end
    set -l args (_nb_parse_todo_args $argv)
    set -l path $args[1]
    set -l todo_id $args[2]
    set -l title $args[3]
    set -l description $args[4]
    set -l tasks $args[5]
    set -l related $args[6]
    set -l tags $args[7]
    set -l cmd $args[8]

    set -l command ""
    if string match -q "folder*" $cmd || string match -q "d*" $cmd || string match -q "e*" $cmd || string match -q move $cmd #|| string match -q "l*" $cmd
        # string match -q "l*" $cmd && set cmd list
        set command nb
    else
        set command "nb todos"
    end

    test -n "$cmd" && set command "$command $cmd"
    set command "$command todos/$path$todo_id"
    test -n "$title" && set command "$command '$title'"
    test -n "$description" && set command "$command --description $description"
    test -n "$related" && set command "$command --related $related"
    # nb todos "$cmd"todos/$path$todo_id "$title" --description $description --related $related
    # --task $tasks --tags $tags

    # if test -n "$content"
    #     nb todos add todos/ "$content"
    # else
    #     nb todos todos/
    # end
    eval $command
end
