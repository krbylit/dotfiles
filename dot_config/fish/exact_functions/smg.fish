function smg --wraps='lazygit -p (chezmoi source-path)/secrets' --description 'alias smg lazygit -p (chezmoi source-path)/secrets'
    lazygit -p (chezmoi source-path)/secrets $argv
end
