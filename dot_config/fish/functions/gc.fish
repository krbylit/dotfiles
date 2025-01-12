function gc
    nvim --cmd 'cd ~/.local/share/chezmoi' ~/.local/share/chezmoi/dot_config/ghostty/ghostty.conf.tmpl $argv
end
