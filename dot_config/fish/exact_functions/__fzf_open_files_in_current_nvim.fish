function __fzf_open_files_in_current_nvim --argument-names selection_file
    if not test -f "$selection_file"
        return 1
    end

    set -l paths (__fzf_selection_paths files $selection_file)
    if test (count $paths) -eq 0
        return 1
    end

    if set -q NVIM
        for path in $paths
            command nvr --servername $NVIM -cc tabedit --remote-silent $path >/dev/null
        end
    else
        command nvim -p $paths </dev/tty >/dev/tty
    end
end
