# Change greeting message. Leave empty to disable.
function fish_greeting
    fish_logo blue cyan green
    echo "░░░░░░▒░▒▒░▒▒▒▒▒▓▒▓▓▓█▓████▓▓▒▒▒░"
    echo " "
    # echo "░░░░░▒▒▒▒▒▓▓▓▓█████▓▓▓▓▒▒▒▒▒░░░░░"
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    if string match -q -- '*ghostty*' $TERM
        # NOTE: Workaround to change cursor shape in Vi mode w/ Ghostty
        set -g fish_vi_force_cursor 1
    end
    # NOTE: Disabling pyenv here as lazy loading from `pyenv.fish` and `python.fish` seems to work and this saves a lot of startup time.
    # pyenv virtualenv-init - fish | source 
    # pyenv init - fish | source 
    # atuin init fish | source # Disabling since we get history with fzf and this adds a lot to startup time.
    starship init fish | source
    zoxide init fish | source
    enable_transience
end
