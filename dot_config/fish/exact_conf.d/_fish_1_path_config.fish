# PATH setup — cross-platform (macOS + Linux)
# set -gx PATH $PATH /usr/local/bin # Homebrew on Intel silicon
set -gx PATH \
    $HOME/.cargo/bin \
    $HOME/.local/bin \
    $HOME/.local/share/bob/nvim-bin \
    $HOME/go/bin \
    $HOME/.cache/.bun/bin \
    $HOME/.local/share/pnpm \
    $HOME/.nix-profile/bin \
    /nix/var/nix/profiles/default/bin \
    $PATH

# Platform-specific paths
switch (uname)
    case Darwin
        fish_add_path --path /opt/homebrew/bin /opt/homebrew/sbin
        fish_add_path --path /Applications/Obsidian.app/Contents/MacOS
    case Linux
        fish_add_path --path /home/linuxbrew/.linuxbrew/bin /home/linuxbrew/.linuxbrew/sbin
end
