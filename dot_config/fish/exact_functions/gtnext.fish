function gtnext --description "Show the next workflow to sling for a crew member"
    if test (count $argv) -lt 1
        echo "Usage: gtnext <crew> <worker>" >&2
        echo "   or: gtnext <crew/worker>" >&2
        return 1
    end

    set -l crew
    set -l worker

    if string match -qr '.+/.+' -- $argv[1]
        set -l target_parts (string split -m 1 / -- $argv[1])
        set crew $target_parts[1]
        set worker $target_parts[2]
    else
        if test (count $argv) -lt 2
            echo "Usage: gtnext <crew> <worker>" >&2
            return 1
        end

        set crew $argv[1]
        set worker $argv[2]
    end

    set -l feature (_gt_work read $crew $worker FEATURE)
    set -l stage (_gt_work read $crew $worker STAGE)

    if test -z "$feature"
        echo "$crew/$worker -> next: spec-workflow"
        return 0
    end

    set -l next_step (_gt_work next "$stage")
    if test "$next_step" = complete
        echo "$crew/$worker -> stage: $stage, pipeline complete for feature $feature"
    else
        echo "$crew/$worker -> next: $next_step (feature $feature, current stage $stage)"
    end
end
