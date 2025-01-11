# Path setup (Homebrew, nvim, etc.)
set -gx PATH $PATH /usr/local/bin # Homebrew on Intel silicon
set -gx PATH $PATH /opt/homebrew/bin # Homebrew on Apple silicon
set -gx PATH $PATH /opt/homebrew/sbin
set -gx PATH $PATH /opt
set -gx PATH $PATH $HOME/.cargo/bin
set -gx PATH $PATH $HOME/.local/bin
set -gx PATH $PATH /nix/var/nix/profiles/default/bin
set -gx PATH $PATH $HOME/.local/share/uv/python
set -gx PATH $PATH $PYENV_ROOT/shims
set -gx PYTHONPATH "$HOME/src/expansion/expansion:$PYTHONPATH"

set -Ux nvm_default_version v18.20.5

# Set Editor
set -gx EDITOR nvim
set -Ux fifc_editor nvim

# NVM, Python settings, project home, and virtual environments
# some programs use FILTER to choose a fuzzy finder
# set -gx FILTER "fzf --cycle --layout=reverse --border --height=90% --preview-window=wrap --marker="*" --bind ctrl-f:preview-down --bind ctrl-b:preview-up --bind ctrl-d:half-page-down --bind ctrl-u:half-page-up"
set -gx NVM_DIR "$HOME/.nvm"
set -gx VIRTUALENVWRAPPER_PYTHON (which python3)
set -gx PROJECT_HOME $HOME/Devel
set -gx CM_PATH "$HOME/.local/share/chezmoi"
set -gx CONFIG_DIR "$HOME/.config/lazygit" # Lazygit config
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx PYENV_ROOT "$HOME/.pyenv"
set -gx WORKON_HOME "$HOME/.virtualenvs"
set -gx PYTHON_VENV_NAME virtual_env
# Use `bat` for man pages
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"

# Git diff tool
set -gx GIT_EXTERNAL_DIFF delta

# Keymaps
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
# bind sunbeam to ctrl+space
bind --mode insert -k nul sunbeam
bind --mode default -k nul sunbeam


# fzf keymaps and options
# https://github.com/PatrickF1/fzf.fish
# Search history with Ctrl-S, directory with Ctrl-F, and processes with Ctrl-P
fzf_configure_bindings --history=\cS --directory=\cF --processes=\cP --git_log=\a
# `fzf_directory_opts` is appended onto default opts passed to `fd`
# Set ctrl+o to open selected file in EDITOR. Appended to defaults.
set -gx fzf_directory_opts --bind "ctrl-o:execute($EDITOR {} &> /dev/tty)"
# Set fzf.fish `fd` opts for searching files/dirs. Appended to defaults.
set -gx fzf_fd_opts --hidden
# Set fzf.fish cmd for listing dirs (e.g. `ls`)
# Defaults to `command ls -A -F "$file_path"`
set -gx fzf_preview_dir_cmd "eza --all --color=always"
# Set the cmd to preview git diffs
set -gx fzf_diff_highlighter 'delta --no-gitconfig --paging=never --line-numbers --line-numbers-minus-style="#444444" --line-numbers-zero-style="#444444" --line-numbers-plus-style="#444444" --line-numbers-left-format="{nm:>4}┊" --line-numbers-right-format="{np:>4}│" --line-numbers-left-style=blue --line-numbers-right-style=blue --commit-decoration-style="bold yellow box ul" --file-style="bold yellow ul" --file-decoration-style=none --hunk-header-decoration-style="yellow box"'
# Set fzf.fish preview command e.g. `cat|bat`
# Defaults to `bat --style=numbers --color=always "$file_path"`
# set fzf_preview_file_cmd bat --style=numbers --color=always "$file_path"
# fzf opts for zoxide
set -gx _ZO_FZF_OPTS "$FZF_DEAFULT_OPTS"
# Zoxide excluded dirs, globs separated by `:`
# NOTE: starting with $HOME is only way I've been able to get this working
set -gx _ZO_EXCLUDE_DIRS "$HOME/**/node_modules:$HOME/**/node_modules/**"
# path to fzf opts rc file
set -gx FZF_DEFAULT_OPTS_FILE "$HOME/.fzfrc"
set -gx FZF_DEAFULT_OPTS (cat $FZF_DEFAULT_OPTS_FILE)
set -gx DOCKER_BUILDKIT 1

# Atuin keymaps
set -gx ATUIN_NOBIND true
bind \cA _atuin_search
bind -M insert \cA _atuin_search

# Get rid of greeting message
function fish_greeting
    fish_logo blue cyan green
    echo "░░░░░░▒░▒▒░▒▒▒▒▒▓▒▓▓▓█▓████▓▓▒▒▒░"
    echo " "
    # echo "░░░░░▒▒▒▒▒▓▓▓▓█████▓▓▓▓▒▒▒▒▒░░░░░"
end

# Config Vi-mode in Fish
set -g fish_key_bindings fish_vi_key_bindings
# Set the normal and visual mode cursors to a block
set fish_cursor_default block blink
# Set the insert mode cursor to a line
set fish_cursor_insert line blink
# Set the replace mode cursors to an underscore
set fish_cursor_replace_one underscore blink
set fish_cursor_replace underscore blink
# Set the external cursor to a line. The external cursor appears when a command is started.
# The cursor shape takes the value of fish_cursor_default when fish_cursor_external is not specified.
set fish_cursor_external line
# The following variable can be used to configure cursor shape in
# visual mode, but due to fish_cursor_default, is redundant here
set fish_cursor_visual block blink

if status is-interactive
    # Commands to run in interactive sessions can go here
    if string match -q -- '*ghostty*' $TERM
        set -g fish_vi_force_cursor 1
    end
    pyenv virtualenv-init - | source
    pyenv init - fish | source
    atuin init fish | source
    starship init fish | source
    enable_transience
    zoxide init fish | source
end

function starship_transient_prompt_func
    # starship prompt
    starship module custom.angular_transient_prompt
    # starship module custom.curvy_transient_prompt
end
function starship_transient_rprompt_func
    starship module custom.transient_rprompt
end
