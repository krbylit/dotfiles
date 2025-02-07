#!/usr/bin/env bash

# fish -c "fisher update" >/dev/null 2>&1

# Workaround for pulling fisher files in to main config
ln -s ~/.config/fish/fisher/conf.d/* ~/.config/fish/conf.d >/dev/null 2>&1 || true
ln -s ~/.config/fish/fisher/functions/* ~/.config/fish/functions >/dev/null 2>&1 || true
ln -s ~/.config/fish/fisher/completions/* ~/.config/fish/completions >/dev/null 2>&1 || true
ln -s ~/.config/fish/fisher/themes/* ~/.config/fish/themes >/dev/null 2>&1 || true

# TODO: Need a better way to handle setting fish theme than here
# fish -c 'fish_config theme save "Catppuccin Mocha"'
