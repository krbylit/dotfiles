#!/usr/bin/env bash

# Function to log messages with timestamps
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
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
  if [ "$(uname)" != "Linux" ]; then
    return 0
  fi

  if [ "$(id -u)" -eq 0 ]; then
    return 0
  fi

  if ! command -v sudo &>/dev/null; then
    log "sudo is unavailable; cannot prepare root-owned install directories automatically."
    return 1
  fi

  log "Requesting sudo once for Linux bootstrap prerequisites..."
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

load_brew_env() {
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    return 0
  fi

  if [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
    return 0
  fi

  if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    return 0
  fi

  return 1
}

# Check if Homebrew is installed
if ! command -v brew &>/dev/null; then
  log "Homebrew is not installed. Installing Homebrew..."
  if [ "$(uname)" = "Linux" ]; then
    ensure_owned_dir /home/linuxbrew/.linuxbrew || log "Failed to prepare /home/linuxbrew/.linuxbrew automatically."
  fi

  if ! NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
    if [ "$(uname)" = "Linux" ]; then
      log "Homebrew install failed on Linux. On a fresh machine, the default prefix usually needs to be created first:"
      log "  sudo mkdir -p /home/linuxbrew/.linuxbrew"
      log "  sudo chown -R $(id -un):$(id -gn) /home/linuxbrew/.linuxbrew"
    fi
  fi

  if ! load_brew_env && ! command -v brew &>/dev/null; then
    log "Homebrew is still unavailable after the install attempt. Skipping brew bundle."
    exit 1
  fi
else
  log "Homebrew is already installed."
fi

# Run brew bundle and capture stderr
log "Running brew bundle..."
tmp_err=$(mktemp) # Create a temporary file for stderr
if [ -z "$SSH_CONNECTION" ] && [ -z "$SSH_CLIENT" ] && [ -z "$SSH_TTY" ]; then
  if ! brew bundle --no-upgrade --file="$HOME/Brewfile" 2>"$tmp_err"; then
    log "brew bundle encountered errors:"
    tee -a "$ERROR_LOG" >&3 <"$tmp_err"
  else
    log "brew bundle completed successfully without errors."
  fi
fi
# If on remote machine, install limited Brew packages designed for remote
if [ -n "$SSH_CONNECTION" ] || [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  if ! brew bundle --no-upgrade --file="$HOME/Brewfile_ssh" 2>"$tmp_err"; then
    log "brew bundle encountered errors:"
    tee -a "$ERROR_LOG" >&3 <"$tmp_err"
  else
    log "brew bundle completed successfully without errors."
  fi
fi
rm -f "$tmp_err" # Clean up the temporary file
