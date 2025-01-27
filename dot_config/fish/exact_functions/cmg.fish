function cmg --wraps='lazygit -p (chezmoi source-path)' --description 'alias cmg lazygit -p (chezmoi source-path)'
  lazygit -p (chezmoi source-path) $argv
        
end
