# fzf-lua-live.yazi

Interactive live grep search using Neovim's fzf-lua live_grep_native, then reveal the selected file in yazi.

## Features

- Uses fzf-lua's `live_grep_native` function for interactive text search
- Mirrors the Fish shell `<C-s>` keybinding functionality
- Searches through file contents with real-time feedback
- Reveals selected file in yazi after selection

## Requirements

- Neovim with fzf-lua plugin installed
- `$XDG_DATA_HOME/nvim/lazy/fzf-lua/scripts/cli.lua` must exist
- ripgrep (rg) for content search

## Installation

1. Copy this plugin directory to `~/.config/yazi/plugins/`
2. Add keybinding in `keymap.toml`:

```toml
[[mgr.prepend_keymap]]
on = ["s", "f"]  # or any key you prefer
run = "plugin fzf-lua-live"
desc = "Search text with fzf-lua live grep and navigate to file"
```

## Usage

Press `sf` in yazi to open fzf-lua's live grep interface. Type your search query and:
- Navigate with arrow keys or `<C-j>`/`<C-k>`
- Press `<Enter>` to select a file
- Press `<Esc>` or `<C-c>` to cancel

The selected file will be revealed in yazi.

## Comparison with ripgrep-live

This plugin uses fzf-lua's native live grep, which provides:
- Consistent interface with Fish shell's `<C-s>` binding
- Integration with Neovim's fzf-lua plugin
- Advanced preview features from fzf-lua

The original `ripgrep-live` plugin (bound to `<C-s>`) uses a custom Fish function with fzf.
