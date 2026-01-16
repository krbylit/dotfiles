# skhd

## Troubleshooting

- If `skhd` keymaps are not working, `skhd --restart-service` and check if the process is running.
  - If the process is not running, try just `skhd`, sometimes a message about secure keyboard input will show...
- macOS secure keyboard input can cause issues with `skhd`. This has been observed to originate from Firefox (likely because a tab is focused on password input). If this is the case, quit Firefox and try re/starting `skhd` before opening Firefox again.
- For `<alt-r>` keymap (restart yabai and apply rules) to work, we have to allow no password for `sudo yabai`:
  - get binary checksum: `shasum -a 256 /opt/homebrew/bin/yabai`
  - `sudo visudo -f /etc/sudoers.d/yabai`
    - add line: `{username} ALL=(root) NOPASSWD: sha256:{checksum} /opt/homebrew/bin/yabai --load-sa`
  - ensure skhd mapping doesn't pass `TERMINFO` env var: `alt - r : env -u TERMINFO sudo -n /opt/homebrew/bin/yabai --load-sa && skhd --restart-service && yabai --stop-service && yabai --start-service && sleep 1 && yabai -m rule --apply`
