function _rsync_dotfiles
    set -l host $argv[-1]
    set -l ssh_opts $argv[1..-2]
    set -l local_term $TERM

    set -l ssh_cmd ssh $ssh_opts

    # Check if terminfo exists on remote
    set -l remote_terminfo (command $ssh_cmd -T $host "infocmp -T $local_term >/dev/null 2>&1; echo \$?")

    if test "$remote_terminfo" -ne 0
        infocmp -x | command $ssh_cmd $host -- tic -x -
    end

    # Copy configs
    rsync -e "ssh $ssh_opts" --recursive \
        --compress \
        --checksum \
        --progress \
        --partial \
        --partial-dir=~/.rsync-partials \
        --backup \
        --backup-dir=~/.dotfiles-backup \
        --chmod=ugo=rwX \
        ~/.ssh-dotfiles/ \
        $host:~/.ssh-dotfiles/ 1>/dev/null 2>/dev/null

    # Then sync specific dotfiles
    rsync -e "ssh $ssh_opts" --compress \
        --checksum \
        --progress \
        --partial \
        --partial-dir=~/.rsync-partials \
        --backup \
        --backup-dir=~/.dotfiles-backup \
        --chmod=ugo=rwX \
        ~/.bashrc \
        ~/private.bashrc \
        ~/.vimrc \
        $host:~/ 1>/dev/null 2>/dev/null

    # Verify if terminfo is now available
    set -l term_check (command $ssh_cmd -T $host "infocmp -T $local_term >/dev/null 2>&1; echo \$?")

    if test "$term_check" -eq 0
        echo $local_term
    else
        echo xterm-256color
    end
end
