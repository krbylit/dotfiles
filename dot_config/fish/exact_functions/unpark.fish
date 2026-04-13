function unpark --description "Unpark Gas Town rigs, optionally limited to specific rigs"
    if test "$PWD" = "$HOME/gt"; or string match -q "$HOME/gt-*" "$PWD"
        set -l town_dir $PWD
    else
        set -l town_dir $HOME/gt
    end

    if not test -d "$town_dir"
        echo "Error: Gas Town directory not found at $town_dir" >&2
        return 1
    end

    set -l rigs $argv
    if test (count $rigs) -eq 0
        set rigs (cd "$town_dir" && gt rig list --json | jq -r '.[].name')
        if test $status -ne 0
            echo "Error: Failed to list Gas Town rigs" >&2
            return 1
        end
    end

    if test (count $rigs) -eq 0
        echo "No rigs found to unpark"
        return 0
    end

    echo "Unparking rigs: "(string join ', ' $rigs)
    if not cd "$town_dir"
        echo "Error: Failed to enter $town_dir" >&2
        return 1
    end

    gt rig unpark $rigs
    or return $status

    gt rig start $rigs
    or return $status

    gt deacon resume
    or return $status

    gt deacon restart
    or return $status

    if test (count $argv) -eq 0
        gt daemon start
        or return $status

        gt deacon resume
        or return $status

        gt deacon restart
        or return $status

        "$town_dir/start-monitors.sh" start
        or return $status
    end
end
