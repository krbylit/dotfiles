function _rsync_dotfiles
    set -l host $argv[-1]
    # Copy over terminfo for Ghostty if it doesn't exist
    set -l remote_terminfo (ssh -T $host "toe | grep ghostty")
    if test -z "$remote_terminfo"
        echo "xterm-ghostty not found, installing..."
        infocmp -x | ssh $host -- tic -x -
    end

    # Copy configs
    rsync --recursive \
        --compress \
        --checksum \
        --progress \
        --partial \
        --partial-dir=~/.rsync-partials \
        --backup \
        --backup-dir=~/.dotfiles-backup \
        --chmod=ugo=rwX \
        ~/.ssh-dotfiles/ \
        $host:~/
    return
end
