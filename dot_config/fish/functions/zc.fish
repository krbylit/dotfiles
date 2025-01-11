function zc --wraps='chezmoi edit ~/.zshrc --watch' --description 'alias zc chezmoi edit ~/.zshrc --watch'
    chezmoi edit ~/.zshrc --watch $argv

end
