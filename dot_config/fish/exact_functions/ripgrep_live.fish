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
        --delimiter : \
        --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
        --preview-window '~4,+{2}+4/3,<80(up)'
    # --query "$argv" # NOTE: This puts any text already on command line into to query, so with this enabled we cannot use this to "fill in" an argument; e.g. `nvim <ripgrep_live()>` does not work to open found file, it will search "nvim".
    # Unset custom config so `rg <pattern>` works as it normally would
    set -e RIPGREP_CONFIG_PATH
end
# this is closest we've gotten to rg-to-fzf
# function rg_fzf
#     set -gx RIPGREP_CONFIG_PATH $HOME/.config/ripgrep/.ripgreprc
#
#     set -l TEMP (mktemp)
#     set -l INITIAL_QUERY (string join " " $argv)
#
#     # Use bash for the transformer since that's what the original example uses
#     set -l TRANSFORMER '
#         rg_pat={q:1}
#         fzf_pat={q:2..}
#
#         if ! [[ -r "'$TEMP'" ]] || [[ $rg_pat != $(cat "'$TEMP'") ]]; then
#             echo "$rg_pat" > "'$TEMP'"
#             printf "reload:rg --column --line-number --no-heading --color=always --smart-case %q || :" "$rg_pat"
#         fi
#         echo "+search:$fzf_pat"
#     '
#
#     set -l OPENER '
#         if test $FZF_SELECT_COUNT -eq 0
#             $EDITOR {1} +{2}
#         else
#             $EDITOR +cw -q {+f}
#         end
#     '
#
#     # Simple ctrl+g action - run ripgrep and pipe to new fzf
#     set -l CTRL_G_ACTION '
#         rg --column --line-number --no-heading --color=always --smart-case {q} || : |
#         fzf --ansi --multi \
#             --prompt "FZF> " \
#             --delimiter : \
#             --preview "bat --style=full --color=always --highlight-line {2} {1}" \
#             --preview-window "~4,+{2}+4/3,<80(up)" \
#             --bind "enter:become:'$OPENER'" \
#             --bind "ctrl-o:execute:'$OPENER'" \
#             --bind "alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview"
#     '
#
#     fzf --ansi --disabled --multi \
#         --prompt 'RG> ' \
#         --query "$INITIAL_QUERY" \
#         --with-shell 'bash -c' \
#         --bind "start,change:transform:$TRANSFORMER" \
#         --bind "ctrl-g:become:$CTRL_G_ACTION" \
#         --color "hl:-1:underline,hl+:-1:underline:reverse" \
#         --delimiter : \
#         --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
#         --preview-window '~4,+{2}+4/3,<80(up)' \
#         --bind "enter:become:$OPENER" \
#         --bind "ctrl-o:execute:$OPENER" \
#         --bind "alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview"
#
#     rm -f $TEMP
#     set -e RIPGREP_CONFIG_PATH
# end
