function __fzf_copy_paths --argument-names mode selection_file
    set -l paths (__fzf_selection_paths $mode $selection_file)
    if test (count $paths) -eq 0
        return 1
    end

    printf '%s' (string join ' ' $paths) | __clipboard_copy
end
