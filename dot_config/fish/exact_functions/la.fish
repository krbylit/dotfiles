function la --wraps='ls -lAFh' --description 'alias la ls -lAFh'
    # ls -lAFh $argv
    eza -a --group-directories-first --long -F --color=always --icons=always --time=modified
end
