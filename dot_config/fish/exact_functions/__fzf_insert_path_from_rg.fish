function __fzf_insert_path_from_rg --argument-names query search_dir
    set -l original_pwd $PWD
    set -l target_dir $search_dir

    if test -z "$target_dir"
        set target_dir $original_pwd
    end

    if not test -d "$target_dir"
        commandline -f repaint
        return 1
    end

    cd $target_dir

    set -gx RIPGREP_CONFIG_PATH $HOME/.config/ripgrep/.ripgreprc
    set -l reload_cmd "reload:rg --column --color=always --smart-case {q} || :"
    set -l result (
        _fzf_wrapper --disabled --ansi \
            --query "$query" \
            --bind "start:$reload_cmd" \
            --bind "change:$reload_cmd" \
            --bind 'ctrl-f:accept' \
            --bind 'enter:become(__fzf_open_in_current_nvim grep {+f})' \
            --bind 'ctrl-o:execute(__fzf_open_in_current_nvim grep {+f})' \
            --bind 'ctrl-y:execute-silent(__fzf_copy_paths grep {+f})' \
            --delimiter : \
            --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
            --preview-window '~4,+{2}+4/3,<80(up)'
    )
    set -l fzf_status $status
    set -e RIPGREP_CONFIG_PATH

    cd $original_pwd

    if test $fzf_status -eq 0 -a -n "$result"
        set -l resolved_paths
        for file in (string split \n -- $result)
            set file (__fzf_strip_ansi $file)
            set file (string replace -r ':.*$' '' -- $file)
            set -l resolved (realpath "$target_dir/$file" 2>/dev/null)
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
