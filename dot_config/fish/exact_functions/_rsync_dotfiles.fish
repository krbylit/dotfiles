function _rsync_dotfiles
    set -l host $argv[-1]
    # set -l dotfile_status 0

    # Copy over terminfo for Ghostty if it doesn't exist
    set -l remote_terminfo (ssh -T $host "toe | grep ghostty" 2>/dev/null)
    if test -z "$remote_terminfo"
        echo "xterm-ghostty not found, installing..."
        infocmp -x | ssh $host -- tic -x -
    end

    # # Check fish
    # ssh -T $host "command -v fish >/dev/null" 2>/dev/null
    # or set dotfile_status (math $dotfile_status + 1)
    #
    # # Check zellij
    # ssh -T $host "command -v zellij >/dev/null" 2>/dev/null
    # or set dotfile_status (math $dotfile_status + 2)

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
        $host:~/.ssh-dotfiles/ 1>/dev/null 2>/dev/null

    # Then sync specific dotfiles
    rsync --compress \
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
    return
    # return $dotfile_status
end
