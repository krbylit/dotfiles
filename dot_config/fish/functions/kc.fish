function kc --wraps='chezmoi edit ~/.config/kitty/kitty.conf --watch' --description 'alias kc chezmoi edit ~/.config/kitty/kitty.conf --watch'
    chezmoi edit ~/.config/kitty/kitty.conf --watch $argv

end
