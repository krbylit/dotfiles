function park --description "Park Gas Town rigs, optionally limited to specific rigs"
    set -l town_dir "$HOME/gt"

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
        echo "No rigs found to park"
        return 0
    end

    echo "Parking rigs: "(string join ', ' $rigs)
    if not cd "$town_dir"
        echo "Error: Failed to enter $town_dir" >&2
        return 1
    end

    gt rig park $rigs
    or return $status

    if test (count $argv) -eq 0
        gt daemon stop
        or return $status

        gt deacon pause
        or return $status

        "$town_dir/start-monitors.sh" stop
        or return $status
    end
end
