function ldz
    set -l start_dir (pwd)
    set -l dir_name (basename "$start_dir")
    set -l path_hash (echo -n "$start_dir" | md5 | string sub -l 8)
    set -l session "lazydocker-$dir_name-$path_hash"
    set -l target_dir "$start_dir"

    set -l git_root
    if git rev-parse --show-toplevel >/dev/null 2>&1
        set git_root (git rev-parse --show-toplevel)
    end

    set -l search_dir "$start_dir"
    set -l found_compose 0
    while true
        for compose_file in compose.yml compose.yaml docker-compose.yml docker-compose.yaml
            if test -f "$search_dir/$compose_file"
                set target_dir "$search_dir"
                set found_compose 1
                break
            end
        end

        if test $found_compose -eq 1
            break
        end

        if test -n "$git_root"; and test "$search_dir" = "$git_root"
            break
        end

        if test "$search_dir" = /
            break
        end

        set -l parent_dir (dirname "$search_dir")
        if test "$parent_dir" = "$search_dir"
            break
        end
        set search_dir "$parent_dir"
    end

    if zellij list-sessions -sn 2>/dev/null | grep -qx $session
        if zellij list-sessions 2>/dev/null | string match -rq "^\x1b\\[[0-9;]*m$session\x1b\\[[0-9;]*m .*EXITED"
            zellij delete-session --force $session >/dev/null 2>&1
        else
            zellij attach $session
            return $status
        end
    end

    begin
        set -l escaped_target_dir (string replace -a '"' '\"' -- "$target_dir")
        set -l layout_file (mktemp -t lazydocker-zellij.XXXXXX.kdl)

        printf 'layout {\n    pane command="lazydocker" cwd="%s" close_on_exit=true\n}\n' "$escaped_target_dir" >"$layout_file"
        zellij -n "$layout_file" -s $session
        set -l status_code $status
        rm -f "$layout_file"
        return $status_code
    end
end
