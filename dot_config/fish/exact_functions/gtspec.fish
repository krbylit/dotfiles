function gtspec --description "Start a spec workflow for a crew member and persist workflow state"
    set -l force 0
    set -l file_path ""
    set -l args

    for i in (seq (count $argv))
        switch $argv[$i]
            case --force
                set force 1
            case --file
                set -l next (math $i + 1)
                if test $next -le (count $argv)
                    set file_path $argv[$next]
                    set i $next
                else
                    echo "Error: --file requires a path argument" >&2
                    return 1
                end
            case '--file=*'
                set file_path (string replace -- '--file=' '' $argv[$i])
            case '*'
                set -a args $argv[$i]
        end
    end

    if test (count $args) -lt 2
        echo "Usage: gtspec [--force] [--file PATH] <crew> <worker> [brief...]" >&2
        echo "   or: gtspec [--force] [--file PATH] <crew/worker> [brief...]" >&2
        echo "   or: echo 'text' | gtspec <crew> <worker> -" >&2
        return 1
    end

    set -l crew
    set -l worker
    set -l brief_args

    if string match -qr '.+/.+' -- $args[1]
        set -l target_parts (string split -m 1 / -- $args[1])
        set crew $target_parts[1]
        set worker $target_parts[2]
        set brief_args $args[2..-1]
    else
        if test (count $args) -lt 3; and test -z "$file_path"; and not isatty stdin
            echo "Usage: gtspec [--force] [--file PATH] <crew> <worker> [brief...]" >&2
            return 1
        end

        set crew $args[1]
        set worker $args[2]
        set brief_args $args[3..-1]
    end

    set -l brief

    if test -n "$file_path"
        if not test -f "$file_path"
            echo "Error: file not found: $file_path" >&2
            return 1
        end
        set brief (string collect -- (cat "$file_path"))
    else if test (count $brief_args) -eq 1; and test "$brief_args[1]" = -
        set brief (string collect -- (cat))
    else if test (count $brief_args) -eq 0; and not isatty stdin
        set brief (string collect -- (cat))
    else
        set brief (string join -- " " $brief_args)
    end

    if test -z "$brief"
        echo "Error: brief is required" >&2
        return 1
    end

    _gt_work ensure-dir $crew $worker
    or return $status

    set -l current_stage (_gt_work read $crew $worker STAGE)
    if test -n "$current_stage"
        if test "$current_stage" != beads; and test $force -ne 1
            set -l current_feature (_gt_work read $crew $worker FEATURE)
            echo "Error: $crew/$worker already has an active workflow at stage '$current_stage' for feature '$current_feature'" >&2
            echo "Use 'gtstatus $crew $worker' to inspect it or rerun with --force to replace it." >&2
            return 1
        end
    end

    set -l feature (_gt_work make-feature "$brief")

    gt sling spec-workflow "$crew/$worker" \
        --var feature="$feature" \
        --var brief="$brief"
    or return $status

    _gt_work write-current $crew $worker $feature spec
    or return $status
    _gt_work write-brief $crew $worker "$brief"
    or return $status
    _gt_work append-history $crew $worker spec $feature (_gt_work compact-text "$brief")
    or return $status

    echo "Started spec-workflow for $crew/$worker"
    echo "feature: $feature"
end
