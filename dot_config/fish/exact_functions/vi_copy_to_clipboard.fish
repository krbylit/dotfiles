function vi_copy_to_clipboard
    set -l cmd (commandline)
    echo $cmd | __clipboard_copy
end
