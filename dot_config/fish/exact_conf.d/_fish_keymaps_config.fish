# KEYMAPS
# with vi mode enabled, bindings default to normal mode
# so we must specify insert mode for binding as such:
# NOTE: we can use `fish_key_reader` to see key code for a key
# Remove alt-l mapping so we can use alt-h/j/k/l for arrows
bind --mode insert alt-l true
bind --mode default alt-l true
bind --mode visual alt-l true
bind --erase --mode insert ctrl-r
bind --erase --mode default ctrl-r
bind --erase --mode visual ctrl-r
bind --mode insert ctrl-y accept-autosuggestion
bind --mode insert ctrl-j down-or-search
bind --mode insert ctrl-k up-or-search
bind --mode default ctrl-j down-or-search
bind --mode default ctrl-k up-or-search
bind ctrl-u backward-kill-line
bind ctrl-w backward-kill-word
bind --mode default yy vi_copy_to_clipboard

# # Television
bind --mode insert ctrl-t 'tv todo-comments; commandline -f repaint'
bind --mode default ctrl-t 'tv todo-comments; commandline -f repaint'
# Yazi
bind --mode insert ctrl-a 'yazicd; set fish_bind_mode insert'
bind --mode default ctrl-a 'yazicd; set fish_bind_mode default'
# fzf grep CHEZMOI_SOURCE_PATH
bind --mode insert ctrl-i 'commandline -f repaint; set -l result (nvim -l "$XDG_DATA_HOME/nvim/lazy/fzf-lua/scripts/cli.lua" live_grep_native search=(commandline -b) "cwd=$CHEZMOI_SOURCE_PATH"); and commandline --current-token --replace -- (string escape -- $result)'
bind --mode default ctrl-i 'commandline -f repaint; set -l result (nvim -l "$XDG_DATA_HOME/nvim/lazy/fzf-lua/scripts/cli.lua" live_grep_native search=(commandline -b) "cwd=$CHEZMOI_SOURCE_PATH"); and commandline --current-token --replace -- (string escape -- $result)'
# fzf grep cwd
bind --mode insert ctrl-s 'commandline -f repaint; set -l result (nvim -l "$XDG_DATA_HOME/nvim/lazy/fzf-lua/scripts/cli.lua" live_grep_native search=(commandline -b)); and commandline --current-token --replace -- (string escape -- $result)'
bind --mode default ctrl-s 'commandline -f repaint; set -l result (nvim -l "$XDG_DATA_HOME/nvim/lazy/fzf-lua/scripts/cli.lua" live_grep_native search=(commandline -b)); and commandline --current-token --replace -- (string escape -- $result)'
# fzf files cwd
bind --mode insert ctrl-f 'commandline -f repaint; set -l result (nvim -l "$XDG_DATA_HOME/nvim/lazy/fzf-lua/scripts/cli.lua" files); and commandline --current-token --replace -- (string escape -- $result)'
bind --mode default ctrl-f 'commandline -f repaint; set -l result (nvim -l "$XDG_DATA_HOME/nvim/lazy/fzf-lua/scripts/cli.lua" files); and commandline --current-token --replace -- (string escape -- $result)'
# fzf files Obsidian vault
bind --mode insert ctrl-o 'commandline -f repaint; set -l result (nvim -l "$XDG_DATA_HOME/nvim/lazy/fzf-lua/scripts/cli.lua" files "cwd=$OBSIDIAN_VAULT_PATH"); and commandline --current-token --replace -- (string escape -- $result)'
bind --mode default ctrl-o 'commandline -f repaint; set -l result (nvim -l "$XDG_DATA_HOME/nvim/lazy/fzf-lua/scripts/cli.lua" files "cwd=$OBSIDIAN_VAULT_PATH"); and commandline --current-token --replace -- (string escape -- $result)'
# fzf files `nb` dir
bind --mode insert ctrl-n 'commandline -f repaint; set -l result (nvim -l "$XDG_DATA_HOME/nvim/lazy/fzf-lua/scripts/cli.lua" files "cwd=~/.nb/home"); and commandline --current-token --replace -- (string escape -- $result)'
bind --mode default ctrl-n 'commandline -f repaint; set -l result (nvim -l "$XDG_DATA_HOME/nvim/lazy/fzf-lua/scripts/cli.lua" files "cwd=~/.nb/home"); and commandline --current-token --replace -- (string escape -- $result)'
# fzf files CHEZMOI_SOURCE_PATH
bind --mode insert ctrl-m 'commandline -f repaint; set -l result (nvim -l "$XDG_DATA_HOME/nvim/lazy/fzf-lua/scripts/cli.lua" files "cwd=$CHEZMOI_SOURCE_PATH"); and commandline --current-token --replace -- (string escape -- $result)'
bind --mode default ctrl-m 'commandline -f repaint; set -l result (nvim -l "$XDG_DATA_HOME/nvim/lazy/fzf-lua/scripts/cli.lua" files "cwd=$CHEZMOI_SOURCE_PATH"); and commandline --current-token --replace -- (string escape -- $result)'
# fzf git commits
bind --mode insert ctrl-g 'commandline -f repaint; set -l result (nvim -l "$XDG_DATA_HOME/nvim/lazy/fzf-lua/scripts/cli.lua" git_commits); and commandline --current-token --replace -- (string escape -- $result)'
bind --mode default ctrl-g 'commandline -f repaint; set -l result (nvim -l "$XDG_DATA_HOME/nvim/lazy/fzf-lua/scripts/cli.lua" git_commits); and commandline --current-token --replace -- (string escape -- $result)'
# fzf Zellij sessions
bind --mode insert ctrl-z 'commandline -f repaint; zellij_picker (commandline -b)'
bind --mode default ctrl-z 'commandline -f repaint; zellij_picker (commandline -b)'
# Zoxide
bind --mode insert ctrl-space 'commandline -f repaint; zi (commandline -b)'
bind --mode default ctrl-space 'commandline -f repaint; zi (commandline -b)'
# bind --mode insert ctrl-a search_and_replace
# bind --mode default ctrl-a search_and_replace

# Atuin keymaps
# set -gx ATUIN_NOBIND true
# bind \cA _atuin_search
# bind -M insert \cA _atuin_search
