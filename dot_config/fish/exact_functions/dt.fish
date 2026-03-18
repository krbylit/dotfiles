function dt --description "Open today's daily note, or append a task under ## Tasks"
    # Check if OBSIDIAN_VAULT_PATH is set
    if not set -q OBSIDIAN_VAULT_PATH
        echo "Error: OBSIDIAN_VAULT_PATH environment variable not set" >&2
        return 1
    end

    set -l today (date +%Y-%m-%d)
    set -l daily_dir "$OBSIDIAN_VAULT_PATH/07_Notes/00_Daily"
    set -l note_path "$daily_dir/$today.md"
    set -l template_path "$OBSIDIAN_VAULT_PATH/06_Metadata/Templates/obsidian-daily-note.md"

    # Create daily directory if needed
    if not test -d "$daily_dir"
        if not mkdir -p "$daily_dir"
            echo "Error: Failed to create directory $daily_dir" >&2
            return 1
        end
    end

    # Create note from template if missing
    if not test -f "$note_path"
        if not test -f "$template_path"
            echo "Error: Template not found at $template_path" >&2
            return 1
        end

        set -l heading (date '+%A %Y-%m-%d')
        set -l time_now (date '+%H:%M')
        set -l iso_now (date '+%Y-%m-%dT%H:%M:%S')
        set -l alias_date (date '+%B %d, %Y')

        # Build frontmatter
        set -l frontmatter "---
id: $today
aliases:
  - $alias_date
tags:
  - daily-notes
created: $iso_now
updated: $iso_now
---"

        # Read template and substitute placeholders
        set -l template_body (cat "$template_path")
        set template_body (string replace '{{daily_heading}}' "$heading" $template_body)
        set template_body (string replace '{{time}}' "$time_now" $template_body)
        set template_body (string replace '{{date}}' "$today" $template_body)

        # Write frontmatter + template body
        printf '%s\n%s\n' "$frontmatter" "$template_body" > "$note_path"
    end

    # Zero args: open in nvim
    if test (count $argv) -eq 0
        nvim "$note_path"
        return 0
    end

    # Build task text from all args
    set -l task_text (string join ' ' $argv)
    set -l iso_now (date '+%Y-%m-%dT%H:%M:%S')

    # Write awk output to temp file, then atomically replace
    set -l tmp_path "$note_path.tmp"
    set -l bak_path "$note_path.bak"

    # awk state machine: find ## Tasks section, replace bare placeholder or
    # append after last task line (before blank line preceding next ## heading)
    awk -v task="- [ ] $task_text" '
        BEGIN {
            in_tasks = 0
            found_placeholder = 0
            last_task_line = -1
            line_count = 0
        }
        {
            lines[line_count] = $0
            line_count++
        }
        END {
            # First pass: find ## Tasks section boundaries and task lines
            in_tasks = 0
            tasks_start = -1
            tasks_end = line_count

            for (i = 0; i < line_count; i++) {
                if (lines[i] ~ /^## Tasks$/) {
                    in_tasks = 1
                    tasks_start = i
                    continue
                }
                if (in_tasks && lines[i] ~ /^## / && i != tasks_start) {
                    tasks_end = i
                    in_tasks = 0
                }
            }

            # If no ## Tasks section found, insert one before first ## heading
            if (tasks_start == -1) {
                insert_at = -1
                for (i = 0; i < line_count; i++) {
                    if (lines[i] ~ /^## /) {
                        insert_at = i
                        break
                    }
                }
                if (insert_at == -1) insert_at = line_count

                for (i = 0; i < insert_at; i++) print lines[i]
                print "## Tasks"
                print ""
                print task
                print ""
                for (i = insert_at; i < line_count; i++) print lines[i]
                exit
            }

            # Find bare placeholder or last task line within the section
            placeholder_line = -1
            last_task = -1
            for (i = tasks_start + 1; i < tasks_end; i++) {
                if (lines[i] == "- [ ]") {
                    placeholder_line = i
                } else if (lines[i] ~ /^- \[/) {
                    last_task = i
                }
            }

            # Replace bare placeholder if it exists and no real tasks yet
            if (placeholder_line != -1 && last_task == -1) {
                for (i = 0; i < line_count; i++) {
                    if (i == placeholder_line) {
                        print task
                    } else {
                        print lines[i]
                    }
                }
                exit
            }

            # Otherwise append after last task line
            # Find insertion point: after last task, before blank line preceding next ##
            if (last_task != -1) {
                insert_after = last_task
            } else {
                # No tasks at all, insert right after section header blank line
                insert_after = tasks_start + 1
                # Skip blank line after header if present
                if (insert_after < tasks_end && lines[insert_after] == "") {
                    # insert after this blank line
                } else {
                    insert_after = tasks_start
                }
            }

            for (i = 0; i < line_count; i++) {
                print lines[i]
                if (i == insert_after) {
                    print task
                }
            }
        }
    ' "$note_path" > "$tmp_path"

    # Validate temp file has frontmatter and ## Tasks
    if not grep -q '^---' "$tmp_path"
        echo "Error: Atomic write validation failed (missing frontmatter)" >&2
        rm -f "$tmp_path"
        return 1
    end
    if not grep -q '^## Tasks' "$tmp_path"
        echo "Error: Atomic write validation failed (missing ## Tasks)" >&2
        rm -f "$tmp_path"
        return 1
    end

    # Keep backup, then atomically replace
    cp "$note_path" "$bak_path"
    mv "$tmp_path" "$note_path"

    # Update 'updated:' frontmatter timestamp
    sed -i '' "s/^updated: .*/updated: $iso_now/" "$note_path"

    echo "Added task to $today"
end
