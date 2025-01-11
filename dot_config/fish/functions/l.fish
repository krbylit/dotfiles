function l --wraps='ls -lFh' --description 'alias l ls -lFh'
    # ls -lFh $argv
    eza --group-directories-first --long -F --color=always --icons=always --smart-group --time=modified --no-permissions --no-user
end
