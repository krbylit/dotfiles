# Set Editor
set -gx EDITOR nvim
set -Ux fifc_editor nvim

# Env vars
set -gx CM_PATH "$HOME/.local/share/chezmoi"
set -gx CONFIG_DIR "$HOME/.config/lazygit" # Lazygit config
set -gx XDG_CONFIG_HOME "$HOME/.config"

# Program configs
set -gx DOCKER_BUILDKIT 1

# Use `bat` for man pages
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"

# some programs use FILTER to choose a fuzzy finder
# set -gx FILTER "fzf --cycle --layout=reverse --border --height=90% --preview-window=wrap --marker="*" --bind ctrl-f:preview-down --bind ctrl-b:preview-up --bind ctrl-d:half-page-down --bind ctrl-u:half-page-up"
