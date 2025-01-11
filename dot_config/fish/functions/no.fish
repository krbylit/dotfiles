function no --wraps='nvim ~/.nb' --description 'alias no nvim ~/.nb'
    nvim ~/.nb $argv
    # nvim --cmd 'cd ~/.nb' -c 'lua Snacks.dashboard({win=0})' $argv

end
