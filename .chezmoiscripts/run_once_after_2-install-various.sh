#!/bin/bash

# Install Vi-Mongo
# curl -LO https://github.com/kopecmaciej/vi-mongo/releases/download/v0.1.18/vi-mongo_Darwin_x86_64.tar.gz && tar -xzf vi-mongo_Darwin_x86_64.tar.gz && chmod +x vi-mongo && sudo mv vi-mongo /opt && rm vi-mongo_Darwin_x86_64.tar.gz

# Install Hammerspoon and VimMode
if [ ! -d "$HOME/.hammerspoon/Spoons/VimMode.spoon" ]; then
	curl -s https://raw.githubusercontent.com/dbalatero/VimMode.spoon/master/bin/installer | bash
fi

# Install Rust. brew install doesn't seem to play nice
if ! command -v rustup &>/dev/null; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# Install nix. Needed for nil-ls in nvim
if ! command -v nix &>/dev/null; then
	curl -L https://nixos.org/nix/install | sh
fi

# Install ruff-lsp for Neovim
if ! command -v ruff-lsp &>/dev/null; then
	pip install ruff-lsp
fi

# # Install sbarlua, required for our sketchybar config
# git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua && cd /tmp/SbarLua/ && make install && rm -rf /tmp/SbarLua/

# Install Ghostty ascii animation (`ghostty_animation`)
if ! command -v ghostty_animation &>/dev/null; then
	cd ~/Downloads
	git clone https://github.com/lukeshere/ghostty-animation-command
	cd ghostty-animation-command
	cargo build
	mv target/debug/ghostty_animation /usr/local/bin
fi

# Install tmux plugin manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install pre-commit for commit hooks
if ! command -v pre-commit &>/dev/null; then
	pip install pre-commit
fi

# Install ruff
if ! command -v ruff &>/dev/null; then
	pip install ruff
fi
if ! command -v ruff-lsp &>/dev/null; then
	pip install ruff-lsp
fi

# Install yapf
if ! command -v yapf &>/dev/null; then
	pip install yapf
fi

# Install aider chat
if ! command -v aider &>/dev/null; then
	python -m pip install aider-install
	# NOTE: need to source config again as this wasn't immediately available in PATH
	source ~/.config/fish/config.fish
	aider-install
	python -m pip install -U aider-chat
fi

# Install our gitleaks pre-commit hook
cd $(chezmoi source-path) && pre-commit autoupdate
cd $(chezmoi source-path) && pre-commit install

# Copy .gitmodules for secrets submodule
cp $(chezmoi source-path)/secrets/dot_gitmodules $(chezmoi source-path)/.gitmodules
