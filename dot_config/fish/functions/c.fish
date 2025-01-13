function c --wraps=nvim\ --cmd\ \'cd\ ~/.local/share/chezmoi\'\ -c\ \'lua\ Snacks.dashboard\(\{win=0\}\)\' --description alias\ c\ nvim\ --cmd\ \'cd\ ~/.local/share/chezmoi\'\ -c\ \'lua\ Snacks.dashboard\(\{win=0\}\)\'
    nvim --cmd 'cd ~/.local/share/chezmoi' -c 'lua Snacks.dashboard({win=0})' $argv

end
