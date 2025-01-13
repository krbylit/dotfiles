function frg
    command rg --hidden --no-ignore --follow --color=always --line-number --no-heading --smart-case $argv \
        | command fzf -d ':' --ansi \
        --preview "command bat -p --color=always {1} --highlight-line {2}" \
        --preview-window '~8,+{2}-5' \
        | awk -F ':' '{print $1}'
end
