function __fzf_insert_path_from_directory --argument-names search_dir
    set -l target_dir $search_dir
    set -l original_pwd $PWD

    if not test -d "$target_dir"
        commandline -f repaint
        return 1
    end

    cd $target_dir

    set -l fd_cmd (command -v fdfind || command -v fd || echo "fd")
    set -l selected (
        $fd_cmd --color=always $fzf_fd_opts . 2>/dev/null |
            _fzf_wrapper --multi --ansi --prompt="Directory $target_dir> " \
                --preview="_fzf_preview_file {}" \
                --bind 'ctrl-f:accept' \
                --bind 'enter:become(__fzf_open_in_current_nvim files {+f})' \
                --bind 'ctrl-o:execute(__fzf_open_in_current_nvim files {+f})' \
                --bind 'ctrl-y:execute-silent(__fzf_copy_paths files {+f})' \
                $fzf_directory_opts
    )
    set -l picker_status $status

    cd $original_pwd

    if test $picker_status -eq 0 -a -n "$selected"
        set -l resolved_paths
        for path in $selected
            set path (__fzf_strip_ansi $path)
            set -l resolved (realpath "$target_dir/$path" 2>/dev/null)
            if test -n "$resolved"
                set -a resolved_paths $resolved
            end
        end
        if test (count $resolved_paths) -gt 0
            commandline --current-token --replace -- (string escape -- $resolved_paths | string join ' ')
        end
    end

    commandline -f repaint
end
