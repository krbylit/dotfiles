function gt --description "Wrap gt to manage monitor scripts on up/shutdown"
    set -l town_dir "$HOME/gt"
    set -l monitor_script "$town_dir/start-monitors.sh"
    set -l subcommand ""

    if test (count $argv) -gt 0
        set subcommand $argv[1]
    end

    command gt $argv
    set -l gt_status $status

    if test $gt_status -ne 0
        return $gt_status
    end

    if test "$subcommand" = "up"
        if test -x "$monitor_script"
            if not tmux has-session -t gt-monitors 2>/dev/null
                "$monitor_script" start
                or return $status
            end
        end
    else if test "$subcommand" = "shutdown"
        if test -x "$monitor_script"
            if tmux has-session -t gt-monitors 2>/dev/null
                "$monitor_script" stop
                or return $status
            end
        end
    end

    return 0
end
