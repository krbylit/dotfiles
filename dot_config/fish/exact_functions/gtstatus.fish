function gtstatus --description "Show persisted Gas Town workflow status"
    set -l root (_gt_work root)

    if not test -d "$root"
        echo "No Gas Town workflow state found at $root"
        return 0
    end

    if test (count $argv) -eq 0
        set -l current_files (find "$root" -mindepth 3 -maxdepth 3 -type f -name current.env 2>/dev/null | sort)
        if test (count $current_files) -eq 0
            echo "No active workflow state found"
            return 0
        end

        for current_file in $current_files
            set -l parts (string split / -- "$current_file")
            set -l count_parts (count $parts)
            set -l crew $parts[(math $count_parts - 2)]
            set -l worker $parts[(math $count_parts - 1)]
            set -l feature (_gt_work read $crew $worker FEATURE)
            set -l stage (_gt_work read $crew $worker STAGE)
            set -l updated_at (_gt_work read $crew $worker UPDATED_AT)
            set -l next_step (_gt_work next "$stage")
            set -l brief (_gt_work brief-summary $crew $worker)

            printf "%s/%s\tstage=%s\tnext=%s\tfeature=%s\tupdated=%s" \
                "$crew" "$worker" "$stage" "$next_step" "$feature" "$updated_at"
            if test -n "$brief"
                printf "\tbrief=%s" "$brief"
            end
            printf "\n"
        end

        return 0
    end

    set -l crew
    set -l worker

    if test (count $argv) -eq 1
        if string match -qr '.+/.+' -- $argv[1]
            set -l target_parts (string split -m 1 / -- $argv[1])
            set crew $target_parts[1]
            set worker $target_parts[2]
        else
            set crew $argv[1]
            set -l crew_root "$root/$crew"
            if not test -d "$crew_root"
                echo "No Gas Town workflow state found for crew '$crew'" >&2
                return 1
            end

            set -l current_files (find "$crew_root" -mindepth 2 -maxdepth 2 -type f -name current.env 2>/dev/null | sort)
            if test (count $current_files) -eq 0
                echo "No workflow state found for crew '$crew'"
                return 0
            end

            for current_file in $current_files
                set -l parts (string split / -- "$current_file")
                set -l current_worker $parts[(count $parts)-1]
                gtstatus $crew $current_worker
            end

            return 0
        end
    else if test (count $argv) -ge 2
        set crew $argv[1]
        set worker $argv[2]
    end

    set -l feature (_gt_work read $crew $worker FEATURE)
    if test -z "$feature"
        echo "No active workflow state found for $crew/$worker" >&2
        return 1
    end

    set -l stage (_gt_work read $crew $worker STAGE)
    set -l updated_at (_gt_work read $crew $worker UPDATED_AT)
    set -l next_step (_gt_work next "$stage")
    set -l brief (_gt_work brief-summary $crew $worker)

    echo "target: $crew/$worker"
    echo "feature: $feature"
    echo "stage: $stage"
    echo "next: $next_step"
    echo "updated_at: $updated_at"
    if test -n "$brief"
        echo "brief: $brief"
    end
end
