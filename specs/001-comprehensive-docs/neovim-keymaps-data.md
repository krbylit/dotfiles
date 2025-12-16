# Neovim Keymaps Data

This document contains a structured catalog of all custom keymaps defined in the Neovim configuration. This data is used to populate KEYMAPS.md (Task T017) and the Neovim README (Task T030).

## Category: Movement & Navigation

### Keymap: ^

- **Mode**: n, v
- **Action**: Move to first non-blank character of visual line (g^)
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/config/keymaps.lua
- **Plugin**: Core

### Keymap: $

- **Mode**: n, v
- **Action**: Move to end of visual line (g$)
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/config/keymaps.lua
- **Plugin**: Core

### Keymap: <C-g>

- **Mode**: n, v, i, x
- **Action**: Toggle scrolloff between 8 and 999 (center cursor)
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/config/keymaps.lua
- **Plugin**: Core

### Keymap: ]f

- **Mode**: n
- **Action**: Jump to next function (treesitter)
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/config/keymaps.lua
- **Plugin**: nvim-treesitter-textobjects

### Keymap: [f

- **Mode**: n
- **Action**: Jump to previous function (treesitter)
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/config/keymaps.lua
- **Plugin**: nvim-treesitter-textobjects

### Keymap: s

- **Mode**: n, x, o
- **Action**: Flash jump to any visible text
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-flash.lua
- **Plugin**: flash.nvim

### Keymap: S

- **Mode**: n, o, x
- **Action**: Flash treesitter selection
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-flash.lua
- **Plugin**: flash.nvim

### Keymap: r

- **Mode**: o
- **Action**: Remote Flash (operator-pending mode)
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-flash.lua
- **Plugin**: flash.nvim

### Keymap: R

- **Mode**: o, x
- **Action**: Treesitter search with Flash
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-flash.lua
- **Plugin**: flash.nvim

### Keymap: f, F, t, T, ;,

- **Mode**: n, x, o
- **Action**: Enhanced f/t motions with Flash labels
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-flash.lua
- **Plugin**: flash.nvim

## Category: Comments

### Keymap: <D-/>

- **Mode**: n
- **Action**: Toggle line comment (same as gcc)
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/config/keymaps.lua
- **Plugin**: Comment.nvim

### Keymap: <D-/>

- **Mode**: x
- **Action**: Toggle block comment in visual mode (same as gc)
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/config/keymaps.lua
- **Plugin**: Comment.nvim

## Category: Windows & Tabs

### Keymap: ]<tab>

- **Mode**: n
- **Action**: Next tab
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/config/keymaps.lua
- **Plugin**: Core

### Keymap: [<tab>

- **Mode**: n
- **Action**: Previous tab
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/config/keymaps.lua
- **Plugin**: Core

## Category: Utility

### Keymap: <leader>xc

- **Mode**: n
- **Action**: Clear quickfix list
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/config/keymaps.lua
- **Plugin**: Core

### Keymap: dd

- **Mode**: n
- **Action**: Smart dd (doesn't override yank register on empty lines)
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/config/keymaps.lua
- **Plugin**: Core

### Keymap: <C-z>

- **Mode**: n, v, i
- **Action**: Unbind (disabled to prevent terminal suspension)
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/config/keymaps.lua
- **Plugin**: Core

## Category: File Operations & Buffers

### Keymap: <C-q>

- **Mode**: n
- **Action**: Close buffer intelligently (opens dashboard if last buffer)
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/config/keymaps.lua
- **Plugin**: snacks.nvim

### Keymap: <leader>m

- **Mode**: n
- **Action**: Toggle MiniFiles explorer (at file location)
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/config/keymaps.lua
- **Plugin**: mini.files

### Keymap: <leader>M

- **Mode**: n
- **Action**: Toggle MiniFiles explorer (at cwd)
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/config/keymaps.lua
- **Plugin**: mini.files

### Keymap: g

- **Mode**: n (in MiniFiles buffer)
- **Action**: Toggle hidden files in MiniFiles
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-mini-files.lua
- **Plugin**: mini.files

### Keymap: g~

- **Mode**: n (in MiniFiles buffer)
- **Action**: Set cwd to current directory in MiniFiles
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-mini-files.lua
- **Plugin**: mini.files

### Keymap: yp

- **Mode**: n (in MiniFiles buffer)
- **Action**: Copy file path to clipboard
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-mini-files.lua
- **Plugin**: mini.files

### Keymap: <leader>e

- **Mode**: n, v
- **Action**: Open Yazi file manager at current file
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/yazi.lua
- **Plugin**: yazi.nvim

### Keymap: <leader>cw

- **Mode**: n
- **Action**: Open Yazi in Neovim's working directory
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/yazi.lua
- **Plugin**: yazi.nvim

### Keymap: <leader>E

- **Mode**: n
- **Action**: Resume last Yazi session
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/yazi.lua
- **Plugin**: yazi.nvim

### Keymap: <leader>fe

- **Mode**: n
- **Action**: Open Snacks Explorer
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

## Category: Marks

### Keymap: <leader>'d

- **Mode**: n
- **Action**: Delete mark on current line
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/config/keymaps.lua
- **Plugin**: Core

### Keymap: <leader>'f

- **Mode**: n
- **Action**: Delete all file marks (a-z)
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/config/keymaps.lua
- **Plugin**: Core

### Keymap: <leader>'g

- **Mode**: n
- **Action**: Delete all global marks (A-Z)
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/config/keymaps.lua
- **Plugin**: Core

## Category: Fuzzy Finding & Pickers

### Keymap: <leader><space>

- **Mode**: n
- **Action**: Smart find files (Snacks picker)
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: <leader>fc

- **Mode**: n
- **Action**: Find config file (in chezmoi directory)
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: <leader>z

- **Mode**: n
- **Action**: Open Zoxide picker
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: <C-c>

- **Mode**: i, n (in Snacks picker)
- **Action**: Close picker
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: <Alt-w>

- **Mode**: n, i (in Snacks picker)
- **Action**: Toggle cwd in picker
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: <C-p>

- **Mode**: i, n (in Snacks picker)
- **Action**: Focus preview window
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: <C-i>

- **Mode**: i, n (in Snacks picker)
- **Action**: Focus input window
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: <C-l>

- **Mode**: i, n (in Snacks picker)
- **Action**: Focus list window
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: <C-o>

- **Mode**: n, i (in Snacks picker)
- **Action**: Delete all buffers NOT selected (inverse of <C-x>)
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: dd

- **Mode**: n (in Snacks picker list)
- **Action**: Delete buffer
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: <C-p>

- **Mode**: n (in fzf-lua)
- **Action**: Toggle preview
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-fzf-lua.lua
- **Plugin**: fzf-lua

## Category: Search & Replace

### Keymap: <leader>sf

- **Mode**: n
- **Action**: Search and replace in current buffer
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-grug-far.lua
- **Plugin**: grug-far.nvim

### Keymap: <leader>sv

- **Mode**: v
- **Action**: Search and replace in visual selection
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-grug-far.lua
- **Plugin**: grug-far.nvim

### Keymap: <leader>sr

- **Mode**: n, v
- **Action**: Search and replace (global)
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-grug-far.lua
- **Plugin**: grug-far.nvim

## Category: Git Operations

### Keymap: <leader>gv

- **Mode**: n
- **Action**: Open Diffview file history
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/diffview.lua
- **Plugin**: diffview.nvim

### Keymap: <leader>gl

- **Mode**: n
- **Action**: Draw GitGraph (show git commit graph)
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/gitgraph.lua
- **Plugin**: gitgraph.nvim

## Category: Harpoon (File Bookmarks)

### Keymap: <leader>H

- **Mode**: n
- **Action**: Add file to Harpoon list
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-harpoon.lua
- **Plugin**: harpoon

### Keymap: <C-n>

- **Mode**: n
- **Action**: Toggle Harpoon quick menu
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-harpoon.lua
- **Plugin**: harpoon

### Keymap: <C-1> to <C-5>

- **Mode**: n
- **Action**: Jump to Harpoon file 1-5
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-harpoon.lua
- **Plugin**: harpoon

## Category: Yank History

### Keymap: <leader>p

- **Mode**: n, x
- **Action**: Open Yank history picker
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-yanky.lua
- **Plugin**: yanky.nvim

## Category: Session Management

### Keymap: <leader>qs

- **Mode**: n
- **Action**: Load session for current directory
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-persistence.lua
- **Plugin**: persistence.nvim

### Keymap: <leader>qS

- **Mode**: n
- **Action**: Select session to load
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-persistence.lua
- **Plugin**: persistence.nvim

### Keymap: <leader>ql

- **Mode**: n
- **Action**: Load last session
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-persistence.lua
- **Plugin**: persistence.nvim

### Keymap: <leader>qd

- **Mode**: n
- **Action**: Don't save session on exit
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-persistence.lua
- **Plugin**: persistence.nvim

## Category: Debugging (DAP)

### Keymap: <F5>

- **Mode**: n
- **Action**: Start/Continue debugging
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-dap.lua
- **Plugin**: nvim-dap

### Keymap: <F10>

- **Mode**: n
- **Action**: Step over
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-dap.lua
- **Plugin**: nvim-dap

### Keymap: <F11>

- **Mode**: n
- **Action**: Step into
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-dap.lua
- **Plugin**: nvim-dap

### Keymap: <F12>

- **Mode**: n
- **Action**: Step out
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-dap.lua
- **Plugin**: nvim-dap

### Keymap: <F9>

- **Mode**: n
- **Action**: Toggle breakpoint
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-dap.lua
- **Plugin**: nvim-dap

### Keymap: <F8>

- **Mode**: n
- **Action**: Terminate debugging
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-dap.lua
- **Plugin**: nvim-dap

### Keymap: <F6>

- **Mode**: n
- **Action**: Pause debugging
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-dap.lua
- **Plugin**: nvim-dap

### Keymap: <leader>dv

- **Mode**: n
- **Action**: Toggle DAP virtual text
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-dap-virtual-text.lua
- **Plugin**: nvim-dap-virtual-text

### Keymap: K

- **Mode**: n (during DAP session)
- **Action**: Show DAP hover widget (overrides LSP hover)
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-dap.lua
- **Plugin**: nvim-dap

## Category: UI & Display

### Keymap: <leader>cp

- **Mode**: n
- **Action**: Toggle MiniMap (code minimap)
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/mini-map.lua
- **Plugin**: mini.map

### Keymap: <leader>uk

- **Mode**: n
- **Action**: Toggle ShowKeys (display keystrokes on screen)
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/showkeys.lua
- **Plugin**: showkeys

## Category: Yazi File Manager (in buffer)

### Keymap: <f1>

- **Mode**: n (in Yazi)
- **Action**: Show help
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/yazi.lua
- **Plugin**: yazi.nvim

### Keymap: <C-v>

- **Mode**: n (in Yazi)
- **Action**: Open file in vertical split
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/yazi.lua
- **Plugin**: yazi.nvim

### Keymap: <C-x>

- **Mode**: n (in Yazi)
- **Action**: Open file in horizontal split
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/yazi.lua
- **Plugin**: yazi.nvim

### Keymap: <C-t>

- **Mode**: n (in Yazi)
- **Action**: Open file in new tab
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/yazi.lua
- **Plugin**: yazi.nvim

### Keymap: <C-s>

- **Mode**: n (in Yazi)
- **Action**: Grep in directory
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/yazi.lua
- **Plugin**: yazi.nvim

### Keymap: <C-g>

- **Mode**: n (in Yazi)
- **Action**: Replace in directory
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/yazi.lua
- **Plugin**: yazi.nvim

### Keymap: <tab>

- **Mode**: n (in Yazi)
- **Action**: Cycle open buffers
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/yazi.lua
- **Plugin**: yazi.nvim

### Keymap: <C-y>

- **Mode**: n (in Yazi)
- **Action**: Copy relative path to selected files
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/yazi.lua
- **Plugin**: yazi.nvim

### Keymap: <C-q>

- **Mode**: n (in Yazi)
- **Action**: Send to quickfix list
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/yazi.lua
- **Plugin**: yazi.nvim

### Keymap: <C-\>

- **Mode**: n (in Yazi)
- **Action**: Change working directory
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/yazi.lua
- **Plugin**: yazi.nvim

### Keymap: <C-o>

- **Mode**: n (in Yazi)
- **Action**: Open and pick window
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/yazi.lua
- **Plugin**: yazi.nvim

## Category: Snacks Explorer (in buffer)

### Keymap: <BS>

- **Mode**: n (in Snacks explorer list)
- **Action**: Go up directory
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: l

- **Mode**: n (in Snacks explorer list)
- **Action**: Confirm/open entry
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: h

- **Mode**: n (in Snacks explorer list)
- **Action**: Close directory
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: a

- **Mode**: n (in Snacks explorer list)
- **Action**: Add file/directory
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: d

- **Mode**: n (in Snacks explorer list)
- **Action**: Delete file/directory
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: r

- **Mode**: n (in Snacks explorer list)
- **Action**: Rename file/directory
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: c

- **Mode**: n (in Snacks explorer list)
- **Action**: Copy file/directory
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: m

- **Mode**: n (in Snacks explorer list)
- **Action**: Move file/directory
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: o

- **Mode**: n (in Snacks explorer list)
- **Action**: Open with system application
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: P

- **Mode**: n (in Snacks explorer list)
- **Action**: Toggle preview
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: y

- **Mode**: n, x (in Snacks explorer list)
- **Action**: Yank file path
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: p

- **Mode**: n (in Snacks explorer list)
- **Action**: Paste file/directory
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: u

- **Mode**: n (in Snacks explorer list)
- **Action**: Update explorer
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: <C-c>

- **Mode**: n (in Snacks explorer list)
- **Action**: Set cwd to current directory
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: <leader>/

- **Mode**: n (in Snacks explorer list)
- **Action**: Grep in current directory
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: <C-t>

- **Mode**: n (in Snacks explorer list)
- **Action**: Open terminal
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap:

- **Mode**: n (in Snacks explorer list)
- **Action**: Focus current directory
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: I

- **Mode**: n (in Snacks explorer list)
- **Action**: Toggle ignored files
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: H

- **Mode**: n (in Snacks explorer list)
- **Action**: Toggle hidden files
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: Z

- **Mode**: n (in Snacks explorer list)
- **Action**: Close all directories
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: ]g

- **Mode**: n (in Snacks explorer list)
- **Action**: Jump to next git change
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: [g

- **Mode**: n (in Snacks explorer list)
- **Action**: Jump to previous git change
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: ]d

- **Mode**: n (in Snacks explorer list)
- **Action**: Jump to next diagnostic
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: [d

- **Mode**: n (in Snacks explorer list)
- **Action**: Jump to previous diagnostic
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: ]w

- **Mode**: n (in Snacks explorer list)
- **Action**: Jump to next warning
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: [w

- **Mode**: n (in Snacks explorer list)
- **Action**: Jump to previous warning
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: ]e

- **Mode**: n (in Snacks explorer list)
- **Action**: Jump to next error
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: [e

- **Mode**: n (in Snacks explorer list)
- **Action**: Jump to previous error
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

## Category: GitHub Integration (Snacks.gh)

### Keymap: <cr>

- **Mode**: n (in Snacks.gh buffer)
- **Action**: Select action
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: i

- **Mode**: n (in Snacks.gh buffer)
- **Action**: Edit
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: a

- **Mode**: n (in Snacks.gh buffer)
- **Action**: Add comment
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: c

- **Mode**: n (in Snacks.gh buffer)
- **Action**: Close issue/PR
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

### Keymap: o

- **Mode**: n (in Snacks.gh buffer)
- **Action**: Reopen issue/PR
- **Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-snacks.lua
- **Plugin**: snacks.nvim

## Category: Octo (GitHub PR Reviews)

Note: Octo plugin configuration is currently commented out, but extensive keymaps are defined in extend-octo.lua for issue and PR management, including:

- Issue management: `<localleader>ic`, `<localleader>io`, `<localleader>il`, etc.
- PR operations: `<localleader>po`, `<localleader>pm`, `<localleader>psm`, etc.
- Comments and reactions: `<localleader>ca`, `<localleader>cd`, `<localleader>r+`, etc.
- Review management: `<localleader>vs`, `<localleader>vr`, `<localleader>rt`, etc.

**Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/extend-octo.lua
**Plugin**: octo.nvim (currently disabled)

## Category: Buffer Navigation (Snipe)

Note: Snipe plugin is currently disabled but has keymap: `gb` to open buffer menu

**Source**: /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins/snipe.lua
**Plugin**: snipe.nvim (currently disabled)

## Notes on LazyVim Default Keymaps

This configuration extends LazyVim, which provides many default keymaps. Key LazyVim defaults include:

- LSP keymaps: `gd` (goto definition), `gr` (goto references), `K` (hover), `<leader>ca` (code actions)
- Diagnostic navigation: `]d`, `[d` (next/prev diagnostic)
- Window navigation: `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>`
- Buffer management: `<leader>bb` (buffer list), `<leader>bd` (delete buffer)
- Search: `<leader>/` (grep), `<leader>ff` (find files), `<leader>sg` (grep)
- Git: `<leader>gg` (lazygit), `<leader>gc` (commits), `<leader>gs` (status)

For a complete list of LazyVim keymaps, see: <https://www.lazyvim.org/keymaps>
