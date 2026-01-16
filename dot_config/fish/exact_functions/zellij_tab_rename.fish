function zellij_tab_rename --on-variable PWD --description "Auto-rename zellij tab on directory change"
    if set -q ZELLIJ
        set -l current_dir $PWD
        if test "$current_dir" = "$HOME"
            set current_dir "~"
        else
            set current_dir (basename "$current_dir")
        end
        command nohup zellij action rename-tab "$current_dir" >/dev/null 2>&1 &
    end
end
