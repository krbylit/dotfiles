# Ripgrep live search for yazi integration
# Outputs the selected file path for yazi to navigate to
function yazi_ripgrep
    # Use our custom config
    set -gx RIPGREP_CONFIG_PATH $HOME/.config/ripgrep/.ripgreprc
    set -l RELOAD "reload:rg --column --color=always --smart-case {q} || :"

    set -l result (fzf --disabled --ansi \
        --bind "start:$RELOAD" --bind "change:$RELOAD" \
        --bind "ctrl-a:select-all,ctrl-u:deselect-all,ctrl-p:toggle-preview" \
        --delimiter : \
        --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
        --preview-window '~4,+{2}+4/3,<80(up)')

    # Unset custom config
    set -e RIPGREP_CONFIG_PATH

    if test -n "$result"
        # Extract just the filename (first field before :)
        set -l file (echo $result | cut -d: -f1)
        # Convert to absolute path and output
        realpath "$file" 2>/dev/null || echo "$file"
    end
end
