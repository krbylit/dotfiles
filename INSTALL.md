# Installation Guide

## Purpose

This guide provides step-by-step instructions for installing and configuring this dotfiles repository on a fresh macOS system. Follow these instructions to set up a complete development environment with window management, shell configuration, and all supporting tools.

**Estimated completion time**: 60 minutes or less

## Table of Contents

- [Purpose](#purpose)
- [Prerequisites](#prerequisites)
- [Quick Start (Experienced Users)](#quick-start-experienced-users)
- [Step-by-Step Installation](#step-by-step-installation)
  - [Step 1: Install Homebrew](#step-1-install-homebrew)
  - [Step 2: Install chezmoi](#step-2-install-chezmoi)
  - [Step 3: Initialize chezmoi with dotfiles repository](#step-3-initialize-chezmoi-with-dotfiles-repository)
  - [Step 4: Review configuration before applying](#step-4-review-configuration-before-applying)
  - [Step 5: Apply dotfiles](#step-5-apply-dotfiles)
  - [Step 6: Set Fish as your default shell](#step-6-set-fish-as-your-default-shell)
  - [Step 7: Configure macOS permissions](#step-7-configure-macos-permissions)
  - [Step 8: Start services](#step-8-start-services)
- [Secrets Setup](#secrets-setup)
  - [Understanding Secrets Architecture](#understanding-secrets-architecture)
  - [Initializing Secrets Submodule](#initializing-secrets-submodule)
  - [GPG Passphrase Setup](#gpg-passphrase-setup)
  - [1Password Service Account Configuration (Optional)](#1password-service-account-configuration-optional)
  - [Adding New Secrets](#adding-new-secrets)
- [Verification Checklist](#verification-checklist)
  - [Shell Environment](#shell-environment)
  - [Development Tools](#development-tools)
  - [Window Management](#window-management)
  - [Keyboard Customization](#keyboard-customization)
  - [Text Editor](#text-editor)
  - [Git Configuration](#git-configuration)
  - [Additional Verifications](#additional-verifications)
- [Troubleshooting](#troubleshooting)
  - [Problem: Homebrew installation fails](#problem-homebrew-installation-fails)
  - [Problem: Chezmoi prompts for passphrase repeatedly](#problem-chezmoi-prompts-for-passphrase-repeatedly)
  - [Problem: Yabai or skhd not working](#problem-yabai-or-skhd-not-working)
  - [Problem: Fish shell not set as default](#problem-fish-shell-not-set-as-default)
  - [Problem: Neovim shows plugin errors](#problem-neovim-shows-plugin-errors)
  - [Problem: Secrets submodule not initializing](#problem-secrets-submodule-not-initializing)
  - [Problem: Permission denied errors during installation](#problem-permission-denied-errors-during-installation)
  - [How to roll back if needed](#how-to-roll-back-if-needed)
  - [Additional Help](#additional-help)
- [Post-Installation Steps](#post-installation-steps)
  - [Optional: Install Manual Dependencies](#optional-install-manual-dependencies)
  - [Customize Your Configuration](#customize-your-configuration)
  - [Multi-Machine Setup](#multi-machine-setup)
- [Next Steps](#next-steps)
- [Related Documentation](#related-documentation)
- [Notes](#notes)

## Prerequisites

Before beginning installation, ensure you have:

- [ ] macOS (latest version recommended, tested on macOS 15.0+)
- [ ] Administrator access (for installing system-level tools)
- [ ] Stable internet connection (for downloading packages and repositories)
- [ ] Basic command-line familiarity (opening Terminal, running commands)
- [ ] GitHub account with SSH keys configured (for private repository access)

## Quick Start (Experienced Users)

If you're familiar with chezmoi and dotfiles:

```bash
# Install chezmoi and apply dotfiles in one command
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply git@github.com:krbylit/dotfiles.git
```

For first-time users, follow the detailed step-by-step instructions below.

## Step-by-Step Installation

### Step 1: Install Homebrew

Homebrew is the package manager for macOS and is required to install most tools in this repository.

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**Expected result**: You should see installation progress and a success message. Follow any post-installation instructions to add Homebrew to your PATH.

**Post-installation setup**:

```bash
# Add Homebrew to PATH (Apple Silicon Macs)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Add Homebrew to PATH (Intel Macs)
echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/usr/local/bin/brew shellenv)"
```

Verify installation:

```bash
brew --version
```

**Expected result**: Version information for Homebrew (e.g., `Homebrew 4.x.x`)

### Step 2: Install chezmoi

Chezmoi is the dotfiles manager that will apply all configurations to your system.

```bash
# Install chezmoi via Homebrew
brew install chezmoi
```

**Expected result**: Chezmoi is installed and available in your PATH.

Verify installation:

```bash
chezmoi --version
```

**Expected result**: Version information for chezmoi (e.g., `chezmoi version 2.x.x`)

### Step 3: Initialize chezmoi with dotfiles repository

This step clones the dotfiles repository into chezmoi's source directory.

```bash
# Initialize chezmoi with the dotfiles repository
chezmoi init git@github.com:krbylit/dotfiles.git
```

**Expected result**: The repository is cloned to `~/.local/share/chezmoi`

During initialization, you will be prompted for:

1. **Secrets repository URL** (optional): Enter the `git@github.com` URL to your private secrets repository, or press Enter to skip
2. **GPG passphrase**: Enter a passphrase for encrypting sensitive files (you'll need to remember this)

**Note**: These values are stored in `~/.config/chezmoi/chezmoi.toml` on your local machine for future use.

### Step 4: Review configuration before applying

Before applying changes to your system, review what will be modified:

```bash
# See what changes will be made
chezmoi diff

# Interactively review and approve changes
chezmoi apply --dry-run --verbose
```

**Expected result**: A diff showing all files that will be created or modified. Review this output to understand what chezmoi will do.

**Important files to note**:

- Shell configuration: `~/.config/fish/`
- Neovim configuration: `~/.config/nvim/`
- Window manager: `~/.config/yabai/`, `~/.config/skhd/`
- Git configuration: `~/.gitconfig`
- And many more tool configurations

### Step 5: Apply dotfiles

Apply all dotfiles to your system:

```bash
# Apply all configurations
chezmoi apply
```

**Expected result**: All configuration files are created in their target locations. Several setup scripts will run automatically:

1. **Secrets submodule setup** (if configured)
2. **Homebrew package installation** via `~/Brewfile` (this will take 15-30 minutes)
3. **Fish shell configuration** and fisher plugin setup
4. **Additional tools installation** (Rust, Nix, npm packages, cargo packages, etc.)

**Note**: The Homebrew installation step installs many packages. You'll see progress for each package being installed or updated.

### Step 6: Set Fish as your default shell

After installation, change your default shell to Fish:

```bash
# Add Fish to allowed shells (if not already present)
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells

# Set Fish as default shell
chsh -s /opt/homebrew/bin/fish
```

**Expected result**: Fish is now your default shell. Close and reopen your terminal to see the new Fish shell with Starship prompt.

### Step 7: Configure macOS permissions

Several tools require special macOS permissions to function properly. Grant these permissions manually:

#### Yabai (Window Manager)

1. Open **System Settings > Privacy & Security > Accessibility**
2. Click the lock icon to make changes
3. Click the **+** button and add `/opt/homebrew/bin/yabai`
4. Ensure the checkbox next to yabai is checked

**Alternative**: Grant permission via command line:

```bash
# Start yabai service
yabai --start-service

# Follow prompts to grant accessibility permissions
```

#### Skhd (Hotkey Daemon)

1. Open **System Settings > Privacy & Security > Accessibility**
2. Click the lock icon to make changes
3. Click the **+** button and add `/opt/homebrew/bin/skhd`
4. Ensure the checkbox next to skhd is checked

**Alternative**: Grant permission via command line:

```bash
# Start skhd service
skhd --start-service

# Follow prompts to grant accessibility permissions
```

#### Karabiner Elements (Keyboard Customization)

1. Open Karabiner Elements (it should auto-start after installation)
2. Follow the setup wizard to grant the following permissions:
   - **Input Monitoring** (System Settings > Privacy & Security > Input Monitoring)
   - **Accessibility** (System Settings > Privacy & Security > Accessibility)
3. Restart Karabiner Elements after granting permissions

#### Hammerspoon (Automation Tool)

1. Open Hammerspoon (located in `/Applications`)
2. Grant **Accessibility** permission when prompted
3. Open **System Settings > Privacy & Security > Accessibility**
4. Ensure Hammerspoon is checked

### Step 8: Start services

Start the window manager and hotkey daemon:

```bash
# Start yabai and skhd (managed by Homebrew services)
brew services start yabai
brew services start skhd
```

**Expected result**: Yabai and skhd are running. You should notice window tiling behavior when opening new applications.

Verify services are running:

```bash
brew services list
```

**Expected result**: `yabai` and `skhd` show status as `started`

## Secrets Setup

Secrets management in this repository uses a combination of GPG encryption and a git submodule.

### Understanding Secrets Architecture

This repository manages secrets through:

1. **Secrets submodule**: A separate private git repository containing sensitive configuration files
2. **GPG encryption**: Chezmoi encrypts files marked with `encrypted_*` prefix using your passphrase
3. **1Password integration** (optional): Service account for accessing secrets programmatically

### Initializing Secrets Submodule

If you provided a secrets repository URL during Step 3, the submodule is automatically initialized. To verify:

```bash
# Check secrets submodule status
cd ~/.local/share/chezmoi
git submodule status
```

**Expected result**: The `secrets` submodule shows as initialized (no `-` prefix)

If the submodule wasn't initialized:

```bash
# Manually initialize secrets submodule
cd ~/.local/share/chezmoi
git submodule update --init --recursive
```

### GPG Passphrase Setup

Your GPG passphrase was configured during Step 3. This passphrase is used to:

- Decrypt files prefixed with `encrypted_*` in the repository
- Encrypt new sensitive files you add to chezmoi

**Important**: Store this passphrase securely. You'll need it when:

- Setting up this repository on additional machines
- Editing encrypted files with `chezmoi edit`

To edit encrypted files:

```bash
# Chezmoi automatically decrypts/re-encrypts when editing
chezmoi edit ~/.path/to/encrypted/file
```

### 1Password Service Account Configuration (Optional)

If using 1Password for secret management:

1. Create a 1Password service account at [1Password.com](https://1password.com)
2. Generate a service account token
3. Set the token in your environment:

```bash
# Add to Fish config
echo 'set -gx OP_SERVICE_ACCOUNT_TOKEN "your-token-here"' >> ~/.config/fish/config.fish
```

1. Verify configuration:

```bash
# Check 1Password integration
chezmoi execute-template "{{ (onepassword \"item-name\").password }}"
```

**Note**: This repository is configured for `onepassword.mode="service"` in `.chezmoi.toml`

### Adding New Secrets

To add new secret files to the repository:

```bash
# Encrypt a file when adding to chezmoi
chezmoi add --encrypt ~/.config/tool/secret-config.conf

# Or manually create with encrypted_ prefix
chezmoi add ~/.config/tool/encrypted_secret-config.conf
```

For more detailed secrets workflows, see `docs/workflows/secrets-management.md` (to be created in task T010).

## Verification Checklist

After installation, verify everything is working correctly:

### Shell Environment

- [ ] **Fish shell loads successfully**: Close and reopen terminal, confirm Fish prompt appears
- [ ] **Starship prompt appears**: You should see a customized prompt with git information
- [ ] **Fish functions are available**: Run `functions` to see custom functions list

Test commands:

```bash
# Verify Fish version
fish --version

# Test a custom Fish function
lg  # Should open lazygit if available
```

### Development Tools

- [ ] **Code formatters are installed**: Verify formatters are in PATH

Test commands:

```bash
# Verify formatters
stylua --version       # Lua formatter
fish_indent --version  # Fish formatter
shfmt --version        # Shell script formatter
prettier --version     # JavaScript/TypeScript/Markdown formatter
yapf --version         # Python formatter
```

- [ ] **Pre-commit hooks are active**: Test pre-commit functionality

Test commands:

```bash
cd ~/.local/share/chezmoi
pre-commit run --all-files
```

**Expected result**: Pre-commit runs gitleaks and other configured hooks

### Window Management

- [ ] **Yabai has accessibility permissions**: Verify in System Settings
- [ ] **Skhd has accessibility permissions**: Verify in System Settings
- [ ] **Window tiling works**: Open multiple applications and verify tiling behavior

Test window management:

```bash
# Check yabai is running
yabai -m query --windows

# Test a hotkey (default: Cmd+Shift+Return opens terminal)
# Try using defined hotkeys from skhd configuration
```

### Keyboard Customization

- [ ] **Karabiner has input monitoring permissions**: Verify in System Settings
- [ ] **Karabiner has accessibility permissions**: Verify in System Settings
- [ ] **Keyboard modifications work**: Test your custom key mappings

Test Karabiner:

```bash
# Check Karabiner status
karabiner_cli --show-current-profile-name
```

### Text Editor

- [ ] **Neovim opens without errors**: Launch Neovim and verify plugins load

Test Neovim:

```bash
# Open Neovim
nvim

# Inside Neovim, check health
:checkhealth
```

**Expected result**: No critical errors in `:checkhealth` output

### Git Configuration

- [ ] **Git is configured**: Verify your git identity and aliases

Test git:

```bash
# Check git config
git config --get user.name
git config --get user.email

# Test git alias
git st  # Should run 'git status' via alias
```

### Additional Verifications

- [ ] **Homebrew packages installed**: Check Brewfile packages

```bash
# List installed packages
brew list
```

- [ ] **Fisher plugins installed**: Check Fish plugin manager

```bash
# List fisher plugins
fisher list
```

## Troubleshooting

### Problem: Homebrew installation fails

**Symptoms**:

- Error messages during Homebrew installation
- `brew` command not found after installation

**Solution**:

1. Ensure you have administrator access and can use `sudo`
2. Check internet connection
3. Review Homebrew installation logs for specific errors
4. Try installing Homebrew manually before running chezmoi
5. Ensure PATH is updated with Homebrew location (see Step 1)

### Problem: Chezmoi prompts for passphrase repeatedly

**Symptoms**:

- Passphrase prompt appears multiple times during `chezmoi apply`
- Passphrase is not saved between sessions

**Solution**:

1. Check that `~/.config/chezmoi/chezmoi.toml` exists and contains passphrase
2. Verify GPG configuration in chezmoi.toml:

   ```toml
   encryption = "gpg"
   [gpg]
       symmetric = true
       args = ["--batch", "--passphrase", "your-passphrase", "--no-symkey-cache"]
   ```

3. Re-initialize chezmoi if configuration is incorrect:

   ```bash
   chezmoi init --force git@github.com:krbylit/dotfiles.git
   ```

### Problem: Yabai or skhd not working

**Symptoms**:

- Window tiling doesn't work
- Hotkeys don't respond
- Service shows as "error" in `brew services list`

**Solution**:

1. Verify accessibility permissions are granted (see Step 7)
2. Check service status and logs:

   ```bash
   brew services list
   brew services restart yabai
   brew services restart skhd

   # Check logs
   tail -f /opt/homebrew/var/log/yabai/yabai.err.log
   tail -f /opt/homebrew/var/log/skhd/skhd.err.log
   ```

3. Disable System Integrity Protection (SIP) if needed for advanced yabai features:
   - Restart Mac in Recovery Mode (hold Cmd+R during boot)
   - Open Terminal from Utilities menu
   - Run `csrutil disable`
   - Restart Mac
   - **Warning**: This reduces system security, only do if necessary

### Problem: Fish shell not set as default

**Symptoms**:

- Terminal still opens with zsh or bash
- Fish prompt doesn't appear on new terminal windows

**Solution**:

1. Verify Fish is in `/etc/shells`:

   ```bash
   cat /etc/shells | grep fish
   ```

2. If not present, add it:

   ```bash
   echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
   ```

3. Change default shell:

   ```bash
   chsh -s /opt/homebrew/bin/fish
   ```

4. Completely quit and reopen Terminal.app (Cmd+Q, then relaunch)

### Problem: Neovim shows plugin errors

**Symptoms**:

- Neovim displays error messages on startup
- Plugins don't load or function incorrectly
- LSP servers not working

**Solution**:

1. Open Neovim and run the plugin manager:

   ```vim
   :Lazy sync
   ```

2. Check Neovim health:

   ```vim
   :checkhealth
   ```

3. Install missing dependencies noted in checkhealth output
4. For LSP issues, install language servers via Mason:

   ```vim
   :Mason
   ```

5. Rebuild plugins if necessary:

   ```vim
   :Lazy clean
   :Lazy sync
   ```

### Problem: Secrets submodule not initializing

**Symptoms**:

- `secrets/` directory is empty
- Encrypted files can't be decrypted
- Error messages about missing secrets

**Solution**:

1. Verify you have access to the secrets repository
2. Manually initialize the submodule:

   ```bash
   cd ~/.local/share/chezmoi
   git submodule update --init --recursive
   ```

3. If URL is incorrect, update `.gitmodules`:

   ```bash
   chezmoi edit ~/.local/share/chezmoi/.gitmodules
   ```

4. Re-run submodule initialization

### Problem: Permission denied errors during installation

**Symptoms**:

- Scripts fail with "Permission denied"
- Unable to create directories or files

**Solution**:

1. Ensure you have write permissions to your home directory
2. Check file permissions on chezmoi source directory:

   ```bash
   ls -la ~/.local/share/chezmoi
   ```

3. Fix permissions if needed:

   ```bash
   chmod +x ~/.local/share/chezmoi/.chezmoiscripts/*.sh
   ```

4. Run chezmoi apply again:

   ```bash
   chezmoi apply
   ```

### How to roll back if needed

If something goes wrong during installation, you can roll back changes:

```bash
# Remove applied dotfiles (WARNING: This removes all configs)
chezmoi purge

# Remove chezmoi source directory
rm -rf ~/.local/share/chezmoi

# Restore backed up configs if you made backups
# (chezmoi creates backups in ~/.local/share/chezmoi/backups by default)
```

**Note**: Rolling back will remove all configurations. Make sure you have backups of any important files before purging.

### Additional Help

For more detailed troubleshooting:

- See [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) for comprehensive troubleshooting guide (to be created)
- Check tool-specific READMEs in `~/.local/share/chezmoi/dot_config/<tool>/README.md`
- Review chezmoi documentation: [chezmoi.io](https://www.chezmoi.io)
- Check GitHub issues in the dotfiles repository

## Post-Installation Steps

### Optional: Install Manual Dependencies

Some tools are not installed automatically via Homebrew and require manual installation:

#### Docker Desktop

Download and install from [docker.com](https://www.docker.com/products/docker-desktop)

#### YabaiIndicator (Menu Bar Status)

Shows yabai status in menu bar:

```bash
# Install from GitHub releases
# https://github.com/xiamaz/YabaiIndicator
```

#### Firefox Extensions (if using Firefox)

Install these extensions for enhanced workflow:

- [Sidebery](https://addons.mozilla.org/en-US/firefox/addon/sidebery/) - Container management
- [Vimium](https://addons.mozilla.org/en-US/firefox/addon/vimium-ff/) - Vim-like navigation
- [Firenvim](https://addons.mozilla.org/en-US/firefox/addon/firenvim/) - Neovim in browser

### Customize Your Configuration

Now that everything is installed, explore and customize:

1. **Read tool-specific documentation**:

   ```bash
   # Navigate to config directories
   cd ~/.config/fish && cat README.md
   cd ~/.config/nvim && cat README.md
   cd ~/.config/yabai && cat README.md
   ```

2. **Learn the chezmoi workflow**:
   - See [CHEZMOI.md](./CHEZMOI.md) for detailed workflow guide (to be created)
   - Practice making configuration changes safely

3. **Explore custom Fish functions**:

   ```bash
   # List all custom functions
   functions

   # See function documentation
   # (TOOLS.md to be created in dot_config/fish/)
   ```

4. **Review keymaps**:
   - See [docs/KEYMAPS.md](./docs/KEYMAPS.md) for unified keymap reference (to be created)
   - Learn window management shortcuts
   - Understand Neovim keybindings

### Multi-Machine Setup

If you plan to use these dotfiles on multiple machines:

1. **Set up SSH keys** on new machines for GitHub access
2. **Follow this installation guide** on each machine
3. **Keep machines in sync**:

   ```bash
   # Pull latest changes
   chezmoi update

   # Push local changes
   cd ~/.local/share/chezmoi
   git add .
   git commit -m "Update configuration"
   git push
   ```

For detailed multi-machine workflows, see `docs/workflows/multi-machine-sync.md` (to be created).

## Next Steps

Congratulations! Your development environment is now set up. Here's what to do next:

1. **Restart your computer** to ensure all services and permissions are fully active
2. **Learn the keyboard shortcuts**: Review `~/.config/skhd/skhdrc` for window management hotkeys
3. **Customize your setup**: Modify configurations using the chezmoi workflow
4. **Explore installed tools**: Try out lazygit, yazi, neovim, and other TUI applications
5. **Read additional documentation**:
   - [CHEZMOI.md](./CHEZMOI.md) - How to modify configurations
   - [README.md](./README.md) - Repository overview
   - Tool-specific READMEs in `~/.config/<tool>/`

## Related Documentation

- [CHEZMOI.md](./CHEZMOI.md) - Chezmoi workflow guide for making configuration changes
- [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) - Comprehensive troubleshooting reference
- [README.md](./README.md) - Repository overview and quick reference
- [docs/KEYMAPS.md](./docs/KEYMAPS.md) - Unified keyboard shortcuts reference
- [docs/ARCHITECTURE.md](./docs/ARCHITECTURE.md) - System architecture and design
- [docs/workflows/](./docs/workflows/) - Workflow guides for common tasks

## Notes

- **Installation time varies**: Depending on internet speed and hardware, installation can take 30-90 minutes
- **Homebrew installs many packages**: The Brewfile contains 100+ packages for a complete development environment
- **Permissions are critical**: Without proper accessibility permissions, yabai and skhd won't function
- **SSH vs local setup**: The installation scripts detect SSH connections and skip GUI-related tools on remote machines
- **Backup existing configs**: If you have existing configurations, chezmoi creates backups before overwriting
- **Keep dotfiles updated**: Regularly run `chezmoi update` to pull the latest configurations
