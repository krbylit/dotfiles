# fzf keymaps and options
# https://github.com/PatrickF1/fzf.fish

# path to fzf opts rc file for global fzf options
set -gx FZF_DEFAULT_OPTS_FILE "$HOME/.fzfrc"
set -gx FZF_DEAFULT_OPTS (command cat $FZF_DEFAULT_OPTS_FILE)

# Search history with Ctrl-S, directory with Ctrl-F, and processes with Ctrl-P
# NOTE: We have to wait for fish_prompt since snippets in `conf.d` don't appear to have access to functions
function load_fzf_bindings --on-event fish_prompt
    fzf_configure_bindings --history=\cE --directory=\cF --processes=\cP --git_log=\a
end

# `fzf_directory_opts` is appended onto default opts passed to `fd`

# Set fzf.fish `fd` opts for searching files/dirs. Appended to defaults.
# Set to show dot files and gitignored files
set -gx fzf_fd_opts --hidden --no-ignore

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
