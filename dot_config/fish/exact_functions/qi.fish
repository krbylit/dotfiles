function qi --description "Open inbox, or append a timestamped task to inbox.md"
    # Check if OBSIDIAN_VAULT_PATH is set
    if not set -q OBSIDIAN_VAULT_PATH
        echo "Error: OBSIDIAN_VAULT_PATH environment variable not set" >&2
        return 1
    end

    set -l inbox_dir "$OBSIDIAN_VAULT_PATH/00_Inbox"
    set -l inbox_path "$inbox_dir/inbox.md"

    # Create inbox directory if needed
    if not test -d "$inbox_dir"
        if not mkdir -p "$inbox_dir"
            echo "Error: Failed to create directory $inbox_dir" >&2
            return 1
        end
    end

    # Create inbox.md with minimal frontmatter if missing
    if not test -f "$inbox_path"
        set -l iso_now (date '+%Y-%m-%dT%H:%M:%S')
        printf '---\nid: inbox\naliases: []\ntags: []\ncreated: %s\nupdated: %s\n---\n' \
            "$iso_now" "$iso_now" > "$inbox_path"
    end

    # Zero args: open inbox at bottom in nvim
    if test (count $argv) -eq 0
        nvim '+normal G' "$inbox_path"
        return 0
    end

    # Build task text from all args
    set -l task_text (string join ' ' $argv)
    set -l timestamp (date '+%Y-%m-%d %H:%M')
    set -l iso_now (date '+%Y-%m-%dT%H:%M:%S')

    # Append timestamped task to inbox
    printf '- [ ] %s _(captured %s)_\n' "$task_text" "$timestamp" >> "$inbox_path"

    # Update 'updated:' frontmatter — insert field if absent
    if grep -q '^updated:' "$inbox_path"
        sed -i '' "s/^updated: .*/updated: $iso_now/" "$inbox_path"
    else
        sed -i '' "s/^created: .*/&\nupdated: $iso_now/" "$inbox_path"
    end

    echo "Added to inbox"
end
