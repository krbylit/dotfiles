# Fish Shell Configuration

Modern, user-friendly shell with powerful features and integrations.

> [!TODO]
>
> - Add feature to `s.fish` to store locally a hash of the files to copy and check for modifications that way before calling `rsync`, then also do not make `rsync` do the hash check

## Table of Contents

- [Overview](#overview)
- [Configuration Structure](#configuration-structure)
  - [Configuration Loading Order](#configuration-loading-order)
- [Fish-Specific Features](#fish-specific-features)
  - [conf.d/ Auto-loading](#confd-auto-loading)
  - [Universal Variables](#universal-variables)
  - [Event Handlers](#event-handlers)
  - [Abbreviations vs Aliases](#abbreviations-vs-aliases)
  - [Vi-Mode Configuration](#vi-mode-configuration)
- [Integration Points](#integration-points)
  - [Starship Prompt](#starship-prompt)
  - [FZF (Fuzzy Finder)](#fzf-fuzzy-finder)
  - [Zoxide (Smart Directory Navigation)](#zoxide-smart-directory-navigation)
  - [Atuin (Shell History)](#atuin-shell-history)
  - [Neovim Integration](#neovim-integration)
  - [Yazi (File Manager)](#yazi-file-manager)
  - [Zellij (Terminal Multiplexer)](#zellij-terminal-multiplexer)
  - [Docker & Kubernetes](#docker--kubernetes)
  - [Git Integration](#git-integration)
  - [Python Development](#python-development)
  - [Node.js/JavaScript](#nodejsjavascript)
- [Custom Key Bindings](#custom-key-bindings)
- [Key Functions](#key-functions)
  - [Navigation & Search](#navigation--search)
  - [Development](#development)
  - [File Management](#file-management)
  - [Notebook Management (nb)](#notebook-management-nb)
  - [Chezmoi Operations](#chezmoi-operations)
  - [Git Operations](#git-operations)
  - [Neovim](#neovim)
  - [Other](#other)
- [Plugins](#plugins)
- [Customization Guide](#customization-guide)
  - [Adding a New Function](#adding-a-new-function)
  - [Modifying Configuration](#modifying-configuration)
  - [Adding Key Bindings](#adding-key-bindings)
  - [Adding a Plugin](#adding-a-plugin)
  - [Profiling Startup Performance](#profiling-startup-performance)
- [CLI Tools](#cli-tools)
- [Tips & Tricks](#tips--tricks)
  - [Bang-Bang Substitution](#bang-bang-substitution)
  - [Bass (Bash Compatibility)](#bass-bash-compatibility)
  - [Environment Variable Management](#environment-variable-management)
  - [SSH Environment Detection](#ssh-environment-detection)
  - [Debugging Functions](#debugging-functions)
- [Troubleshooting](#troubleshooting)
  - [FZF Issues](#fzf-issues)
  - [Slow Startup](#slow-startup)
  - [Function Not Found](#function-not-found)
  - [Key Binding Not Working](#key-binding-not-working)
  - [Plugin Issues](#plugin-issues)
  - [Path Issues](#path-issues)
- [Resources](#resources)

## Overview

This Fish shell configuration provides a comprehensive development environment with:

- **Vi-mode keybindings** with visual cursor feedback
- **FZF integration** for fuzzy finding files, history, processes, and more
- **Starship prompt** with transient mode for clean terminal history
- **Custom functions** for development workflows (77+ functions)
- **Plugin ecosystem** managed by Fisher
- **Tool integrations** (Zoxide, Atuin, Zellij, Yazi, Neovim, and more)

## Configuration Structure

```
~/.config/fish/
├── config.fish              # Main configuration entry point
├── conf.d/                  # Auto-loaded configuration files
│   ├── _fish_general_config.fish     # Environment variables, editor setup
│   ├── _fish_vi_mode_config.fish     # Vi-mode and cursor configuration
│   ├── _fish_fzf_config.fish         # FZF keybindings and options
│   ├── _fish_keymaps_config.fish     # Custom key bindings
│   ├── _fish_starship_config.fish    # Starship transient prompt
│   ├── _fish_path_config.fish        # PATH modifications
│   ├── _fish_python_config.fish      # Python environment setup
│   ├── _fish_javascript_config.fish  # Node/JS configuration
│   ├── _fish_rust_config.fish        # Rust tooling setup
│   └── _fish_load_env.fish           # Load secrets from dotfiles
├── functions/               # Custom functions (auto-loaded)
├── completions/            # Custom completions
└── fish_plugins            # Fisher plugin list (symlinked)
```

### Configuration Loading Order

1. **System-wide configuration**: `/usr/share/fish/config.fish`
2. **User configuration**: `~/.config/fish/config.fish`
3. **conf.d/ files**: All `.fish` files in `conf.d/` (alphabetically)
4. **Interactive init**: Starship, Zoxide initialization (if interactive session)
5. **Functions**: Loaded on-demand when called

## Fish-Specific Features

### conf.d/ Auto-loading

Fish automatically sources all `.fish` files in `conf.d/` during shell initialization. This modular approach keeps configuration organized by topic:

- Use `_` prefix for configuration files to ensure proper load order
- Each file handles a specific domain (vi-mode, FZF, keymaps, etc.)
- Changes take effect in new shell sessions
- Files are sourced alphabetically

### Universal Variables

Fish supports **universal variables** that persist across sessions and are shared between all Fish instances:

```fish
set -Ux EDITOR nvim          # Set universal variable
set -gx TEMP_VAR value       # Set global variable (session only)
set -e VARIABLE_NAME         # Erase variable
```

**Current universal variables:**

- `SSH_AGENT_PID`: SSH agent process ID (auto-configured)

**Variable scopes:**

- `-U` (universal): Persists across all Fish sessions
- `-g` (global): Available to current session and child processes
- `-x` (export): Exported to child processes
- `-l` (local): Function-local only

### Event Handlers

Fish functions can respond to events using `--on-event`:

```fish
function load_fzf_bindings --on-event fish_prompt
    # Runs when prompt is displayed
    fzf_configure_bindings --history=\cE --directory=\cF
end
```

**Active event handlers:**

- `fish_prompt`: FZF binding configuration (runs once on first prompt)

### Abbreviations vs Aliases

Fish doesn't use traditional aliases. Instead, it provides **abbreviations** and **functions**:

- **Functions** (preferred in this config): Full-featured, can accept arguments, auto-loaded from `functions/`
- **Abbreviations**: Expand in the command line before execution (not currently used)
- **Aliases**: Deprecated in Fish, use functions instead

**Example function** (replaces traditional alias):

```fish
# functions/l.fish
function l --description "List files with eza"
    eza --all --long --header --group --group-directories-first --icons $argv
end
```

**Why functions over abbreviations:**

- Functions support complex logic and argument handling
- Auto-loaded on first use (faster startup)
- Can be documented with `--description`
- Easier to maintain and test

### Vi-Mode Configuration

**Cursor shapes** indicate current mode (configured in `conf.d/_fish_vi_mode_config.fish`):

- **Block (blinking)**: Normal/Visual mode
- **Line (blinking)**: Insert mode
- **Underscore (blinking)**: Replace mode

**Ghostty terminal workaround:**

```fish
if string match -q -- '*ghostty*' $TERM
    set -g fish_vi_force_cursor 1
end
```

**Key bindings** (see [Custom Key Bindings](#custom-key-bindings) for full list):

- `Ctrl+y`: Accept autosuggestion
- `Ctrl+j/k`: Navigate command history
- `yy`: Copy line to clipboard (normal mode)

## Integration Points

### Starship Prompt

**Configuration**: `conf.d/_fish_starship_config.fish`

Starship provides a fast, customizable prompt with rich information display.

**Features:**

- **Transient prompt mode**: Previous commands show minimal prompt for cleaner history
- Custom modules for Git status, language versions, exit codes
- Right prompt with execution time and status codes

**Functions:**

- `starship_transient_prompt_func`: Left transient prompt (angular style)
- `starship_transient_rprompt_func`: Right transient prompt
- `enable_transience`: Enables transient mode (called in `config.fish`)

**Initialization:**

```fish
starship init fish | source
enable_transience
```

### FZF (Fuzzy Finder)

Fish shell is heavily integrated with [fzf](https://github.com/junegunn/fzf) (fuzzy finder) through the [fzf.fish](https://github.com/PatrickF1/fzf.fish) plugin, providing powerful interactive search capabilities across files, history, processes, and more.

#### Global FZF Configuration

FZF global options are configured in `~/.fzfrc` (managed by chezmoi as `dot_fzfrc`):

```bash
--cycle                           # Enable cycling through results
--layout=reverse                  # Display from top to bottom
--border=block                    # Block-style border
--height=90%                      # Use 90% of screen height
--preview-window=wrap,border-bold # Preview window settings
--marker="*"                      # Selection marker
```

**Global Keybindings (work in all FZF instances):**

- `Ctrl-f` / `Ctrl-b`: Scroll preview window down/up (half page)
- `Ctrl-d` / `Ctrl-u`: Scroll results down/up (half page)
- `Ctrl-p`: Toggle preview window visibility
- `Ctrl-o`: Execute `$EDITOR` on selected item
- `Ctrl-a` / `Ctrl-r`: Select all / deselect all

#### Fish-Specific FZF Configuration

**Configuration**: `conf.d/_fish_fzf_config.fish`

**Custom Keybindings (Fish shell prompt):**

- `Ctrl+E`: Search command history
- `Ctrl+F`: Search files/directories
- `Ctrl+P`: Search running processes
- `Alt+A`: Search git log
- `Ctrl+V`: Search environment variables (disabled by default)

**FZF Integration Settings:**

```fish
# File discovery options
set -gx fzf_fd_opts --hidden --no-ignore  # Show hidden and gitignored files

# Directory preview
set -gx fzf_preview_dir_cmd "eza --all --color=always"

# Git diff preview (using delta)
set -gx fzf_diff_highlighter 'delta --no-gitconfig --paging=never ...'

# Zoxide FZF options
set -gx _ZO_FZF_OPTS "$FZF_DEAFULT_OPTS"
set -gx _ZO_EXCLUDE_DIRS "$HOME/**/node_modules:$HOME/**/node_modules/**"
```

#### Custom FZF Functions

Several custom Fish functions leverage FZF for enhanced workflows:

##### `frg` - Fast Ripgrep with FZF

```fish
frg <search_pattern>
```

Pipes ripgrep results through FZF with syntax-highlighted preview using `bat`.

**Features:**

- Shows line numbers and file paths
- Live preview with syntax highlighting
- Returns selected file path

##### `ripgrep_live` - Interactive Live Ripgrep Search

```fish
ripgrep_live
```

Real-time interactive search that updates FZF results as you type.

**Features:**

- Live reload on query change
- Multi-selection support
- `Enter`: Open file in `$EDITOR` at matching line
- `Ctrl-o`: Execute `$EDITOR` without closing FZF
- Builds quickfix list for multiple selections
- Uses custom ripgrep config from `~/.config/ripgrep/.ripgreprc`

##### `rg_fzf_search` - Search and Transform

```fish
rg_fzf_search [initial_query]
```

Advanced ripgrep-to-fzf pipeline with search transformation (experimental).

**Features:**

- First word searches with ripgrep, rest filters in FZF
- Syntax-highlighted preview
- `Enter`: Opens file in vim at matching line

##### `yazi_ripgrep` - Ripgrep for Yazi Integration

```fish
yazi_ripgrep
```

FZF ripgrep search designed for Yazi file manager integration.

**Features:**

- Returns absolute file path of selection
- Custom keybindings: `Ctrl-a` (select all), `Ctrl-u` (deselect all)
- Outputs realpath for Yazi navigation

##### `zellij_picker` - Zellij Session Manager

```fish
zellij_picker [query]
```

FZF interface for managing Zellij terminal multiplexer sessions.

**Features:**

- `Enter`: Attach to selected session
- `Ctrl-x`: Delete selected session
- Live preview of session details
- Auto-reload after session deletion

#### FZF Search Syntax

FZF supports powerful search patterns for precise filtering:

**Basic Patterns:**

- `word` - Fuzzy match
- `'exact` - Exact match (single quote prefix)
- `^prefix` - Prefix exact match
- `suffix$` - Suffix exact match
- `!exclude` - Inverse exact match (exclude)

**Examples:**

```fish
# Search for Python files excluding Library directory
python !Library

# Search for "git add" as phrase (no spaces between words works better)
gitadd  # Better than "git add"
gadd    # Acronym matching works well
```

**Pro Tips:**

- Type fewer characters for better fuzzy matching
- FZF prioritizes matches at word boundaries
- Acronyms work surprisingly well (e.g., `gas` for "git add something")
- Use `!pattern` to exclude results

#### Common FZF Workflows

**Search command history:**

```fish
# Press Ctrl-e at prompt
# Type pattern to filter history
# Enter to execute, Ctrl-o to edit in $EDITOR
```

**Find and open file:**

```fish
# Press Ctrl-f at prompt
# Type filename pattern
# Ctrl-p to toggle preview
# Enter to paste path, Ctrl-o to open in editor
```

**Kill a process:**

```fish
kill <tab>       # Opens FZF process picker
# or
# Press Ctrl-p at prompt
# Type process name
# Enter to paste PID
```

**Search with ripgrep interactively:**

```fish
ripgrep_live     # Start typing to search across all files
# Enter to open in editor
# Ctrl-a to select multiple matches
```

**Browse directories with zoxide:**

```fish
zi               # Opens FZF with zoxide history
zi <partial>     # Pre-filter results
```

**Tab completion with FZF:**

```fish
# At empty prompt, press Tab
# Browse all commands with man page previews

# With partial command
grep --<tab>     # FZF completion with man page docs (via fifc plugin)
```

#### Integration with Other Tools

**fzf.fish Plugin:**

- Provides core Fish keybindings and functions
- Integrates with `fd` for file search
- Provides git status, git log search functions
- Repository: <https://github.com/PatrickF1/fzf.fish>

**fifc Plugin:**

- FZF-powered tab completion
- Shows man page previews for command flags
- Repository: <https://github.com/gazorby/fifc>

**Zoxide:**

- Uses FZF for interactive directory selection (`zi`)
- Excludes `node_modules` from results
- Repository: <https://github.com/ajeetdsouza/zoxide>

**Delta:**

- Syntax-highlighted git diffs in FZF preview windows
- Custom configuration for optimal FZF display

**Bat:**

- Syntax-highlighted file previews
- Used by all custom FZF functions

### Zoxide (Smart Directory Navigation)

**Configuration**: Initialized in `config.fish`

```fish
zoxide init fish | source
```

**Usage:**

- `z <pattern>`: Jump to directory matching pattern
- `zi`: Interactive directory picker (FZF integration)

**Configuration variables:**

- `_ZO_FZF_OPTS`: Uses global FZF options
- `_ZO_EXCLUDE_DIRS`: Excludes `node_modules/**`

**Examples:**

```fish
z proj          # Jump to project directory
zi              # Interactive picker with FZF
z foo bar       # Match directory with both "foo" and "bar"
```

### Atuin (Shell History)

**Status**: Disabled (commented out in `config.fish`)

```fish
# atuin init fish | source  # Adds startup time
```

**Reason for disabling:**

- FZF (`Ctrl+E`) provides sufficient history search
- Reduces startup time significantly
- May be re-enabled if advanced history sync is needed

### Neovim Integration

**Configuration**: `conf.d/_fish_general_config.fish`

**Editor setup:**

- `$EDITOR` and `$VISUAL` set to `nvim`
- **Neovim-remote** support: When inside Neovim terminal, uses `nvr` to open files in parent instance
- **Man pages**: Uses `bat` with syntax highlighting (`$MANPAGER`)

```fish
# Inside Neovim terminal
if set -q NVIM
    set -gx EDITOR "nvr --remote-wait"
    function nvim
        command nvr $argv
    end
else
    set -gx EDITOR nvim
end
```

**Helper functions:**

- `v`: Open files in Neovim
- `vc`: Open Neovim config
- `vm`: Edit chezmoi dotfiles
- `vman`: View man pages in Neovim
- `vtest`: Run tests in Neovim

**Man page configuration:**

```fish
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
```

### Yazi (File Manager)

**Functions:**

- `y`: Launch Yazi and cd to selected directory on exit
- `yazi_ripgrep`: Search files with ripgrep, open results in Yazi
- `ywd`: Copy current working directory to clipboard

**Integration:**

- Automatically changes directory when exiting Yazi
- Uses FZF for file search before opening

### Zellij (Terminal Multiplexer)

**Functions:**

- `zel`: Smart Zellij launcher (attach or create session)
- `zellij_picker`: FZF picker for Zellij sessions (`Ctrl+Z` keybind)
- `zs`: Zellij session manager

**Key binding:**

- `Ctrl+Z`: Opens Zellij session picker (replaces suspend)

### Docker & Kubernetes

**Docker functions:**

- `dbuild`: Docker build helper
- `ddeploy`: Docker deploy workflow
- `dup`: Docker Compose up
- `ddown`: Docker Compose down
- `dlog`: Docker logging utilities
- `dtail`: Docker tail logs
- `dcv`: Docker container manager TUI

**Kubernetes:**

- `ksh`: Kubernetes shell access
- `kdash`: Kubernetes dashboard TUI

**Docker configuration:**

```fish
set -gx DOCKER_BUILDKIT 1
```

### Git Integration

**Functions:**

- `gc`: Git commit with interactive selection
- `gdiff`: Enhanced git diff viewer
- `lg`: LazyGit TUI
- `cmg`: Chezmoi git operations

**FZF Git integration:**

- `Ctrl+Alt+A`: Search Git log (via `fzf.fish`)

### Python Development

**Configuration**: `conf.d/_fish_python_config.fish`

**Virtual environment:**

- Auto-activation when entering project directories (via `venv_auto_activate`)
- `venv`: Create/manage virtual environments

**Tools supported:**

- Poetry, pipx, pyenv
- YAPF formatter
- Pyright, Ruff linting

### Node.js/JavaScript

**Configuration**: `conf.d/_fish_javascript_config.fish`

**NVM integration** (via `jorgebucaran/nvm.fish`):

- Automatic Node version management
- `.nvmrc` support

**Helper functions:**

- `ni`: npm install
- `nid`: npm install --save-dev
- `ns`: npm start
- `nt`: npm test

## Custom Key Bindings

**Configuration**: `conf.d/_fish_keymaps_config.fish`

**Vi-mode enhancements:**

| Key      | Mode          | Action                               |
| -------- | ------------- | ------------------------------------ |
| `Ctrl+Y` | Insert        | Accept autosuggestion                |
| `Ctrl+X` | Insert        | Clear line                           |
| `Ctrl+J` | Insert/Normal | Down or search                       |
| `Ctrl+K` | Insert/Normal | Up or search                         |
| `Ctrl+U` | All           | Delete from cursor to line start     |
| `Ctrl+W` | All           | Delete previous word                 |
| `yy`     | Normal        | Copy line to clipboard               |
| `Ctrl+S` | Insert/Normal | Live ripgrep search                  |
| `Ctrl+Z` | Insert/Normal | Zellij session picker                |
| `Alt+L`  | All           | Unmapped (allows OS-level shortcuts) |

**How to discover key codes:**

```fish
fish_key_reader  # Press keys to see their codes
```

## Key Functions

**77 custom functions** organized by category:

### Navigation & Search

- `ripgrep_live`: Live ripgrep with FZF and Neovim integration
- `rg_fzf_search`: Search codebase with FZF
- `frg`: Fast ripgrep with FZF
- `brg`: Browse ripgrep results
- `zi`: Interactive zoxide directory picker
- `l`, `la`, `ll`, `lt`, `lrt`: Enhanced directory listings (eza)
- `ld`, `ldot`: List directories, list dotfiles
- `lS`, `lsa`, `lsn`, `lsr`: Size-sorted, all files, newest, recursive listings

### Development

- `brewadd`, `brewrem`: Homebrew management
- `dbuild`, `ddeploy`, `dup`, `ddown`: Docker workflows
- `dlog`, `dtail`: Docker logging
- `profile_fish`: Profile Fish startup time
- `timer`: Simple command timer

### File Management

- `s`: Rsync dotfiles helper
- `ter`: Terminal screenshot utility
- `search_and_replace`: Interactive find & replace
- `cat`: Enhanced cat with bat

### Notebook Management (nb)

- `ne`: Edit note
- `ni`: Interactive note browser
- `nq`: Quick note capture
- `ns`: Search notes
- `nt`: Todo management

### Chezmoi Operations

- `cm`: Chezmoi manager
- `cmf`: Chezmoi with FZF
- `cmg`: Chezmoi git operations
- `vm`: Edit dotfiles in Neovim
- `sc`: Source config (chezmoi apply)

### Git Operations

- `gc`: Git commit
- `gdiff`: Git diff viewer
- `lg`: LazyGit

### Neovim

- `v`: Open in Neovim
- `vc`: Edit Neovim config
- `vman`: View man pages
- `vtest`: Run tests

### Other

- `c`: Quick cd
- `ca`: Cd with autocomplete
- `fc`: Find and cd
- `help`: Enhanced help viewer
- `y`: Yazi file manager

## Plugins

**Managed by Fisher** (`jorgebucaran/fisher`):

| Plugin                        | Purpose                                         |
| ----------------------------- | ----------------------------------------------- |
| `patrickf1/fzf.fish`          | FZF integration (file search, history, git log) |
| `jorgebucaran/nvm.fish`       | Node version manager                            |
| `catppuccin/fish`             | Catppuccin theme                                |
| `oh-my-fish/plugin-bang-bang` | Bash-style `!!` and `!$` expansions             |
| `edc/bass`                    | Run Bash scripts in Fish                        |
| `gazorby/fifc`                | FZF completion with man page preview            |
| `laughedelic/fish_logo`       | Fish logo for greeting                          |

**External CLI tools integrated:**

- `eza`: Modern `ls` replacement
- `bat`: Cat with syntax highlighting
- `fd`: Fast `find` alternative
- `ripgrep` (`rg`): Fast grep alternative
- `delta`: Git diff viewer
- `dust`: Disk usage analyzer
- `starship`: Cross-shell prompt
- `zoxide`: Smart directory jumper

## Customization Guide

### Adding a New Function

1. Create a file in `functions/` directory:

   ```fish
   # functions/myfunction.fish
   function myfunction --description "Description here"
       # Check if arguments are provided
       if test (count $argv) -eq 0
           echo "Usage: myfunction <arg>"
           return 1
       end

       echo "Function body"
       echo "Arguments: $argv"
   end
   ```

2. Fish auto-loads functions on first use (no need to source)

3. Test in a new shell: `fish -c "myfunction arg1 arg2"`

4. Add to version control via chezmoi:

   ```fish
   chezmoi add ~/.config/fish/functions/myfunction.fish
   ```

### Modifying Configuration

**For conf.d/ files:**

```fish
# Edit the appropriate config file
nvim ~/.config/fish/conf.d/_fish_fzf_config.fish

# Changes take effect in new shells
exec fish
```

**For interactive changes:**

```fish
# Set variable for current session only
set -g MY_VAR value

# Set universal variable (persists across sessions)
set -Ux MY_VAR value

# Make change permanent by adding to conf.d/ file
echo 'set -gx MY_VAR value' >> ~/.config/fish/conf.d/_fish_custom.fish
```

### Adding Key Bindings

Edit `conf.d/_fish_keymaps_config.fish`:

```fish
# Insert mode binding
bind --mode insert ctrl-t 'echo "Hello"'

# Normal mode binding
bind --mode default ctrl-t 'echo "Hello"'

# All modes
bind ctrl-t 'echo "Hello"'

# Binding to a function
bind --mode insert ctrl-t 'commandline -f repaint; my_function (commandline -b)'
```

**Test key bindings:**

```fish
fish_key_reader  # Press keys to see their codes
bind | grep ctrl-t  # Verify binding is set
```

### Adding a Plugin

1. Edit the fish_plugins file (managed via chezmoi):

   ```fish
   vim ~/.local/share/chezmoi/cm-util/ctrld-configs/fish/fish_plugins
   # Add: author/plugin-name
   ```

2. Apply changes:

   ```fish
   chezmoi apply ~/.config/fish/fish_plugins
   ```

3. Install the plugin:

   ```fish
   fisher update
   ```

### Profiling Startup Performance

```fish
profile_fish  # Opens sorted profile in Neovim

# Or manually:
fish --profile-startup /tmp/fish.profile -i -c exit
sort -nk2 /tmp/fish.profile | less  # View by time (microseconds)

# Calculate total startup time
awk '{sum += $2} END {print sum/1000 "ms"}' /tmp/fish.profile
```

**Common slow items:**

- Plugin initialization
- Path modifications
- External command initialization (starship, zoxide)

**Optimization tips:**

- Defer non-essential initializations to event handlers
- Use lazy-loading for plugins
- Minimize PATH modifications
- Comment out unused integrations (e.g., Atuin)

## CLI Tools

**Search & Text Processing:**

- `serpl`: Search and replace text tool
- `ripgrep` (`rg`): Fast grep alternative
- `bat`: Cat with syntax highlighting

**Development:**

- `cmdperf`: Benchmark terminal commands
- `oq`: OpenAPI spec viewer
- `gittype`: Typing test using your source code

**System & Infrastructure:**

- `gobackup`: Database backup utility
- `nerdlog`: Remote host log aggregator
- `dust`: Disk usage analyzer (Rust-based `du`)
- `kdash`: Kubernetes dashboard TUI
- `dcv`: Docker container manager TUI

**Terminal & Productivity:**

- `ziina`: Terminal multiplayer sharing (Zellij)
- `lazyssh`: SSH host TUI
- `tclock`: Timer, stopwatch, clock TUI
- `termframe`: Terminal screenshot utility
- `regname`: Regex file renamer TUI

**File Management:**

- `yazi`: Terminal file manager
- `jocalsend`: P2P local file sharing TUI
- `hygg`: Vim-like e-book reader

## Tips & Tricks

### Bang-Bang Substitution

```fish
# Previous command
vim text.txt  # Permission denied
sudo !!       # Expands to: sudo vim text.txt

# Previous argument
cat /long/path/to/file.txt
vim !$  # Expands to: vim /long/path/to/file.txt
```

### Bass (Bash Compatibility)

```fish
# Run Bash scripts in Fish
bass source venv/bin/activate  # Sets environment variables in Fish

# Source Bash environment
bass source ~/.bashrc

# One-off Bash command
bass export MY_VAR=value
```

### Environment Variable Management

**Query variables:**

```fish
# Show all variables
set

# Show specific variable
echo $PATH

# Search variables with FZF (if enabled)
# Ctrl+V at prompt
```

**Modify variables:**

```fish
# Append to PATH
set -gx PATH $PATH /new/path

# Prepend to PATH
set -gx PATH /new/path $PATH

# Remove from PATH
set -gx PATH (string match -v /path/to/remove $PATH)
```

### SSH Environment Detection

```fish
# Check if in SSH session
if test $IS_SSH -eq 1
    echo "Running in SSH session"
end
```

### Debugging Functions

```fish
# Check syntax
fish -n ~/.config/fish/functions/myfunction.fish

# Run function with tracing
fish --debug-categories=fish_function myfunction arg

# Print function definition
type myfunction
```

## Troubleshooting

### FZF Issues

**Keybindings not working:**

```fish
# Check if fzf is installed
which fzf

# Verify fzf.fish plugin
fisher list | grep fzf

# Reload config
source ~/.config/fish/config.fish
```

**Preview window issues:**

```fish
# Ensure preview tools are installed
which bat
which delta
which eza
```

### Slow Startup

**Profile startup:**

```fish
profile_fish  # Identify slow files
```

**Common fixes:**

```fish
# Disable Atuin (already done)
# Minimize path modifications in conf.d/_fish_path_config.fish
# Lazy-load plugins
```

### Function Not Found

```fish
# Check if function file exists
ls ~/.config/fish/functions/myfunction.fish

# Check for syntax errors
fish -n ~/.config/fish/functions/myfunction.fish

# Reload functions
exec fish

# Clear function cache
functions -e myfunction
```

### Key Binding Not Working

```fish
# Check current bindings
bind | grep ctrl-x

# Verify mode
echo $fish_bind_mode  # Should be "default" or "insert"

# Reload key bindings
source ~/.config/fish/conf.d/_fish_keymaps_config.fish

# Test key code
fish_key_reader
```

### Plugin Issues

```fish
# Update all plugins
fisher update

# List installed plugins
fisher list

# Remove problematic plugin
fisher remove author/plugin-name

# Reinstall plugin
fisher install author/plugin-name
```

### Path Issues

```fish
# Check current PATH
echo $PATH | tr ' ' '\n'

# Reset PATH
exec fish

# Check for duplicates
printf '%s\n' $PATH | sort | uniq -d
```

## Resources

**Fish Shell:**

- [Official Documentation](https://fishshell.com/docs/current/)
- [Fish Tutorial](https://fishshell.com/docs/current/tutorial.html)
- [Fish Cookbook](https://github.com/jorgebucaran/cookbook.fish)
- [Fish for Bash Users](https://fishshell.com/docs/current/fish_for_bash_users.html)

**Plugins:**

- [Fisher](https://github.com/jorgebucaran/fisher)
- [fzf.fish](https://github.com/PatrickF1/fzf.fish)
- [Catppuccin for Fish](https://github.com/catppuccin/fish)

**Tools:**

- [Starship Prompt](https://starship.rs/)
- [FZF](https://github.com/junegunn/fzf)
- [Zoxide](https://github.com/ajeetdsouza/zoxide)
- [eza](https://github.com/eza-community/eza)
- [bat](https://github.com/sharkdp/bat)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [delta](https://github.com/dandavison/delta)
