#!/bin/bash

VAULT_DIR="$HOME/obsidian-vault"

if [ ! -d "$VAULT_DIR/.git" ]; then
    exit 0
fi

cd "$VAULT_DIR" || exit 1
git pull --rebase origin "$(git branch --show-current)" 2>&1
