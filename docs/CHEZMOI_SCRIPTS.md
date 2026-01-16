# Chezmoi Scripts Documentation

## Overview

Chezmoi scripts are shell scripts that automate setup tasks during `chezmoi apply`. These scripts handle everything from initializing secrets repositories to installing development tools and configuring system settings. They execute automatically at specific times during the chezmoi workflow, ensuring a consistent and reproducible dotfiles setup across machines.

Scripts can run:

- **Before** chezmoi applies configuration files (prerequisites)
- **After** chezmoi applies configuration files (installations and setup)
- **Once** (first-time setup only)
- **Every time** `chezmoi apply` runs (maintenance tasks)

## Table of Contents

- [Overview](#overview)
- [Execution Order](#execution-order)
- [Timing Categories Explained](#timing-categories-explained)
  - [`run_once_before`](#run_once_before)
  - [`run_once_after`](#run_once_after)
  - [`run_after`](#run_after)
- [Script Details](#script-details)
  - [Script: run_once_before_1-setup-secrets-submodule.sh.tmpl](#script-run_once_before_1-setup-secrets-submodulesshtmpl)
  - [Script: run_once_after_1-install-homebrew.sh](#script-run_once_after_1-install-homebrewsh)
  - [Script: run_once_after_2-install-various.sh](#script-run_once_after_2-install-varioussh)
  - [Script: run_once_after_3-install-uv-tools.sh.tmpl](#script-run_once_after_3-install-uv-toolssshtmpl)
  - [Script: run_once_after_4-macos-settings.sh](#script-run_once_after_4-macos-settingssh)
  - [Script: run_after_1-setup-fish.sh](#script-run_after_1-setup-fishsh)
- [Template Files (.tmpl)](#template-files-tmpl)
- [SSH vs Local Behavior](#ssh-vs-local-behavior)
  - [SSH Detection Methods](#ssh-detection-methods)
  - [Installation Differences](#installation-differences)
  - [Why This Matters](#why-this-matters)
- [Troubleshooting](#troubleshooting)
  - [Skip Scripts Temporarily](#skip-scripts-temporarily)
  - [Re-run One-Time Scripts](#re-run-one-time-scripts)
  - [Log Locations and Debugging](#log-locations-and-debugging)
- [Numbering Convention](#numbering-convention)
- [Best Practices](#best-practices)
- [Additional Resources](#additional-resources)

## Execution Order

| Order | Timing              | Script                                            | Purpose                                           |
| ----- | ------------------- | ------------------------------------------------- | ------------------------------------------------- |
| 1     | before              | run_once_before_1-setup-secrets-submodule.sh.tmpl | Initialize secrets git submodule                  |
| 2     | after               | run_once_after_1-install-homebrew.sh              | Install Homebrew and run brew bundle              |
| 3     | after               | run_once_after_2-install-various.sh               | Install additional tools via curl, cargo, go, npm |
| 4     | after               | run_once_after_3-install-uv-tools.sh.tmpl         | Install Python tools using uv                     |
| 5     | after               | run_once_after_4-macos-settings.sh                | Configure macOS system settings                   |
| 6     | after (every apply) | run_after_1-setup-fish.sh                         | Link Fisher plugin files to Fish config           |

## Timing Categories Explained

### `run_once_before`

Executes once before applying any configuration files. Used for prerequisite setup that must complete before dotfiles are applied.

**Example**: Setting up git submodules for secrets before other configurations need those secrets.

### `run_once_after`

Executes once after applying configuration files. Used for one-time installations and system configuration that should only happen during initial setup.

**Examples**: Installing Homebrew, installing development tools, configuring macOS defaults.

### `run_after`

Executes after every `chezmoi apply` command. Used for maintenance tasks that should stay synchronized with the latest configuration.

**Example**: Relinking Fish shell plugin directories to ensure plugins remain accessible.

## Script Details

### Script: run_once_before_1-setup-secrets-submodule.sh.tmpl

**Purpose**: Set up secrets git submodule configuration

**When it runs**: Once, before chezmoi applies files (first in execution order)

**Key actions**:

- Creates `.gitmodules` file in chezmoi source directory
- Configures secrets submodule path and URL from template data
- Ensures secrets repository is available before applying dotfiles
- Only runs on local machines (skips SSH connections)

**Conditional logic**:

- Skips execution when connected via SSH
- Uses template data (`.secretsRepo`) to configure submodule URL

**Manual execution**:

```bash
# Re-run this script manually (from chezmoi source directory)
bash .chezmoiscripts/run_once_before_1-setup-secrets-submodule.sh.tmpl
```

---

### Script: run_once_after_1-install-homebrew.sh

**Purpose**: Install Homebrew package manager and install packages from Brewfile

**When it runs**: Once, after chezmoi applies files (second in execution order)

**Key actions**:

- Checks if Homebrew is already installed
- Installs Homebrew if not present (non-interactive mode)
- Adds Homebrew to PATH for macOS, Linux, and local bin locations
- Runs `brew bundle --cleanup` with appropriate Brewfile
- Uses `~/Brewfile` for local machines
- Uses `~/Brewfile_ssh` for remote SSH connections
- Logs all operations with timestamps
- Captures and reports any errors during brew bundle execution

**Conditional logic**:

- Detects SSH connections via environment variables (`SSH_CONNECTION`, `SSH_CLIENT`, `SSH_TTY`)
- Local machines: Full Brewfile with GUI apps and development tools
- Remote SSH machines: Minimal Brewfile_ssh with CLI-only tools

**Manual execution**:

```bash
# Re-run Homebrew installation and bundle
bash ~/.local/share/chezmoi/.chezmoiscripts/run_once_after_1-install-homebrew.sh

# Or just run brew bundle manually
brew bundle --file=~/Brewfile --cleanup
```

---

### Script: run_once_after_2-install-various.sh

**Purpose**: Install various development tools and utilities not managed by Homebrew

**When it runs**: Once, after chezmoi applies files (third in execution order)

**Key actions**:

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

**Conditional logic**:

- Uses `IS_SSH` environment variable to determine installation scope
- Local machines: Full GUI applications and all development tools
- Remote SSH machines: Minimal CLI-only installations
- Skips GUI tools (Hammerspoon, Cursor, Ghostty) on SSH connections
- Skips gitleaks pre-commit setup on SSH connections

**Manual execution**:

```bash
# Re-run all tool installations
bash ~/.local/share/chezmoi/.chezmoiscripts/run_once_after_2-install-various.sh

# Set IS_SSH=1 to test SSH mode locally
IS_SSH=1 bash ~/.local/share/chezmoi/.chezmoiscripts/run_once_after_2-install-various.sh
```

---

### Script: run_once_after_3-install-uv-tools.sh.tmpl

**Purpose**: Install and manage Python tools using uv package manager

**When it runs**: Once, after chezmoi applies files (fourth in execution order)

**Key actions**:

- Installs Python 3.13 (preview) using uv
- Reads tool list from `.chezmoidata/uv.toml`
- Installs each Python tool specified in the configuration
- Handles both version-specific (`==`) and git-based (`@`) installations
- Upgrades all system-wide Python CLI tools
- Only runs if uv is available

**Conditional logic**:

- Checks for uv availability before running
- Processes template data from `.chezmoidata/uv.toml`

**Manual execution**:

```bash
# Re-run uv tool installation
bash ~/.local/share/chezmoi/.chezmoiscripts/run_once_after_3-install-uv-tools.sh.tmpl

# Or manually install/upgrade tools with uv
uv tool install --upgrade <tool-name>
uv tool upgrade --all
```

---

### Script: run_once_after_4-macos-settings.sh

**Purpose**: Configure macOS system preferences and defaults

**When it runs**: Once, after chezmoi applies files (fifth in execution order)

**Key actions**:

- Enables App Switcher (Cmd+Tab) on all displays
- Disables press-and-hold for alternate characters (enables key repeat)
- Disables font smoothing for pixel-perfect rendering
- Configures Services submenu threshold to hide default terminal service
- Sets fast key repeat rates (InitialKeyRepeat: 25, KeyRepeat: 1)

**Conditional logic**:

- Only runs on macOS (exits immediately on other systems)
- Checks for Darwin kernel using `uname`

**Manual execution**:

```bash
# Re-run macOS settings configuration
bash ~/.local/share/chezmoi/.chezmoiscripts/run_once_after_4-macos-settings.sh

# View current macOS defaults
defaults read
```

---

### Script: run_after_1-setup-fish.sh

**Purpose**: Link Fisher plugin files into Fish shell configuration

**When it runs**: After every `chezmoi apply` (sixth in execution order, runs repeatedly)

**Key actions**:

- Creates symlinks from `~/.config/fish/fisher/` to `~/.config/fish/`
- Links conf.d, functions, completions, and themes directories
- Ensures Fisher-installed plugins are available in main Fish config
- Ignores errors if links already exist
- Runs on every apply (not just once) to maintain current state

**Conditional logic**:

- None - runs unconditionally on every apply
- Note: Fisher theme setting is commented out as TODO

**Manual execution**:

```bash
# Re-run Fish setup linking
bash ~/.local/share/chezmoi/.chezmoiscripts/run_after_1-setup-fish.sh

# Or manually create symlinks
ln -sf ~/.config/fish/fisher/conf.d ~/.config/fish/
ln -sf ~/.config/fish/fisher/functions ~/.config/fish/
ln -sf ~/.config/fish/fisher/completions ~/.config/fish/
ln -sf ~/.config/fish/fisher/themes ~/.config/fish/
```

## Template Files (.tmpl)

Scripts ending in `.tmpl` are processed as Go templates before execution. This allows them to access chezmoi template data and conditionally configure themselves based on your environment.

**Template data sources**:

- `.chezmoidata/uv.toml`: Python tools to install with uv
- `.secretsRepo`: Git repository URL for secrets submodule
- Chezmoi built-in variables: `.chezmoi.os`, `.chezmoi.arch`, etc.

**Example template usage**:

```bash
# In a .tmpl script
{{ if .secretsRepo }}
git config submodule.secrets.url "{{ .secretsRepo }}"
{{ end }}
```

## SSH vs Local Behavior

Scripts detect SSH connections using environment variables to conditionally install tools:

### SSH Detection Methods

```bash
# Environment variables checked:
- SSH_CONNECTION
- SSH_CLIENT
- SSH_TTY
- IS_SSH (manually set)
```

### Installation Differences

| Category          | Local Machines               | Remote SSH Machines         |
| ----------------- | ---------------------------- | --------------------------- |
| Package Manager   | Full Brewfile                | Minimal Brewfile_ssh        |
| GUI Applications  | Hammerspoon, Cursor, Ghostty | Skipped                     |
| Development Tools | All cargo, go, npm packages  | All cargo, go, npm packages |
| Git Hooks         | gitleaks pre-commit          | Skipped                     |
| Secrets Submodule | Initialized                  | Skipped                     |
| macOS Settings    | Applied                      | Applied (if macOS)          |
| Fish Setup        | Applied                      | Applied                     |

### Why This Matters

- **Local machines**: Full desktop environment with GUI apps and complete tooling
- **Remote SSH machines**: Lightweight, CLI-focused setup for server environments
- **Performance**: Avoids installing unnecessary GUI tools on headless servers
- **Security**: Keeps secrets on local machines only

## Troubleshooting

### Skip Scripts Temporarily

To skip all scripts during `chezmoi apply`:

```bash
chezmoi apply --no-scripts
```

### Re-run One-Time Scripts

Chezmoi tracks script execution in `~/.local/share/chezmoi/chezmoistate.boltdb`. To re-run a one-time script:

**Option 1: Remove the script's state entry**

```bash
# Remove the entire state database (re-runs ALL one-time scripts)
rm ~/.local/share/chezmoi/chezmoistate.boltdb
chezmoi apply
```

**Option 2: Run the script manually**

```bash
# Execute the script directly
bash ~/.local/share/chezmoi/.chezmoiscripts/run_once_after_1-install-homebrew.sh
```

**Option 3: Force re-run by renaming**

```bash
# Temporarily rename the script (chezmoi sees it as "new")
cd ~/.local/share/chezmoi/.chezmoiscripts
mv run_once_after_1-install-homebrew.sh run_once_after_1-install-homebrew-v2.sh
chezmoi apply
# Rename back after running
mv run_once_after_1-install-homebrew-v2.sh run_once_after_1-install-homebrew.sh
```

### Log Locations and Debugging

**Enable verbose output**:

```bash
chezmoi apply --verbose
```

**Debug script execution**:

```bash
# Run a specific script with shell debugging
bash -x ~/.local/share/chezmoi/.chezmoiscripts/run_once_after_1-install-homebrew.sh
```

**Check script state**:

```bash
# View chezmoi state database
chezmoi state dump
```

**Common issues**:

1. **Script fails silently**
   - Run manually with `bash -x` to see detailed execution
   - Check file permissions: `chmod +x <script>`

2. **Template errors in .tmpl scripts**
   - Verify template data: `chezmoi data`
   - Check for missing variables in `.chezmoidata/` files

3. **Homebrew installation fails**
   - Ensure internet connection
   - Check Homebrew logs: `~/Library/Logs/Homebrew/`
   - Verify Brewfile syntax: `brew bundle check --file=~/Brewfile`

4. **SSH detection not working**
   - Manually set IS_SSH: `export IS_SSH=1`
   - Check environment: `env | grep SSH`

5. **Fish setup not working**
   - Verify Fisher installation: `fisher --version`
   - Check symlink targets exist: `ls -la ~/.config/fish/fisher/`

## Numbering Convention

Scripts use numbered prefixes (1, 2, 3, etc.) to control execution order within their timing category. Scripts execute in numerical order within each timing prefix.

**Example**:

- `run_once_before_1-setup-secrets.sh` runs before `run_once_before_2-other.sh`
- `run_once_after_1-homebrew.sh` runs before `run_once_after_2-various.sh`

This ensures dependencies are satisfied (e.g., Homebrew is installed before tools that depend on it).

## Best Practices

1. **Idempotency**: Scripts should be safe to run multiple times
2. **Error handling**: Check command success and provide meaningful error messages
3. **Logging**: Include timestamps and clear progress indicators
4. **Conditional logic**: Use SSH detection for environment-specific installations
5. **Dependencies**: Order scripts so prerequisites are satisfied
6. **Testing**: Run scripts manually before committing to verify behavior

## Additional Resources

- [Chezmoi documentation](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/)
- [Script execution order](https://www.chezmoi.io/reference/special-files-and-directories/chezmoiscripts/)
- [Template syntax](https://www.chezmoi.io/user-guide/templating/)
