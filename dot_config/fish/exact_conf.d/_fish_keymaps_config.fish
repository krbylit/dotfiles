# KEYMAPS
# with vi mode enabled, bindings default to normal mode
# so we must specify insert mode for binding as such:
# NOTE: we can use `fish_key_reader` to see key code for a key

function __run_fzf_lua_cli --argument-names picker
    if set -q NVIM
        commandline -f repaint
        return 1
    end

    set -e argv[1]
    set -l result (nvim -l "$XDG_DATA_HOME/nvim/lazy/fzf-lua/scripts/cli.lua" $picker $argv)
    and commandline --current-token --replace -- (string escape -- $result)
end

function __search_files_current
    if set -q NVIM
        __fzf_insert_path_from_directory $PWD
    else
        __run_fzf_lua_cli files
    end
end

function __search_files_in_dir --argument-names search_dir
    if set -q NVIM
        __fzf_insert_path_from_directory $search_dir
    else
        __run_fzf_lua_cli files "cwd=$search_dir"
    end
end

function __search_git_commits
    if set -q NVIM
        _fzf_search_git_log
    else
        __run_fzf_lua_cli git_commits
    end
end

function __search_grep_current
    if set -q NVIM
        __fzf_insert_path_from_rg (commandline -b) $PWD
    else
        __run_fzf_lua_cli live_grep_native search=(commandline -b)
    end
end

function __search_grep_in_dir --argument-names search_dir
    if set -q NVIM
        __fzf_insert_path_from_rg (commandline -b) $search_dir
    else
        __run_fzf_lua_cli live_grep_native search=(commandline -b) "cwd=$search_dir"
    end
end

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
bind --mode insert ctrl-t 'tv obsidian-todos; commandline -f repaint'
bind --mode default ctrl-t 'tv obsidian-todos; commandline -f repaint'
# Yazi
bind --mode insert ctrl-a 'yazicd; set fish_bind_mode insert; commandline -f repaint'
bind --mode default ctrl-a 'yazicd; set fish_bind_mode default; commandline -f repaint'
# fzf grep CHEZMOI_SOURCE_PATH
bind --mode insert ctrl-i 'commandline -f repaint; __search_grep_in_dir "$CHEZMOI_SOURCE_PATH"'
bind --mode default ctrl-i 'commandline -f repaint; __search_grep_in_dir "$CHEZMOI_SOURCE_PATH"'
# fzf grep cwd
bind --mode insert ctrl-s 'commandline -f repaint; __search_grep_current'
bind --mode default ctrl-s 'commandline -f repaint; __search_grep_current'
# fzf files cwd
bind --mode insert ctrl-f 'commandline -f repaint; __search_files_current'
bind --mode default ctrl-f 'commandline -f repaint; __search_files_current'
bind --mode insert ctrl-q 'commandline -f repaint; __search_files_current'
bind --mode default ctrl-q 'commandline -f repaint; __search_files_current'
# fzf files Obsidian vault
bind --mode insert ctrl-o 'commandline -f repaint; __search_files_in_dir "$OBSIDIAN_VAULT_PATH"'
bind --mode default ctrl-o 'commandline -f repaint; __search_files_in_dir "$OBSIDIAN_VAULT_PATH"'
# fzf files `nb` dir
bind --mode insert ctrl-n 'commandline -f repaint; __search_files_in_dir ~/.nb/home'
bind --mode default ctrl-n 'commandline -f repaint; __search_files_in_dir ~/.nb/home'
# fzf files CHEZMOI_SOURCE_PATH
bind --mode insert ctrl-m 'commandline -f repaint; __search_files_in_dir "$CHEZMOI_SOURCE_PATH"'
bind --mode default ctrl-m 'commandline -f repaint; __search_files_in_dir "$CHEZMOI_SOURCE_PATH"'
# fzf git commits
bind --mode insert ctrl-g 'commandline -f repaint; __search_git_commits'
bind --mode default ctrl-g 'commandline -f repaint; __search_git_commits'
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
