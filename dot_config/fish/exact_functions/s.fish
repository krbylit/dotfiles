function s --wraps='ssh' --description 'SSH with custom config'
    set -l host $argv[-1]
    set -l ssh_args $argv

    set -l CUSTOM_HOSTNAME $host
    set -l session_name "$USER-$CUSTOM_HOSTNAME"

    set -l GIT_ASKPASS "\$HOME/.ssh-dotfiles/git_token.sh"
    # Git user and token should be set in `secrets` module and exported to shell env.
    set -l SSH_GIT_TOKEN $SSH_GIT_TOKEN
    set -l GIT_USER $GIT_USER
    set -l AWS_ACCESS_KEY_ID $AWS_ACCESS_KEY_ID
    set -l AWS_SECRET_ACCESS_KEY $AWS_SECRET_ACCESS_KEY

    if string match -q -- "-*" $host
        command ssh $ssh_args
        return
    end

    set -l remote_term (_rsync_dotfiles $ssh_args | string trim)

    # command ssh -t $ssh_args "
    command ssh -A -t $ssh_args TERM=$remote_term "
        export TERM=$remote_term;
        export GIT_USER=$GIT_USER;
        export SSH_GIT_TOKEN=$SSH_GIT_TOKEN;
        export GIT_ASKPASS=$GIT_ASKPASS;
        export CUSTOM_HOSTNAME=$CUSTOM_HOSTNAME;
        export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY;
        export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID;
        export SSH_AUTH_SOCK=\$SSH_AUTH_SOCK;
        bash --login -c 'zellij attach $session_name 2>/dev/null || zellij --session $session_name 2>/dev/null || tmux new-session -A -s "$session_name" || bash --login'
    "
end
