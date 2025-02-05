# KEYMAPS
# with vi mode enabled, bindings default to normal mode
# so we must specify insert mode for binding as such:
# NOTE: we can use `fish_key_reader` to see key code for a key
bind --mode insert \cY accept-autosuggestion
bind --mode insert \cx clear
bind --mode insert \n down-or-search
bind --mode insert \v up-or-search
bind --mode default \n down-or-search
bind --mode default \v up-or-search
bind \cu backward-kill-line
bind \cw backward-kill-word
bind --mode default yy vi_copy_to_clipboard
bind --mode insert ctrl-s 'commandline -f repaint; ripgrep_live (commandline -b)'
bind --mode default ctrl-s 'commandline -f repaint; ripgrep_live (commandline -b)'

# Atuin keymaps
# set -gx ATUIN_NOBIND true
# bind \cA _atuin_search
# bind -M insert \cA _atuin_search
