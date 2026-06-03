# Set up SSH agent for key forwarding.
# macOS (Tahoe) launchd intermittently advertises a dead SSH_AUTH_SOCK, so we
# check that the agent is actually reachable (`ssh-add -l` exit 2 == no agent)
# instead of merely checking that the var is set. Pin a fixed socket so the
# agent is stable across shells. Skip inside SSH sessions, where the forwarded
# agent (see the `s` function) owns SSH_AUTH_SOCK.
if not set -q SSH_CONNECTION; and not set -q SSH_TTY
    set -gx SSH_AUTH_SOCK "$HOME/.ssh/agent-local.sock"
    ssh-add -l >/dev/null 2>&1
    if test $status -eq 2
        # No reachable agent — start a self-managed one bound to the fixed socket.
        rm -f "$SSH_AUTH_SOCK"
        ssh-agent -a "$SSH_AUTH_SOCK" >/dev/null 2>&1
    end
    ssh-add -l >/dev/null 2>&1
    if test $status -eq 1
        # Agent reachable but empty — load keys non-interactively.
        if test (uname) = Darwin
            ssh-add --apple-load-keychain >/dev/null 2>&1
        else
            ssh-add >/dev/null 2>&1
        end
    end
end
# Set Editor
if set -q NVIM
    # Avoid nested neovim instances with neovim-remote
    # https://github.com/mhinz/neovim-remote#usage https://stackoverflow.com/questions/76024656/can-i-use-nvim-remote-to-replace-nvr
    set -gx EDITOR "nvr --remote-wait"
    function nvim
        command nvr $argv
    end
else
    set -gx EDITOR nvim
    # Always open files in the same single nvim process
    # set -gx EDITOR nvr -s
    # function nvim
    #     command nvr -s $argv
    # end
end
set -gx VISUAL $EDITOR

set -gx fifc_editor nvim

# Env vars
set -gx CHEZMOI_SOURCE_PATH (chezmoi source-path)
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx fisher_path "$XDG_CONFIG_HOME/fish/fisher"
# set -gx fish_function_path $fish_function_path "$XDG_CONFIG_HOME/fish/fisher/functions"
# set -gx fish_complete_path $fish_function_path "$XDG_CONFIG_HOME/fish/fisher/completions"

set -gx BEADS_DOLT_SHARED_SERVER 0

# Program configs
set -gx DOCKER_BUILDKIT 1

# Use `bat` for man pages
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"

# some programs use FILTER to choose a fuzzy finder
# set -gx FILTER "fzf --cycle --layout=reverse --border --height=90% --preview-window=wrap --marker="*" --bind ctrl-f:preview-down --bind ctrl-b:preview-up --bind ctrl-d:half-page-down --bind ctrl-u:half-page-up"

# Set global env var if we are SSH'd into a remote machine
# TODO: Use this for any further configuration specific to SSH envs. E.g. disable certain nvim plugins based on this.
if set -q SSH_CONNECTION; or set -q SSH_CLIENT; or set -q SSH_TTY
    set -gx IS_SSH 1
else
    set -gx IS_SSH 0
end
