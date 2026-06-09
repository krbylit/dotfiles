#!/usr/bin/env bash
# Restart yabai (and skhd) and re-apply window rules.
#
# Why this is a script instead of an inline skhd command:
# `yabai -m rule --apply` was a no-op when run too early after
# `yabai --start-service`. yabai's socket starts answering queries
# (~2.6s on this machine) well BEFORE yabairc finishes labeling
# spaces and adding its ~77 rules (~3.6s). Applying in that window
# runs against an empty ruleset, so no windows move -- yet a manual
# alt-a seconds later works. We therefore wait until yabairc has
# actually finished (rule count non-zero and stable) before applying,
# rather than guessing a sleep duration.

set -u

# Poll yabai's message socket until it answers, up to ~5s.
wait_for_socket() {
  for _ in $(seq 1 50); do
    yabai -m query --spaces >/dev/null 2>&1 && return 0
    sleep .1
  done
  return 1
}

# Wait until yabairc has finished loading rules: the count must be
# non-zero and unchanged across two consecutive samples. Up to ~12s.
wait_for_rules() {
  local prev=-1 cur
  for _ in $(seq 1 60); do
    cur=$(yabai -m rule --list 2>/dev/null | jq 'length' 2>/dev/null)
    cur=${cur:-0}
    [ "$cur" -gt 0 ] && [ "$cur" = "$prev" ] && return 0
    prev=$cur
    sleep .2
  done
  return 1
}

# Reveal hidden, non-background apps so rules can match their windows.
osascript -e 'tell application "System Events" to set visible of (every process whose visible is false and background only is false) to true'

yabai --stop-service
sleep .25
yabai --start-service

wait_for_socket || exit 1

# Load the scripting addition (requires the yabai NOPASSWD sudoers
# entry). Needed so rules can move windows across spaces.
env -u TERMINFO sudo -n /opt/homebrew/bin/yabai --load-sa

# Block until yabairc has registered all its rules and space labels.
wait_for_rules || exit 1

# Small settle so the scripting-addition connection is live before we
# ask it to move windows across spaces.
sleep .3

yabai -m rule --apply

# Restart skhd last so it does not kill this script mid-run.
skhd --restart-service
