# Quick note feature. Smartly adds single argument cmds as quick notes to a daily note in the 'notes' folder. If two args are given (1:path, 2:content), then either creates a new note for the content or appends to the existing note.
# Usage:
# `nq <arg1> <arg2>`
# 'arg2' is always interpreted as note content (passed to `nb --content`).
# 'arg1' can be folder/path, filename, or content. Folders/filenames must be identified by trailing `/` or leading `/`, respectively (i.e. `folder/` or `/filename`). Absence of `/` in 'arg1' always results in it being interpreted as content. TODO: add handling for ability to take var args for more content, i.e. `nq arg1 arg2 .. argN` -> `nb <..> --content "arg1|2" <..> --content "argN"`
# `nq` to list all in notes/
# `nq "content"` to add to existing or create new note for today
# `nq <path>/filename` edit file in notes/ if exists, else create new file w/ filename
function nq --wraps=nb --description 'alias nq nb'
    if test (count $argv) -eq 0
        nb notes/
        return 0
    end
    set parsed_args (_nb_parse_note_args $argv)
    set path $parsed_args[1]
    set filename $parsed_args[2]
    set content $parsed_args[3]
    # If only content is provided
    # `nq "new note content"`
    # TODO: add handling for just `dir/` and no filename
    if test -z "$path" -a -z "$filename" -a -n "$content"
        # Check if we have a quicknote for today
        set -l today (date "+%Y%m%d")
        set -l todays_note (nb list notes/ | rg -N "^.*("$today"\d{6}\.md).*\$" --replace '$1')

        if test -n "$todays_note"
            # Add to today's existing note
            nb edit notes/$todays_note --content "$content"
        else
            # Create a new quicknote with content
            nb add notes/ --content "$content"
        end

        # If just filename is provided, edit existing `notes/<filename>` or create new `notes/<filename>`
    else
        set path "notes/$parsed_args[1]"
        _nb_upsert_note $path $filename $content
    end
end
