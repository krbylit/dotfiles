# tmux

## SSH

- for using TPM (tmux plugin manager) w/ `kitten ssh`, these are the minimum required files that must be copied to the remote host:
  - local `~/.tmux/plugins/tpm/<bin/ & bindings/ & scripts/ & tpm>` > remote same location
  - local `~/.config/tmux/tmux.conf` > remote `~/.tmux.conf`
