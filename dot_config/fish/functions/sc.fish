function sc --wraps='chezmoi edit ~/.config/starship.toml --watch' --description 'alias sc chezmoi edit ~/.config/starship.toml --watch'
    chezmoi edit ~/.config/starship.toml --watch $argv

end
