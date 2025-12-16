# Troubleshooting Guide

## Overview

This guide provides diagnostic steps and solutions for common issues in this dotfiles repository. Use the **Quick Diagnostic Commands** section to gather information, then find your issue in the problem categories below.

## Table of Contents

1. [Quick Diagnostic Commands](#quick-diagnostic-commands)
2. [System Permissions](#system-permissions)
3. [Pre-commit Hooks and Gitleaks](#pre-commit-hooks-and-gitleaks)
4. [Neovim LSP Issues](#neovim-lsp-issues)
5. [Chezmoi Apply Conflicts](#chezmoi-apply-conflicts)
6. [GitHub Actions Sync Failures](#github-actions-sync-failures)
7. [Shell and Terminal Issues](#shell-and-terminal-issues)
8. [Tool-Specific Issues](#tool-specific-issues)
9. [Related Documentation](#related-documentation)

---

## Quick Diagnostic Commands

Run these commands to gather information about your system state:

```bash
# Check chezmoi configuration
chezmoi doctor

# Check managed files status
chezmoi status

# View pending changes
chezmoi diff

# Check Homebrew services
brew services list

# Check yabai and skhd status
yabai -m query --windows 2>&1 | head -5
ps aux | grep -E "yabai|skhd" | grep -v grep

# Check Fish shell version
fish --version

# Check Neovim health
nvim +checkhealth +qa

# Check pre-commit hooks
cd ~/.local/share/chezmoi && pre-commit run --all-files

# Check GitHub Actions status (if you have gh CLI)
gh workflow list

# Check for chezmoi template errors
chezmoi execute-template "{{ .chezmoi.hostname }}"
```

---

## System Permissions

### Yabai Not Working

**Symptoms:**

- Windows don't tile automatically
- `yabai -m query --windows` returns errors
- Service shows as "error" in `brew services list`
- Error: "cannot establish connection to the accessibility API"

**Cause:**

- Missing Accessibility permissions
- System Integrity Protection (SIP) blocking yabai features
- Configuration errors in `yabairc`

**Solution:**

**Step 1: Grant Accessibility Permissions**

```bash
# Stop yabai service
brew services stop yabai

# Grant permissions via System Settings
open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"

# In System Settings:
# 1. Click the lock icon and authenticate
# 2. Click '+' button
# 3. Navigate to /opt/homebrew/bin/yabai
# 4. Add it to the list
# 5. Ensure checkbox is checked

# Start yabai service
brew services start yabai

# Verify it's running
brew services list | grep yabai
```

**Step 2: Check Log Files**

```bash
# View yabai error log
tail -f /opt/homebrew/var/log/yabai/yabai.err.log

# View yabai stdout log
tail -f /opt/homebrew/var/log/yabai/yabai.out.log

# Common errors and their meanings:
# - "connection failed" → Accessibility permission needed
# - "scripting addition" → SIP needs configuration
# - "invalid config" → Syntax error in yabairc
```

**Step 3: Validate Configuration**

```bash
# Test yabairc for syntax errors
yabai --validate-config

# Reload yabai configuration
yabai --restart-service

# Check if yabai can communicate
yabai -m query --windows
```

**Step 4: Advanced Features (Optional)**

For advanced yabai features (window focus, opacity changes, etc.), SIP must be partially disabled:

```bash
# Check SIP status
csrutil status

# To disable SIP (CAUTION: reduces security):
# 1. Restart Mac in Recovery Mode (hold Cmd+R during boot)
# 2. Open Terminal from Utilities menu
# 3. Run: csrutil disable
# 4. Restart Mac

# To enable scripting addition after SIP is configured:
sudo yabai --load-sa
yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
```

**Reference:**

- [yabairc configuration](./dot_config/yabai/executable_yabairc)
- [Yabai README](./dot_config/yabai/README.md)
- [Official yabai wiki](https://github.com/koekeishiya/yabai/wiki)

---

### Skhd Not Responding to Hotkeys

**Symptoms:**

- Keyboard shortcuts don't work
- No response when pressing configured hotkeys
- Service shows as "error" in `brew services list`
- Error: "failed to open connection"

**Cause:**

- Missing Accessibility permissions
- Conflicting hotkeys with system or other apps
- Configuration syntax errors in `skhdrc`

**Solution:**

**Step 1: Grant Accessibility Permissions**

```bash
# Stop skhd service
brew services stop skhd

# Grant permissions via System Settings
open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"

# In System Settings:
# 1. Click the lock icon and authenticate
# 2. Click '+' button
# 3. Navigate to /opt/homebrew/bin/skhd
# 4. Add it to the list
# 5. Ensure checkbox is checked

# Start skhd service
brew services start skhd

# Verify it's running
brew services list | grep skhd
```

**Step 2: Check for Hotkey Conflicts**

```bash
# Test a simple hotkey manually
# Add this temporarily to skhdrc:
# cmd - return : open -a Ghostty

# Reload skhd
skhd --reload

# Try pressing Cmd+Return

# Check skhd logs
tail -f /opt/homebrew/var/log/skhd/skhd.err.log
```

**Step 3: Validate Configuration Syntax**

```bash
# Check skhdrc syntax
cat ~/.config/skhd/skhdrc | grep -E "^[^#]" | head -20

# Common syntax errors:
# - Missing space before ':'
# - Invalid modifier keys
# - Incorrect command syntax

# Test configuration by reloading
skhd --reload
```

**Step 4: Debug Specific Hotkeys**

```bash
# Enable verbose logging (add to skhdrc)
echo ".load \"~/.config/skhd/skhd.conf\"" | skhd --reload

# Watch logs while testing
tail -f /opt/homebrew/var/log/skhd/skhd.err.log

# Test each hotkey one by one
# Comment out all hotkeys except one, then reload
```

**Reference:**

- [skhdrc configuration](./dot_config/skhd/skhdrc)
- [Skhd README](./dot_config/skhd/README.md)
- [Official skhd documentation](https://github.com/koekeishiya/skhd)

---

### Karabiner Elements Not Remapping Keys

**Symptoms:**

- Keyboard remappings don't work
- Karabiner Elements shows "Not connected" status
- Key presses aren't captured

**Cause:**

- Missing Input Monitoring permission
- Missing Accessibility permission
- Karabiner kernel extension not loaded
- Configuration errors in `karabiner.json`

**Solution:**

**Step 1: Grant Required Permissions**

```bash
# Open Karabiner Elements
open -a "Karabiner-Elements"

# Karabiner will prompt for permissions
# Grant the following in System Settings:
# 1. Input Monitoring
# 2. Accessibility

# Manually open System Settings if needed:
open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
open "x-apple.systempreferences:com.apple.preference.security?Privacy_ListenEvent"
```

**Step 2: Verify Kernel Extension**

```bash
# Check if Karabiner driver is loaded
kextstat | grep Karabiner

# If not loaded, restart Karabiner
killall Karabiner-Elements
open -a "Karabiner-Elements"

# Restart Mac if issue persists
```

**Step 3: Validate Configuration**

```bash
# Check karabiner.json syntax
# Configuration is symlinked to cm-util/ctrld-configs/karabiner/karabiner.json
cat ~/.config/karabiner/karabiner.json | jq . > /dev/null

# If jq command succeeds, JSON is valid
# If it fails, there's a syntax error

# Check Karabiner EventViewer to see if keys are being captured
open "karabiner://karabiner/assets/event_viewer"
```

**Step 4: Reset Configuration (if needed)**

```bash
# Backup current config
cp ~/.config/karabiner/karabiner.json ~/.config/karabiner/karabiner.json.backup

# Remove symlink and test with default config
rm ~/.config/karabiner/karabiner.json
open -a "Karabiner-Elements"

# If this works, issue is in your configuration
# Restore and debug:
chezmoi apply ~/.config/karabiner/karabiner.json
```

**Reference:**

- [karabiner.json configuration](./cm-util/ctrld-configs/karabiner/karabiner.json)
- [Karabiner README](./dot_config/karabiner/README.md)
- [Official Karabiner documentation](https://karabiner-elements.pqrs.org/)

---

## Pre-commit Hooks and Gitleaks

### Pre-commit Hook Fails on Every Commit

**Symptoms:**

- `git commit` fails with gitleaks errors
- Error: "gitleaks has detected secret in your changes"
- Pre-commit hook blocks all commits

**Cause:**

- Actual secrets detected in staged files
- False positives from gitleaks
- Pre-commit configuration issues

**Solution:**

**Step 1: Identify What Gitleaks Detected**

```bash
# Run gitleaks manually to see detections
cd ~/.local/share/chezmoi
gitleaks detect --verbose --no-git

# Run only on staged files
gitleaks protect --verbose --staged

# View detailed report
gitleaks detect --report-path gitleaks-report.json
cat gitleaks-report.json | jq .
```

**Step 2: Handle False Positives**

If gitleaks detects non-sensitive data as secrets:

```bash
# Add to .gitleaksignore
cd ~/.local/share/chezmoi

# Format: filepath:rule-id:line-number or just filepath
echo "path/to/file.txt:generic-api-key:42" >> .gitleaksignore

# Example entries in repository:
cat .gitleaksignore
# .chezmoi.toml.tmpl:generic-api-key
# private.bashrc.tmpl:generic-api-key
```

**Step 3: Handle Real Secrets**

If gitleaks found actual secrets:

```bash
# DO NOT commit the secrets to main repository
# Move them to secrets submodule:

cd ~/.local/share/chezmoi

# Move file to secrets/
mv dot_config/tool/config.yaml secrets/dot_config/tool/private_config.yaml

# Create a symlink or include statement
# See CHEZMOI.md for secrets management workflow

# Or encrypt with chezmoi:
chezmoi add --encrypt ~/.config/tool/config.yaml
```

**Step 4: Fix Pre-commit Configuration**

```bash
# Verify pre-commit is installed
pre-commit --version

# Install/update hooks
cd ~/.local/share/chezmoi
pre-commit install

# Update pre-commit hooks
pre-commit autoupdate

# Test hooks manually
pre-commit run --all-files
```

**Step 5: Bypass Pre-commit (Emergency Only)**

```bash
# Skip pre-commit hooks (NOT RECOMMENDED)
git commit --no-verify -m "emergency commit"

# Better: Fix the issue and commit properly
```

**Reference:**

- [.pre-commit-config.yaml](./.pre-commit-config.yaml)
- [.gitleaksignore](./.gitleaksignore)
- [Gitleaks documentation](https://github.com/gitleaks/gitleaks)

---

### Gitleaks Scan Takes Too Long

**Symptoms:**

- Pre-commit hook hangs for minutes
- `git commit` extremely slow
- Gitleaks scanning entire git history

**Cause:**

- Gitleaks scanning full repository history
- Large repository with many commits
- Pre-commit running on all files instead of staged

**Solution:**

**Step 1: Use Protect Mode for Commits**

```bash
# Gitleaks has two modes:
# - detect: Scans entire repo and history (slow)
# - protect: Scans only staged changes (fast)

# Verify .pre-commit-config.yaml uses protect mode
cat .pre-commit-config.yaml
# Should have: args: ['protect', '--verbose', '--staged']
```

**Step 2: Skip Full Repository Scans**

```bash
# Don't run gitleaks on all files
pre-commit run --files <specific-file>

# For full scan (occasionally):
pre-commit run --all-files --hook-stage manual
```

**Step 3: Optimize Gitleaks Configuration**

```bash
# Create or update .gitleaks.toml to exclude paths
cat > ~/.local/share/chezmoi/.gitleaks.toml << 'EOF'
[allowlist]
paths = [
    # Exclude paths that don't need scanning
    '''node_modules/''',
    '''vendor/''',
    '''.git/''',
]
EOF

# Commit the optimization
cd ~/.local/share/chezmoi
git add .gitleaks.toml
git commit -m "chore: optimize gitleaks configuration"
```

**Reference:**

- [Pre-commit hooks documentation](https://pre-commit.com/)
- [Gitleaks configuration](https://github.com/gitleaks/gitleaks#configuration)

---

## Neovim LSP Issues

### LSP Not Starting for File Type

**Symptoms:**

- No autocompletion in Neovim
- No LSP diagnostics (errors/warnings)
- `:LspInfo` shows "0 client(s) attached to this buffer"
- Error: "LSP server not found"

**Cause:**

- Language server not installed
- Mason not configured for file type
- LSP server not configured in `extend-lspconfig.lua`

**Solution:**

**Step 1: Check LSP Status**

```vim
" Open a file of the problematic type
" Run LSP info
:LspInfo

" Check Mason status
:Mason

" Check LSP logs
:LspLog
```

**Step 2: Install Missing Language Server**

```vim
" Open Mason
:Mason

" Search for language server (e.g., 'pyright' for Python)
/pyright

" Press 'i' to install
" Press 'U' to update all

" Verify installation
:Mason
" Look for green checkmark next to server
```

**Step 3: Verify Server Configuration**

```bash
# Check if server is in ensure_installed list
cd ~/.local/share/chezmoi
grep -n "ensure_installed" dot_config/exact_nvim/lua/plugins/extend-lspconfig.lua

# Add server if missing:
# Edit the file and add to ensure_installed table
chezmoi edit ~/.config/nvim/lua/plugins/extend-lspconfig.lua

# Add to ensure_installed table:
# "pyright",  -- Python
# "lua_ls",   -- Lua
# etc.
```

**Step 4: Restart Neovim LSP**

```vim
" Restart LSP for current buffer
:LspRestart

" Or completely restart Neovim
:qa
nvim
```

**Step 5: Check for Server-Specific Issues**

```bash
# Test language server manually
# For pyright:
pyright --version

# For typescript:
typescript-language-server --version

# If command not found, server isn't in PATH
# Check Mason installation:
ls ~/.local/share/nvim/mason/bin/
```

**Reference:**

- [extend-lspconfig.lua](./dot_config/exact_nvim/lua/plugins/extend-lspconfig.lua)
- [Neovim README](./dot_config/exact_nvim/README.md)
- [Mason documentation](https://github.com/williamboman/mason.nvim)

---

### Neovim Shows Plugin Errors on Startup

**Symptoms:**

- Error messages when opening Neovim
- "Plugin not found" errors
- `:Lazy` shows failed plugins
- Plugins don't load or function incorrectly

**Cause:**

- Plugin installation failed
- Lazy.nvim cache corruption
- Plugin configuration errors
- Missing dependencies

**Solution:**

**Step 1: Check Plugin Status**

```vim
" Open Lazy plugin manager
:Lazy

" Look for:
" - Red 'x' marks (failed plugins)
" - Yellow '!' marks (warnings)
" - Update indicators

" View plugin logs
" Press 'l' on a plugin to see its log
```

**Step 2: Sync Plugins**

```vim
" Update and install all plugins
:Lazy sync

" Or separately:
:Lazy update  " Update existing plugins
:Lazy install " Install missing plugins
:Lazy clean   " Remove unused plugins
```

**Step 3: Run Neovim Health Check**

```vim
" Check overall health
:checkhealth

" Check specific plugin health
:checkhealth lazy
:checkhealth lspconfig
:checkhealth mason

" Address any ERROR items shown
```

**Step 4: Clear Plugin Cache**

```bash
# Exit Neovim
# Remove lazy.nvim cache
rm -rf ~/.local/share/nvim/lazy

# Remove state files
rm -rf ~/.local/state/nvim

# Restart Neovim
nvim

# Lazy will reinstall all plugins
:Lazy sync
```

**Step 5: Check Plugin Configuration**

```bash
# Look for syntax errors in plugin configs
cd ~/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins

# Check for common issues:
# - Missing commas in tables
# - Mismatched brackets
# - Invalid plugin specifications

# Test specific plugin file
nvim lua/plugins/problematic-plugin.lua

# View Neovim startup errors
nvim +checkhealth +qa > nvim-health.txt 2>&1
cat nvim-health.txt
```

**Reference:**

- [Neovim plugin directory](./dot_config/exact_nvim/lua/plugins/)
- [Lazy.nvim documentation](https://github.com/folke/lazy.nvim)

---

### Copilot Not Working in Neovim

**Symptoms:**

- No Copilot suggestions appearing
- `:Copilot status` shows "Not running"
- Error: "Copilot is not set up"

**Cause:**

- Copilot not authenticated
- Node.js not installed or wrong version
- Copilot plugin not loaded

**Solution:**

**Step 1: Authenticate Copilot**

```vim
" Setup Copilot (first time)
:Copilot setup

" Follow browser authentication flow

" Check status
:Copilot status
" Should show: "Copilot is ready"
```

**Step 2: Verify Node.js**

```bash
# Check Node.js version (needs v18+)
node --version

# If not installed or wrong version:
brew install node

# Verify after installation
node --version
```

**Step 3: Restart Copilot**

```vim
" Restart Copilot
:Copilot restart

" Check logs
:Copilot log
```

**Step 4: Check Plugin Configuration**

```bash
# Verify copilot.lua plugin is enabled
cd ~/.local/share/chezmoi/dot_config/exact_nvim/lua/plugins
cat copilot.lua

# Make sure it's not disabled
# (not in _disabled.lua)
```

**Reference:**

- [Copilot.lua plugin configuration](./dot_config/exact_nvim/lua/plugins/copilot.lua)

---

## Chezmoi Apply Conflicts

### Chezmoi Reports Files as Modified But Diff Shows Nothing

**Symptoms:**

- `chezmoi status` shows modified files
- `chezmoi diff` shows no differences or only whitespace
- Files keep appearing as changed

**Cause:**

- Line ending differences (CRLF vs LF)
- File permissions changes
- Template rendering differences
- Git attributes issues

**Solution:**

**Step 1: Verify What Changed**

```bash
# Check detailed diff
chezmoi diff --verbose

# Check specific file
chezmoi diff ~/.config/fish/config.fish

# Check with git diff tool
cd ~/.local/share/chezmoi
git diff --check
```

**Step 2: Fix Line Ending Issues**

```bash
# Check git configuration
git config --get core.autocrlf

# Set to handle line endings automatically
git config core.autocrlf input

# Re-apply files
chezmoi apply --force
```

**Step 3: Check Template Processing**

```bash
# For template files, verify rendering
chezmoi cat ~/.config/tool/config.yaml

# Compare with actual file
diff <(chezmoi cat ~/.config/tool/config.yaml) ~/.config/tool/config.yaml

# Check template data
chezmoi data
```

**Step 4: Force Re-apply**

```bash
# Re-apply specific file
chezmoi apply --force ~/.config/fish/config.fish

# Re-apply everything
chezmoi apply --force

# Verify status
chezmoi status
```

**Reference:**

- [CHEZMOI.md workflow guide](./docs/CHEZMOI.md)

---

### Template Syntax Errors

**Symptoms:**

- `chezmoi apply` fails with template errors
- Error: "template: ...: function 'X' not defined"
- Error: "unexpected '}'" or similar syntax error

**Cause:**

- Invalid Go template syntax
- Missing template data
- Incorrect variable references

**Solution:**

**Step 1: Identify Problem Template**

```bash
# Apply with verbose output
chezmoi apply --verbose

# Error will show which template file failed
# Example: "template: dot_config/file.yaml.tmpl:10:5: ..."
```

**Step 2: Test Template Rendering**

```bash
# Test specific template
chezmoi cat ~/.config/tool/config.yaml

# Execute template directly
cat ~/.local/share/chezmoi/dot_config/tool/config.yaml.tmpl | \
  chezmoi execute-template

# Check available template data
chezmoi data
```

**Step 3: Common Template Syntax Fixes**

```go
# ❌ Wrong: Missing closing brace
{{ .chezmoi.hostname

# ✅ Right:
{{ .chezmoi.hostname }}

# ❌ Wrong: Using = instead of eq
{{ if .chezmoi.hostname = "laptop" }}

# ✅ Right:
{{ if eq .chezmoi.hostname "laptop" }}

# ❌ Wrong: Accessing undefined variable
{{ .nonexistent.variable }}

# ✅ Right: Check existence first
{{ if hasKey . "variable" }}{{ .variable }}{{ end }}

# ❌ Wrong: Missing quote filter for strings
api_key = {{ .api_key }}

# ✅ Right: Use quote filter
api_key = {{ .api_key | quote }}
```

**Step 4: Debug Template Data**

```bash
# Check what data is available
chezmoi data | jq .

# Check specific template variable
chezmoi execute-template "{{ .chezmoi.hostname }}"
chezmoi execute-template "{{ .path.ctrld_configs }}"

# View all chezmoi variables
chezmoi data | jq '.chezmoi'
```

**Reference:**

- [CHEZMOI.md template system section](./docs/CHEZMOI.md#4-template-system)
- [Go template documentation](https://pkg.go.dev/text/template)

---

### Symlink Broken or Points to Wrong Location

**Symptoms:**

- Symlinked file shows as broken
- `ls -la` shows symlink pointing to non-existent path
- Application can't find configuration file

**Cause:**

- Symlink template has incorrect path
- Target file doesn't exist in cm-util/
- Template variables not resolving correctly

**Solution:**

**Step 1: Verify Symlink Status**

```bash
# Check if symlink exists and where it points
ls -la ~/Brewfile
ls -la ~/.config/karabiner/karabiner.json

# Test if symlink target exists
file ~/Brewfile
file ~/.config/karabiner/karabiner.json
```

**Step 2: Check Symlink Template**

```bash
# View symlink template
cat ~/.local/share/chezmoi/symlink_Brewfile.tmpl

# Should contain absolute path like:
# {{ .chezmoi.sourceDir }}{{ .path.ctrld_configs }}/homebrew/Brewfile

# Verify template renders correctly
chezmoi cat ~/Brewfile
```

**Step 3: Verify Target File Exists**

```bash
# Check target file exists
ls -la ~/.local/share/chezmoi/cm-util/ctrld-configs/homebrew/Brewfile

# If missing, create it or fix path
```

**Step 4: Fix and Re-apply Symlink**

```bash
# Edit symlink template
chezmoi edit ~/.local/share/chezmoi/symlink_Brewfile.tmpl

# Correct format:
# {{ .chezmoi.sourceDir }}{{ .path.ctrld_configs }}/path/to/file

# Remove broken symlink
rm ~/Brewfile

# Re-apply
chezmoi apply ~/Brewfile

# Verify
ls -la ~/Brewfile
file ~/Brewfile
```

**Reference:**

- [CHEZMOI.md symlink strategy](./docs/CHEZMOI.md#5-cm-util-symlink-strategy)
- [.chezmoidata/constants.toml](./.chezmoidata/constants.toml)

---

## GitHub Actions Sync Failures

### Daily Sync Workflow Fails

**Symptoms:**

- GitHub Actions workflow shows failed status
- Email notification about workflow failure
- Public repository out of sync with private repository

**Cause:**

- Merge conflicts between repositories
- Missing secrets in GitHub Actions
- Changed file paths or structure
- Git authentication issues

**Solution:**

**Step 1: Check Workflow Status**

```bash
# View workflow runs
gh workflow list

# View specific run details
gh run list --workflow="daily_sync_main.yaml"

# View logs of failed run
gh run view <run-id> --log
```

**Step 2: Check for Merge Conflicts**

```bash
# Clone and check both repositories
cd /tmp
git clone git@github.com:your-org/dotfiles-private.git
git clone git@github.com:your-org/dotfiles-public.git

cd dotfiles-private
git pull
git log --oneline -5

cd ../dotfiles-public
git pull
git log --oneline -5

# Check for divergence
git log --oneline --graph --all
```

**Step 3: Verify GitHub Secrets**

```bash
# List repository secrets (requires admin access)
gh secret list

# Required secrets:
# - PERSONAL_ACCESS_TOKEN or GITHUB_TOKEN
# - PUBLIC_REPO_URL
# - Any other deployment keys

# Set missing secrets
gh secret set SECRET_NAME
```

**Step 4: Manually Trigger Sync**

```bash
# Trigger workflow manually
gh workflow run daily_sync_main.yaml

# Watch run status
gh run watch
```

**Step 5: Fix Sync Issues Manually**

```bash
# If automated sync fails, sync manually:
cd ~/.local/share/chezmoi

# Ensure you're on main branch
git checkout main
git pull

# Push to trigger sync
git push

# Or sync public repo manually (if you have access):
# cd /path/to/public/repo
# git pull private-remote main
# git push origin main
```

**Reference:**

- [daily_sync_main.yaml](./.github/workflows/daily_sync_main.yaml)
- [daily_sync_dev.yaml](./.github/workflows/daily_sync_dev.yaml)

---

### GitHub Actions: Cannot Access Private Submodule

**Symptoms:**

- Workflow fails with "unable to access secrets submodule"
- Error: "Permission denied (publickey)"
- Secrets not available in workflow

**Cause:**

- Missing deploy key for secrets repository
- Incorrect submodule URL
- Authentication token lacks permissions

**Solution:**

**Step 1: Verify Submodule Configuration**

```bash
# Check submodule configuration
cd ~/.local/share/chezmoi
cat .gitmodules

# Should show secrets repository URL
# [submodule "secrets"]
#     path = secrets
#     url = git@github.com:your-org/secrets.git
```

**Step 2: Add Deploy Key to Secrets Repository**

```bash
# Generate deploy key
ssh-keygen -t ed25519 -C "github-actions-secrets" -f secrets-deploy-key

# Add public key to secrets repository:
# 1. Go to secrets repo → Settings → Deploy keys
# 2. Add new deploy key
# 3. Paste contents of secrets-deploy-key.pub
# 4. Enable "Allow write access" if needed

# Add private key as GitHub Secret:
cat secrets-deploy-key
gh secret set SECRETS_DEPLOY_KEY < secrets-deploy-key
```

**Step 3: Update Workflow to Use Deploy Key**

```yaml
# In .github/workflows/daily_sync_main.yaml
# Add step before checkout:
- name: Setup SSH for submodules
  uses: webfactory/ssh-agent@v0.8.0
  with:
    ssh-private-key: ${{ secrets.SECRETS_DEPLOY_KEY }}

- name: Checkout with submodules
  uses: actions/checkout@v4
  with:
    submodules: recursive
    token: ${{ secrets.GITHUB_TOKEN }}
```

**Reference:**

- [GitHub Actions submodule authentication](https://github.com/actions/checkout#usage)

---

## Shell and Terminal Issues

### Fish Shell Not Loading as Default

**Symptoms:**

- Terminal opens with Zsh or Bash instead of Fish
- `echo $SHELL` shows `/bin/zsh` or `/bin/bash`
- Fish functions not available

**Cause:**

- Fish not set as default shell
- Fish not in `/etc/shells`
- Terminal.app or Ghostty using wrong shell

**Solution:**

**Step 1: Verify Fish Installation**

```bash
# Check Fish is installed
which fish
# Should show: /opt/homebrew/bin/fish

# Check Fish version
fish --version
```

**Step 2: Add Fish to Allowed Shells**

```bash
# Check if Fish is in /etc/shells
cat /etc/shells | grep fish

# If not present, add it:
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells

# Verify it was added
cat /etc/shells
```

**Step 3: Set Fish as Default Shell**

```bash
# Change default shell to Fish
chsh -s /opt/homebrew/bin/fish

# Enter your password when prompted

# Verify change
echo $SHELL
# Should show: /opt/homebrew/bin/fish
```

**Step 4: Restart Terminal**

```bash
# Completely quit Terminal/Ghostty
# CMD+Q (not just close window)

# Reopen Terminal/Ghostty

# Verify Fish is running
echo $version
# Should show Fish version info
```

**Step 5: Check Terminal Configuration**

For Ghostty, verify `ghostty.conf`:

```bash
# Check shell setting
grep "shell-integration" ~/.config/ghostty/ghostty.conf

# Should have:
# shell-integration = fish
```

**Reference:**

- [Fish shell configuration](./dot_config/fish/README.md)
- [Ghostty configuration](./dot_config/ghostty/README.md)

---

### Fish Functions Not Available

**Symptoms:**

- Custom Fish functions return "command not found"
- `functions` command shows empty or incomplete list
- Fisher plugins not loaded

**Cause:**

- Functions not in correct directory
- Fisher not installed or not loaded
- Path issues

**Solution:**

**Step 1: Verify Functions Directory**

```bash
# Check functions directory exists
ls -la ~/.config/fish/functions/ | head -10

# Should show many .fish files
# If empty or missing, chezmoi didn't apply correctly
```

**Step 2: Re-apply Fish Configuration**

```bash
# Re-apply Fish config
chezmoi apply -v ~/.config/fish/

# Check functions directory again
ls ~/.config/fish/functions/ | wc -l
# Should show ~77 functions
```

**Step 3: Check Fisher Plugin Manager**

```fish
# In Fish shell, check Fisher status
fisher list

# If Fisher not installed:
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | \
  source && fisher install jorgebucaran/fisher

# Install plugins from fish_plugins file
fisher update
```

**Step 4: Source Configuration**

```fish
# Reload Fish configuration
source ~/.config/fish/config.fish

# Test a function
lg  # Should open lazygit
```

**Step 5: Debug Specific Function**

```fish
# Check if function file exists
ls ~/.config/fish/functions/lg.fish

# View function definition
functions lg

# If missing, check source
ls ~/.local/share/chezmoi/dot_config/fish/exact_functions/lg.fish
```

**Reference:**

- [Fish functions directory](./dot_config/fish/exact_functions/)
- [Fish README](./dot_config/fish/README.md)

---

### Starship Prompt Not Appearing

**Symptoms:**

- Plain prompt appears instead of Starship
- No git information in prompt
- No custom prompt styling

**Cause:**

- Starship not initialized in Fish config
- Starship not installed
- Configuration errors in `starship.toml`

**Solution:**

**Step 1: Verify Starship Installation**

```bash
# Check Starship is installed
which starship
starship --version

# If not installed:
brew install starship
```

**Step 2: Check Fish Configuration**

```fish
# Verify Starship initialization in config.fish
grep -n "starship" ~/.config/fish/config.fish

# Should have line like:
# starship init fish | source
```

**Step 3: Manually Initialize Starship**

```fish
# In Fish shell, initialize Starship
starship init fish | source

# If this works, prompt should appear
# If not, check for errors
```

**Step 4: Verify Starship Configuration**

```bash
# Check starship.toml exists
ls -la ~/.config/starship.toml

# Validate configuration
starship config

# Test configuration
starship print-config
```

**Step 5: Reload Fish Configuration**

```fish
# Reload Fish
exec fish

# Or source config
source ~/.config/fish/config.fish
```

**Reference:**

- [starship.toml configuration](./dot_config/starship.toml)
- [Starship documentation](https://starship.rs/)

---

## Tool-Specific Issues

### Homebrew Bundle Fails to Install Packages

**Symptoms:**

- `brew bundle` fails with errors
- Packages fail to install
- Cask installation errors

**Cause:**

- Outdated Homebrew
- Conflicting packages
- Missing dependencies
- Brewfile syntax errors

**Solution:**

**Step 1: Update Homebrew**

```bash
# Update Homebrew itself
brew update

# Upgrade installed packages
brew upgrade

# Check for issues
brew doctor
```

**Step 2: Install Packages Incrementally**

```bash
# Install one category at a time
brew bundle --file=~/Brewfile --no-upgrade

# If it fails, check which package failed:
brew bundle check --file=~/Brewfile --verbose

# Install failed package manually:
brew install <package-name>
```

**Step 3: Fix Brewfile Syntax**

```bash
# Validate Brewfile
cd ~
brew bundle check

# Common syntax issues:
# - Missing quotes around package names with special chars
# - Invalid tap URLs
# - Duplicate entries

# Edit Brewfile (it's symlinked)
vim ~/Brewfile
# Or via chezmoi:
cd ~/.local/share/chezmoi
vim cm-util/ctrld-configs/homebrew/Brewfile
```

**Step 4: Clean Up Failed Installations**

```bash
# Clean up incomplete installations
brew cleanup

# Remove problematic package and reinstall
brew uninstall <package-name>
brew install <package-name>

# Clear cache if needed
rm -rf $(brew --cache)
```

**Reference:**

- [Brewfile](./cm-util/ctrld-configs/homebrew/Brewfile)

---

### Lazygit Not Opening or Configuration Issues

**Symptoms:**

- `lg` function doesn't work
- Lazygit shows errors on startup
- Configuration not applied

**Cause:**

- Lazygit not installed
- Configuration file issues
- Wrong working directory

**Solution:**

**Step 1: Verify Installation**

```bash
# Check lazygit is installed
which lazygit
lazygit --version

# If not installed:
brew install lazygit
```

**Step 2: Check Configuration**

```bash
# Verify config exists (symlinked)
ls -la ~/.config/lazygit/config.yml

# Should be symlink to cm-util/
file ~/.config/lazygit/config.yml

# Test configuration syntax
lazygit --help
```

**Step 3: Test Lazygit in Git Repository**

```bash
# Navigate to a git repository
cd ~/.local/share/chezmoi

# Run lazygit directly
lazygit

# If it works here but not elsewhere, issue is with lg function
```

**Step 4: Check lg Function**

```fish
# View lg function definition
functions lg

# Should contain:
# lazygit

# Test function
lg
```

**Reference:**

- [lazygit config.yml](./cm-util/ctrld-configs/lazygit/config.yml)

---

### Yazi File Manager Issues

**Symptoms:**

- Yazi won't start
- Plugins not loading
- Key bindings not working

**Cause:**

- Yazi not installed
- Plugin dependencies missing
- Configuration errors

**Solution:**

**Step 1: Verify Installation**

```bash
# Check yazi is installed
which yazi
yazi --version

# If not installed:
brew install yazi
```

**Step 2: Check Plugins**

```bash
# List yazi plugins
ls ~/.config/yazi/plugins/

# Should show many plugin directories
# If empty, chezmoi didn't apply correctly:
chezmoi apply -v ~/.config/yazi/
```

**Step 3: Test Yazi**

```bash
# Start yazi in current directory
yazi

# If it crashes, check for errors:
yazi --debug
```

**Step 4: Verify Configuration**

```bash
# Check yazi.toml exists
cat ~/.config/yazi/yazi.toml

# Check keymap configuration
cat ~/.config/yazi/keymap.toml
```

**Reference:**

- [Yazi configuration](./dot_config/yazi/README.md)

---

### GPG Encryption/Decryption Issues

**Symptoms:**

- Chezmoi prompts for passphrase repeatedly
- Unable to decrypt encrypted files
- Error: "decryption failed: Bad passphrase"

**Cause:**

- Incorrect passphrase
- GPG configuration issues
- Passphrase not stored in chezmoi config

**Solution:**

**Step 1: Verify GPG Configuration**

```bash
# Check GPG is installed
gpg --version

# Check chezmoi encryption configuration
cat ~/.config/chezmoi/chezmoi.toml | grep -A 5 "\[gpg\]"

# Should show passphrase and GPG args
```

**Step 2: Test GPG Manually**

```bash
# Test encryption
echo "test" | gpg --symmetric --batch --passphrase "your-passphrase" > test.gpg

# Test decryption
gpg --decrypt --batch --passphrase "your-passphrase" test.gpg

# If this fails, GPG has issues
```

**Step 3: Re-initialize Chezmoi with Correct Passphrase**

```bash
# Backup current config
cp ~/.config/chezmoi/chezmoi.toml ~/.config/chezmoi/chezmoi.toml.backup

# Re-initialize
chezmoi init --force git@github.com:your-org/dotfiles.git

# Enter correct passphrase when prompted

# Apply configurations
chezmoi apply
```

**Step 4: Update Passphrase in Configuration**

```bash
# Edit chezmoi config
vim ~/.config/chezmoi/chezmoi.toml

# Update passphrase in [gpg] section:
# [gpg]
#     symmetric = true
#     args = ["--batch", "--passphrase", "YOUR_PASSPHRASE", "--no-symkey-cache"]
```

**Reference:**

- [CHEZMOI.md secrets section](./docs/CHEZMOI.md#secrets-and-encryption)

---

## Related Documentation

### Primary Documentation

- **[README.md](./README.md)** - Repository overview and quick start guide
- **[INSTALL.md](./INSTALL.md)** - Complete installation instructions
- **[CHEZMOI.md](./CHEZMOI.md)** - Chezmoi workflow and usage guide

### Workflow Guides

- **[docs/workflows/new-machine-setup.md](./docs/workflows/new-machine-setup.md)** - Setting up dotfiles on a new machine
- **[docs/workflows/configuration-changes.md](./docs/workflows/configuration-changes.md)** - Making safe configuration changes
- **[docs/workflows/multi-machine-sync.md](./docs/workflows/multi-machine-sync.md)** - Keeping dotfiles synchronized across machines
- **[docs/workflows/secrets-management.md](./docs/workflows/secrets-management.md)** - Managing secrets and sensitive data

### Tool-Specific Documentation

- **[dot_config/fish/README.md](./dot_config/fish/README.md)** - Fish shell configuration
- **[dot_config/exact_nvim/README.md](./dot_config/exact_nvim/README.md)** - Neovim configuration
- **[dot_config/yabai/README.md](./dot_config/yabai/README.md)** - Yabai window manager
- **[dot_config/skhd/README.md](./dot_config/skhd/README.md)** - Skhd hotkey daemon
- **[dot_config/karabiner/README.md](./dot_config/karabiner/README.md)** - Karabiner Elements keyboard customization
- **[.chezmoiscripts/README.md](./.chezmoiscripts/README.md)** - Automation scripts

### Reference Guides

- **[docs/KEYMAPS.md](./docs/KEYMAPS.md)** - Unified keyboard shortcuts across all tools
- **[docs/ARCHITECTURE.md](./docs/ARCHITECTURE.md)** - System architecture and tool interactions

### External Resources

- **[Chezmoi Documentation](https://www.chezmoi.io/)** - Official chezmoi user guide
- **[Yabai Wiki](https://github.com/koekeishiya/yabai/wiki)** - Official yabai documentation
- **[LazyVim Documentation](https://www.lazyvim.org/)** - LazyVim starter guide
- **[Fish Shell Documentation](https://fishshell.com/docs/current/)** - Official Fish documentation
- **[Gitleaks Documentation](https://github.com/gitleaks/gitleaks)** - Gitleaks usage and configuration

---

## Getting Additional Help

If you've followed the troubleshooting steps and still experience issues:

1. **Check Recent Changes**

   ```bash
   cd ~/.local/share/chezmoi
   git log --oneline -10
   # Review recent commits that might have introduced issues
   ```

2. **Search GitHub Issues**
   - Check issues in this repository
   - Search issues for specific tools (yabai, chezmoi, etc.)

3. **Run Diagnostic Commands**
   - Use the diagnostic commands at the top of this guide
   - Collect output and error messages

4. **Review Logs**

   ```bash
   # Yabai logs
   tail -100 /opt/homebrew/var/log/yabai/yabai.err.log

   # Skhd logs
   tail -100 /opt/homebrew/var/log/skhd/skhd.err.log

   # Neovim logs
   nvim +LspLog +qa

   # System logs
   log show --predicate 'processImagePath contains "yabai"' --last 10m
   ```

5. **Create Minimal Reproduction**
   - Isolate the issue to a specific configuration
   - Test with minimal settings
   - Document steps to reproduce

6. **Rollback Changes**

   ```bash
   cd ~/.local/share/chezmoi
   git log --oneline
   git checkout <previous-commit-hash>
   chezmoi apply
   # Test if issue is resolved
   ```

Remember: Most issues can be resolved by carefully reading error messages, checking logs, and verifying configurations. Take your time and work through problems systematically.
