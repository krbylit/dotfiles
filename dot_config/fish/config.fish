# Change greeting message. Leave empty to disable.
function fish_greeting
    fish_logo blue cyan green
    echo "░░░░░░▒░▒▒░▒▒▒▒▒▓▒▓▓▓█▓████▓▓▒▒▒░"
    echo " "
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    if string match -q -- '*ghostty*' $TERM
        # NOTE: Workaround to change cursor shape in Vi mode w/ Ghostty
        set -g fish_vi_force_cursor 1
    end
    # atuin init fish | source # Disabling since we get history with fzf and this adds a lot to startup time.
    starship init fish | source
    zoxide init fish | source
    enable_transience
end
