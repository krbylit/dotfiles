# KEYMAPS
# with vi mode enabled, bindings default to normal mode
# so we must specify insert mode for binding as such:
# NOTE: we can use `fish_key_reader` to see key code for a key
# Remove alt-l mapping so we can use alt-h/j/k/l for arrows
bind --mode insert alt-l true
bind --mode default alt-l true
bind --mode visual alt-l true
bind --mode insert ctrl-y accept-autosuggestion
bind --mode insert ctrl-x clear
bind --mode insert ctrl-j down-or-search
bind --mode insert ctrl-k up-or-search
bind --mode default ctrl-j down-or-search
bind --mode default ctrl-k up-or-search
bind ctrl-u backward-kill-line
bind ctrl-w backward-kill-word
bind --mode default yy vi_copy_to_clipboard
# Now using fzf-lua instead of our own pieced-together live grep function
# bind --mode insert ctrl-s 'commandline -f repaint; ripgrep_live (commandline -b)'
# bind --mode default ctrl-s 'commandline -f repaint; ripgrep_live (commandline -b)'
# fzf-lua live grep
bind --mode insert ctrl-s 'commandline -f repaint; set -l result (nvim -l "$XDG_DATA_HOME/nvim/lazy/fzf-lua/scripts/cli.lua" live_grep_native search=(commandline -b));'
bind --mode default ctrl-s 'commandline -f repaint; set -l result (nvim -l "$XDG_DATA_HOME/nvim/lazy/fzf-lua/scripts/cli.lua" live_grep_native search=(commandline -b));'
# fzf-lua files search
bind --mode insert ctrl-f 'commandline -f repaint; set -l result (nvim -l "$XDG_DATA_HOME/nvim/lazy/fzf-lua/scripts/cli.lua" files);'
bind --mode default ctrl-f 'commandline -f repaint; set -l result (nvim -l "$XDG_DATA_HOME/nvim/lazy/fzf-lua/scripts/cli.lua" files);'
# fzf-lua git commits
bind --mode insert ctrl-g 'commandline -f repaint; set -l result (nvim -l "$XDG_DATA_HOME/nvim/lazy/fzf-lua/scripts/cli.lua" git_commits);'
bind --mode default ctrl-g 'commandline -f repaint; set -l result (nvim -l "$XDG_DATA_HOME/nvim/lazy/fzf-lua/scripts/cli.lua" git_commits);'
bind --mode insert ctrl-z 'commandline -f repaint; zellij_picker (commandline -b)'
bind --mode default ctrl-z 'commandline -f repaint; zellij_picker (commandline -b)'
# bind --mode insert ctrl-z 'commandline -f repaint; zi (commandline -b)'
# bind --mode default ctrl-z 'commandline -f repaint; zi (commandline -b)'
# bind --mode insert ctrl-a search_and_replace
# bind --mode default ctrl-a search_and_replace

# Atuin keymaps
# set -gx ATUIN_NOBIND true
# bind \cA _atuin_search
# bind -M insert \cA _atuin_search
