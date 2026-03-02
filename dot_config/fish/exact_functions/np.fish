function np --description "Create new Claude prompt from template and open in nvim"
    # Check if OBSIDIAN_VAULT_PATH is set
    if not set -q OBSIDIAN_VAULT_PATH
        echo "Error: OBSIDIAN_VAULT_PATH environment variable not set" >&2
        return 1
    end

    set -l template_path "$OBSIDIAN_VAULT_PATH/03_Resources/claude/templates/prompt_template.md"
    set -l prompts_dir "$OBSIDIAN_VAULT_PATH/03_Resources/claude/prompts"

    # Check if template exists
    if not test -f "$template_path"
        echo "Error: Template file not found at $template_path" >&2
        return 1
    end

    # Get directory name for subdirectory (use git repo root if in a git repo)
    set -l target_base_dir (pwd)
    if git rev-parse --show-toplevel >/dev/null 2>&1
        set target_base_dir (git rev-parse --show-toplevel)
    end
    set -l current_dir_name (basename "$target_base_dir")
    set -l target_dir "$prompts_dir/$current_dir_name"

    # Create subdirectory if it doesn't exist
    if not test -d "$target_dir"
        if not mkdir -p "$target_dir"
            echo "Error: Failed to create directory $target_dir" >&2
            return 1
        end
    end

    # Generate timestamp in YYYYMMDD-HHMMSS format (24-hour time)
    set -l timestamp (date +%Y-%m-%dT%H-%M-%S)
    set -l new_filename "$timestamp"_prompt.md
    set -l new_filepath "$target_dir/$new_filename"

    # Copy template to new file
    if cp "$template_path" "$new_filepath"
        echo "Created new prompt: $new_filename"
        # Create a scratch file in current dir to anchor buffer 1 here
        # This ensures mini.misc.setup_auto_root() roots to current dir, not Obsidian vault
        set -l scratch_file ".cwd_anchor"
        touch $scratch_file

        # Buffer 1: scratch file (anchors to current directory)
        # Buffer 2: prompt file
        # Delete scratch file after opening (while nvim is running)
        nvim -c "edit $scratch_file | badd $new_filepath | bnext | call delete('$scratch_file')"
    else
        echo "Error: Failed to create prompt file" >&2
        return 1
    end
end
