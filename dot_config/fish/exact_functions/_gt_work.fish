function _gt_work --description "Manage persisted Gas Town workflow state"
    set -l command $argv[1]

    switch "$command"
        case root
            echo "$HOME/gt/crew-work"

        case dir
            echo (_gt_work root)/$argv[2]/$argv[3]

        case current-file
            echo (_gt_work dir $argv[2] $argv[3])/current.env

        case brief-file
            echo (_gt_work dir $argv[2] $argv[3])/brief.md

        case history-file
            echo (_gt_work dir $argv[2] $argv[3])/history.tsv

        case ensure-dir
            mkdir -p (_gt_work dir $argv[2] $argv[3])

        case read
            set -l current_file (_gt_work current-file $argv[2] $argv[3])
            set -l key $argv[4]

            if not test -f "$current_file"
                return 1
            end

            set -l line (rg "^$key=" "$current_file")
            if test -z "$line"
                return 1
            end

            string replace -r "^$key=" "" -- "$line"

        case write-current
            set -l current_file (_gt_work current-file $argv[2] $argv[3])
            set -l now (date "+%Y-%m-%dT%H:%M:%S%z")

            printf "FEATURE=%s\nSTAGE=%s\nCREW=%s\nWORKER=%s\nUPDATED_AT=%s\n" \
                "$argv[4]" "$argv[5]" "$argv[2]" "$argv[3]" "$now" >"$current_file"

        case write-brief
            set -l brief_file (_gt_work brief-file $argv[2] $argv[3])
            printf "%s\n" "$argv[4]" >"$brief_file"

        case append-history
            set -l history_file (_gt_work history-file $argv[2] $argv[3])
            set -l now (date "+%Y-%m-%dT%H:%M:%S%z")
            set -l note

            if test (count $argv) -ge 6
                set note (_gt_work compact-text "$argv[6]")
            end

            printf "%s\t%s\t%s\t%s\n" "$now" "$argv[4]" "$argv[5]" "$note" >>"$history_file"

        case compact-text
            if test (count $argv) -lt 2
                return 0
            end

            set -l text (string join " " $argv[2..-1])
            set text (string replace -ra '[[:space:]]+' ' ' -- "$text")
            string trim -- "$text"

        case make-feature
            set -l brief (_gt_work compact-text "$argv[2]")
            set -l slug (string lower -- "$brief")
            set slug (string replace -ra '[^a-z0-9]+' '-' -- "$slug")
            set slug (string replace -ra '^-+|-+$' '' -- "$slug")

            if test -z "$slug"
                set slug feat
            end

            if test (string length -- "$slug") -gt 40
                set slug (string sub -s 1 -l 40 -- "$slug")
                set slug (string replace -ra -- '-+$' '' "$slug")
            end

            echo "$slug-"(date "+%Y%m%d%H%M%S")

        case brief-summary
            set -l brief_file (_gt_work brief-file $argv[2] $argv[3])

            if not test -f "$brief_file"
                return 1
            end

            set -l summary (sed -n '1p' "$brief_file")
            _gt_work compact-text "$summary"

        case next
            set -l stage $argv[2]

            switch "$stage"
                case spec
                    echo plan-workflow
                case plan
                    echo beads-workflow
                case beads
                    echo complete
                case '*'
                    echo spec-workflow
            end

        case '*'
            echo "Unknown _gt_work command: $command" >&2
            return 1
    end
end
