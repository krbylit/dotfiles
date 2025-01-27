function vi_copy_to_clipboard
    set -l cmd (commandline) # Get the current command line
    echo $cmd | pbcopy # Copy to system clipboard using pbcopy
end
