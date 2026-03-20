function __clipboard_copy --description 'Copy stdin to system clipboard (cross-platform)'
    if command -q pbcopy
        pbcopy
    else if command -q xclip
        xclip -selection clipboard
    else if command -q xsel
        xsel --clipboard --input
    else if command -q wl-copy
        wl-copy
    else
        echo "__clipboard_copy: no clipboard provider found" >&2
        return 1
    end
end
