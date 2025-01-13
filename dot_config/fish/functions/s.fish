function s --wraps='ssh' --description 'SSH with custom config'
    set -l host $argv[-1]
    if string match -q -- "-*" $host
        command ssh $argv
        return
    end

    _rsync_dotfiles $host

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
    command ssh $argv
end
