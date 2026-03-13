function __fzf_selection_paths --argument-names mode selection_file
    if not test -f "$selection_file"
        return 1
    end

    while read -l line
        if test -z "$line"
            continue
        end

        set line (__fzf_strip_ansi $line)

        switch $mode
            case grep
                set -l path (string split -m1 ":" -- $line)[1]
            case '*'
                set -l path $line
        end

        set -l resolved (realpath "$path" 2>/dev/null)
        if test -n "$resolved"
            printf '%s\n' "$resolved"
        end
    end <"$selection_file"
end
