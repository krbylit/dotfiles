# Adapted from https://alexwlchan.net/2023/fish-venv/
function venv --description "Create and activate a new virtual environment"
    if test -n "$VIRTUAL_ENV"
        deactivate
        return 0
    end

    set REPO_ROOT (git rev-parse --show-toplevel 2>/dev/null)

    if [ -d "$REPO_ROOT/.venv" ]
        source "$REPO_ROOT/.venv/bin/activate.fish" &>/dev/null
    else
        echo "Creating virtual environment in "(pwd)"/.venv"
        # Can specify Python versions with e.g. `venv --python 3.13`
        uv venv .venv $argv
        source .venv/bin/activate.fish

        # Append .venv to the Git exclude file, but only if it's not
        # already there.
        if test -e .git
            set line_to_append ".venv"
            set target_file ".git/info/exclude"

            if not grep --quiet --fixed-strings --line-regexp "$line_to_append" "$target_file" 2>/dev/null
                echo "$line_to_append" >>"$target_file"
            end
        end
    end

    # Tell Time Machine that it doesn't need to both backing up the
    # virtualenv directory. (macOS-only)
    # See https://ss64.com/mac/tmutil.html
    # tmutil addexclusion .venv
end
