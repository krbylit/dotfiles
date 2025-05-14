# PATH setup
# set -gx PATH $PATH /opt # `vi-mongo` installs to /opt
set -gx PATH $PATH $HOME/.local/bin
set -gx PATH $PATH /nix/var/nix/profiles/default/bin
# nvim version manager binaries
set -gx PATH $PATH $HOME/.local/share/bob/nvim-bin
# set -gx PATH $PATH /usr/local/bin # Homebrew on Intel silicon
set -gx PATH /opt/homebrew/sbin $PATH
set -gx PATH /opt/homebrew/bin $PATH # Homebrew on Apple silicon
set -gx PATH $HOME/go/bin $PATH # Go-installed binaries
