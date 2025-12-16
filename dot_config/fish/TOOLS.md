# Fish Shell Custom Functions

> **77 custom Fish shell functions** for streamlined workflows, development tools, and system utilities.

## Overview

This document catalogs all custom Fish shell functions available in this dotfiles configuration. Functions are organized by category for easy discovery and reference.

**Quick Search**: Use `Ctrl+F` to search for keywords like "git", "docker", "note", "file", etc.

## Table of Contents

- [File \& Directory Navigation](#file--directory-navigation)
- [Git Shortcuts](#git-shortcuts)
- [Development Workflows](#development-workflows)
- [Docker Tools](#docker-tools)
- [Note-Taking \& Knowledge Management](#note-taking--knowledge-management)
- [Session Management](#session-management)
- [System Utilities](#system-utilities)
- [Text Processing \& Search](#text-processing--search)
- [Configuration Management](#configuration-management)
- [AI/LLM Tools](#aillm-tools)
- [Homebrew Package Management](#homebrew-package-management)
- [Internal Helper Functions](#internal-helper-functions)
- [Fish Shell Internals](#fish-shell-internals)

---

## File & Directory Navigation

### `l`

**Purpose**: Enhanced directory listing with icons and smart grouping
**Usage**: `l`
**Example**: `l` - Shows files with icons, grouped by type, directories first
**See also**: `la`, `ll`, `ls`, `lrt`, `ldot`

---

### `la`

**Purpose**: List all files including hidden files with enhanced formatting
**Usage**: `la`
**Example**: `la` - Shows all files including dotfiles with icons
**See also**: `l`, `ldot`, `lsa`

---

### `lart`

**Purpose**: List all files sorted by modification time (oldest first)
**Usage**: `lart [path]`
**Example**: `lart ~/Documents` - Find oldest files in Documents
**See also**: `lrt`, `lr`, `lt`

---

### `ldot`

**Purpose**: List dotfiles with detailed information
**Usage**: `ldot`
**Example**: `ldot` - Shows all hidden files with details
**See also**: `la`, `lsa`

---

### `ll`

**Purpose**: List files in columns with color
**Usage**: `ll [path]`
**Example**: `ll src/` - Columnar view of source directory
**See also**: `l`, `lsn`

---

### `lr`

**Purpose**: List files recursively sorted by modification time
**Usage**: `lr [path]`
**Example**: `lr .` - Recursive listing sorted by time
**See also**: `lsr`, `lrt`, `lart`

---

### `lrt`

**Purpose**: List files sorted by modification time (newest first)
**Usage**: `lrt [path]`
**Example**: `lrt` - See most recently modified files
**See also**: `lart`, `lr`, `lt`

---

### `ls`

**Purpose**: Enhanced ls with color support (macOS -G flag)
**Usage**: `ls [args]`
**Example**: `ls -lh` - List with human-readable sizes
**See also**: `l`, `ll`, `la`

---

### `lsa`

**Purpose**: List all files with details and human-readable sizes
**Usage**: `lsa [path]`
**Example**: `lsa /var/log` - Detailed view of all log files
**See also**: `la`, `ll`, `lsr`

---

### `lsn`

**Purpose**: List files one per line
**Usage**: `lsn [path]`
**Example**: `lsn | wc -l` - Count files in directory
**See also**: `ll`, `ls`

---

### `lsr`

**Purpose**: List all files recursively with details
**Usage**: `lsr [path]`
**Example**: `lsr src/` - Deep view of source tree
**See also**: `lr`, `lsa`

---

### `lt`

**Purpose**: List files sorted by modification time with details
**Usage**: `lt [path]`
**Example**: `lt` - Detailed view sorted by time
**See also**: `lrt`, `lart`, `lsa`

---

### `y`

**Purpose**: Yazi file manager wrapper with directory tracking
**Usage**: `y [args]`
**Example**: `y` - Open yazi, automatically cd to selected directory on exit
**See also**: `yazi_ripgrep`

---

### `ywd`

**Purpose**: Copy current working directory to clipboard
**Usage**: `ywd`
**Example**: `ywd` - Copies pwd to clipboard for easy sharing
**See also**: `vi_copy_to_clipboard`

---

## Git Shortcuts

### `gdiff`

**Purpose**: Git diff with histogram algorithm, ignoring whitespace changes
**Usage**: `gdiff [args]`
**Example**: `gdiff HEAD~1` - Compare with previous commit, better diff algorithm
**See also**: `lg`, `cmg`

---

### `lg`

**Purpose**: Launch lazygit for interactive git management
**Usage**: `lg [args]`
**Example**: `lg` - Opens lazygit TUI
**See also**: `cmg`, `gdiff`

---

### `cmg`

**Purpose**: Open lazygit in chezmoi source directory
**Usage**: `cmg [args]`
**Example**: `cmg` - Manage dotfiles with lazygit
**See also**: `lg`, `cm`, `c`

---

## Development Workflows

### `v`

**Purpose**: Alias for nvim
**Usage**: `v <file>`
**Example**: `v config.fish` - Edit file in neovim
**See also**: `vc`, `c`, `fc`

---

### `vc`

**Purpose**: Open nvim in nvim config directory, returns to previous directory on exit
**Usage**: `vc [args]`
**Example**: `vc` - Edit neovim configuration
**See also**: `v`, `c`, `fc`, `gc`

---

### `vman`

**Purpose**: Read man pages in nvim with syntax highlighting
**Usage**: `vman <command>`
**Example**: `vman git` - Read git manual in neovim
**See also**: `help`, `v`

---

### `vtest`

**Purpose**: Run nvim with isolated test directories for data, state, and cache
**Usage**: `vtest [args]`
**Example**: `vtest` - Test nvim config changes in isolation
**See also**: `v`, `vc`

---

### `venv`

**Purpose**: Create and activate Python virtual environment using uv, or deactivate if active
**Usage**: `venv [--python 3.13]`
**Example**: `venv --python 3.13` - Create venv with specific Python version
**See also**: `venv_auto_activate`

---

### `venv_auto_activate`

**Purpose**: Auto-activate/deactivate virtualenv when changing directories
**Usage**: Automatically triggered on directory change
**Example**: _Disabled - FIXME: event handler not triggering_
**See also**: `venv`

---

### `profile_fish`

**Purpose**: Profile fish shell startup time and open results in nvim
**Usage**: `profile_fish`
**Example**: `profile_fish` - Analyze shell startup performance
**See also**: `fc`, `v`

---

### `ter`

**Purpose**: Alias for terraform
**Usage**: `ter <args>`
**Example**: `ter plan` - Run terraform plan
**See also**: `tf`, `tft`

---

### `tf`

**Purpose**: Alias for terraform
**Usage**: `tf <args>`
**Example**: `tf apply` - Run terraform apply
**See also**: `ter`, `tft`

---

### `tft`

**Purpose**: Wrapper for tftui with -d flag
**Usage**: `tft [args]`
**Example**: `tft` - Launch terraform TUI
**See also**: `tf`, `ter`

---

### `vm`

**Purpose**: Alias for vi-mongo
**Usage**: `vm [args]`
**Example**: `vm` - Interactive MongoDB TUI
**See also**: `v`

---

## Docker Tools

### `dbuild`

**Purpose**: Build Docker compose in detached tmux session with logging
**Usage**: `dbuild`
**Example**: `dbuild` then `dlog` - Build and monitor logs
**See also**: `ddeploy`, `dlog`, `dtail`, `exportlogs`

---

### `ddeploy`

**Purpose**: Build, stop, and start Docker compose in detached tmux session with logging
**Usage**: `ddeploy`
**Example**: `ddeploy` - Full deployment cycle with logging
**See also**: `dbuild`, `ddown`, `dup`, `dlog`

---

### `ddown`

**Purpose**: Stop Docker compose services
**Usage**: `ddown`
**Example**: `ddown` - Gracefully stop all containers
**See also**: `dup`, `ddeploy`

---

### `dlog`

**Purpose**: Tail the most recent Docker build log file
**Usage**: `dlog`
**Example**: `dlog` - Monitor latest build output
**See also**: `dbuild`, `dtail`, `exportlogs`

---

### `dtail`

**Purpose**: Tail journald logs for all running Docker containers
**Usage**: `dtail`
**Example**: `dtail` - Monitor all container logs in real-time
**See also**: `dlog`, `exportlogs`, `logtail`

---

### `dup`

**Purpose**: Restart Docker compose services (down then up)
**Usage**: `dup`
**Example**: `dup` - Quick restart all services
**See also**: `ddown`, `ddeploy`

---

### `exportlogs`

**Purpose**: Export journald logs for a container to file, optionally filtered by date
**Usage**: `exportlogs <container-name> [YYYYMMDD or json] [json]`
**Example**: `exportlogs myapp 20231215 json` - Export specific date in JSON format
**See also**: `dlog`, `dtail`, `logtail`

---

### `ld`

**Purpose**: Alias for lazydocker
**Usage**: `ld [args]`
**Example**: `ld` - Interactive Docker management TUI
**See also**: `dbuild`, `ddeploy`, `dup`

---

## Note-Taking & Knowledge Management

### `nq`

**Purpose**: Quick note feature for nb - add to daily notes or create/edit specific notes
**Usage**: `nq` to list, `nq "content"` to add to today, `nq path/filename` to edit/create
**Example**: `nq "quick meeting note"` - Adds to today's daily note
**See also**: `ni`, `nid`, `nt`, `ns`, `ne`

---

### `ni`

**Purpose**: Helper for nb ideas/ folder - toggle tasks, add content, or open ideas inbox
**Usage**: `ni [path/filename] [content]` or `ni <filename>` to toggle task
**Example**: `ni "new startup idea"` - Adds to ideas/inbox.md
**See also**: `nq`, `nid`, `nt`

---

### `nid`

**Purpose**: Helper for nb ideas/dev.md - toggle tasks, add content, or open dev ideas
**Usage**: `nid [path/filename] [content]` or `nid <filename>` to toggle task
**Example**: `nid "refactor auth system"` - Adds to ideas/dev.md
**See also**: `ni`, `nq`, `nt`

---

### `nt`

**Purpose**: Wrapper for nb todos - supports do/undo, add, edit, list with complex parsing
**Usage**: `nt` to open, `nt do|undo <todoID>`, `nt <title>` to add, `nt l/c/o` to list
**Example**: `nt "Buy groceries"` - Adds new todo; `nt do 5` - Completes todo #5
**See also**: `nq`, `ni`, `nid`, `ns`

---

### `ns`

**Purpose**: Open scratch.md in nb for temporary notes
**Usage**: `ns`
**Example**: `ns` - Quick scratch pad for throwaway notes
**See also**: `nq`, `ne`

---

### `ne`

**Purpose**: Open nb directory for editing in nvim
**Usage**: `ne`
**Example**: `ne` - Browse all notes in neovim
**See also**: `nq`, `nt`, `ns`

---

## Session Management

### `zel`

**Purpose**: Smart zellij session manager - attach to existing or create new session
**Usage**: `zel` for default, `zel <name>` to attach/create, `zel l` to list
**Example**: `zel work` - Attaches to 'work' session or creates if doesn't exist
**See also**: `zs`, `zellij_picker`

---

### `zellij_picker`

**Purpose**: Zellij session picker with fzf - attach or delete sessions interactively
**Usage**: `zellij_picker [initial_query]`
**Example**: Select session with Enter to attach, Ctrl-x to delete
**See also**: `zel`, `zs`

---

### `zs`

**Purpose**: Start or attach to zellij session
**Usage**: `zs <session_name>`
**Example**: `zs dev` - Attach to dev session
**See also**: `zel`, `zellij_picker`

---

### `s`

**Purpose**: SSH with custom config, rsync dotfiles, auto-attach to zellij/tmux with env setup
**Usage**: `s [ssh_options] <host>`
**Example**: `s myserver` - Connects with dotfiles and attaches to session named $USER-myserver
**See also**: `ksh`, `_rsync_dotfiles`

---

### `ksh`

**Purpose**: SSH with kitty kitten using custom config, prefers zsh over bash
**Usage**: `ksh <host>`
**Example**: `ksh server.example.com` - SSH with kitty terminal features
**See also**: `s`

---

## System Utilities

### `cat`

**Purpose**: Alias for bat with paging disabled
**Usage**: `cat <file>`
**Example**: `cat config.yaml` - Syntax-highlighted file viewing
**See also**: `brg`, `help`, `logtail`

---

### `brg`

**Purpose**: Alias for batgrep with smart case search
**Usage**: `brg <pattern>`
**Example**: `brg "TODO"` - Search with syntax highlighting
**See also**: `frg`, `cat`, `rg_fzf_search`

---

### `help`

**Purpose**: Display colorized --help output using bat
**Usage**: `help <command>`
**Example**: `help git` - Colorized help documentation
**See also**: `vman`, `cat`

---

### `logtail`

**Purpose**: Tail a log file with bat syntax highlighting
**Usage**: `logtail <logfile>`
**Example**: `logtail /var/log/system.log` - Monitor logs with syntax highlighting
**See also**: `dtail`, `dlog`, `cat`

---

### `timer`

**Purpose**: Set a timer with terminal notification using tclock
**Usage**: `timer <duration>`
**Example**: `timer 5m` - Sets 5 minute countdown timer
**See also**: None

---

### `vi_copy_to_clipboard`

**Purpose**: Copy current command line to system clipboard using pbcopy
**Usage**: Bound to a key binding
**Example**: Type command, press keybinding - Command copied to clipboard
**See also**: `ywd`

---

## Text Processing & Search

### `frg`

**Purpose**: Interactive ripgrep with fzf preview using bat
**Usage**: `frg <pattern>`
**Example**: `frg "function"` - Search with live preview and navigation
**See also**: `brg`, `ripgrep_live`, `rg_fzf_search`

---

### `rg_fzf_search`

**Purpose**: Search and transform search action using ripgrep and fzf
**Usage**: `rg_fzf_search [initial_query]`
**Example**: _FIXME: fish conversion not working_
**See also**: `frg`, `ripgrep_live`

---

### `ripgrep_live`

**Purpose**: Live ripgrep search with fzf and vim integration - opens files or builds quickfix
**Usage**: `ripgrep_live`
**Example**: Enter to open file, Tab for multi-select then Enter for quickfix list
**See also**: `frg`, `rg_fzf_search`, `yazi_ripgrep`

---

### `yazi_ripgrep`

**Purpose**: Ripgrep live search for yazi integration - outputs selected file path
**Usage**: `yazi_ripgrep`
**Example**: Called from yazi to search and navigate to files
**See also**: `y`, `ripgrep_live`, `frg`

---

### `search_and_replace`

**Purpose**: Wrapper for serpl command
**Usage**: `search_and_replace <args>`
**Example**: `search_and_replace "oldtext" "newtext"` - Interactive search/replace
**See also**: `brg`, `frg`

---

## Configuration Management

### `c`

**Purpose**: Open nvim in chezmoi source directory, returns to previous directory on exit
**Usage**: `c [args]`
**Example**: `c` - Edit dotfiles configuration
**See also**: `cm`, `cmf`, `cmg`, `vc`

---

### `cm`

**Purpose**: Alias for chezmoi
**Usage**: `cm <args>`
**Example**: `cm apply` - Apply dotfile changes
**See also**: `c`, `cmf`, `cmg`

---

### `cmf`

**Purpose**: Force apply chezmoi changes and reload fish config
**Usage**: `cmf [args]`
**Example**: `cmf` - Force update and reload shell
**See also**: `cm`, `c`, `fc`

---

### `fc`

**Purpose**: Edit fish config file in nvim
**Usage**: `fc [args]`
**Example**: `fc` - Edit config.fish
**See also**: `c`, `vc`, `gc`, `sc`

---

### `gc`

**Purpose**: Edit ghostty config file in nvim
**Usage**: `gc [args]`
**Example**: `gc` - Edit terminal emulator config
**See also**: `fc`, `vc`, `c`

---

### `sc`

**Purpose**: Edit secrets env.keys.fish file in nvim
**Usage**: `sc [args]`
**Example**: `sc` - Edit secret environment variables
**See also**: `fc`, `c`

---

## AI/LLM Tools

### `ai`

**Purpose**: Wrapper for aichat command
**Usage**: `ai <args>`
**Example**: `ai "explain this code"` - AI chat interface
**See also**: `ca`

---

### `ca`

**Purpose**: Wrapper for cursor-agent command
**Usage**: `ca <args>`
**Example**: `ca` - Launch cursor agent
**See also**: `ai`

---

## Homebrew Package Management

### `brewadd`

**Purpose**: Install Homebrew package and update Brewfile
**Usage**: `brewadd <package>`
**Example**: `brewadd ripgrep` - Install and track in Brewfile
**See also**: `brewrem`

---

### `brewrem`

**Purpose**: Uninstall Homebrew package and update Brewfile
**Usage**: `brewrem <package>`
**Example**: `brewrem wget` - Uninstall and remove from Brewfile
**See also**: `brewadd`

---

## Internal Helper Functions

These functions are used internally by other functions and typically not called directly.

### `_nb_parse_note_args`

**Purpose**: Parse arguments for nb note commands - handles path, filename, content
**Usage**: `_nb_parse_note_args <arg1> [arg2] [arg3...]`
**Example**: Called internally by `nq`, `ni`, and `nid` functions
**See also**: `_nb_parse_todo_args`, `_nb_upsert_note`

---

### `_nb_parse_todo_args`

**Purpose**: Parse arguments for nb todo commands - complex todo argument parsing
**Usage**: `_nb_parse_todo_args <args...>`
**Example**: Called internally by `nt` function
**See also**: `_nb_parse_note_args`, `nt`

---

### `_nb_upsert_note`

**Purpose**: Create or update note using nb - edit if exists, create if not
**Usage**: `_nb_upsert_note <path> <filename> <content>`
**Example**: Called internally by note functions
**See also**: `_nb_parse_note_args`, `nq`, `ni`, `nid`

---

### `_rsync_dotfiles`

**Purpose**: Sync dotfiles to remote host via rsync - handles terminfo and configs
**Usage**: `_rsync_dotfiles [ssh_opts...] <host>`
**Example**: Called internally by `s` function for SSH connections
**See also**: `s`

---

## Fish Shell Internals

These functions are part of Fish shell's internal system and are automatically called by the shell.

### `fish_prompt`

**Purpose**: Custom fish prompt using starship
**Usage**: Automatically called by fish shell
**Example**: N/A - Renders on every prompt
**See also**: `fish_right_prompt`

---

### `fish_right_prompt`

**Purpose**: Custom fish right prompt using starship
**Usage**: Automatically called by fish shell
**Example**: N/A - Renders on every prompt
**See also**: `fish_prompt`

---

### `fish_user_key_bindings`

**Purpose**: User key bindings override - runs last when fish sets up keybindings
**Usage**: Automatically called by fish shell
**Example**: N/A - Sets up custom keybindings
**See also**: `vi_copy_to_clipboard`

---

### `fisher`

**Purpose**: Plugin manager for Fish shell (version 4.4.5)
**Usage**: `fisher install <plugins...>`, `fisher remove <plugins...>`, `fisher update [plugins...]`, `fisher list [regex]`
**Example**: `fisher install jorgebucaran/nvm.fish` - Install fish plugin
**See also**: None

---

### `fzf_configure_bindings`

**Purpose**: Install default key bindings for fzf.fish with user overrides
**Usage**: `fzf_configure_bindings [--directory=key] [--git_log=key] [--git_status=key] [--history=key] [--processes=key] [--variables=key]`
**Example**: `fzf_configure_bindings --history=\ch` - Customize fzf keybindings
**See also**: `frg`, `ripgrep_live`

---

## Search Keywords

For easy discovery, here are common task keywords:

- **Edit config**: `c`, `fc`, `vc`, `gc`, `sc`, `cm`
- **Search files**: `frg`, `brg`, `rg_fzf_search`, `ripgrep_live`
- **List files**: `l`, `la`, `ll`, `ls`, `lrt`, `lsa`, `lr`, `lt`
- **Git**: `lg`, `cmg`, `gdiff`
- **Docker**: `dbuild`, `ddeploy`, `ddown`, `dup`, `dlog`, `dtail`, `ld`, `exportlogs`
- **Notes**: `nq`, `ni`, `nid`, `nt`, `ns`, `ne`
- **Sessions**: `zel`, `zs`, `zellij_picker`, `s`, `ksh`
- **Neovim**: `v`, `vc`, `vman`, `vtest`, `ne`
- **Python**: `venv`, `venv_auto_activate`
- **AI tools**: `ai`, `ca`
- **Homebrew**: `brewadd`, `brewrem`

## Related Documentation

- [Fish Shell README](./README.md) - Main fish configuration documentation
- [Official Fish Documentation](https://fishshell.com/docs/current/)
- [Starship Prompt](https://starship.rs/)
- [fzf.fish Plugin](https://github.com/PatrickF1/fzf.fish)
- [nb Note-taking](https://github.com/xwmx/nb)
- [Zellij Terminal Multiplexer](https://zellij.dev/)

## Contributing

When adding new functions:

1. Use `fish_indent` for consistent formatting
2. Add descriptive comments at the top of the function file
3. Follow naming conventions (snake_case)
4. Update this documentation with the new function
5. Organize by appropriate category

## Function Count by Category

- **File & Directory Navigation**: 14 functions
- **Git Shortcuts**: 3 functions
- **Development Workflows**: 10 functions
- **Docker Tools**: 7 functions
- **Note-Taking & Knowledge Management**: 6 functions
- **Session Management**: 5 functions
- **System Utilities**: 6 functions
- **Text Processing & Search**: 5 functions
- **Configuration Management**: 6 functions
- **AI/LLM Tools**: 2 functions
- **Homebrew Package Management**: 2 functions
- **Internal Helper Functions**: 4 functions
- **Fish Shell Internals**: 5 functions

**Total**: 77 custom functions
