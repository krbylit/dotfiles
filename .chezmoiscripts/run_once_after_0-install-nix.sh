#!/usr/bin/env bash

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

have() {
  command -v "$1" &>/dev/null
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
    log "sudo is unavailable; cannot prepare root-owned install directories automatically."
    return 1
  fi

  log "Requesting sudo once for Nix bootstrap..."
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

load_nix_env() {
  if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
  elif [ -f "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
    . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
  fi
}

# Install Nix if not present
load_nix_env

if ! have nix; then
  if is_linux && [ ! -d /nix ] && ! has_sudo_ticket; then
    log "Skipping Nix install on Linux because /nix requires sudo and no cached sudo ticket is available."
    exit 0
  fi

  if is_linux; then
    ensure_owned_dir /nix || {
      log "Failed to prepare /nix directory. Cannot install Nix."
      exit 1
    }
  fi

  log "Installing Nix..."
  curl -L https://nixos.org/nix/install | sh -s -- --no-daemon
  load_nix_env
fi

if ! have nix; then
  log "Nix is still unavailable after install attempt. Skipping nix package install."
  exit 1
fi

# Ensure flakes are enabled (chezmoi should have already placed nix.conf,
# but guard against first-run edge cases)
mkdir -p "$HOME/.config/nix"
if ! grep -q "experimental-features.*flakes" "$HOME/.config/nix/nix.conf" 2>/dev/null; then
  echo "experimental-features = nix-command flakes" >>"$HOME/.config/nix/nix.conf"
fi

# Install packages from flake on Linux
if is_linux; then
  CHEZMOI_SOURCE="$(chezmoi source-path 2>/dev/null || echo "$HOME/.local/share/chezmoi")"
  FLAKE_DIR="$CHEZMOI_SOURCE/dot_config/nix"

  if [ -f "$FLAKE_DIR/flake.nix" ]; then
    FLAKE_REF="path:$CHEZMOI_SOURCE?dir=dot_config/nix"
    if nix profile list | grep -q "dot_config/nix"; then
      log "Upgrading existing nix profile from flake..."
      nix profile upgrade --all
      log "Nix profile upgrade completed."
    else
      log "Installing packages via nix profile from flake..."
      nix profile install "$FLAKE_REF"
      log "Nix profile install completed."
    fi
  else
    log "No flake.nix found at $FLAKE_DIR. Skipping nix package install."
  fi
fi
