function ksh --wraps='kitten ssh' --description 'SSH with custom config'
    AX_APPLICATION=1 kitty kitten ssh -t $argv 'if which zsh >/dev/null 2>&1; then exec zsh; else exec bash --rcfile /tmp/ssh-kitten-config/.ssh-dotfiles/.bashrc; fi'
end
