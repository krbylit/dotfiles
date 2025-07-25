#!/usr/bin/env bash

# Install Vi-Mongo
# curl -LO https://github.com/kopecmaciej/vi-mongo/releases/download/v0.1.18/vi-mongo_Darwin_x86_64.tar.gz && tar -xzf vi-mongo_Darwin_x86_64.tar.gz && chmod +x vi-mongo && sudo mv vi-mongo /opt && rm vi-mongo_Darwin_x86_64.tar.gz

# Install Hammerspoon and VimMode
if [ "${IS_SSH}" != "1" ]; then
    if [ ! -d "$HOME/.hammerspoon/Spoons/VimMode.spoon" ]; then
        curl -s https://raw.githubusercontent.com/dbalatero/VimMode.spoon/master/bin/installer | bash
    fi
fi

# Install Rust. brew install doesn't seem to play nice
if ! command -v rustup &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# Install nix. Needed for nil-ls in nvim
if ! command -v nix &>/dev/null; then
    curl -L https://nixos.org/nix/install | sh
fi

# # Install sbarlua, required for our sketchybar config
# git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua && cd /tmp/SbarLua/ && make install && rm -rf /tmp/SbarLua/

# Install Ghostty ascii animation (`ghostty_animation`)
if [ "${IS_SSH}" != "1" ]; then
    if ! command -v ghostty_animation &>/dev/null; then
        cd ~/Downloads
        git clone https://github.com/lukeshere/ghostty-animation-command
        cd ghostty-animation-command
        cargo build
        mv target/debug/ghostty_animation /usr/local/bin
    fi
fi

# We use Zellij here
# # Install tmux plugin manager
# if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
#     git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# fi

# Install aider chat
if [ "${IS_SSH}" != "1" ]; then
    if ! command -v aider &>/dev/null; then
        uv tool install aider-install
        # NOTE: need to source config again as this wasn't immediately available in PATH
        source ~/.config/fish/config.fish
        aider-install
        uv tool install --force --python python3.12 aider-chat@latest
    fi
fi

if [ "${IS_SSH}" != "1" ]; then
    if ! command -v claude &>/dev/null; then
        npm install -g @anthropic-ai/claude-code
    fi
fi
if [ "${IS_SSH}" != "1" ]; then
    if ! command -v tclock &>/dev/null; then
        cargo install clock-tui
    fi
fi

if [ "${IS_SSH}" != "1" ]; then
    if ! command -v regname &>/dev/null; then
        cargo install --locked --git https://github.com/linkdd/regname
    fi
fi

if [ "${IS_SSH}" != "1" ]; then
    if ! command -v hygg &>/dev/null; then
        cargo install --locked hygg
    fi
fi

if [ "${IS_SSH}" != "1" ]; then
    if ! command -v nerdlog &>/dev/null; then
        go install github.com/dimonomid/nerdlog/cmd/nerdlog@master
    fi
fi

if [ "${IS_SSH}" != "1" ]; then
    if ! command -v stormy &>/dev/null; then
        if command -v go &>/dev/null; then
            go install github.com/ashish0kumar/stormy@latest
        fi
    fi
fi

if ! command -v zellij &>/dev/null; then
    cargo install --locked zellij
fi

if [ "${IS_SSH}" != "1" ]; then
    if ! command -v ziina &>/dev/null; then
        go install github.com/ziinaio/zmate@latest
    fi
fi

# Install our gitleaks pre-commit hook
if [ "${IS_SSH}" != "1" ]; then
    cd $HOME/.local/share/chezmoi && pre-commit autoupdate
    cd $HOME/.local/share/chezmoi && pre-commit install
fi

# NOTE: handling this with submodule setup script now
# # Copy .gitmodules for secrets submodule
# cp $(chezmoi source-path)/secrets/dot_gitmodules $(chezmoi source-path)/.gitmodules

# Update fisher plugins
if command -v fish &>/dev/null; then
    fish -c "fisher update"
fi

if command -v bob &>/dev/null; then
    bob install stable
    if [ "${IS_SSH}" != "1" ]; then
        bob use stable
    fi
fi
