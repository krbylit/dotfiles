#!/usr/bin/env bash
# Restart yabai (and skhd) and re-apply window rules.
#
# Why this is a script instead of an inline skhd command:
# `yabai -m rule --apply` is a no-op if it runs before yabairc has
# finished loading. yabai's socket answers queries (~2.6s) well before
# yabairc finishes labeling spaces and adding its rules, and yabairc
# adds rules in bursts -- so neither a fixed sleep nor a "rule count
# stopped changing" heuristic is reliable. Instead, yabairc touches a
# sentinel file as its very last action; we wait for that file, which
# guarantees every rule and space label is in place before we apply.
# Keep $SENTINEL in sync with the touch at the end of yabairc.

set -u

SENTINEL="/tmp/yabai_${USER}.ready"

# Poll yabai's message socket until it answers, up to ~5s.
wait_for_socket() {
  for _ in $(seq 1 50); do
    yabai -m query --spaces >/dev/null 2>&1 && return 0
    sleep .1
  done
  return 1
}

# Wait for yabairc to finish (it touches $SENTINEL on its last line),
# up to ~20s. Returns the instant yabairc is done -- no fixed padding.
wait_for_yabairc() {
  for _ in $(seq 1 200); do
    [ -e "$SENTINEL" ] && return 0
    sleep .1
  done
  return 1
}

# Drop any stale sentinel so we detect THIS restart's completion.
rm -f "$SENTINEL"

# Reveal hidden, non-background apps so rules can match their windows.
osascript -e 'tell application "System Events" to set visible of (every process whose visible is false and background only is false) to true'

yabai --restart-service

wait_for_socket || exit 1

# Load the scripting addition (requires the yabai NOPASSWD sudoers
# entry). Needed so rules can move windows across spaces. Done early
# so its connection settles while wait_for_yabairc runs, below.
env -u TERMINFO sudo -n /opt/homebrew/bin/yabai --load-sa

# Block until yabairc has registered every rule and space label.
wait_for_yabairc || exit 1

yabai -m rule --apply

# Restart skhd only when explicitly requested. The alt-r keymap passes
# --restart-skhd; the yabai display-change signals call this script
# bare, so plugging/unplugging monitors does not churn skhd. Done last
# so it does not kill this script mid-run.
if [ "${1:-}" = "--restart-skhd" ]; then
  skhd --restart-service
fi
