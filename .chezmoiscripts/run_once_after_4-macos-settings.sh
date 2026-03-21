#!/usr/bin/env bash

# Only run on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    exit 0
fi

# Show cmd + tab App Switcher on all displays
defaults write com.apple.dock appswitcher-all-displays -bool true
# Disable press and hold on keyboard. Without disabled, hold brings up alt character selection. Disabled lets us do key repeat (e.g. hold `j` to continue scrolling in Vim)
defaults write -g ApplePressAndHoldEnabled -bool false
# Disable font smoothing to ensure we get pixel-perfect font. NOTE: may not be necessary on newer macOS versions.
defaults -currentHost write -g AppleFontSmoothing -int 0
# Set the number of items required for the "Services" submenu to appear in the right-click context menu. Setting to a number higher than the number of services selected in `Settings > Keyboard > Shortcuts > Services` will prevent the submenu from appearing. This allows us to "replace" the default "New Terminal Tab at Folder" that appears in the main context menu with our custom terminal service e.g. "New Ghostty Tab Here".
defaults write -g NSServicesMinimumItemCountForContextSubmenu -int 5
# Increase key repeat rate
defaults write -g InitialKeyRepeat -int 25
defaults write -g KeyRepeat -int 1

# Install fonts from chezmoi source into macOS font directory
FONT_SRC="$(chezmoi source-path)/cm-util/pkg-backups/fonts"
FONT_DST="$HOME/Library/Fonts"
if [[ -d "$FONT_SRC" ]]; then
    mkdir -p "$FONT_DST"
    cp -n "$FONT_SRC"/*.otf "$FONT_SRC"/*.ttf "$FONT_DST/" 2>/dev/null
fi
