# Chezmoi Scripts Data

## Execution Order

| Order | Timing | Script | Purpose |
|-------|--------|--------|---------|
| 1 | before | run_once_before_1-setup-secrets-submodule.sh.tmpl | Initialize secrets git submodule |
| 2 | after | run_once_after_1-install-homebrew.sh | Install Homebrew and run brew bundle |
| 3 | after | run_once_after_2-install-various.sh | Install additional tools via curl, cargo, go, npm |
| 4 | after | run_once_after_3-install-uv-tools.sh.tmpl | Install Python tools using uv |
| 5 | after | run_once_after_4-macos-settings.sh | Configure macOS system settings |
| 6 | after (every apply) | run_after_1-setup-fish.sh | Link Fisher plugin files to Fish config |

## Script Details

### Script: run_once_before_1-setup-secrets-submodule.sh.tmpl

- **Timing**: Runs once before chezmoi applies files
- **Order**: 1
- **Purpose**: Set up secrets git submodule configuration
- **Key Actions**:
  - Creates `.gitmodules` file in chezmoi source directory
  - Configures secrets submodule path and URL from template data
  - Only runs on local machines (skips SSH connections)
  - Ensures secrets repository is available before applying dotfiles

### Script: run_once_after_1-install-homebrew.sh

- **Timing**: Runs once after chezmoi applies files
- **Order**: 2
- **Purpose**: Install Homebrew package manager and install packages from Brewfile
- **Key Actions**:
  - Checks if Homebrew is already installed
  - Installs Homebrew if not present (non-interactive mode)
  - Adds Homebrew to PATH for macOS, Linux, and local bin locations
  - Runs `brew bundle --cleanup` with appropriate Brewfile (local or SSH)
  - Uses `~/Brewfile` for local machines
  - Uses `~/Brewfile_ssh` for remote SSH connections
  - Logs all operations with timestamps
  - Captures and reports any errors during brew bundle execution

### Script: run_once_after_2-install-various.sh

- **Timing**: Runs once after chezmoi applies files
- **Order**: 3
- **Purpose**: Install various development tools and utilities not managed by Homebrew
- **Key Actions**:
  - Installs Hammerspoon VimMode.spoon (local only)
  - Installs Cursor AI editor (local only)
  - Installs Rust via rustup
  - Installs Nix package manager (for nil-ls in Neovim)
  - Installs Ghostty animation command (local only)
  - Installs uv tools: aider-chat, specify-cli
  - Installs npm packages: typescript-language-server, claude-code
  - Installs Cargo packages: clock-tui, filessh, trippy, rustnet-monitor, gittype, glues, jocalsend, regname, hygg, zellij, ugdb, systemd-manager-tui
  - Installs Go packages: csvi, trex, e2c, nerdlog, tuios, stormy, zmate, reddix
  - Sets up pre-commit hooks for gitleaks (local only)
  - Updates Fisher plugins
  - Conditionally installs based on IS_SSH environment variable

### Script: run_once_after_3-install-uv-tools.sh.tmpl

- **Timing**: Runs once after chezmoi applies files
- **Order**: 4
- **Purpose**: Install and manage Python tools using uv package manager
- **Key Actions**:
  - Installs Python 3.13 (preview) using uv
  - Reads tool list from `.chezmoidata/uv.toml`
  - Installs each Python tool specified in the configuration
  - Handles both version-specific (==) and git-based (@) installations
  - Upgrades all system-wide Python CLI tools
  - Only runs if uv is available

### Script: run_once_after_4-macos-settings.sh

- **Timing**: Runs once after chezmoi applies files
- **Order**: 5
- **Purpose**: Configure macOS system preferences and defaults
- **Key Actions**:
  - Only runs on macOS (exits on other systems)
  - Enables App Switcher (Cmd+Tab) on all displays
  - Disables press-and-hold for alternate characters (enables key repeat)
  - Disables font smoothing for pixel-perfect rendering
  - Configures Services submenu threshold to hide default terminal service
  - Sets fast key repeat rates (InitialKeyRepeat: 25, KeyRepeat: 1)

### Script: run_after_1-setup-fish.sh

- **Timing**: Runs after every chezmoi apply
- **Order**: 6
- **Purpose**: Link Fisher plugin files into Fish shell configuration
- **Key Actions**:
  - Creates symlinks from `~/.config/fish/fisher/` to `~/.config/fish/`
  - Links conf.d, functions, completions, and themes directories
  - Ensures Fisher-installed plugins are available in main Fish config
  - Ignores errors if links already exist
  - Runs on every apply (not just once) to maintain current state
  - Note: Fisher theme setting is commented out as TODO

## Notes

### Execution Timing Categories

- **run_once_before**: Executes once before applying any files (e.g., prerequisite setup)
- **run_once_after**: Executes once after applying files (e.g., one-time installations)
- **run_after**: Executes after every `chezmoi apply` (e.g., maintenance tasks)

### Numbering Convention

Scripts are numbered (1, 2, 3, etc.) to control execution order within their timing category. Scripts with the same timing prefix execute in numerical order.

### Template Files (.tmpl)

Scripts ending in `.tmpl` are processed as templates before execution, allowing access to chezmoi template data (e.g., `.secretsRepo`, `.uv.tools`).

### SSH Detection

Many scripts use environment variables (`SSH_CONNECTION`, `SSH_CLIENT`, `SSH_TTY`) or the `IS_SSH` variable to conditionally install tools:

- Local machines get full GUI applications and development tools
- Remote SSH machines get minimal CLI-only installations
