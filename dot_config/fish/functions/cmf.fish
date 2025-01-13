function cmf --wraps='chezmoi apply --force' --description 'alias cmf chezmoi apply --force'
  chezmoi apply --force $argv
        
end
