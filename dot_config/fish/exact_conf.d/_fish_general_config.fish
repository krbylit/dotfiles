# Set SSH agent env vars for forwarding
if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c) >/dev/null
    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
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

set -gx BEADS_DOLT_SHARED_SERVER 1
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
