# PATH setup 
# set -gx PATH $PATH /usr/local/bin # Homebrew on Intel silicon
set -gx PATH $PATH /opt/homebrew/bin # Homebrew on Apple silicon
set -gx PATH $PATH /opt/homebrew/sbin
# set -gx PATH $PATH /opt # `vi-mongo` installs to /opt
set -gx PATH $PATH $HOME/.local/bin
set -gx PATH $PATH /nix/var/nix/profiles/default/bin
