function gtplan --description "Advance a crew member from spec to plan workflow"
    set -l force 0
    set -l args $argv

    if contains -- --force $args
        set force 1
        set args (string match -v -- --force $args)
    end

    if test (count $args) -lt 1
        echo "Usage: gtplan [--force] <crew> <worker>" >&2
        echo "   or: gtplan [--force] <crew/worker>" >&2
        return 1
    end

    set -l crew
    set -l worker

    if string match -qr '.+/.+' -- $args[1]
        set -l target_parts (string split -m 1 / -- $args[1])
        set crew $target_parts[1]
        set worker $target_parts[2]
    else
        if test (count $args) -lt 2
            echo "Usage: gtplan [--force] <crew> <worker>" >&2
            return 1
        end

        set crew $args[1]
        set worker $args[2]
    end

    set -l feature (_gt_work read $crew $worker FEATURE)
    set -l stage (_gt_work read $crew $worker STAGE)

    if test -z "$feature"
        echo "Error: no active workflow found for $crew/$worker" >&2
        echo "Start one with 'gtspec $crew $worker <brief>'." >&2
        return 1
    end

    if test "$stage" != spec; and test $force -ne 1
        echo "Error: $crew/$worker is at stage '$stage', expected 'spec' before running plan-workflow" >&2
        echo "Use 'gtstatus $crew $worker' to inspect it or rerun with --force to bypass the guard." >&2
        return 1
    end

    gt sling plan-workflow "$crew/$worker" \
        --var feature="$feature"
    or return $status

    _gt_work write-current $crew $worker $feature plan
    or return $status
    _gt_work append-history $crew $worker plan $feature
    or return $status

    echo "Advanced $crew/$worker to plan-workflow"
    echo "feature: $feature"
end
