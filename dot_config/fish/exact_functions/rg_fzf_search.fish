# Yanked from https://junegunn.github.io/fzf/releases/0.59.0/#search-and-transform-search-action
# FIXME: fish conversion not working
function rg_fzf_search
    set -l TEMP (mktemp -u)
    trap "rm -f $TEMP" EXIT

    set -l INITIAL_QUERY (string join " " $argv)
    set -l TRANSFORMER '
        rg_pat={q:1}      # The first word is passed to ripgrep
        fzf_pat={q:2..}   # The rest are passed to fzf

        if not test -r "$TEMP" || test "$rg_pat" != (cat "$TEMP")
            echo "$rg_pat" > "$TEMP"
            printf "reload:sleep 0.1; rg --column --line-number --no-heading --color=always --smart-case %q || true" "$rg_pat"
        end
        echo "+search:$fzf_pat"
    '

    fzf --ansi --disabled --query "$INITIAL_QUERY" \
        --with-shell "fish -c" \
        --bind "start,change:transform:$TRANSFORMER" \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --delimiter : \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'up,60%,border-line,+{2}+3/3,~3' \
        --bind 'enter:become(vim {1} +{2})'
end
