function __fzf_open_in_current_nvim --argument-names mode selection_file
    # FIXME: Not working when in fzf file picker
    if not test -f "$selection_file"
        return 1
    end

    set -l open_cmd nvim
    set -l remote_args
    if set -q NVIM
        set open_cmd nvr
        set remote_args --servername $NVIM --remote-silent
    end

    switch $mode
        case grep
            set -l lines
            while read -l line
                test -z "$line"; and continue
                set line (__fzf_strip_ansi $line)
                set -l parts (string split -m2 ":" -- $line)
                set -l path (realpath "$parts[1]" 2>/dev/null)
                test -n "$path"; or continue
                set -l lnum $parts[2]
                if test -n "$lnum"
                    $open_cmd $remote_args +$lnum $path >/dev/null
                else
                    $open_cmd $remote_args $path >/dev/null
                end
            end <"$selection_file"
        case '*'
            __fzf_open_files_in_current_nvim $selection_file
    end
end
