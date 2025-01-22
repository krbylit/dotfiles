function sc --wraps='chezmoi edit ~/.config/starship.toml --watch' --description 'alias sc chezmoi edit ~/.config/starship.toml --watch'
    nvim (chezmoi source-path)(chezmoi data | jql --raw-string ' "path" "secrets"'
    )/.ssh/private_config $argv

end
