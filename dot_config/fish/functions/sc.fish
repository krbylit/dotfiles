function sc --wraps='chezmoi edit ~/.config/starship.toml --watch' --description 'alias sc chezmoi edit ~/.config/starship.toml --watch'
    nvim ~/.config/starship.toml $argv

end
