#!/usr/bin/env bash

have() {
  command -v "$1" &>/dev/null
}

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

is_linux() {
  [ "$(uname)" = "Linux" ]
}

has_sudo_ticket() {
  if ! is_linux; then
    return 1
  fi

  if [ "$(id -u)" -eq 0 ]; then
    return 0
  fi

  have sudo && sudo -n true >/dev/null 2>&1
}

running_under_chezmoi() {
  parent_comm="$(ps -o comm= -p "$PPID" 2>/dev/null | awk '{$1=$1; print}')"
  parent_args="$(ps -o args= -p "$PPID" 2>/dev/null | awk '{$1=$1; print}')"

  case "$parent_comm $parent_args" in
  *chezmoi*)
    return 0
    ;;
  esac

  return 1
}

SCRIPT_NAME="$(basename "$0")"
ERROR_LOG="$(mktemp "/tmp/${SCRIPT_NAME}.XXXXXX.err")"
exec 3>&2
exec 2> >(tee -a "$ERROR_LOG" >&3)

SUDO_KEEPALIVE_PID=""

cleanup() {
  exit_status=$?

  if [ -n "$SUDO_KEEPALIVE_PID" ]; then
    kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true
  fi

  if [ "$exit_status" -ne 0 ] && [ -s "$ERROR_LOG" ]; then
    echo
    echo "Error summary for $SCRIPT_NAME:"
    sed 's/^/  /' "$ERROR_LOG"
  fi

  rm -f "$ERROR_LOG"

  return "$exit_status"
}

trap cleanup EXIT

prime_sudo() {
  if ! is_linux; then
    return 0
  fi

  if [ "$(id -u)" -eq 0 ]; then
    return 0
  fi

  if ! have sudo; then
    echo "sudo is unavailable; cannot prepare root-owned install directories automatically."
    return 1
  fi

  echo "Requesting sudo once for Linux bootstrap prerequisites..."
  sudo -v 2>&3 || return 1

  if [ -z "$SUDO_KEEPALIVE_PID" ]; then
    while true; do
      sudo -n true
      sleep 30
    done >/dev/null 2>&1 &
    SUDO_KEEPALIVE_PID=$!
  fi

  return 0
}

ensure_owned_dir() {
  dir_path="$1"
  owner_name="${2:-$(id -un)}"
  group_name="${3:-$(id -gn)}"
  dir_mode="${4:-0755}"

  if [ -d "$dir_path" ] && [ -w "$dir_path" ]; then
    return 0
  fi

  prime_sudo || return 1
  sudo mkdir -p -m "$dir_mode" "$dir_path"
  sudo chown -R "$owner_name:$group_name" "$dir_path"
}

prepare_local_build_dirs() {
  export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
  export TMPDIR="${TMPDIR:-$XDG_CACHE_HOME/chezmoi/tmp}"
  export CARGO_TARGET_DIR="${CARGO_TARGET_DIR:-$XDG_CACHE_HOME/cargo-install}"
  export CARGO_BUILD_JOBS="${CARGO_BUILD_JOBS:-1}"

  mkdir -p "$TMPDIR" "$CARGO_TARGET_DIR" "$HOME/.local/bin"
}

load_brew_env() {
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  elif [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
}

load_cargo_env() {
  if [ -f "$HOME/.cargo/env" ]; then
    # rustup writes PATH updates here for the current shell session
    . "$HOME/.cargo/env"
  fi
}

# Ensure Homebrew is in PATH
load_brew_env
load_cargo_env
prepare_local_build_dirs

# Ensure CC is set for Cargo and other build tools
if ! have cc; then
  if have gcc; then
    export CC=gcc
  elif have clang; then
    export CC=clang
  fi
fi

# Setup Node.js with fnm (Fast Node Manager)
# Ensure a default Node version is installed on all systems
if have fnm; then
  if [ "${IS_SSH}" = "1" ]; then
    # TODO: Consolidate all installer env vars into a single place for easier management
    DEFAULT_NODE_VERSION="v18.20.8" # Change to a lighter version for remote machines if desired
  else
    DEFAULT_NODE_VERSION="v25.6.1" # Change to your preferred version
  fi

  # Install the default version if not already installed
  if ! fnm list | grep -q "$DEFAULT_NODE_VERSION"; then
    echo "Installing Node $DEFAULT_NODE_VERSION..."
    fnm install "$DEFAULT_NODE_VERSION"
  fi

  # Set as default
  echo "Setting Node $DEFAULT_NODE_VERSION as default..."
  fnm default "$DEFAULT_NODE_VERSION"

  # Initialize fnm for the current shell session so node/npm are available
  eval "$(fnm env --shell bash)"

  echo "Node setup complete"
  fnm list
fi

# Install Vi-Mongo
# curl -LO https://github.com/kopecmaciej/vi-mongo/releases/download/v0.1.18/vi-mongo_Darwin_x86_64.tar.gz && tar -xzf vi-mongo_Darwin_x86_64.tar.gz && chmod +x vi-mongo && sudo mv vi-mongo /opt && rm vi-mongo_Darwin_x86_64.tar.gz

# Install Hammerspoon and VimMode
if [ "${IS_SSH}" != "1" ]; then
  if [ ! -d "$HOME/.hammerspoon/Spoons/VimMode.spoon" ]; then
    curl -s https://raw.githubusercontent.com/dbalatero/VimMode.spoon/master/bin/installer | bash
  fi
fi

# if [ "${IS_SSH}" != "1" ]; then
#   if ! command -v cursor-agent &>/dev/null; then
#     curl https://cursor.com/install -fsS | bash
#   fi
# fi

# Install Rust. brew install doesn't seem to play nice
if ! have rustup; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
load_cargo_env

# Install nix. Needed for nil-ls in nvim
if ! have nix; then
  if is_linux && [ ! -d /nix ] && ! has_sudo_ticket; then
    log "Skipping Nix install on Linux because /nix requires sudo and no cached sudo ticket is available."
  else
    if is_linux; then
      ensure_owned_dir /nix || {
        log "Failed to prepare /nix automatically."
        exit 1
      }
    fi
    curl -L https://nixos.org/nix/install | sh -s -- --no-daemon
  fi
fi

# # Install sbarlua, required for our sketchybar config
# git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua && cd /tmp/SbarLua/ && make install && rm -rf /tmp/SbarLua/

# Install Ghostty ascii animation (`ghostty_animation`)
if [ "${IS_SSH}" != "1" ]; then
  if ! have ghostty_animation && have cargo; then
    mkdir -p ~/Downloads
    cd ~/Downloads || exit 1
    if [ ! -d ghostty-animation-command/.git ]; then
      git clone https://github.com/lukeshere/ghostty-animation-command
    fi
    cd ghostty-animation-command || exit 1
    cargo build
    if [ -f target/debug/ghostty_animation ]; then
      mkdir -p "$HOME/.local/bin"
      mv target/debug/ghostty_animation "$HOME/.local/bin"
    fi
  fi
fi

# We use Zellij here
# # Install tmux plugin manager
# if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
#     git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# fi

# Install aider chat
# if [ "${IS_SSH}" != "1" ]; then
#   if ! command -v aider &>/dev/null; then
#     uv tool install aider-install
#     # NOTE: need to source config again as this wasn't immediately available in PATH
#     source ~/.config/fish/config.fish
#     aider-install
#     uv tool install --force --python python3.12 aider-chat@latest
#   fi
# fi

if [ "${IS_SSH}" != "1" ]; then
  if ! have specify && have uv; then
    uv tool install specify-cli --from git+https://github.com/github/spec-kit.git
  fi
fi

if [ "${IS_SSH}" != "1" ]; then
  if ! have claude-code-acp && have npm; then
    npm install -g @zed-industries/claude-code-acp
  fi
fi

if ! have typescript-language-server && have npm; then
  npm install -g typescript typescript-language-server
fi

if [ "${IS_SSH}" != "1" ]; then
  if ! have claude && have npm; then
    npm install -g @anthropic-ai/claude-code
  fi
fi

if [ "${IS_SSH}" != "1" ]; then
  if ! have reddix; then
    curl --proto '=https' --tlsv1.2 -LsSf https://github.com/ck-zhang/reddix/releases/latest/download/reddix-installer.sh | sh
  fi
fi

if [ "${IS_SSH}" != "1" ]; then
  if ! have csvi && have go; then
    go install github.com/hymkor/csvi/cmd/csvi@latest
  fi
fi

if [ "${IS_SSH}" != "1" ]; then
  if ! have pomo && have go; then
    go install github.com/Bahaaio/pomo@latest
  fi
fi

if [ "${IS_SSH}" != "1" ]; then
  if ! have trex && have go; then
    go install github.com/samyakbardiya/trex@latest
  fi
fi

if [ "${IS_SSH}" != "1" ]; then
  if ! have e2c && have go; then
    go install github.com/nlamirault/e2c/cmd/e2c@latest
  fi
fi

if [ "${IS_SSH}" != "1" ]; then
  if ! have tclock && have cargo; then
    cargo install wiki-tui
  fi
fi

if [ "${IS_SSH}" != "1" ]; then
  if ! have tclock && have cargo; then
    cargo install clock-tui
  fi
fi

if [ "${IS_SSH}" != "1" ]; then
  if ! have filessh && have cargo; then
    cargo install --locked filessh
  fi
fi

if [ "${IS_SSH}" != "1" ]; then
  if ! have trip && have cargo; then
    # TUI for network monitoring
    cargo install trippy --locked
  fi
fi

if [ "${IS_SSH}" != "1" ]; then
  if ! have rustnet && have cargo; then
    # TUI for network monitoring
    cargo install rustnet-monitor
  fi
fi

if [ "${IS_SSH}" != "1" ]; then
  if ! have gittype && have cargo; then
    cargo install gittype
  fi
fi

if [ "${IS_SSH}" != "1" ]; then
  if ! have glues && have cargo; then
    cargo install glues
  fi
fi

# Terminal local network file sharing TUI
if [ "${IS_SSH}" != "1" ]; then
  if ! have jocalsend && have cargo; then
    cargo install jocalsend
  fi
fi

if [ "${IS_SSH}" != "1" ]; then
  if ! have regname && have cargo; then
    cargo install --locked --git https://github.com/linkdd/regname
  fi
fi

if [ "${IS_SSH}" != "1" ]; then
  if ! have hygg && have cargo; then
    cargo install --locked hygg
  fi
fi

if [ "${IS_SSH}" != "1" ]; then
  if have gh; then
    if gh auth status >/dev/null 2>&1; then
      if ! gh extension list | awk '{print $1}' | grep -qx "dlvhdr/gh-dash"; then
        gh extension install dlvhdr/gh-dash
      fi
      if ! gh extension list | awk '{print $1}' | grep -qx "dlvhdr/gh-enhance"; then
        gh extension install dlvhdr/gh-enhance
      fi
    else
      echo "Skipping gh extension install because gh is not authenticated."
    fi
  fi
fi

if [ "${IS_SSH}" != "1" ]; then
  if ! have nerdlog && have go; then
    go install github.com/dimonomid/nerdlog/cmd/nerdlog@master
  fi
fi

if [ "${IS_SSH}" != "1" ]; then
  if ! have tuios && have go; then
    go install github.com/Gaurav-Gosain/tuios/cmd/tuios@latest
  fi
fi

if [ "${IS_SSH}" != "1" ]; then
  if ! have stormy; then
    if have go; then
      go install github.com/ashish0kumar/stormy@latest
    fi
  fi
fi

if [ "${IS_SSH}" == "1" ]; then
  if ! have systemd-manager-tui; then
    if have cargo; then
      cargo install --locked systemd-manager-tui
    fi
  fi
fi

if [ "${IS_SSH}" != "1" ]; then
  if ! have ugdb; then
    if have cargo; then
      cargo install ugdb
    fi
  fi
else
  log "Skipping ugdb install on SSH hosts to keep remote bootstrap lighter."
fi

if [ "${IS_SSH}" != "1" ]; then
  if ! have ziina && have go; then
    go install github.com/ziinaio/zmate@latest
  fi
fi

if [[ "$(uname)" != "Darwin" ]]; then
  cp "$HOME/.local/share/chezmoi/cm-util/pkg-backups/home/.local/bin/yazi-linux/ya" "$HOME/.local/bin/ya"
  cp "$HOME/.local/share/chezmoi/cm-util/pkg-backups/home/.local/bin/yazi-linux/yazi" "$HOME/.local/bin/yazi"
fi

if [[ "$(uname)" = "Darwin" ]]; then
  cp "$HOME/.local/share/chezmoi/cm-util/pkg-backups/home/.local/bin/ya" "$HOME/.local/bin/ya"
  cp "$HOME/.local/share/chezmoi/cm-util/pkg-backups/home/.local/bin/yazi" "$HOME/.local/bin/yazi"
fi

# Install our gitleaks pre-commit hook
if [ "${IS_SSH}" != "1" ]; then
  if have pre-commit; then
    cd "$HOME/.local/share/chezmoi" || exit 1
    pre-commit autoupdate
    pre-commit install
  fi
fi

# NOTE: handling this with submodule setup script now
# # Copy .gitmodules for secrets submodule
# cp $(chezmoi source-path)/secrets/dot_gitmodules $(chezmoi source-path)/.gitmodules

# Update fisher plugins
if have fish; then
  if running_under_chezmoi; then
    log "Skipping fisher update during chezmoi apply to avoid chezmoi lock contention."
  else
    fish -c "fisher update"
  fi
fi

# FIX: Something is up with `bob` (maybe just local install). Can't find/use/install "stable" release.
# if command -v bob &>/dev/null; then
#     bob install stable
#     if [ "${IS_SSH}" != "1" ]; then
#         bob use stable
#     fi
# fi
