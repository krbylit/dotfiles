# New Machine Setup

## Purpose

This workflow guides you through setting up your dotfiles on an additional machine (your second, third, or nth machine). Unlike the initial installation documented in [INSTALL.md](../../INSTALL.md), this guide assumes you already have a working dotfiles repository and focuses on the streamlined process for additional machines.

**Target setup time**: Under 30 minutes for experienced users

**Use this guide when**:

- Setting up dotfiles on a new work laptop
- Configuring a remote SSH server
- Replacing/rebuilding an existing machine
- Testing your dotfiles setup on a fresh system

## Prerequisites

Before starting, ensure you have:

- [ ] **Git access configured**: SSH keys or personal access token for GitHub
- [ ] **Administrator access**: Ability to use `sudo` for system-level installations
- [ ] **Stable internet connection**: Required for downloading packages and repositories
- [ ] **Your dotfiles repository URL**: `git@github.com:username/dotfiles.git` (or HTTPS alternative)
- [ ] **GPG passphrase**: The passphrase you configured during initial setup
- [ ] **Secrets repository access** (optional): SSH key or PAT if using a secrets submodule

## Quick Setup (One-Line Installation)

For experienced users who have set this up before:

```bash
# Install chezmoi and apply dotfiles in one command
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply git@github.com:krbylit/dotfiles.git
```

This command:

1. Downloads and installs chezmoi
2. Clones your dotfiles repository
3. Prompts for required configuration (secrets repo URL, GPG passphrase)
4. Applies all configurations
5. Runs automated setup scripts

**Expected duration**: 20-30 minutes (mostly waiting for package installations)

For first-time additional machine setup or if you want more control, follow the step-by-step procedure below.

## Step-by-Step Procedure

### Step 1: Configure Git Authentication

Before cloning your dotfiles, set up Git authentication so chezmoi can access your private repository.

#### Option A: SSH Key (Recommended)

```bash
# Generate a new SSH key
ssh-keygen -t ed25519 -C "your-email@example.com"

# Start SSH agent
eval "$(ssh-agent -s)"

# Add SSH key to agent
ssh-add ~/.ssh/id_ed25519

# Copy public key to clipboard (macOS)
pbcopy < ~/.ssh/id_ed25519.pub

# Copy public key to clipboard (Linux with xclip)
cat ~/.ssh/id_ed25519.pub | xclip -selection clipboard
```

**Add to GitHub**:

1. Go to [GitHub Settings > SSH and GPG keys](https://github.com/settings/keys)
2. Click "New SSH key"
3. Paste your public key
4. Save

**Verify connection**:

```bash
ssh -T git@github.com
```

**Expected result**: `Hi username! You've successfully authenticated...`

#### Option B: Personal Access Token (Alternative)

```bash
# Generate a PAT at GitHub Settings > Developer settings > Personal access tokens
# Store it securely in 1Password or your password manager

# Configure Git to use HTTPS with credential helper
git config --global credential.helper osxkeychain  # macOS
git config --global credential.helper cache        # Linux
```

**Note**: SSH is preferred for dotfiles repositories as it's more secure and convenient.

### Step 2: Install Chezmoi

Install chezmoi first to manage the dotfiles setup process.

```bash
# macOS (if Homebrew is already installed)
brew install chezmoi

# macOS (without Homebrew - installs to ~/.local/bin)
sh -c "$(curl -fsLS get.chezmoi.io)"

# Linux (installs to ~/.local/bin)
sh -c "$(curl -fsLS get.chezmoi.io)"
```

**Verify installation**:

```bash
chezmoi --version
```

**Expected result**: Version information (e.g., `chezmoi version 2.x.x`)

**Add to PATH** (if using standalone installation):

```bash
# For Fish shell
fish_add_path ~/.local/bin

# For Bash/Zsh
export PATH="$HOME/.local/bin:$PATH"
```

### Step 3: Initialize Chezmoi with Your Repository

Clone your dotfiles repository to chezmoi's source directory.

```bash
# Initialize with SSH URL (recommended)
chezmoi init git@github.com:krbylit/dotfiles.git

# Initialize with HTTPS URL (alternative)
chezmoi init https://github.com/krbylit/dotfiles.git
```

**During initialization**, you'll be prompted for:

1. **Secrets repository URL** (optional):

   ```
   Prompt: "Enter `git@github.com` URL to optional repo containing dotfile secrets"
   Input: git@github.com:username/dotfiles-secrets.git
   ```

   - Press Enter to skip if you don't have a secrets repository
   - Enter the SSH/HTTPS URL if you have one

2. **GPG passphrase**:

   ```
   Prompt: "passphrase"
   Input: [your-passphrase-here]
   ```

   - Use the same passphrase you configured during initial setup
   - This is required for decrypting encrypted files

**Expected result**: Repository cloned to `~/.local/share/chezmoi`

**Verification**:

```bash
ls ~/.local/share/chezmoi
```

You should see your dotfiles directory structure.

### Step 4: Preview Changes

Before applying any configurations, review what will be modified on this machine.

```bash
# Show all files that will be created/modified
chezmoi diff

# Perform a dry run to see detailed changes
chezmoi apply --dry-run --verbose

# Count how many files will be managed
chezmoi managed | wc -l
```

**Review the output carefully**:

- Check that no existing configurations will be overwritten unexpectedly
- Verify that machine-specific templates will apply correctly
- Look for any errors or warnings in the diff output

**Expected result**: A comprehensive diff showing all files that will be created or modified

**Common files to note**:

- Shell configs: `~/.config/fish/config.fish`
- Editor: `~/.config/nvim/`
- Git: `~/.gitconfig`
- Window manager: `~/.config/yabai/`, `~/.config/skhd/`
- And many more tool configurations

### Step 5: Apply Dotfiles

Apply all configurations to your system.

```bash
# Apply all dotfiles and run setup scripts
chezmoi apply

# Alternative: Apply with verbose output to monitor progress
chezmoi apply --verbose
```

**What happens during apply**:

1. **Configuration files are created**: Dotfiles are copied to their target locations
2. **Templates are processed**: Machine-specific values are substituted
3. **Encrypted files are decrypted**: GPG decryption happens automatically
4. **Automated scripts run** (in this order):
   - Secrets submodule initialization (if configured)
   - Homebrew installation and `brew bundle`
   - Additional tools installation (Rust, Nix, npm/cargo/go packages)
   - Python tools via uv
   - macOS system settings
   - Fish shell setup

**Expected duration**: 15-30 minutes (mostly Homebrew package installation)

**Expected result**: All configurations applied, packages installed, scripts completed

### Step 6: Handle Machine-Specific Configurations

If this machine requires different settings than your primary machine, use chezmoi's machine-specific configuration features.

#### Method 1: Environment-Based Conditionals

Chezmoi automatically detects:

- Hostname: `.chezmoi.hostname`
- OS: `.chezmoi.os` (darwin, linux)
- Architecture: `.chezmoi.arch` (amd64, arm64)
- SSH connection: Environment variables

**Example in a template file** (`.config/fish/config.fish.tmpl`):

```fish
# Work machine specific settings
{{ if eq .chezmoi.hostname "work-laptop" }}
set -gx WORK_EMAIL "you@company.com"
set -gx WORK_DIR "$HOME/work"
{{ end }}

# Personal machine specific settings
{{ if eq .chezmoi.hostname "personal-mac" }}
set -gx PERSONAL_EMAIL "you@personal.com"
{{ end }}

# SSH vs local detection
{{ if or (env "SSH_CONNECTION") (env "SSH_CLIENT") }}
# Minimal setup for SSH connections
{{ else }}
# Full GUI setup for local machines
{{ end }}
```

#### Method 2: Machine-Specific Data Files

Create machine-specific configuration in `.chezmoidata/`:

```bash
# On the new machine, navigate to chezmoi source
chezmoi cd

# Create a machine-specific data file
cat > .chezmoidata/$(hostname).yaml <<EOF
email: "work@example.com"
git_signing_key: "ABC123DEF456"
custom_paths:
  - "/opt/work/bin"
  - "/usr/local/custom/bin"
EOF

# Commit the machine-specific data
git add .chezmoidata/$(hostname).yaml
git commit -m "feat: add machine-specific config for $(hostname)"
git push
```

**Use in templates**:

```toml
# .gitconfig.tmpl
[user]
    name = "Your Name"
    email = {{ .email | quote }}
{{ if .git_signing_key }}
    signingkey = {{ .git_signing_key | quote }}
{{ end }}
```

#### Method 3: Interactive Prompts

Add prompts to `.chezmoi.toml.tmpl` for one-time configuration:

```toml
{{ $email := promptString "email" "Enter your email for this machine" -}}
{{ $useWorkConfig := promptBool "useWorkConfig" "Is this a work machine" -}}

[data]
    email = {{ $email | quote }}
    useWorkConfig = {{ $useWorkConfig }}
```

These values are stored in `~/.config/chezmoi/chezmoi.toml` and persist across applies.

### Step 7: Set Fish as Default Shell

Change your default shell to Fish.

```bash
# Add Fish to allowed shells
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells

# Set as default shell
chsh -s /opt/homebrew/bin/fish

# Verify
echo $SHELL
```

**Expected result**: `/opt/homebrew/bin/fish`

**Note**: You may need to log out and log back in for the change to take effect fully.

### Step 8: Configure System Permissions

Grant required permissions for macOS-specific tools.

#### Yabai (Window Manager)

```bash
# Start yabai service (triggers permission prompts)
yabai --start-service

# Or grant manually via System Settings
# System Settings > Privacy & Security > Accessibility
# Add: /opt/homebrew/bin/yabai
```

#### Skhd (Hotkey Daemon)

```bash
# Start skhd service (triggers permission prompts)
skhd --start-service

# Or grant manually via System Settings
# System Settings > Privacy & Security > Accessibility
# Add: /opt/homebrew/bin/skhd
```

#### Karabiner Elements (Keyboard Customization)

```bash
# Open Karabiner Elements (auto-starts after installation)
open -a "Karabiner-Elements"

# Follow the setup wizard to grant:
# - Input Monitoring permission
# - Accessibility permission
```

#### Start Services

```bash
# Start window management services
brew services start yabai
brew services start skhd

# Verify services are running
brew services list
```

**Expected result**: `yabai` and `skhd` show status as `started`

### Step 9: Set Up Secrets (If Applicable)

If you're using a secrets submodule or encrypted files, ensure they're configured correctly.

#### Verify Secrets Submodule

```bash
# Check submodule status
cd ~/.local/share/chezmoi
git submodule status

# If submodule is not initialized (shows `-` prefix)
git submodule init
git submodule update --remote
```

**Expected result**: Secrets directory populated with files from your private repository

#### Verify GPG Decryption

```bash
# Test decryption of an encrypted file
chezmoi cat ~/.config/service/encrypted-file.conf

# If you see errors, verify your passphrase in chezmoi config
chezmoi edit-config
```

**Expected result**: File contents are decrypted and displayed correctly

#### Configure 1Password (Optional)

If using 1Password integration:

```bash
# Set service account token
set -Ux OP_SERVICE_ACCOUNT_TOKEN "ops_your_token_here"  # Fish
export OP_SERVICE_ACCOUNT_TOKEN="ops_your_token_here"   # Bash/Zsh

# Verify authentication
op account list

# Test secret retrieval
chezmoi execute-template '{{ onepasswordRead "op://Private/TestItem/password" }}'
```

See [secrets-management.md](./secrets-management.md) for detailed secrets workflows.

### Step 10: Verify Setup

Run through this checklist to ensure everything is configured correctly.

#### Shell Environment

```bash
# Open a new Fish shell
fish

# Verify Fish version
fish --version

# Test a custom function
lg  # Should open lazygit

# Verify Starship prompt appears
# (You should see a customized prompt with git information)
```

#### Development Tools

```bash
# Verify formatters are installed
stylua --version
fish_indent --version
shfmt --version
prettier --version
yapf --version
```

#### Window Management

```bash
# Check yabai is running
yabai -m query --windows

# Test window tiling (open multiple apps and verify behavior)
open -a Safari
open -a Terminal
# Windows should tile automatically
```

#### Text Editor

```bash
# Open Neovim and check health
nvim
:checkhealth

# Verify plugins are installed
:Lazy

# Exit
:q
```

#### Git Configuration

```bash
# Verify git identity
git config --get user.name
git config --get user.email

# Test an alias
git st  # Should run 'git status'
```

#### Pre-commit Hooks

```bash
# Verify pre-commit hooks are active
cd ~/.local/share/chezmoi
pre-commit run --all-files
```

**Expected result**: All checks pass (or show known exceptions)

## SSH vs Local Setup Differences

The dotfiles repository automatically detects SSH connections and adjusts the setup accordingly.

### Detection Method

Scripts check for these environment variables:

- `SSH_CONNECTION`
- `SSH_CLIENT`
- `SSH_TTY`
- `IS_SSH` (manually set)

### Installation Differences

| Component          | Local Machine                | Remote SSH Machine       |
| ------------------ | ---------------------------- | ------------------------ |
| **Brewfile**       | Full `~/Brewfile`            | Minimal `~/Brewfile_ssh` |
| **GUI Apps**       | Hammerspoon, Cursor, Ghostty | Skipped                  |
| **CLI Tools**      | All installed                | All installed            |
| **Secrets**        | Submodule initialized        | Skipped                  |
| **Git Hooks**      | Pre-commit installed         | Skipped                  |
| **Window Manager** | Yabai, skhd started          | Skipped                  |
| **macOS Settings** | Applied                      | Applied (if macOS)       |

### Force SSH Mode Locally (Testing)

```bash
# Test SSH mode on a local machine
export IS_SSH=1
chezmoi apply
```

## Common First-Time Tasks

After initial setup, you may need to complete these tasks manually:

### 1. SSH Keys for Git/GitHub

```bash
# Generate SSH key for this machine
ssh-keygen -t ed25519 -C "your-email@example.com"

# Add to SSH agent
ssh-add ~/.ssh/id_ed25519

# Copy public key
cat ~/.ssh/id_ed25519.pub

# Add to GitHub/GitLab SSH keys
```

### 2. GPG Keys for Commit Signing

```bash
# List existing GPG keys
gpg --list-secret-keys --keyid-format=long

# Generate a new GPG key (if needed)
gpg --full-generate-key

# Configure Git to use GPG key
git config --global user.signingkey YOUR_KEY_ID
git config --global commit.gpgsign true
```

### 3. Application-Specific Logins

Some applications require manual authentication:

- **GitHub CLI**: `gh auth login`
- **1Password**: Sign in to your account
- **Docker**: Sign in to Docker Desktop
- **Atuin**: `atuin login` (for shell history sync)
- **Cloud CLIs**: `aws configure`, `gcloud auth login`, etc.

### 4. Install Manual Dependencies

Some tools aren't installed automatically:

```bash
# Docker Desktop
# Download from https://www.docker.com/products/docker-desktop

# YabaiIndicator (menu bar status)
# Download from https://github.com/xiamaz/YabaiIndicator

# Firefox Extensions (if using Firefox)
# - Sidebery: https://addons.mozilla.org/firefox/addon/sidebery/
# - Vimium: https://addons.mozilla.org/firefox/addon/vimium-ff/
# - Firenvim: https://addons.mozilla.org/firefox/addon/firenvim/
```

### 5. Configure Browser Profiles

- Import bookmarks and extensions
- Sign in to sync accounts (Firefox Sync, Chrome Sync)
- Configure browser-specific settings not in dotfiles

## Troubleshooting

### Problem: Chezmoi init fails to clone repository

**Symptoms**:

- `Permission denied (publickey)` error
- `Authentication failed` error
- Repository not found

**Solution**:

1. Verify SSH key is configured:

   ```bash
   ssh -T git@github.com
   ```

2. If SSH fails, use HTTPS URL:

   ```bash
   chezmoi init https://github.com/username/dotfiles.git
   ```

3. Check repository URL is correct:

   ```bash
   # Should match your actual repository
   git ls-remote git@github.com:username/dotfiles.git
   ```

4. Ensure SSH key is added to ssh-agent:

   ```bash
   ssh-add -l  # List loaded keys
   ssh-add ~/.ssh/id_ed25519  # Add your key
   ```

### Problem: Wrong GPG passphrase entered during init

**Symptoms**:

- Cannot decrypt encrypted files
- `gpg: decryption failed: Bad session key` errors

**Solution**:

1. Re-initialize with correct passphrase:

   ```bash
   chezmoi init --force git@github.com:username/dotfiles.git
   ```

2. Or manually edit the config:

   ```bash
   chezmoi edit-config

   # Update both locations:
   [data]
       passphrase = "correct-passphrase"

   [gpg]
       args = ["--batch", "--passphrase", "correct-passphrase", "--no-symkey-cache"]
   ```

3. Re-apply dotfiles:

   ```bash
   chezmoi apply
   ```

### Problem: Homebrew installation takes forever

**Symptoms**:

- `brew bundle` hangs or runs very slowly
- Installation of packages appears stuck

**Solution**:

1. Check internet connection and speed

2. Run brew bundle manually to see detailed progress:

   ```bash
   brew bundle --file=~/Brewfile --verbose
   ```

3. Skip problematic packages temporarily:

   ```bash
   # Edit Brewfile to comment out slow packages
   chezmoi edit ~/Brewfile

   # Re-run brew bundle
   brew bundle --file=~/Brewfile
   ```

4. Update Homebrew before running bundle:

   ```bash
   brew update
   brew upgrade
   brew bundle --file=~/Brewfile
   ```

### Problem: Scripts don't run during apply

**Symptoms**:

- Homebrew not installed after `chezmoi apply`
- Setup scripts appear to be skipped
- Expected tools missing

**Solution**:

1. Verify scripts are executable:

   ```bash
   ls -la ~/.local/share/chezmoi/.chezmoiscripts/
   ```

2. Run scripts manually:

   ```bash
   bash ~/.local/share/chezmoi/.chezmoiscripts/run_once_after_1-install-homebrew.sh
   ```

3. Check for script errors:

   ```bash
   chezmoi apply --verbose 2>&1 | grep -i error
   ```

4. Reset script state to force re-run:

   ```bash
   rm ~/.local/share/chezmoi/chezmoistate.boltdb
   chezmoi apply
   ```

### Problem: Secrets submodule not initializing

**Symptoms**:

- `secrets/` directory is empty
- Submodule shows as uninitialized

**Solution**:

1. Verify you have access to secrets repository:

   ```bash
   git ls-remote git@github.com:username/dotfiles-secrets.git
   ```

2. Manually initialize submodule:

   ```bash
   cd ~/.local/share/chezmoi
   git submodule init
   git submodule update --remote
   ```

3. Check `.gitmodules` file exists and has correct URL:

   ```bash
   cat ~/.local/share/chezmoi/.gitmodules
   ```

4. If URL is wrong, re-run init with correct secrets repo URL:

   ```bash
   chezmoi init --force git@github.com:username/dotfiles.git
   ```

### Problem: Permission errors on macOS

**Symptoms**:

- Yabai or skhd don't work
- Karabiner doesn't respond to key mappings
- "Accessibility permission required" errors

**Solution**:

1. Grant permissions via System Settings:
   - Open System Settings > Privacy & Security > Accessibility
   - Click lock to make changes
   - Add `/opt/homebrew/bin/yabai` and `/opt/homebrew/bin/skhd`
   - Ensure checkboxes are enabled

2. Restart services after granting permissions:

   ```bash
   brew services restart yabai
   brew services restart skhd
   ```

3. For Karabiner, open the app to trigger permission prompts:

   ```bash
   open -a "Karabiner-Elements"
   ```

4. Check service logs for errors:

   ```bash
   tail -f /opt/homebrew/var/log/yabai/yabai.err.log
   tail -f /opt/homebrew/var/log/skhd/skhd.err.log
   ```

## Syncing with Other Machines

Once you have multiple machines set up, keep them synchronized:

### Pull Latest Changes

```bash
# Update dotfiles and apply changes
chezmoi update

# Or do it manually for more control:
chezmoi git pull
chezmoi diff      # Preview changes
chezmoi apply     # Apply changes
```

### Push Changes from This Machine

```bash
# Navigate to chezmoi source
chezmoi cd

# Make changes and commit
git add .
git commit -m "feat: add new configuration"
git push

# Return to previous directory
exit
```

### Automatic Sync Workflow

For detailed multi-machine synchronization workflows, see [multi-machine-sync.md](./multi-machine-sync.md) .

## Verification Checklist

After completing setup, verify everything works:

- [ ] Fish shell loads without errors
- [ ] Starship prompt appears with git information
- [ ] Custom Fish functions are available (`functions` command)
- [ ] Neovim opens without errors (`:checkhealth` passes)
- [ ] Git is configured with correct identity
- [ ] Window management works (yabai tiles windows)
- [ ] Hotkeys respond (skhd keybindings work)
- [ ] Keyboard customizations active (Karabiner mappings)
- [ ] Pre-commit hooks installed (`pre-commit run --all-files`)
- [ ] Encrypted files decrypt correctly
- [ ] All services running (`brew services list`)
- [ ] No errors in `chezmoi verify`

**Quick verification command**:

```bash
# Verify all files match source state
chezmoi verify
```

## Next Steps

After successful setup:

1. **Restart your computer**: Ensures all services and permissions are fully active

2. **Learn keyboard shortcuts**: Review `.config/skhd/skhdrc` for window management hotkeys

3. **Explore installed tools**: Try lazygit, yazi, neovim, and other TUI applications

4. **Customize for this machine**: Add machine-specific configurations as needed

5. **Read additional documentation**:
   - [configuration-changes.md](./configuration-changes.md) - How to modify configurations safely
   - [secrets-management.md](./secrets-management.md) - Managing secrets and encryption
   - [multi-machine-sync.md](./multi-machine-sync.md) - Keeping machines synchronized

## Related Documentation

- [INSTALL.md](../../INSTALL.md) - Initial installation guide (first-time setup)
- [README.md](../../README.md) - Repository overview and quick reference
- [configuration-changes.md](./configuration-changes.md) - Making safe configuration changes
- [secrets-management.md](./secrets-management.md) - Managing secrets across machines
- [multi-machine-sync.md](./multi-machine-sync.md) - Multi-machine synchronization
- [Chezmoi Official Docs](https://www.chezmoi.io/) - Comprehensive chezmoi documentation

## Notes

- **Setup is idempotent**: Running `chezmoi apply` multiple times is safe and won't break your configuration
- **SSH detection is automatic**: The setup scripts detect SSH connections and adjust installations accordingly
- **Secrets stay on local machines**: Secrets submodule is only initialized on local machines for security
- **Machine-specific configs are powerful**: Use templates to customize per-machine without maintaining separate branches
- **Homebrew is the slowest step**: Package installation takes 15-30 minutes; be patient
- **Permissions are critical on macOS**: Without accessibility permissions, yabai and skhd won't function
- **Keep dotfiles updated regularly**: Run `chezmoi update` weekly to pull latest configurations
- **Test risky changes on non-critical machines first**: Apply experimental configs to your least important machine before syncing to all
