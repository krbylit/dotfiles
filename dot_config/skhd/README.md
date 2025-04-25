# skhd

## Troubleshooting

- If `skhd` keymaps are not working, `skhd --restart-service` and check if the process is running.
  - If the process is not running, try just `skhd`, sometimes a message about secure keyboard input will show...
- macOS secure keyboard input can cause issues with `skhd`. This has been observed to originate from Firefox (likely because a tab is focused on password input). If this is the case, quit Firefox and try re/starting `skhd` before opening Firefox again.
