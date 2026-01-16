# Keyboard Shortcuts Reference

Complete keymap reference across all tools and layers in the dotfiles environment.

## How to Use This Reference

- **Search**: Use Cmd+F to find specific keys or actions
- **Layers**: Keybindings are organized by layer (hardware → window management → applications)
- **Context**: Each keymap includes the tool, layer, and effect

## Table of Contents

- [How to Use This Reference](#how-to-use-this-reference)
- [Quick Navigation](#quick-navigation)
- [Understanding Keymap Layers](#understanding-keymap-layers)
- [Hardware Layer (Karabiner)](#hardware-layer-karabiner)
  - [Vim-Style Navigation (Terminal)](#vim-style-navigation-terminal)
  - [Vim-Style Navigation (Non-Terminal)](#vim-style-navigation-non-terminal)
  - [Application Switcher](#application-switcher)
  - [Keyboard-Specific Remapping](#keyboard-specific-remapping)
  - [Safety Features](#safety-features)
  - [Disabled Rules (8 total)](#disabled-rules-8-total)
- [Window Management (Skhd + Yabai)](#window-management-skhd--yabai)
  - [MacOS Override](#macos-override)
  - [Application Launch](#application-launch)
  - [Space Switching](#space-switching)
  - [Window Focus](#window-focus)
  - [Display Focus](#display-focus)
  - [Window Movement](#window-movement)
  - [Layout Manipulation](#layout-manipulation)
  - [Window State](#window-state)
  - [Layout Mode](#layout-mode)
  - [Space Management](#space-management)
  - [Yabai Service Control](#yabai-service-control)
- [Neovim](#neovim)
  - [Movement & Navigation](#movement--navigation)
  - [Comments](#comments)
  - [Windows & Tabs](#windows--tabs)
  - [Utility](#utility)
  - [File Operations & Buffers](#file-operations--buffers)
  - [Marks](#marks)
  - [Fuzzy Finding & Pickers](#fuzzy-finding--pickers)
  - [Search & Replace](#search--replace)
  - [Git Operations](#git-operations)
  - [Harpoon (File Bookmarks)](#harpoon-file-bookmarks)
  - [Yank History](#yank-history)
  - [Session Management](#session-management)
  - [Debugging (DAP)](#debugging-dap)
  - [UI & Display](#ui--display)
  - [Yazi File Manager (in Neovim buffer)](#yazi-file-manager-in-neovim-buffer)
  - [Snacks Explorer (in Neovim buffer)](#snacks-explorer-in-neovim-buffer)
  - [GitHub Integration (Snacks.gh)](#github-integration-snacksgh)
  - [LazyVim Default Keymaps](#lazyvim-default-keymaps)
- [Yazi](#yazi)
  - [Basic Navigation](#basic-navigation)
  - [File Operations](#file-operations)
  - [Selection & Visual Mode](#selection--visual-mode)
  - [Search & Filter](#search--filter)
  - [Tabs](#tabs)
  - [Shell & External Commands](#shell--external-commands)
  - [Yazi Plugins](#yazi-plugins)
- [Tmux](#tmux)
  - [Default Prefix](#default-prefix)
  - [Key Plugins](#key-plugins)
  - [Common Operations](#common-operations)
  - [Standard Tmux Keybindings (after prefix `<C-b>`)](#standard-tmux-keybindings-after-prefix-c-b)
  - [Mouse Support](#mouse-support)
- [Fish Shell](#fish-shell)
  - [Vi Mode](#vi-mode)
  - [Cursor Shapes](#cursor-shapes)
  - [Custom Keybindings](#custom-keybindings)
  - [Default Vi Mode Keybindings](#default-vi-mode-keybindings)
  - [FZF Integration](#fzf-integration)
- [Cross-Layer Interactions](#cross-layer-interactions)
  - [Terminal Applications (Kitty/Ghostty)](#terminal-applications-kittyghosstty)
  - [Non-Terminal Applications](#non-terminal-applications)
  - [Neovim in Terminal](#neovim-in-terminal)
  - [Space/Window Management Flow](#spacewindow-management-flow)
- [Keymap Conflicts & Resolutions](#keymap-conflicts--resolutions)
  - [Resolved Conflicts](#resolved-conflicts)
  - [Layer Priority](#layer-priority)
- [Tips for Discoverability](#tips-for-discoverability)
  - [Finding Keymaps](#finding-keymaps)
  - [Common Patterns](#common-patterns)
- [Additional Resources](#additional-resources)

## Quick Navigation

- [Hardware Layer (Karabiner)](#hardware-layer-karabiner) - Hardware key remapping
- [Window Management (Skhd + Yabai)](#window-management-skhd--yabai) - Tiling and hotkeys
- [Neovim](#neovim) - Editor keybindings
- [Yazi](#yazi) - File manager navigation
- [Tmux](#tmux) - Terminal multiplexer
- [Fish Shell](#fish-shell) - Shell keybindings

## Understanding Keymap Layers

This environment uses multiple layers of keyboard customization:

1. **Hardware Layer (Karabiner)**: Remaps physical keys before they reach applications
2. **Window Management (Skhd)**: System-wide hotkeys for window/space management
3. **Application Layer**: Tool-specific keymaps (Neovim, Yazi, Tmux, Fish)

---

## Hardware Layer (Karabiner)

Hardware key remapping that affects all applications. **Active rules: 15 | Total rules: 23**

### Vim-Style Navigation (Terminal)

| From Keys        | To Keys     | Application    | Purpose                                |
| ---------------- | ----------- | -------------- | -------------------------------------- |
| Right Option + h | Left Arrow  | Kitty, Ghostty | Vim-style left navigation in terminal  |
| Right Option + j | Down Arrow  | Kitty, Ghostty | Vim-style down navigation in terminal  |
| Right Option + k | Up Arrow    | Kitty, Ghostty | Vim-style up navigation in terminal    |
| Right Option + l | Right Arrow | Kitty, Ghostty | Vim-style right navigation in terminal |

### Vim-Style Navigation (Non-Terminal)

| From Keys        | To Keys     | Application          | Purpose                    |
| ---------------- | ----------- | -------------------- | -------------------------- |
| Left Control + h | Left Arrow  | All except terminals | Vim-style left navigation  |
| Left Control + j | Down Arrow  | All except terminals | Vim-style down navigation  |
| Left Control + k | Up Arrow    | All except terminals | Vim-style up navigation    |
| Left Control + l | Right Arrow | All except terminals | Vim-style right navigation |

### Application Switcher

| From Keys  | To Keys               | Purpose                               |
| ---------- | --------------------- | ------------------------------------- |
| Option + c | Command + Tab         | Forward through application switcher  |
| Option + x | Command + Shift + Tab | Backward through application switcher |

### Keyboard-Specific Remapping

#### HHKB Keyboard (vendor_id: 1278, product_id: 33)

| From Keys           | To Keys      | Purpose                               |
| ------------------- | ------------ | ------------------------------------- |
| Left Control (tap)  | Escape       | Quick Escape access for Vim workflows |
| Left Control (hold) | Left Control | Maintain Control functionality        |

#### Mac Keyboard (non-HHKB)

| From Keys        | To Keys      | Purpose                               |
| ---------------- | ------------ | ------------------------------------- |
| Left Control     | Left Option  | Match HHKB layout expectations        |
| Caps Lock (tap)  | Escape       | Quick Escape access for Vim workflows |
| Caps Lock (hold) | Left Control | Maintain Control functionality        |

### Safety Features

| From Keys                | To Keys          | Purpose                                 |
| ------------------------ | ---------------- | --------------------------------------- |
| Right Shift (double-tap) | Caps Lock toggle | Prevent accidental Caps Lock activation |
| Command + q (double-tap) | Quit application | Prevent accidental application closure  |
| Command + h              | (disabled)       | Prevent accidental window hiding        |
| Command + Option + h     | (disabled)       | Prevent accidental hide all windows     |
| Command + Option + m     | (disabled)       | Prevent accidental minimize all windows |

### Disabled Rules (8 total)

The following rules are currently disabled but available:

- **Hyper Key variants**: Caps Lock → Hyper, Right Option → Hyper, Tab → Hyper (3 rules)
- **Right Command + hjkl → arrows**: Alternative Vim navigation (1 rule)
- **Spacebar → Shift**: Dual-function spacebar (1 rule)

---

## Window Management (Skhd + Yabai)

System-wide hotkeys for window and space management. **Total hotkeys: 76**

### MacOS Override

| Hotkey  | Effect                                   |
| ------- | ---------------------------------------- |
| cmd - h | Disabled (prevents conflicts with yabai) |

### Application Launch

| Hotkey        | Effect                           |
| ------------- | -------------------------------- |
| ctrl - return | Launch or focus Ghostty terminal |

### Space Switching

| Hotkey  | Action                                 | Yabai Command                 |
| ------- | -------------------------------------- | ----------------------------- |
| alt - d | Show desktop (focus first empty space) | Custom script                 |
| alt - 1 | Switch to space 1                      | `yabai -m space --focus 1`    |
| alt - 2 | Switch to space 2                      | `yabai -m space --focus 2`    |
| alt - 3 | Switch to space 3                      | `yabai -m space --focus 3`    |
| alt - 4 | Switch to space 4                      | `yabai -m space --focus 4`    |
| alt - 5 | Switch to space 5                      | `yabai -m space --focus 5`    |
| alt - 6 | Switch to space 6                      | `yabai -m space --focus 6`    |
| alt - 7 | Switch to space 7                      | `yabai -m space --focus 7`    |
| alt - 8 | Switch to space 8                      | `yabai -m space --focus 8`    |
| alt - 9 | Switch to space 9                      | `yabai -m space --focus 9`    |
| alt - 0 | Switch to space 10                     | `yabai -m space --focus 10`   |
| alt - ] | Switch to next space                   | `yabai -m space --focus next` |
| alt - [ | Switch to previous space               | `yabai -m space --focus prev` |

### Window Focus

| Hotkey         | Action                     | Yabai Command                    |
| -------------- | -------------------------- | -------------------------------- |
| ctrl + alt - j | Focus window below (south) | `yabai -m window --focus south`  |
| ctrl + alt - k | Focus window above (north) | `yabai -m window --focus north`  |
| ctrl + alt - h | Focus window left (west)   | `yabai -m window --focus west`   |
| ctrl + alt - l | Focus window right (east)  | `yabai -m window --focus east`   |
| ctrl + alt - p | Focus most recent window   | `yabai -m window --focus recent` |

### Display Focus

| Hotkey  | Action             | Yabai Command                   |
| ------- | ------------------ | ------------------------------- |
| alt - w | Focus west display | `yabai -m display --focus west` |
| alt - e | Focus east display | `yabai -m display --focus east` |

### Window Movement

| Hotkey          | Action                                     | Yabai Command                  |
| --------------- | ------------------------------------------ | ------------------------------ |
| shift + alt - j | Move window south (warp)                   | `yabai -m window --warp south` |
| shift + alt - k | Move window north (warp)                   | `yabai -m window --warp north` |
| shift + alt - h | Move window west (warp)                    | `yabai -m window --warp west`  |
| shift + alt - l | Move window east (warp)                    | `yabai -m window --warp east`  |
| shift + alt - w | Move window to west display and follow     | Multi-command                  |
| shift + alt - e | Move window to east display and follow     | Multi-command                  |
| shift + alt - p | Move window to previous space              | `yabai -m window --space prev` |
| shift + alt - n | Move window to next space                  | `yabai -m window --space next` |
| shift + alt - 1 | Move window to space 1 and maintain focus  | Multi-command with jq          |
| shift + alt - 2 | Move window to space 2 and maintain focus  | Multi-command with jq          |
| shift + alt - 3 | Move window to space 3 and maintain focus  | Multi-command with jq          |
| shift + alt - 4 | Move window to space 4 and maintain focus  | Multi-command with jq          |
| shift + alt - 5 | Move window to space 5 and maintain focus  | Multi-command with jq          |
| shift + alt - 6 | Move window to space 6 and maintain focus  | Multi-command with jq          |
| shift + alt - 7 | Move window to space 7 and maintain focus  | Multi-command with jq          |
| shift + alt - 8 | Move window to space 8 and maintain focus  | Multi-command with jq          |
| shift + alt - 9 | Move window to space 9 and maintain focus  | Multi-command with jq          |
| shift + alt - 0 | Move window to space 10 and maintain focus | Multi-command with jq          |

### Layout Manipulation

| Hotkey          | Action                                | Yabai Command                    |
| --------------- | ------------------------------------- | -------------------------------- |
| shift + alt - r | Rotate layout clockwise               | `yabai -m space --rotate 270`    |
| shift + alt - y | Flip layout along y-axis (vertical)   | `yabai -m space --mirror y-axis` |
| shift + alt - x | Flip layout along x-axis (horizontal) | `yabai -m space --mirror x-axis` |
| shift + alt - e | Balance window sizes                  | `yabai -m space --balance`       |

### Window State

| Hotkey          | Action                                 | Yabai Command                                       |
| --------------- | -------------------------------------- | --------------------------------------------------- |
| shift + alt - t | Toggle float/tiled (centered 2x2 grid) | `yabai -m window --toggle float --grid 4:4:1:1:2:2` |
| shift + alt - m | Toggle zoom-fullscreen                 | `yabai -m window --toggle zoom-fullscreen`          |
| shift + alt - f | Toggle native macOS fullscreen         | `yabai -m window --toggle native-fullscreen`        |

### Layout Mode

| Hotkey  | Action                       | Yabai Command                   |
| ------- | ---------------------------- | ------------------------------- |
| alt - b | Change space to BSP layout   | `yabai -m space --layout bsp`   |
| alt - f | Change space to float layout | `yabai -m space --layout float` |
| alt - s | Change space to stack layout | `yabai -m space --layout stack` |
| alt - t | Toggle between stack and BSP | Conditional script              |

### Space Management

| Hotkey          | Action               | Yabai Command              |
| --------------- | -------------------- | -------------------------- |
| shift + alt - q | Delete current space | `yabai -m space --destroy` |

### Yabai Service Control

| Hotkey         | Action                     | Effect                                                         |
| -------------- | -------------------------- | -------------------------------------------------------------- |
| ctrl + alt - q | Stop yabai service         | `yabai --stop-service`                                         |
| ctrl + alt - s | Start yabai service        | `yabai --start-service`                                        |
| ctrl + alt - r | Restart yabai service      | `yabai --restart-service`                                      |
| alt - r        | Full system refresh        | Restart skhd + yabai, reload scripting addition, reapply rules |
| alt - a        | Apply/reapply window rules | `yabai -m rule --apply`                                        |

---

## Neovim

Editor keybindings organized by function. **100+ custom keymaps** (extends LazyVim defaults)

### Movement & Navigation

| Keymap           | Mode       | Action                                 | Plugin/Source               |
| ---------------- | ---------- | -------------------------------------- | --------------------------- |
| ^                | n, v       | Move to first non-blank of visual line | Core                        |
| $                | n, v       | Move to end of visual line             | Core                        |
| <C-g>            | n, v, i, x | Toggle scrolloff (center cursor)       | Core                        |
| ]f               | n          | Jump to next function (treesitter)     | nvim-treesitter-textobjects |
| [f               | n          | Jump to previous function (treesitter) | nvim-treesitter-textobjects |
| s                | n, x, o    | Flash jump to any visible text         | flash.nvim                  |
| S                | n, o, x    | Flash treesitter selection             | flash.nvim                  |
| r                | o          | Remote Flash (operator-pending)        | flash.nvim                  |
| R                | o, x       | Treesitter search with Flash           | flash.nvim                  |
| f, F, t, T, ;, , | n, x, o    | Enhanced f/t motions with Flash labels | flash.nvim                  |

### Comments

| Keymap | Mode | Action                            | Plugin/Source |
| ------ | ---- | --------------------------------- | ------------- |
| <D-/>  | n    | Toggle line comment (same as gcc) | Comment.nvim  |
| <D-/>  | x    | Toggle block comment (same as gc) | Comment.nvim  |

### Windows & Tabs

| Keymap | Mode | Action       | Plugin/Source |
| ------ | ---- | ------------ | ------------- |
| ]<tab> | n    | Next tab     | Core          |
| [<tab> | n    | Previous tab | Core          |

### Utility

| Keymap     | Mode    | Action                                            | Plugin/Source |
| ---------- | ------- | ------------------------------------------------- | ------------- |
| <leader>xc | n       | Clear quickfix list                               | Core          |
| dd         | n       | Smart dd (preserves yank register on empty lines) | Core          |
| <C-z>      | n, v, i | Unbind (prevent terminal suspension)              | Core          |

### File Operations & Buffers

| Keymap     | Mode | Action                                    | Plugin/Source |
| ---------- | ---- | ----------------------------------------- | ------------- |
| <C-q>      | n    | Close buffer (opens dashboard if last)    | snacks.nvim   |
| <leader>m  | n    | Toggle MiniFiles (at file location)       | mini.files    |
| <leader>M  | n    | Toggle MiniFiles (at cwd)                 | mini.files    |
| g.         | n    | Toggle hidden files in MiniFiles          | mini.files    |
| g~         | n    | Set cwd to current directory in MiniFiles | mini.files    |
| yp         | n    | Copy file path to clipboard               | mini.files    |
| <leader>e  | n, v | Open Yazi at current file                 | yazi.nvim     |
| <leader>cw | n    | Open Yazi in Neovim's working directory   | yazi.nvim     |
| <leader>E  | n    | Resume last Yazi session                  | yazi.nvim     |
| <leader>fe | n    | Open Snacks Explorer                      | snacks.nvim   |

### Marks

| Keymap     | Mode | Action                        | Plugin/Source |
| ---------- | ---- | ----------------------------- | ------------- |
| <leader>'d | n    | Delete mark on current line   | Core          |
| <leader>'f | n    | Delete all file marks (a-z)   | Core          |
| <leader>'g | n    | Delete all global marks (A-Z) | Core          |

### Fuzzy Finding & Pickers

| Keymap          | Mode | Action                               | Plugin/Source |
| --------------- | ---- | ------------------------------------ | ------------- |
| <leader><space> | n    | Smart find files                     | snacks.nvim   |
| <leader>fc      | n    | Find config file (chezmoi directory) | snacks.nvim   |
| <leader>z       | n    | Open Zoxide picker                   | snacks.nvim   |
| <C-c>           | i, n | Close picker                         | snacks.nvim   |
| <Alt-w>         | n, i | Toggle cwd in picker                 | snacks.nvim   |
| <C-p>           | i, n | Focus preview window                 | snacks.nvim   |
| <C-i>           | i, n | Focus input window                   | snacks.nvim   |
| <C-l>           | i, n | Focus list window                    | snacks.nvim   |
| <C-o>           | n, i | Delete all buffers NOT selected      | snacks.nvim   |
| dd              | n    | Delete buffer (in picker list)       | snacks.nvim   |
| <C-p>           | n    | Toggle preview (in fzf-lua)          | fzf-lua       |

### Search & Replace

| Keymap     | Mode | Action                                 | Plugin/Source |
| ---------- | ---- | -------------------------------------- | ------------- |
| <leader>sf | n    | Search and replace in current buffer   | grug-far.nvim |
| <leader>sv | v    | Search and replace in visual selection | grug-far.nvim |
| <leader>sr | n, v | Search and replace (global)            | grug-far.nvim |

### Git Operations

| Keymap     | Mode | Action                       | Plugin/Source |
| ---------- | ---- | ---------------------------- | ------------- |
| <leader>gv | n    | Open Diffview file history   | diffview.nvim |
| <leader>gl | n    | Draw GitGraph (commit graph) | gitgraph.nvim |

### Harpoon (File Bookmarks)

| Keymap         | Mode | Action                    | Plugin/Source |
| -------------- | ---- | ------------------------- | ------------- |
| <leader>H      | n    | Add file to Harpoon list  | harpoon       |
| <C-n>          | n    | Toggle Harpoon quick menu | harpoon       |
| <C-1> to <C-5> | n    | Jump to Harpoon file 1-5  | harpoon       |

### Yank History

| Keymap    | Mode | Action                   | Plugin/Source |
| --------- | ---- | ------------------------ | ------------- |
| <leader>p | n, x | Open Yank history picker | yanky.nvim    |

### Session Management

| Keymap     | Mode | Action                             | Plugin/Source    |
| ---------- | ---- | ---------------------------------- | ---------------- |
| <leader>qs | n    | Load session for current directory | persistence.nvim |
| <leader>qS | n    | Select session to load             | persistence.nvim |
| <leader>ql | n    | Load last session                  | persistence.nvim |
| <leader>qd | n    | Don't save session on exit         | persistence.nvim |

### Debugging (DAP)

| Keymap     | Mode | Action                                 | Plugin/Source         |
| ---------- | ---- | -------------------------------------- | --------------------- |
| <F5>       | n    | Start/Continue debugging               | nvim-dap              |
| <F6>       | n    | Pause debugging                        | nvim-dap              |
| <F8>       | n    | Terminate debugging                    | nvim-dap              |
| <F9>       | n    | Toggle breakpoint                      | nvim-dap              |
| <F10>      | n    | Step over                              | nvim-dap              |
| <F11>      | n    | Step into                              | nvim-dap              |
| <F12>      | n    | Step out                               | nvim-dap              |
| <leader>dv | n    | Toggle DAP virtual text                | nvim-dap-virtual-text |
| K          | n    | Show DAP hover widget (during session) | nvim-dap              |

### UI & Display

| Keymap     | Mode | Action                               | Plugin/Source |
| ---------- | ---- | ------------------------------------ | ------------- |
| <leader>cp | n    | Toggle MiniMap (code minimap)        | mini.map      |
| <leader>uk | n    | Toggle ShowKeys (display keystrokes) | showkeys      |

### Yazi File Manager (in Neovim buffer)

| Keymap | Mode | Action                               | Plugin/Source |
| ------ | ---- | ------------------------------------ | ------------- |
| <f1>   | n    | Show help                            | yazi.nvim     |
| <C-v>  | n    | Open file in vertical split          | yazi.nvim     |
| <C-x>  | n    | Open file in horizontal split        | yazi.nvim     |
| <C-t>  | n    | Open file in new tab                 | yazi.nvim     |
| <C-s>  | n    | Grep in directory                    | yazi.nvim     |
| <C-g>  | n    | Replace in directory                 | yazi.nvim     |
| <tab>  | n    | Cycle open buffers                   | yazi.nvim     |
| <C-y>  | n    | Copy relative path to selected files | yazi.nvim     |
| <C-q>  | n    | Send to quickfix list                | yazi.nvim     |
| <C-\>  | n    | Change working directory             | yazi.nvim     |
| <C-o>  | n    | Open and pick window                 | yazi.nvim     |

### Snacks Explorer (in Neovim buffer)

| Keymap    | Mode | Action                       | Plugin/Source |
| --------- | ---- | ---------------------------- | ------------- |
| <BS>      | n    | Go up directory              | snacks.nvim   |
| l         | n    | Confirm/open entry           | snacks.nvim   |
| h         | n    | Close directory              | snacks.nvim   |
| a         | n    | Add file/directory           | snacks.nvim   |
| d         | n    | Delete file/directory        | snacks.nvim   |
| r         | n    | Rename file/directory        | snacks.nvim   |
| c         | n    | Copy file/directory          | snacks.nvim   |
| m         | n    | Move file/directory          | snacks.nvim   |
| o         | n    | Open with system application | snacks.nvim   |
| P         | n    | Toggle preview               | snacks.nvim   |
| y         | n, x | Yank file path               | snacks.nvim   |
| p         | n    | Paste file/directory         | snacks.nvim   |
| u         | n    | Update explorer              | snacks.nvim   |
| <C-c>     | n    | Set cwd to current directory | snacks.nvim   |
| <leader>/ | n    | Grep in current directory    | snacks.nvim   |
| <C-t>     | n    | Open terminal                | snacks.nvim   |
| .         | n    | Focus current directory      | snacks.nvim   |
| I         | n    | Toggle ignored files         | snacks.nvim   |
| H         | n    | Toggle hidden files          | snacks.nvim   |
| Z         | n    | Close all directories        | snacks.nvim   |
| ]g, [g    | n    | Jump to next/prev git change | snacks.nvim   |
| ]d, [d    | n    | Jump to next/prev diagnostic | snacks.nvim   |
| ]w, [w    | n    | Jump to next/prev warning    | snacks.nvim   |
| ]e, [e    | n    | Jump to next/prev error      | snacks.nvim   |

### GitHub Integration (Snacks.gh)

| Keymap | Mode | Action          | Plugin/Source |
| ------ | ---- | --------------- | ------------- |
| <cr>   | n    | Select action   | snacks.nvim   |
| i      | n    | Edit            | snacks.nvim   |
| a      | n    | Add comment     | snacks.nvim   |
| c      | n    | Close issue/PR  | snacks.nvim   |
| o      | n    | Reopen issue/PR | snacks.nvim   |

### LazyVim Default Keymaps

This configuration extends LazyVim, which provides many default keymaps:

- **LSP**: `gd` (goto definition), `gr` (goto references), `K` (hover), `<leader>ca` (code actions)
- **Diagnostics**: `]d`, `[d` (next/prev diagnostic)
- **Windows**: `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>` (window navigation)
- **Buffers**: `<leader>bb` (buffer list), `<leader>bd` (delete buffer)
- **Search**: `<leader>/` (grep), `<leader>ff` (find files), `<leader>sg` (grep)
- **Git**: `<leader>gg` (lazygit), `<leader>gc` (commits), `<leader>gs` (status)

For complete LazyVim keymaps: <https://www.lazyvim.org/keymaps>

---

## Yazi

File manager navigation and operations. Yazi uses Vim-like keybindings with extensive plugin support.

### Basic Navigation

| Keymap        | Action                 | Description                |
| ------------- | ---------------------- | -------------------------- |
| k / j         | Move up/down           | Cursor movement            |
| h / l         | Parent/child directory | Directory navigation       |
| H / L         | Back/forward           | History navigation         |
| gg / G        | Top/bottom             | Jump to top/bottom of list |
| <C-u> / <C-d> | Page up/down           | Full page scroll           |
| <C-k> / <C-j> | Half page up/down      | Half page scroll (10%)     |

### File Operations

| Keymap  | Action             | Description                                 |
| ------- | ------------------ | ------------------------------------------- |
| <Enter> | Open               | Open selected files                         |
| O       | Open interactively | Choose application to open with             |
| y       | Yank (copy)        | Copy selected files                         |
| x       | Cut                | Cut selected files                          |
| p       | Paste              | Paste yanked/cut files                      |
| P       | Force paste        | Overwrite if destination exists             |
| d       | Trash              | Move to trash                               |
| D       | Delete permanently | Permanently delete files                    |
| a       | Create             | Create file/directory (end with / for dirs) |
| r       | Rename             | Rename file (cursor before extension)       |
| -       | Symlink (absolute) | Create absolute symlink                     |
| \_      | Symlink (relative) | Create relative symlink                     |
| <C-->   | Hardlink           | Create hardlink                             |

### Selection & Visual Mode

| Keymap  | Action              | Description                        |
| ------- | ------------------- | ---------------------------------- |
| <Space> | Toggle selection    | Toggle current item and move down  |
| v       | Visual mode         | Enter visual selection mode        |
| V       | Visual mode (unset) | Enter visual mode (unset existing) |
| <C-a>   | Select all          | Select all files                   |
| <C-r>   | Inverse selection   | Invert current selection           |

### Search & Filter

| Keymap | Action              | Description                            |
| ------ | ------------------- | -------------------------------------- |
| s      | Search jump         | Interactive search (searchjump plugin) |
| S      | Search content      | Search file content with ripgrep       |
| f      | Filter              | Filter files by name                   |
| F      | Smart filter        | Smart filter plugin                    |
| /      | Find next           | Find next file                         |
| n / N  | Next/previous found | Navigate find results                  |
| <C-s>  | Ripgrep live        | Interactive text search with ripgrep   |

### Tabs

| Keymap | Action              | Description                           |
| ------ | ------------------- | ------------------------------------- |
| t      | New tab             | Create new tab with current directory |
| 1-9    | Switch to tab 1-9   | Jump to specific tab                  |
| [ / ]  | Previous/next tab   | Navigate tabs                         |
| { / }  | Swap tab left/right | Reorder tabs                          |

### Shell & External Commands

| Keymap | Action         | Description                      |
| ------ | -------------- | -------------------------------- |
| ;      | Shell          | Run shell command (interactive)  |
| :      | Shell (block)  | Run shell command (blocking)     |
| <C-/>  | Popup shell    | Open Fish shell in popup         |
| o, f   | Open in Finder | Open current directory in Finder |
| <C-p>  | Quick Look     | Preview with macOS Quick Look    |

### Yazi Plugins

#### Projects (Session Management)

| Keymap | Action              | Description                             |
| ------ | ------------------- | --------------------------------------- |
| q      | Save and quit       | Save project and exit                   |
| P, s   | Save project        | Save current project                    |
| P, l   | Load project        | Load a project                          |
| P, P   | Load last project   | Resume last project                     |
| P, d   | Delete project      | Delete a project                        |
| P, D   | Delete all projects | Clear all projects                      |
| P, m   | Merge current       | Merge current tab to other projects     |
| P, M   | Merge all           | Merge current project to other projects |

#### Bookmarks (Vim-like)

| Keymap | Action               | Description               |
| ------ | -------------------- | ------------------------- |
| m      | Save bookmark        | Bookmark current location |
| '      | Jump to bookmark     | Jump to a bookmark        |
| b, d   | Delete bookmark      | Delete a bookmark         |
| b, D   | Delete all bookmarks | Clear all bookmarks       |

#### Relative Motions

| Keymap | Action       | Description                     |
| ------ | ------------ | ------------------------------- |
| 1-9    | Move N steps | Jump N items relative to cursor |

#### Sorting & Display

| Keymap  | Action              | Description                    |
| ------- | ------------------- | ------------------------------ |
| ,m / ,M | Sort by mtime       | Modified time (normal/reverse) |
| ,b / ,B | Sort by btime       | Birth time (normal/reverse)    |
| ,e / ,E | Sort by extension   | Extension (normal/reverse)     |
| ,a / ,A | Sort alphabetically | Alphabetical (normal/reverse)  |
| ,n / ,N | Sort naturally      | Natural sort (normal/reverse)  |
| ,s / ,S | Sort by size        | Size (normal/reverse)          |
| ,r      | Sort randomly       | Random order                   |
| ,t      | Toggle auto-save    | Toggle preference auto-save    |
| ,d      | Disable auto-save   | Disable preference saving      |
| ,R      | Reset preferences   | Reset preferences for cwd      |

#### Linemode (Display Format)

| Keymap | Action               | Description        |
| ------ | -------------------- | ------------------ |
| m, s   | Size linemode        | Show file sizes    |
| m, p   | Permissions linemode | Show permissions   |
| m, m   | Mtime linemode       | Show modified time |
| m, b   | Btime linemode       | Show birth time    |
| m, o   | Owner linemode       | Show owner         |
| m, n   | None linemode        | Minimal display    |

#### Copy Operations

| Keymap | Action                | Description                     |
| ------ | --------------------- | ------------------------------- |
| c, c   | Copy path             | Copy full file path             |
| c, d   | Copy dirname          | Copy directory path             |
| c, f   | Copy filename         | Copy filename with extension    |
| c, n   | Copy name without ext | Copy filename without extension |

#### Navigation Shortcuts

| Keymap     | Action          | Description                   |
| ---------- | --------------- | ----------------------------- |
| g, h       | Go to home      | Navigate to ~                 |
| g, c       | Go to config    | Navigate to ~/.config         |
| g, d       | Go to downloads | Navigate to ~/Downloads       |
| g, m       | Go to chezmoi   | Navigate to chezmoi directory |
| g, <Space> | Go interactive  | Interactive directory jump    |
| z          | Zoxide          | Jump with zoxide              |
| Z          | FZF jump        | Jump with fzf                 |

#### Git Integration

| Keymap | Action  | Description                       |
| ------ | ------- | --------------------------------- |
| g, l   | LazyGit | Open LazyGit in current directory |

#### Other Features

| Keymap        | Action        | Description                      |
| ------------- | ------------- | -------------------------------- |
| .             | Toggle hidden | Toggle hidden files visibility   |
| w             | Tasks         | Show task manager                |
| <Tab>         | Spot          | Spot hovered file                |
| ~ / ? / <F1>  | Help          | Open help menu                   |
| <Esc> / <C-[> | Escape        | Exit mode/clear selection/cancel |
| <C-c>         | Close         | Close current tab or quit        |
| <C-z>         | Suspend       | Suspend process                  |

---

## Tmux

Terminal multiplexer keybindings.

### Default Prefix

Tmux uses the default prefix: **`<C-b>`** (Control + b)

All tmux commands are prefixed with `<C-b>` unless otherwise noted.

### Key Plugins

- **tmux-sensible**: Provides sensible default settings
- **tmux-which-key**: Shows available keybindings on `<prefix>` press
- **catppuccin/tmux**: Theme with status bar modules

### Common Operations

Tmux follows standard keybindings. Use `<C-b> ?` to see all keybindings or `<C-b>` + wait to trigger which-key.

### Standard Tmux Keybindings (after prefix `<C-b>`)

| Keymap | Action           | Description              |
| ------ | ---------------- | ------------------------ |
| ?      | Help             | Show all keybindings     |
| c      | Create window    | Create new window        |
| ,      | Rename window    | Rename current window    |
| w      | Window list      | Choose window from list  |
| n / p  | Next/prev window | Navigate windows         |
| 0-9    | Switch to window | Jump to window by number |
| %      | Vertical split   | Split pane vertically    |
| "      | Horizontal split | Split pane horizontally  |
| o      | Next pane        | Cycle through panes      |
| ;      | Last pane        | Switch to last pane      |
| x      | Kill pane        | Close current pane       |
| &      | Kill window      | Close current window     |
| d      | Detach           | Detach from session      |
| s      | Session list     | Choose session from list |
| $      | Rename session   | Rename current session   |
| [      | Copy mode        | Enter copy/scroll mode   |
| ]      | Paste            | Paste from tmux buffer   |

### Mouse Support

Mouse support is **enabled** - you can:

- Click to select panes
- Drag borders to resize panes
- Scroll to navigate history
- Right-click for context menu

---

## Fish Shell

Vi-mode keybindings and shell-specific shortcuts.

### Vi Mode

Fish is configured with **vi key bindings** enabled (`fish_vi_key_bindings`).

### Cursor Shapes

| Mode                       | Cursor Shape          |
| -------------------------- | --------------------- |
| Normal                     | Block (blinking)      |
| Insert                     | Line (blinking)       |
| Visual                     | Block (blinking)      |
| Replace                    | Underscore (blinking) |
| External (command running) | Line                  |

### Custom Keybindings

#### Insert Mode

| Keymap | Action                | Description                                |
| ------ | --------------------- | ------------------------------------------ |
| ctrl-y | Accept autosuggestion | Accept the current suggestion              |
| ctrl-x | Clear line            | Clear command line                         |
| ctrl-j | Down or search        | Move down in history                       |
| ctrl-k | Up or search          | Move up in history                         |
| ctrl-u | Backward kill line    | Delete from cursor to beginning            |
| ctrl-w | Backward kill word    | Delete previous word                       |
| ctrl-s | Ripgrep live          | Interactive ripgrep search                 |
| ctrl-z | Zellij picker         | Open Zellij session picker                 |
| alt-l  | True (unbound)        | Removed to allow system alt-l (arrow keys) |

#### Normal Mode

| Keymap | Action            | Description                                |
| ------ | ----------------- | ------------------------------------------ |
| yy     | Copy to clipboard | Copy current line to system clipboard      |
| ctrl-j | Down or search    | Move down in history                       |
| ctrl-k | Up or search      | Move up in history                         |
| ctrl-s | Ripgrep live      | Interactive ripgrep search                 |
| ctrl-z | Zellij picker     | Open Zellij session picker                 |
| alt-l  | True (unbound)    | Removed to allow system alt-l (arrow keys) |

#### Visual Mode

| Keymap | Action         | Description                                |
| ------ | -------------- | ------------------------------------------ |
| alt-l  | True (unbound) | Removed to allow system alt-l (arrow keys) |

#### All Modes

| Keymap | Action             | Description                      |
| ------ | ------------------ | -------------------------------- |
| ctrl-u | Backward kill line | Delete from cursor to line start |
| ctrl-w | Backward kill word | Delete previous word             |

### Default Vi Mode Keybindings

Fish vi-mode includes standard Vim keybindings:

#### Normal Mode

- `h`, `j`, `k`, `l`: Movement
- `w`, `b`, `e`: Word movement
- `0`, `$`: Line start/end
- `i`, `a`, `I`, `A`: Enter insert mode
- `v`: Visual mode
- `d`, `c`, `y`: Delete, change, yank
- `/`: Search history
- `n`, `N`: Next/previous search result

#### Insert Mode

- Standard editing
- `<Esc>` or `<C-[>`: Return to normal mode

### FZF Integration

FZF keybindings are configured through `fzf_configure_bindings` function. Standard FZF bindings include:

- `<C-r>`: Search command history
- `<C-t>`: Search files
- `<Alt-c>`: Search directories

---

## Cross-Layer Interactions

Understanding how keymaps interact across layers:

### Terminal Applications (Kitty/Ghostty)

1. **Hardware Layer**: Uses Right Option + hjkl for arrows (Karabiner)
2. **Application Layer**: These arrows work in Yazi, Fish, etc.
3. **Why**: Avoids conflicts with Ctrl sequences used by terminal programs

### Non-Terminal Applications

1. **Hardware Layer**: Uses Left Control + hjkl for arrows (Karabiner)
2. **Application Layer**: Works in browsers, Finder, etc.
3. **Why**: Provides Vim-style navigation everywhere

### Neovim in Terminal

1. **Hardware Layer**: Karabiner remapping applies
2. **Window Management**: Skhd hotkeys for window/space switching
3. **Application Layer**: Neovim's own extensive keymaps
4. **Yazi Integration**: When opening Yazi from Neovim, Yazi keymaps take over

### Space/Window Management Flow

1. **alt - 1-9**: Switch to workspace (Skhd)
2. **ctrl + alt - hjkl**: Focus windows in workspace (Skhd)
3. **Inside app**: Use app-specific navigation (Neovim, Yazi, etc.)
4. **shift + alt - hjkl**: Move windows between positions (Skhd)

---

## Keymap Conflicts & Resolutions

### Resolved Conflicts

1. **Fish alt-l**: Unbound in Fish to allow Karabiner's alt-l → arrow remapping
2. **Terminal vs Non-Terminal Navigation**: Different modifiers (Right Option vs Left Control)
3. **Skhd cmd-h**: Disabled macOS hide to prevent conflicts with yabai
4. **Neovim <C-z>**: Disabled to prevent accidental terminal suspension

### Layer Priority

From lowest to highest priority:

1. **Karabiner** (hardware) - affects everything
2. **Skhd** (system-wide) - only when no modal app captures keys
3. **Application** (Neovim, Yazi, Fish) - highest priority when app has focus

---

## Tips for Discoverability

### Finding Keymaps

1. **Neovim**: Use `<leader>sk` (LazyVim keymap search) or `:Telescope keymaps`
2. **Yazi**: Press `~` or `?` or `<F1>` for help
3. **Tmux**: Press `<C-b> ?` for help or `<C-b>` + wait for which-key
4. **Fish**: Use `bind` command to list bindings
5. **This Document**: Use Cmd+F to search for specific keys or actions

### Common Patterns

- **hjkl**: Vim-style directional movement (everywhere)
- **Leader key in Neovim**: `<Space>` (LazyVim default)
- **Double-tap for safety**: Cmd+q, Right Shift (Karabiner)
- **Ctrl+Alt for window focus**: Consistent window navigation (Skhd)
- **Shift+Alt for window movement**: Consistent window repositioning (Skhd)
- **Alt for space switching**: Fast workspace navigation (Skhd)

---

## Additional Resources

- **Karabiner Config**: `/Users/kirbylittle/.config/karabiner/karabiner.json`
- **Skhd Config**: `/Users/kirbylittle/.config/skhd/skhdrc`
- **Yabai Config**: `/Users/kirbylittle/.config/yabai/yabairc`
- **Neovim Config**: `/Users/kirbylittle/.config/nvim/`
- **Yazi Config**: `/Users/kirbylittle/.config/yazi/keymap.toml`
- **Tmux Config**: `/Users/kirbylittle/.config/tmux/tmux.conf`
- **Fish Config**: `/Users/kirbylittle/.config/fish/`
- **LazyVim Keymaps**: <https://www.lazyvim.org/keymaps>

---

**Last Updated**: 2025-12-11
