# Zellij session picker with fzf
function zellij_picker
    set -l OPENER 'zellij attach {1}'

    # Strip ANSI escape codes and parse session names
    zellij list-sessions 2>/dev/null | sed 's/\x1b\[[0-9;]*m//g' | awk '{print $1}' | fzf \
        --prompt 'Zellij> ' \
        --header 'Enter: attach | Ctrl-x: kill session' \
        --bind "enter:become:$OPENER" \
        --bind "ctrl-x:execute-silent(zellij delete-session --force {})+reload(zellij list-sessions 2>/dev/null | sed 's/\x1b\[[0-9;]*m//g' | awk '{print \$1}')" \
        --preview 'zellij list-sessions | rg {1}' \
        --preview-window 'down,1,border-line,nowrap,noinfo' \
        --query "$argv"
end
