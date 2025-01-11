function vc --wraps=nvim\ --cmd\ \'cd\ ~/.local/share/chezmoi/private_dot_config/exact_nvim\'\ -c\ \'lua\ Snacks.dashboard\(\{win=0\}\)\' --description alias\ vc\ nvim\ --cmd\ \'cd\ ~/.local/share/chezmoi/private_dot_config/nvim\'\ -c\ \'lua\ Snacks.dashboard\(\{win=0\}\)\'
    nvim --cmd 'cd ~/.local/share/chezmoi/private_dot_config/exact_nvim' -c 'lua Snacks.dashboard({win=0})' $argv

end
