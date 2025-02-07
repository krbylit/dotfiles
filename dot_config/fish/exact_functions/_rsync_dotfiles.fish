function _rsync_dotfiles
    set -l host $argv[-1]
    # Copy over terminfo for Ghostty if it doesn't exist
    set -l remote_terminfo (ssh -T $host "toe | grep ghostty" 2>/dev/null)
    if test -z "$remote_terminfo"
        echo "xterm-ghostty not found, installing..."
        infocmp -x | ssh $host -- tic -x -
    end

    # Copy configs
    rsync --recursive \
        --compress \
        --copy-links \
        --checksum \
        --progress \
        --partial \
        --partial-dir=~/.rsync-partials \
        --backup \
        --backup-dir=~/.dotfiles-backup \
        --chmod=ugo=rwX \
        ~/.ssh-dotfiles/ \
        # $host:~/
        $host:~/ 1>/dev/null 2>/dev/null
    return
end
