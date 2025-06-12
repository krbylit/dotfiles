function s --wraps='ssh' --description 'SSH with custom config'
    set -l host $argv[-1]
    set -l CUSTOM_HOSTNAME $host
    set -l session_name "kirby-$CUSTOM_HOSTNAME"

    set -l GIT_ASKPASS "\$HOME/.ssh-dotfiles/git_token.sh"
    # Git user and token should be set in `secrets` module and exported to shell env.
    set -l SSH_GIT_TOKEN $SSH_GIT_TOKEN
    set -l GIT_USER $GIT_USER
    # if not grep -qE "^Host[[:space:]]+$host$" ~/.ssh/config
    #     set CUSTOM_HOSTNAME ""
    # end
    if string match -q -- "-*" $host
        command ssh $argv
        return
    end

    _rsync_dotfiles $host
    # set -l dotfile_status $status
    #
    # set -l env_block "GIT_USER='$GIT_USER' SSH_GIT_TOKEN='$SSH_GIT_TOKEN' GIT_ASKPASS='$GIT_ASKPASS' CUSTOM_HOSTNAME='$CUSTOM_HOSTNAME'"
    #
    # switch $dotfile_status
    #     case 0
    #         set -l remote_cmd "env $env_block zellij --command 'fish --login'"
    #     case 1
    #         set -l remote_cmd "env $env_block zellij --command 'bash --login'"
    #     case 2
    #         set -l remote_cmd "env $env_block fish --login"
    #     case 3
    #         set -l remote_cmd "env $env_block bash --login"
    # end
    #
    # command ssh -t $argv "bash -c 'exec $remote_cmd'"

    # tmux new-session -d -s ghostty_session ghostty_animation
    # tmux attach-session -t ghostty_session
    #
    # tmux new-session -d -s ghostty_session ghostty_animation
    #
    # tmux new-session -d -s copy_session 'fish -c "_rsync_dotfiles '$host'; tmux send-keys -t ghostty_session C-c"'
    #
    # set -l copy_tasks_pid (jobs -lp | awk '{print $1}')
    # wait $copy_tasks_pid &
    #
    # tmux kill-session -t ghostty_session
    #
    # set -l animation_pid (pgrep ghostty_animation)
    # kill $animation_pid

    # Execute SSH with remaining arguments
    command ssh -t $argv "
        export GIT_USER=$GIT_USER;
        export SSH_GIT_TOKEN=$SSH_GIT_TOKEN;
        export GIT_ASKPASS=$GIT_ASKPASS;
        export CUSTOM_HOSTNAME=$CUSTOM_HOSTNAME;
        bash --login -c 'zellij attach $session_name 2>/dev/null || zellij --session $session_name 2>/dev/null || tmux new-session -A -s "$session_name" || bash --login'
    "

end
