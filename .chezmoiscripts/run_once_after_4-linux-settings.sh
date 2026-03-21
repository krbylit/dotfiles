#!/usr/bin/env bash

# Only run on Linux
if [[ "$(uname)" != "Linux" ]]; then
    exit 0
fi

# Install fonts from chezmoi source into Linux font directory
FONT_SRC="$(chezmoi source-path)/cm-util/pkg-backups/fonts"
FONT_DST="$HOME/.local/share/fonts"
if [[ -d "$FONT_SRC" ]]; then
    mkdir -p "$FONT_DST"
    cp -u "$FONT_SRC"/*.otf "$FONT_SRC"/*.ttf "$FONT_DST/" 2>/dev/null
    fc-cache -fv
fi
