function tt --description "Add a todo item to today's Obsidian daily note"
    set -l vault "$HOME/obsidian-vault"
    set -l daily_dir "$vault/07_Notes/00_Daily"
    set -l today (date +%Y-%m-%d)
    set -l daily_file "$daily_dir/$today.md"

    if not test -f "$daily_file"
        echo "Daily note not found: $daily_file"
        return 1
    end

    # Get the todo content
    set -l todo_content
    if test -n "$argv"
        set todo_content "$argv"
    else
        read -P "Today TODO: " todo_content
        if test -z "$todo_content"
            return 0
        end
    end

    # Build new file content, inserting todo above "## Notes"
    set -l tmpfile (mktemp)
    set -l inserted false
    while read -l line
        if test "$inserted" = false; and string match -q '## Notes' -- "$line"
            echo "- [ ] $todo_content" >>"$tmpfile"
            echo "" >>"$tmpfile"
            set inserted true
        end
        echo "$line" >>"$tmpfile"
    end <"$daily_file"

    if test "$inserted" = false
        # No ## Notes section found, append to end
        echo "- [ ] $todo_content" >>"$tmpfile"
    end

    mv "$tmpfile" "$daily_file"
    echo "TODO added to today's daily note"
end
