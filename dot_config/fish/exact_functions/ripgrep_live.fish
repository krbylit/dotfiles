# Yanked from https://junegunn.github.io/fzf/tips/ripgrep-integration/
# ripgrep->fzf->vim [QUERY]
function ripgrep_live
    # Use our custom config
    set -gx RIPGREP_CONFIG_PATH $HOME/.config/ripgrep/.ripgreprc
    set -l RELOAD "reload:rg --column --color=always --smart-case {q} || :"
    set -l OPENER '
        if test $FZF_SELECT_COUNT -eq 0
            $EDITOR {1} +{2}  # No selection. Open the current line in Vim.
        else
            $EDITOR +cw -q {+f}  # Build quickfix list for the selected items.
        end
    '

    fzf --disabled --ansi --multi \
        --bind "start:$RELOAD" --bind "change:$RELOAD" \
        --bind "enter:become:$OPENER" \
        --bind "ctrl-o:execute:$OPENER" \
        --bind "alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview" \
        --delimiter : \
        --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
        --preview-window '~4,+{2}+4/3,<80(up)' \
        --query "$argv"
    # Unset custom config so `rg <pattern>` works as it normally would
    set -e RIPGREP_CONFIG_PATH
end
