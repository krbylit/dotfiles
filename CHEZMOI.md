# Chezmoi Workflow Guide

## Table of Contents

1. [Overview](#1-overview)
2. [Core Workflow](#2-core-workflow)
3. [Naming Conventions](#3-naming-conventions)
4. [Template System](#4-template-system)
5. [cm-util/ Symlink Strategy](#5-cm-util-symlink-strategy)
6. [State Terminology](#6-state-terminology)
7. [Essential Commands Reference](#7-essential-commands-reference)
8. [Best Practices](#8-best-practices)
9. [Common Pitfalls](#9-common-pitfalls)
10. [Next Steps](#10-next-steps)
11. [Pre-commit Hook System](#11-pre-commit-hook-system)

---

## 1. Overview

### What is chezmoi?

[Chezmoi](https://www.chezmoi.io/) is a dotfile manager that helps you maintain consistent configurations across multiple machines. It stores your dotfiles in a source directory (`~/.local/share/chezmoi/`) and applies them to your home directory, transforming them based on templates, machine-specific settings, and naming conventions.

### Why we use chezmoi

- **Version control**: Track all configuration changes with git
- **Machine-specific configs**: Use templates for different machines/contexts
- **Secret management**: Integrate with 1Password, encrypt sensitive files
- **Safe modifications**: Preview changes before applying them
- **Reproducibility**: Recreate your environment on any machine

### The Basic Workflow

The chezmoi workflow follows a simple cycle:

```
EDIT → DIFF → APPLY → COMMIT
```

1. **EDIT**: Modify files in the source state (`~/.local/share/chezmoi/`)
2. **DIFF**: Preview what will change before applying
3. **APPLY**: Copy transformed files to your home directory
4. **COMMIT**: Save changes to git for version control

This workflow ensures you always know what changes will be made before they happen, preventing configuration mistakes.

---

## 2. Core Workflow

### Complete Workflow Example

Let's walk through modifying the Fish shell configuration from start to finish:

```bash
# Step 1: Edit the configuration file
chezmoi edit ~/.config/fish/config.fish

# Make your changes in the editor...
# (chezmoi opens the SOURCE file, not the destination file)

# Step 2: Preview what will change
chezmoi diff ~/.config/fish/config.fish

# Step 3: Review the diff output
# Verify the changes are what you expect

# Step 4: Apply the changes
chezmoi apply ~/.config/fish/config.fish

# Step 5: Test the changes
# Open a new Fish shell and verify everything works

# Step 6: Commit to git
chezmoi cd  # Navigate to source directory
git add dot_config/fish/config.fish
git status
git diff --staged
git commit -m "feat: update fish shell configuration"
git push
exit  # Return to previous directory
```

### Editing Files

The `chezmoi edit` command opens files from the **source state** in your configured editor:

```bash
# Edit a single configuration file
chezmoi edit ~/.config/fish/config.fish

# Edit with a specific editor
EDITOR=nvim chezmoi edit ~/.config/nvim/init.lua

# Edit multiple files at once
chezmoi edit ~/.gitconfig ~/.config/starship.toml

# Edit and apply changes automatically (if configured)
# See .chezmoi.toml.tmpl for auto-apply settings
chezmoi edit ~/.config/fish/config.fish
```

**Important**: Always use `chezmoi edit` to modify configurations. If you edit files directly in your home directory, those changes will be lost the next time you run `chezmoi apply`.

### Previewing Changes

Before applying changes, always preview them:

```bash
# See all pending changes
chezmoi diff

# See changes for a specific file
chezmoi diff ~/.config/fish/config.fish

# Dry run - see what WOULD be applied without actually applying
chezmoi apply --dry-run --verbose

# Show detailed information about what will happen
chezmoi apply --verbose --dry-run
```

The diff output shows:

- Lines with `-` will be removed
- Lines with `+` will be added
- Context lines show where changes occur

### Applying Changes

Once you've reviewed the diff, apply the changes:

```bash
# Apply all pending changes
chezmoi apply

# Apply a specific file
chezmoi apply ~/.config/fish/config.fish

# Apply with verbose output (recommended for learning)
chezmoi apply --verbose

# Force apply even if no changes detected
chezmoi apply --force
```

**Auto-apply behavior**: This repository is configured with `edit.apply = true` and `edit.watch = true` in `.chezmoi.toml.tmpl`, which means:

- Changes are automatically applied when you save and exit the editor
- Changes are watched and applied on save (for supported editors)

### Committing Changes

After applying and testing your changes, commit them to git:

```bash
# Method 1: Use chezmoi cd
chezmoi cd
git add .
git status
git diff --staged
git commit -m "feat: update configuration"
git push
exit  # Returns to your previous directory

# Method 2: Use absolute paths
cd ~/.local/share/chezmoi
git add .
git commit -m "feat: update configuration"
git push
cd -  # Return to previous directory
```

**Commit message style**: Follow conventional commits:

- `feat:` - New feature or configuration
- `fix:` - Bug fix or correction
- `docs:` - Documentation changes
- `refactor:` - Code/config restructuring
- `chore:` - Maintenance tasks

### Adding New Files to Chezmoi

To start tracking a new configuration file:

```bash
# Add a file to chezmoi
chezmoi add ~/.config/newtool/config.yaml

# Chezmoi copies it to ~/.local/share/chezmoi/dot_config/newtool/config.yaml
# Now you can edit it with: chezmoi edit ~/.config/newtool/config.yaml

# Add a file with specific attributes
chezmoi add --template ~/.gitconfig  # Add as a template
chezmoi add --private ~/.ssh/config  # Add with private permissions
```

### Removing Files from Chezmoi

To stop tracking a configuration file:

```bash
# Remove from chezmoi (keeps the destination file)
chezmoi forget ~/.config/oldtool/config.yaml

# Remove from chezmoi and delete the source file
cd ~/.local/share/chezmoi
rm dot_config/oldtool/config.yaml
git add -u
git commit -m "chore: remove oldtool configuration"
```

---

## 3. Naming Conventions

Chezmoi uses special filename prefixes in the **source directory** to control how files are created in your home directory. Understanding these naming patterns is critical for working with chezmoi.

### File Prefix Reference

| Prefix | Purpose | Example Source | Example Destination | Permissions |
|--------|---------|----------------|---------------------|-------------|
| `dot_` | Creates dotfile (leading `.`) | `dot_gitconfig` | `~/.gitconfig` | Default (644) |
| `private_` | Restricts permissions | `private_dot_bashrc` | `~/.bashrc` | 600 (owner only) |
| `executable_` | Makes file executable | `executable_yabairc` | `~/.config/yabai/yabairc` | 755 (executable) |
| `symlink_` | Creates symbolic link | `symlink_Brewfile.tmpl` | `~/Brewfile` → target | Link |
| `exact_` | Directory managed exactly | `exact_nvim/` | `~/.config/nvim/` | Removes untracked |
| `encrypted_` | GPG-encrypted file | `encrypted_key.asc` | Decrypted file | As specified |
| `.tmpl` | Template file (suffix) | `config.yaml.tmpl` | `config.yaml` | Processed |

### dot_ - Creating Dotfiles

The most common prefix. Converts files/directories to start with a `.` (dot):

```
Source: dot_gitconfig
Destination: ~/.gitconfig

Source: dot_config/fish/config.fish
Destination: ~/.config/fish/config.fish

Source: dot_vimrc
Destination: ~/.vimrc
```

**When to use**: Almost all configuration files in your home directory start with a dot, so you'll use this prefix constantly.

**Repository examples**:

- `dot_gitconfig` → `~/.gitconfig`
- `dot_bashrc` → `~/.bashrc`
- `dot_config/ripgrep/dot_ripgreprc` → `~/.config/ripgrep/.ripgreprc`

### private_ - Restricting Permissions

Creates files with `600` permissions (readable/writable by owner only):

```
Source: private_dot_bashrc
Destination: ~/.bashrc (with permissions 600)

Source: secrets/.ssh/private_config
Destination: ~/.ssh/config (with permissions 600)
```

**When to use**:

- SSH configurations
- API keys and tokens
- Any sensitive data that shouldn't be readable by other users

**Repository examples**:

- `secrets/private_dot_bashrc` → `~/.bashrc` (600)
- `secrets/.config/gh/private_hosts.yml` → `~/.config/gh/hosts.yml` (600)
- `dot_config/aichat/private_config.yaml` → `~/.config/aichat/config.yaml` (600)

### executable_ - Creating Executable Scripts

Creates files with `755` permissions (executable by all, writable by owner):

```
Source: executable_yabairc
Destination: ~/.config/yabai/yabairc (with permissions 755)

Source: dot_config/skhd/util/executable_focus_empty_space.sh
Destination: ~/.config/skhd/util/focus_empty_space.sh (with permissions 755)
```

**When to use**:

- Shell scripts that need to run
- Helper utilities and automation scripts
- Any file that needs execute permissions

**Repository examples**:

- `dot_config/yabai/executable_yabairc` → `~/.config/yabai/yabairc` (755)
- `dot_config/skhd/util/executable_focus_empty_space.sh` → `~/.config/skhd/util/focus_empty_space.sh` (755)

### symlink_ - Creating Symbolic Links

Creates a symbolic link instead of copying the file. The template must output the target path:

```
Source: symlink_Brewfile.tmpl
Template output: /Users/you/.local/share/chezmoi/cm-util/ctrld-configs/homebrew/Brewfile
Destination: ~/Brewfile → (symlinks to that path)
```

**When to use**:

- Sharing configurations between multiple tools
- Linking to files in `cm-util/` (see Section 5)
- Avoiding duplication of large files

**Repository examples**:

- `symlink_Brewfile.tmpl` → `~/Brewfile` → `cm-util/ctrld-configs/homebrew/Brewfile`
- `dot_config/karabiner/symlink_karabiner.json.tmpl` → `~/.config/karabiner/karabiner.json` → `cm-util/ctrld-configs/karabiner/karabiner.json`

**Note**: Symlink templates must contain a valid file path as their output. See Section 4 for template syntax.

### exact_ - Exact Directory Management

Marks a directory as "exact" - chezmoi removes any files in the destination that aren't in the source:

```
Source: dot_config/exact_nvim/
Destination: ~/.config/nvim/ (removes any files not in source)

Source: dot_config/fish/exact_functions/
Destination: ~/.config/fish/functions/ (removes untracked functions)
```

**When to use**:

- Plugin directories that shouldn't have stale files
- Configuration directories that should match source exactly
- Preventing accumulation of old/deleted configurations

**Repository examples**:

- `dot_config/exact_nvim/` → `~/.config/nvim/` (exact)
- `dot_config/fish/exact_functions/` → `~/.config/fish/functions/` (exact)
- `dot_config/fish/exact_completions/` → `~/.config/fish/completions/` (exact)

**Warning**: Be careful with `exact_` directories! Files not tracked by chezmoi will be **deleted** from the destination.

### .tmpl - Template Files (Suffix)

Files ending in `.tmpl` are processed as Go templates before being applied:

```
Source: .chezmoi.toml.tmpl
Destination: ~/.config/chezmoi/chezmoi.toml (after template processing)

Source: symlink_Brewfile.tmpl
Destination: ~/Brewfile (symlink, target from template)
```

**When to use**:

- Machine-specific configurations
- Injecting secrets from 1Password
- Conditional content based on OS/hostname
- Generating symlink targets

**Repository examples**:

- `.chezmoi.toml.tmpl` → Template for chezmoi config
- `dot_config/ghostty/ghostty.conf.tmpl` → Machine-specific terminal config
- All `symlink_*.tmpl` files → Generate symlink targets

See Section 4 for detailed template syntax and examples.

### Combining Prefixes

Chezmoi prefixes can be combined in a specific order:

```
private_executable_script.sh
→ Creates executable script with 700 permissions

private_dot_bashrc
→ Creates ~/.bashrc with 600 permissions

executable_dot_local/bin/script
→ Creates ~/.local/bin/script with 755 permissions

symlink_dot_config/tool/config.yaml.tmpl
→ Creates ~/.config/tool/config.yaml as a symlink (target from template)
```

**Prefix order** (left to right):

1. `private_` or `readonly_`
2. `executable_`
3. `symlink_`
4. `dot_` or `literal_`
5. Filename
6. `.tmpl` (suffix)

### Special Cases and Edge Cases

**Double dots**: To create a file with `..` in the name:

```
Source: dot_dot_gitconfig
Destination: ~/.gitconfig (not ..gitconfig)
```

**Literal underscores**: To use a literal underscore instead of a prefix:

```
Source: literal_my_file.txt
Destination: ~/my_file.txt (preserves underscore)
```

**No transformation**: To use exact filename:

```
Source: exact_literal_my_file_name.txt
Destination: ~/my_file_name.txt (no modifications)
```

### Decision Tree: Choosing the Right Prefix

Ask yourself these questions:

1. **Does it need a dot prefix?** → Use `dot_`
2. **Is it sensitive data?** → Add `private_` prefix
3. **Does it need to execute?** → Add `executable_` prefix
4. **Should it be a symlink?** → Use `symlink_` + `.tmpl`
5. **Is it machine-specific?** → Add `.tmpl` suffix
6. **Should directory be exact?** → Use `exact_` prefix

**Common patterns**:

- Regular config: `dot_config/tool/config.yaml`
- Sensitive config: `private_dot_config/tool/config.yaml`
- Executable script: `executable_script.sh`
- Shared config: `symlink_config.yaml.tmpl` (points to `cm-util/`)
- Plugin directory: `dot_config/exact_nvim/`
- Machine-specific: `config.yaml.tmpl`

---

## 4. Template System

### What are Templates?

Templates are files ending in `.tmpl` that are processed using [Go template syntax](https://pkg.go.dev/text/template) before being applied. Templates allow you to:

- Inject secrets from 1Password
- Create machine-specific configurations
- Use conditional logic based on OS, hostname, or other variables
- Access data from `.chezmoidata/` files
- Generate dynamic content

**Key concept**: The `.tmpl` suffix is removed from the destination filename:

```
Source: config.yaml.tmpl
Destination: config.yaml (after processing)
```

### Template Data Sources

Chezmoi provides data to templates from multiple sources:

#### 1. Chezmoi Variables

Built-in variables about your system:

```go
{{ .chezmoi.hostname }}          # Your machine's hostname
{{ .chezmoi.os }}                # Operating system (darwin, linux, etc.)
{{ .chezmoi.arch }}              # Architecture (amd64, arm64, etc.)
{{ .chezmoi.homeDir }}           # Home directory path
{{ .chezmoi.sourceDir }}         # Chezmoi source directory (~/.local/share/chezmoi)
{{ .chezmoi.username }}          # Current username
```

#### 2. .chezmoidata Files

Custom data from TOML files in `.chezmoidata/`:

**`constants.toml`** - Shared constants and paths:

```toml
[path]
ctrld_configs = "/cm-util/ctrld-configs"
secrets = "/secrets"
templates = "/.chezmoitemplates"
```

Access in templates:

```go
{{ .path.ctrld_configs }}        # "/cm-util/ctrld-configs"
{{ .path.secrets }}              # "/secrets"
```

**`uv.toml`** - UV tool configuration:

```toml
[uv]
tools = [
    { name = "ruff", version = "latest" },
    { name = "aider-chat", version = "latest" },
]
```

Access in templates:

```go
{{ range .uv.tools }}
{{ .name }} @ {{ .version }}
{{ end }}
```

#### 3. 1Password Integration

Access secrets from 1Password Service Account:

```go
{{ (onepassword "item-name").password }}
{{ (onepassword "item-name").username }}
{{ (onepassword "item-name").fields.custom_field }}
```

#### 4. Prompt Values

Values entered during `chezmoi init`:

```go
{{ .passphrase }}                # GPG passphrase for encryption
{{ .secretsRepo }}               # Secrets repository URL
```

These are defined in `.chezmoi.toml.tmpl` and stored in your local chezmoi config.

### Common Template Patterns

#### Conditional Content Based on Machine

```go
{{- if eq .chezmoi.hostname "work-laptop" }}
# Work-specific configuration
export COMPANY_API_KEY="xxx"
{{- else if eq .chezmoi.hostname "personal-macbook" }}
# Personal configuration
export PERSONAL_API_KEY="xxx"
{{- else }}
# Default configuration
{{- end }}
```

#### Conditional Content Based on OS

```go
{{- if eq .chezmoi.os "darwin" }}
# macOS-specific settings
alias ls="ls -G"
{{- else if eq .chezmoi.os "linux" }}
# Linux-specific settings
alias ls="ls --color=auto"
{{- end }}
```

#### Including External Files

```go
{{- $privateBashRc := (joinPath .chezmoi.sourceDir .path.secrets "private_dot_bashrc") -}}
{{- if (stat $privateBashRc) -}}
{{ include $privateBashRc | trim }}
{{- end -}}
```

This pattern:

1. Constructs a path to a private file
2. Checks if the file exists with `stat`
3. Includes its contents if it exists
4. Trims whitespace with `| trim`

#### Generating Symlink Targets

All `symlink_*.tmpl` files must output a valid path:

```go
{{ .chezmoi.sourceDir }}{{ .path.ctrld_configs }}/karabiner/karabiner.json
```

This generates:

```
/Users/you/.local/share/chezmoi/cm-util/ctrld-configs/karabiner/karabiner.json
```

Which becomes the symlink target.

#### Accessing 1Password Secrets

```go
[user]
    name = "John Doe"
    email = {{ (onepassword "github-credentials").username | quote }}
    signingkey = {{ (onepassword "github-credentials").fields.gpg_key | quote }}
```

The `| quote` filter ensures the value is properly quoted in the output.

#### Iterating Over Lists

```go
{{ range .uv.tools }}
uv tool install {{ .name }}@{{ .version }}
{{ end }}
```

#### Trimming Whitespace

Use `{{-` and `-}}` to remove whitespace:

```go
{{- if .condition -}}
content
{{- end -}}
```

This prevents extra blank lines in the output.

### Template Examples from This Repository

#### Example 1: .chezmoi.toml.tmpl

**Purpose**: Main chezmoi configuration with prompts and settings

```go
{{ $secretsRepo := promptString "Enter git@github.com URL to optional repo containing dotfile secrets" -}}
{{ $passphrase := promptStringOnce . "passphrase" "passphrase" -}}

encryption = "gpg"

[edit]
    apply = true
    watch = true

[data]
    passphrase = {{ $passphrase | quote }}
    secretsRepo = {{ $secretsRepo | quote }}

[gpg]
    symmetric = true
    args = ["--batch", "--passphrase", {{ $passphrase | quote }}, "--no-symkey-cache"]
```

**Key features**:

- Prompts user for secrets during `chezmoi init`
- Stores values in config for future use
- Uses `quote` filter for safe string handling

#### Example 2: private.bashrc.tmpl

**Purpose**: Include secrets from submodule if they exist

```go
{{- $privateBashRc := (joinPath .chezmoi.sourceDir .path.secrets "private_dot_bashrc") -}}
{{- if (stat $privateBashRc) -}}
{{ include $privateBashRc | trim }}
{{- end -}}
```

**Key features**:

- Constructs path using data from `constants.toml`
- Checks if file exists before including
- Gracefully handles missing secrets

#### Example 3: symlink_Brewfile.tmpl

**Purpose**: Symlink to shared Brewfile in cm-util/

```go
{{ .chezmoi.sourceDir }}{{ .path.ctrld_configs }}/homebrew/Brewfile
```

**Key features**:

- Generates absolute path to symlink target
- Uses constants from `.chezmoidata/constants.toml`
- Keeps Brewfile in shared location

#### Example 4: ghostty.conf.tmpl

**Purpose**: Machine-specific terminal configuration

```go
theme = tokyonight
# SSH theme
# theme = Paraiso Dark

font-family = "Departure Mono Phosphor Fill"
font-size = 14

{{- if eq .chezmoi.hostname "ssh-server" }}
background-opacity = 0.9
{{- else }}
background-opacity = 1.0
{{- end }}
```

**Key features**:

- Different settings based on hostname
- Conditional content for SSH vs local machines
- Theme and font customization

### When to Use Templates

Use templates when you need:

1. **Machine-specific configurations**
   - Different settings for work vs personal machines
   - SSH server vs local machine differences
   - OS-specific settings (macOS vs Linux)

2. **Secret injection**
   - API keys from 1Password
   - Tokens and credentials
   - Machine-specific passwords

3. **Dynamic content**
   - Generated paths using chezmoi variables
   - Conditional features based on hostname/OS
   - Including external files conditionally

4. **Symlink generation**
   - All `symlink_*` files must be templates
   - Generate absolute paths to link targets

### Template Debugging

If a template isn't working:

```bash
# See the rendered template output
chezmoi cat ~/.config/tool/config.yaml

# Check for template syntax errors
chezmoi apply --verbose

# Test template processing
chezmoi execute-template < template-file.tmpl

# Verify template data
chezmoi data
```

---

## 5. cm-util/ Symlink Strategy

### What is cm-util/?

`cm-util/` is a directory in the chezmoi source tree that stores shared configurations. Instead of duplicating configuration files, we create symlinks to files in `cm-util/` using the `symlink_*.tmpl` pattern.

**Directory structure**:

```
~/.local/share/chezmoi/
├── cm-util/
│   ├── ctrld-configs/      # Shared "controlled configs"
│   │   ├── homebrew/
│   │   │   └── Brewfile
│   │   ├── karabiner/
│   │   │   └── karabiner.json
│   │   ├── lazygit/
│   │   │   └── config.yml
│   │   ├── nvim/
│   │   └── ...
│   └── pkg-backups/        # Package backup files
└── symlink_Brewfile.tmpl   # Symlinks to cm-util/ctrld-configs/homebrew/Brewfile
```

### How Symlinks Work

Symlink templates contain a single line with the target path:

**File**: `symlink_Brewfile.tmpl`

```go
{{ .chezmoi.sourceDir }}{{ .path.ctrld_configs }}/homebrew/Brewfile
```

**Result**: When applied, chezmoi creates:

```bash
~/Brewfile → /Users/you/.local/share/chezmoi/cm-util/ctrld-configs/homebrew/Brewfile
```

**Verification**:

```bash
ls -la ~/Brewfile
# lrwxr-xr-x  ... Brewfile -> /Users/you/.local/share/chezmoi/cm-util/...
```

### Symlink Examples in Repository

#### Example 1: Brewfile

**Source**: `symlink_Brewfile.tmpl`

```go
{{ .chezmoi.sourceDir }}{{ .path.ctrld_configs }}/homebrew/Brewfile
```

**Destination**: `~/Brewfile` → `cm-util/ctrld-configs/homebrew/Brewfile`

**Why**: Homebrew expects `Brewfile` in home directory, but we maintain it in `cm-util/`

#### Example 2: Karabiner Configuration

**Source**: `dot_config/karabiner/symlink_karabiner.json.tmpl`

```go
{{ .chezmoi.sourceDir }}{{ .path.ctrld_configs }}/karabiner/karabiner.json
```

**Destination**: `~/.config/karabiner/karabiner.json` → `cm-util/ctrld-configs/karabiner/karabiner.json`

**Why**: Large JSON file shared across multiple setups

#### Example 3: Lazygit Configuration

**Source**: `dot_config/lazygit/symlink_config.yml.tmpl`

```go
{{ .chezmoi.sourceDir }}{{ .path.ctrld_configs }}/lazygit/config.yml
```

**Destination**: `~/.config/lazygit/config.yml` → `cm-util/ctrld-configs/lazygit/config.yml`

**Why**: Shared git UI configuration

#### Example 4: Neovim Lazy Lock

**Source**: `dot_config/exact_nvim/symlink_lazy-lock.json.tmpl`

```go
{{ .chezmoi.sourceDir }}{{ .path.ctrld_configs }}/lazyvim/lazy-lock.json
```

**Destination**: `~/.config/nvim/lazy-lock.json` → `cm-util/ctrld-configs/lazyvim/lazy-lock.json`

**Why**: Plugin lock file shared across machines for consistent Neovim setup

### Rationale: Why Use Symlinks?

#### 1. Avoid Duplication

Without symlinks, you'd need to maintain copies:

```
dot_config/karabiner/karabiner.json    # Copy 1
dot_config/tool2/karabiner.json        # Copy 2
```

With symlinks, one source of truth:

```
cm-util/ctrld-configs/karabiner/karabiner.json  # Single source
symlink_karabiner.json.tmpl                     # Link to it
```

#### 2. Cross-Platform Sharing

Share configurations between:

- Multiple tools that use the same config format
- Different machines that need the same settings
- SSH vs local contexts

#### 3. Easier Updates

Change once, applies everywhere:

```bash
# Edit the source file
vim cm-util/ctrld-configs/lazygit/config.yml

# All symlinks automatically see the change
chezmoi apply  # Updates any symlinks if needed
```

#### 4. Cleaner Repository Structure

Separates:

- **Tool-specific layouts**: `dot_config/tool/` (where configs live)
- **Shared content**: `cm-util/ctrld-configs/` (what those configs contain)

### Working with Symlinked Configurations

#### Editing Symlinked Files

**Option 1**: Edit through chezmoi (recommended)

```bash
# This won't work for symlinks - you'll edit the template
chezmoi edit ~/Brewfile

# Instead, edit the target directly
vim ~/.local/share/chezmoi/cm-util/ctrld-configs/homebrew/Brewfile
```

**Option 2**: Edit via the symlink

```bash
# Since it's a symlink, this edits the target in cm-util/
vim ~/Brewfile

# Changes are automatically in cm-util/, ready to commit
cd ~/.local/share/chezmoi
git add cm-util/ctrld-configs/homebrew/Brewfile
git commit -m "feat: update Brewfile"
```

#### Adding New Symlinks

To create a new symlink to a shared config:

```bash
# 1. Create the target file in cm-util/
mkdir -p cm-util/ctrld-configs/newtool
echo "config content" > cm-util/ctrld-configs/newtool/config.yaml

# 2. Create the symlink template
cat > dot_config/newtool/symlink_config.yaml.tmpl << 'EOF'
{{ .chezmoi.sourceDir }}{{ .path.ctrld_configs }}/newtool/config.yaml
EOF

# 3. Apply the symlink
chezmoi apply ~/.config/newtool/config.yaml

# 4. Verify
ls -la ~/.config/newtool/config.yaml
# Should show symlink to cm-util/...
```

#### Moving Existing Configs to cm-util/

To convert a regular config to a symlinked one:

```bash
cd ~/.local/share/chezmoi

# 1. Move config to cm-util/
mv dot_config/tool/config.yaml cm-util/ctrld-configs/tool/config.yaml

# 2. Create symlink template
cat > dot_config/tool/symlink_config.yaml.tmpl << 'EOF'
{{ .chezmoi.sourceDir }}{{ .path.ctrld_configs }}/tool/config.yaml
EOF

# 3. Apply
chezmoi apply ~/.config/tool/config.yaml

# 4. Commit both changes
git add dot_config/tool/symlink_config.yaml.tmpl
git add cm-util/ctrld-configs/tool/config.yaml
git rm dot_config/tool/config.yaml  # Remove old file
git commit -m "refactor: convert tool config to symlink"
```

### When to Use Symlinks

**Use symlinks when**:

- Configuration is shared between multiple tools
- Config file is large (reduces duplication)
- You want a single source of truth
- Config doesn't need per-machine customization

**Don't use symlinks when**:

- Config needs to be a template (machine-specific)
- Config requires different content per machine
- Tool expects to modify the config file (some tools don't follow symlinks)
- Config is small and not shared

### Symlink Strategy Summary

The cm-util/ strategy provides:

- **Organization**: Shared configs in one place
- **Maintainability**: Edit once, apply everywhere
- **Flexibility**: Easy to convert between regular files and symlinks
- **Version control**: Track shared configs separately from file layout

All symlinks use the template pattern:

```go
{{ .chezmoi.sourceDir }}{{ .path.ctrld_configs }}/path/to/file
```

This generates absolute paths that are stable across machines.

---

## 6. State Terminology

Chezmoi uses three important concepts to describe file states:

### Source State

Files stored in `~/.local/share/chezmoi/`:

- Your git repository
- Uses special naming conventions (`dot_`, `private_`, etc.)
- Contains templates (`.tmpl` files)
- The "blueprint" for your configurations

**Example**:

```
~/.local/share/chezmoi/dot_config/fish/config.fish
```

### Destination State

Current files in your home directory:

- What's actually on your system right now
- Real dotfiles and configurations
- What applications actually read

**Example**:

```
~/.config/fish/config.fish
```

### Target State

What chezmoi **wants** your destination to look like:

- Source state after applying templates
- After transforming file names
- After processing all chezmoi logic

**Example**:

```
chezmoi apply  # Makes destination match target state
```

### State Comparison Commands

```bash
# See differences between destination and target
chezmoi diff

# See what target state looks like
chezmoi cat ~/.config/fish/config.fish

# Verify state consistency
chezmoi verify

# Show managed files status
chezmoi status
```

### State Workflow Diagram

```
Source State                Target State              Destination State
(in git repo)              (desired state)           (actual files)
     |                           |                          |
     |  chezmoi apply            |                          |
     |-------------------------->|                          |
     |                           |  chezmoi apply          |
     |                           |------------------------>|
     |                           |                          |
     |  chezmoi diff             |                          |
     |<---------------------------------------------------- |
```

**Key insight**: You edit the **source state**, chezmoi calculates the **target state**, and `chezmoi apply` updates the **destination state** to match.

---

## 7. Essential Commands Reference

### Quick Reference Table

| Command | Purpose | Common Usage |
|---------|---------|--------------|
| `chezmoi edit <file>` | Edit file in source state | `chezmoi edit ~/.gitconfig` |
| `chezmoi diff` | Show pending changes | `chezmoi diff` |
| `chezmoi apply` | Apply changes to destination | `chezmoi apply` |
| `chezmoi cd` | Navigate to source directory | `chezmoi cd` |
| `chezmoi update` | Pull and apply remote changes | `chezmoi update` |
| `chezmoi add <file>` | Add new file to chezmoi | `chezmoi add ~/.config/tool/config.yaml` |
| `chezmoi forget <file>` | Stop tracking file | `chezmoi forget ~/.config/old/config.yaml` |
| `chezmoi status` | Show managed files status | `chezmoi status` |
| `chezmoi cat <file>` | Show target state of file | `chezmoi cat ~/.gitconfig` |
| `chezmoi verify` | Verify destination matches target | `chezmoi verify` |
| `chezmoi data` | Show template data | `chezmoi data` |
| `chezmoi doctor` | Diagnose chezmoi setup | `chezmoi doctor` |

### Detailed Command Explanations

#### chezmoi edit

Opens files from source state in your configured editor:

```bash
# Edit single file
chezmoi edit ~/.config/fish/config.fish

# Edit multiple files
chezmoi edit ~/.gitconfig ~/.bashrc

# Use specific editor
EDITOR=nvim chezmoi edit ~/.vimrc

# Edit and apply (if auto-apply enabled)
chezmoi edit ~/.config/tool/config.yaml
# Saves and applies automatically on exit
```

**Configured editor**: Set in chezmoi config or `$EDITOR` environment variable.

#### chezmoi diff

Shows differences between destination and target state:

```bash
# Show all differences
chezmoi diff

# Show specific file differences
chezmoi diff ~/.config/fish/config.fish

# Show with context
chezmoi diff --color=always | less -R

# Use different diff tool
chezmoi diff --pager=delta
```

#### chezmoi apply

Applies target state to destination:

```bash
# Apply all changes
chezmoi apply

# Apply specific file
chezmoi apply ~/.config/fish/config.fish

# Dry run (don't actually apply)
chezmoi apply --dry-run --verbose

# Force apply even if unchanged
chezmoi apply --force

# Apply with detailed output
chezmoi apply --verbose
```

#### chezmoi cd

Navigates to source directory:

```bash
# Enter source directory
chezmoi cd

# Now you're in ~/.local/share/chezmoi
pwd  # /Users/you/.local/share/chezmoi

# Do git operations
git status
git add .
git commit -m "feat: update configs"

# Return to previous directory
exit  # or Ctrl+D
```

#### chezmoi update

Pulls latest changes from git and applies them:

```bash
# Update from remote and apply
chezmoi update

# Update with verbose output
chezmoi update --verbose

# Update without applying
chezmoi git pull  # Just pull, don't apply
```

**Note**: This is equivalent to:

```bash
chezmoi cd
git pull
exit
chezmoi apply
```

#### chezmoi add

Adds files to chezmoi management:

```bash
# Add a file
chezmoi add ~/.config/tool/config.yaml

# Add with template processing
chezmoi add --template ~/.gitconfig

# Add with private permissions
chezmoi add --private ~/.ssh/config

# Add entire directory
chezmoi add --recursive ~/.config/tool
```

#### chezmoi status

Shows status of managed files:

```bash
# Show all managed files status
chezmoi status

# Shows files with codes:
# A  = Added (in target, not in destination)
# M  = Modified (different in target vs destination)
# D  = Deleted (in destination, not in target)
```

#### chezmoi cat

Shows what the target state looks like:

```bash
# Show target state of file
chezmoi cat ~/.config/fish/config.fish

# Show target for template
chezmoi cat ~/.gitconfig
# Shows the rendered template output
```

#### chezmoi verify

Checks if destination matches target:

```bash
# Verify all files
chezmoi verify

# Exit codes:
# 0 = All files match
# 1 = Some files differ
```

#### chezmoi data

Shows template data available:

```bash
# Show all template data
chezmoi data

# Shows:
# - chezmoi variables (.chezmoi.hostname, etc.)
# - .chezmoidata contents
# - Config values
```

#### chezmoi doctor

Diagnoses chezmoi setup:

```bash
# Run diagnostics
chezmoi doctor

# Checks:
# - Chezmoi version
# - Git configuration
# - Editor settings
# - Tool availability (gpg, 1password, etc.)
```

### Git Integration Commands

Chezmoi wraps common git commands:

```bash
# Git status
chezmoi git status

# Git add
chezmoi git add .

# Git commit
chezmoi git commit -m "message"

# Git push
chezmoi git push

# Any git command
chezmoi git <any-git-command>
```

These commands run in the source directory without needing `chezmoi cd`.

---

## 8. Best Practices

### Always Preview Before Applying

**Never** apply changes without reviewing them:

```bash
# ❌ Bad: Apply blindly
chezmoi apply

# ✅ Good: Review first
chezmoi diff
chezmoi apply
```

**Why**: Prevent accidental overwrites or broken configurations.

### Use Descriptive Commit Messages

Follow conventional commits:

```bash
# ❌ Bad
git commit -m "update"

# ✅ Good
git commit -m "feat: add Neovim LSP configuration for Python"
```

**Format**:

- `feat:` - New features or configurations
- `fix:` - Bug fixes or corrections
- `docs:` - Documentation updates
- `refactor:` - Restructuring without changing behavior
- `chore:` - Maintenance tasks

### Commit Changes Regularly

Don't let changes pile up:

```bash
# After each logical change
chezmoi cd
git add .
git status
git diff --staged
git commit -m "feat: update configuration"
git push
exit
```

**Why**: Easier to track changes, rollback mistakes, and understand history.

### Test Changes Before Committing

Always verify configurations work:

```bash
# 1. Apply changes
chezmoi apply

# 2. Test the configuration
# (e.g., open a new shell, restart the tool)

# 3. If it works, commit
chezmoi cd
git add .
git commit -m "feat: update config"
git push
exit

# 4. If it doesn't work, fix it
chezmoi edit ~/.config/tool/config.yaml
# Repeat from step 1
```

### Use Templates for Machine-Specific Configs

Don't hardcode machine-specific values:

```bash
# ❌ Bad: Hardcoded hostname
export SERVER="my-laptop"

# ✅ Good: Use template
export SERVER="{{ .chezmoi.hostname }}"
```

### Keep Secrets in secrets/ Submodule

Never commit secrets directly:

```bash
# ❌ Bad: Secrets in main repo
dot_config/tool/config.yaml  # Contains API key

# ✅ Good: Secrets in submodule
secrets/private_dot_config/tool/config.yaml  # Contains API key
symlink_config.yaml.tmpl  # Links to it
```

**Or**: Use 1Password integration:

```go
api_key = {{ (onepassword "tool-credentials").fields.api_key | quote }}
```

### Use exact_ Carefully

Only use `exact_` when you're sure:

```bash
# ❌ Bad: exact_ on directory you manually add files to
dot_config/exact_scripts/

# ✅ Good: exact_ on managed plugin directory
dot_config/exact_nvim/
```

**Why**: `exact_` deletes untracked files. Make sure you won't lose anything important.

### Document Complex Templates

Add comments to explain template logic:

```go
{{- /* Determine SSH vs local machine based on hostname */ -}}
{{- if contains "ssh" .chezmoi.hostname -}}
# SSH server configuration
theme = "Paraiso Dark"
{{- else -}}
# Local machine configuration
theme = "tokyonight"
{{- end -}}
```

### Use Dry Run for Risky Operations

Test before applying:

```bash
# Preview what will happen
chezmoi apply --dry-run --verbose

# If it looks good, apply for real
chezmoi apply
```

### Keep Your Chezmoi Updated

Regularly update chezmoi itself:

```bash
# Check version
chezmoi doctor

# Update via Homebrew
brew upgrade chezmoi

# Or update via chezmoi update
chezmoi update
```

### Organize Files Logically

Mirror your home directory structure:

```
dot_config/
├── fish/
│   ├── config.fish
│   └── functions/
├── nvim/
│   └── init.lua
└── git/
    └── config
```

**Why**: Makes it easier to find and maintain configurations.

---

## 9. Common Pitfalls

### Editing Files in Home Directory

**Problem**: Editing `~/config.fish` instead of using `chezmoi edit`:

```bash
# ❌ Wrong: Edit destination directly
vim ~/.config/fish/config.fish
# Changes will be lost on next chezmoi apply!

# ✅ Right: Edit through chezmoi
chezmoi edit ~/.config/fish/config.fish
```

**Why**: Chezmoi overwrites destination with source state. Direct edits are lost.

**Recovery**:

```bash
# If you edited the wrong file, add it back
chezmoi add ~/.config/fish/config.fish
```

### Forgetting to Apply After Editing Source

**Problem**: Editing source but not applying changes:

```bash
cd ~/.local/share/chezmoi
vim dot_config/fish/config.fish
# Changes aren't live yet!

# ✅ Apply the changes
chezmoi apply
```

**Prevention**: Use `chezmoi edit` which auto-applies (if configured).

### Not Committing Changes

**Problem**: Making changes but not committing to git:

```bash
chezmoi edit ~/.config/fish/config.fish
chezmoi apply
# But never commit...
# Changes aren't backed up or portable!

# ✅ Commit regularly
chezmoi cd
git add .
git commit -m "feat: update fish config"
git push
exit
```

**Why**: Git is your backup and sync mechanism. No commit = no backup.

### Template Syntax Errors

**Problem**: Broken template syntax:

```go
# ❌ Wrong: Missing closing brace
{{ .chezmoi.hostname

# ❌ Wrong: Invalid Go template syntax
{{ if .chezmoi.hostname = "laptop" }}

# ✅ Right: Proper syntax
{{ .chezmoi.hostname }}
{{ if eq .chezmoi.hostname "laptop" }}
```

**Debugging**:

```bash
# Check for errors
chezmoi apply --verbose

# See rendered output
chezmoi cat ~/.config/file
```

### Using exact_ on the Wrong Directories

**Problem**: Using `exact_` on directories you manually add files to:

```bash
# ❌ Bad: exact_ on scripts directory
dot_config/exact_scripts/
# Any script you manually add will be deleted!

# ✅ Good: Use exact_ only on managed directories
dot_config/exact_nvim/
# Plugin directory that chezmoi fully manages
```

**Recovery**: Remove `exact_` prefix:

```bash
cd ~/.local/share/chezmoi
git mv dot_config/exact_scripts dot_config/scripts
```

### Broken Symlinks

**Problem**: Symlink template points to wrong location:

```go
# ❌ Wrong: Relative path
../cm-util/config.yaml

# ❌ Wrong: Missing template variables
/Users/hardcoded/.local/share/chezmoi/cm-util/config.yaml

# ✅ Right: Use template variables
{{ .chezmoi.sourceDir }}{{ .path.ctrld_configs }}/config.yaml
```

**Verification**:

```bash
# Check if symlink is valid
ls -la ~/Brewfile
# Should show valid symlink

# If broken, fix the template
chezmoi edit <symlink-template>
```

### Hardcoding Machine-Specific Values

**Problem**: Hardcoding values that differ per machine:

```bash
# ❌ Bad: Hardcoded path
export PATH="/Users/john/.local/bin:$PATH"

# ✅ Good: Use template variable
export PATH="{{ .chezmoi.homeDir }}/.local/bin:$PATH"
```

**Why**: Templates make configs portable across machines.

### Not Using --dry-run for Risky Changes

**Problem**: Applying changes without previewing:

```bash
# ❌ Risky: Apply without checking
chezmoi apply

# ✅ Safe: Preview first
chezmoi diff
chezmoi apply --dry-run --verbose
chezmoi apply
```

### Committing Secrets to Main Repository

**Problem**: Accidentally committing sensitive data:

```bash
# ❌ Bad: API key in main repo
dot_config/tool/config.yaml  # Contains secrets

# ✅ Good: Use secrets submodule or 1Password
secrets/private_dot_config/tool/config.yaml
# Or use 1Password template
```

**Prevention**:

- Use `secrets/` submodule for sensitive files
- Use 1Password integration
- Add `encrypted_` prefix for GPG encryption

### Mixing Up Source and Destination Paths

**Problem**: Using destination paths when source paths are needed:

```bash
# ❌ Wrong: Destination path
vim ~/.local/share/chezmoi/.config/fish/config.fish
# File doesn't exist!

# ✅ Right: Source path with naming conventions
vim ~/.local/share/chezmoi/dot_config/fish/config.fish

# ✅ Better: Use chezmoi edit
chezmoi edit ~/.config/fish/config.fish
```

---

## 10. Next Steps

### Recommended Reading

Now that you understand the chezmoi workflow, explore these resources:

#### In This Repository

- **[INSTALL.md](./INSTALL.md)** - Full installation guide
  - Setting up chezmoi from scratch
  - Installing dependencies
  - macOS-specific configuration

- **[docs/workflows/configuration-changes.md](./docs/workflows/configuration-changes.md)** - Detailed workflow procedures
  - Step-by-step modification procedures
  - Safety checks and validation
  - Troubleshooting guides

- **[docs/workflows/secrets-management.md](./docs/workflows/secrets-management.md)** - Handling sensitive data
  - 1Password integration
  - GPG encryption
  - Secrets submodule strategy

- **Tool-specific READMEs** - Configuration details
  - `dot_config/nvim/README.md` - Neovim setup
  - `dot_config/fish/README.md` - Fish shell
  - `dot_config/yabai/README.md` - Window management
  - And more...

#### Official Chezmoi Documentation

- [Chezmoi Quick Start](https://www.chezmoi.io/quick-start/)
- [User Guide](https://www.chezmoi.io/user-guide/)
- [Reference Manual](https://www.chezmoi.io/reference/)
- [Template Variables](https://www.chezmoi.io/reference/templates/)

### Practice Exercises

Solidify your understanding with these exercises:

#### Exercise 1: Edit and Apply a Configuration

```bash
# 1. Edit a configuration
chezmoi edit ~/.config/fish/config.fish

# 2. Add a comment at the top
# # Modified on YYYY-MM-DD

# 3. Preview changes
chezmoi diff

# 4. Apply changes
chezmoi apply

# 5. Verify
cat ~/.config/fish/config.fish

# 6. Commit
chezmoi cd
git add .
git commit -m "docs: add modification date to fish config"
git push
exit
```

#### Exercise 2: Add a New Configuration File

```bash
# 1. Create a new config file
echo "alias ll='ls -lah'" > ~/.config/fish/aliases.fish

# 2. Add to chezmoi
chezmoi add ~/.config/fish/aliases.fish

# 3. Verify it was added
chezmoi status

# 4. Check the source file
cat ~/.local/share/chezmoi/dot_config/fish/aliases.fish

# 5. Commit
chezmoi cd
git add .
git commit -m "feat: add fish shell aliases"
git push
exit
```

#### Exercise 3: Create a Template Configuration

```bash
# 1. Create a template
cat > ~/.local/share/chezmoi/dot_config/test/config.yaml.tmpl << 'EOF'
hostname: {{ .chezmoi.hostname }}
os: {{ .chezmoi.os }}
arch: {{ .chezmoi.arch }}
EOF

# 2. Apply
chezmoi apply ~/.config/test/config.yaml

# 3. View the result
cat ~/.config/test/config.yaml
# Should show your actual hostname, OS, arch

# 4. Commit
chezmoi cd
git add .
git commit -m "feat: add test template configuration"
git push
exit
```

#### Exercise 4: Create a Symlink to cm-util/

```bash
cd ~/.local/share/chezmoi

# 1. Create a config in cm-util/
mkdir -p cm-util/ctrld-configs/myapp
echo "version: 1.0" > cm-util/ctrld-configs/myapp/config.yaml

# 2. Create symlink template
mkdir -p dot_config/myapp
cat > dot_config/myapp/symlink_config.yaml.tmpl << 'EOF'
{{ .chezmoi.sourceDir }}{{ .path.ctrld_configs }}/myapp/config.yaml
EOF

# 3. Apply
chezmoi apply ~/.config/myapp/config.yaml

# 4. Verify symlink
ls -la ~/.config/myapp/config.yaml
# Should show symlink to cm-util/

# 5. Commit both files
git add cm-util/ctrld-configs/myapp/config.yaml
git add dot_config/myapp/symlink_config.yaml.tmpl
git commit -m "feat: add myapp configuration with symlink"
git push
```

### Common Tasks Quick Reference

#### Update Configuration on New Machine

```bash
# Pull latest changes
chezmoi update

# Or manually
chezmoi cd
git pull
exit
chezmoi apply
```

#### Sync Changes from Another Machine

```bash
# On machine 1: Make changes and push
chezmoi edit ~/.config/fish/config.fish
chezmoi cd && git add . && git commit -m "feat: update fish" && git push && exit

# On machine 2: Pull and apply
chezmoi update
```

#### Rollback a Bad Change

```bash
# Undo with git
chezmoi cd
git log  # Find the bad commit
git revert <commit-hash>
git push
exit

# Apply the rollback
chezmoi apply
```

#### View Diff for All Files

```bash
# See all pending changes
chezmoi diff

# See specific tool's changes
chezmoi diff | grep "config/fish"
```

### Getting Help

If you run into issues:

1. **Check diagnostics**: `chezmoi doctor`
2. **View verbose output**: `chezmoi apply --verbose`
3. **Check template data**: `chezmoi data`
4. **Read official docs**: <https://www.chezmoi.io/>
5. **Search issues**: <https://github.com/twpayne/chezmoi/issues>

### Workflow Mastery Checklist

You've mastered the chezmoi workflow when you can:

- [ ] Edit configurations using `chezmoi edit`
- [ ] Preview changes with `chezmoi diff`
- [ ] Apply changes confidently with `chezmoi apply`
- [ ] Commit changes to git regularly
- [ ] Understand naming conventions (`dot_`, `private_`, etc.)
- [ ] Create and use templates
- [ ] Work with symlinks to `cm-util/`
- [ ] Debug template errors
- [ ] Add new files to chezmoi
- [ ] Sync changes across machines
- [ ] Use `exact_` directories appropriately
- [ ] Keep secrets secure (1Password or `secrets/`)

---

## Summary

The chezmoi workflow enables safe, reproducible configuration management:

1. **EDIT** configurations with `chezmoi edit`
2. **DIFF** to preview changes with `chezmoi diff`
3. **APPLY** changes with `chezmoi apply`
4. **COMMIT** to git for backup and sync

Combined with:

- **Naming conventions** for file transformation
- **Templates** for machine-specific configs
- **Symlinks** for shared configurations
- **Best practices** for safe modifications

You now have the knowledge to confidently modify configurations on your first attempt, with the safety net of git version control and the power of templates for portability.

**Remember**: Always preview before applying, test before committing, and commit regularly. Your future self will thank you!

---

## 11. Pre-commit Hook System

### What are Pre-commit Hooks?

Pre-commit hooks are automated scripts that run **before** each git commit to validate your changes. This repository uses the [pre-commit framework](https://pre-commit.com/) to automatically scan for secrets and sensitive data before they are committed to version control.

**Key benefits**:

- **Prevent secret leaks**: Catch API keys, tokens, and credentials before they enter git history
- **Automated validation**: No need to remember to run security checks manually
- **Fast feedback**: Detect issues immediately, not after pushing to remote
- **Team consistency**: Everyone gets the same security checks

### Installed Pre-commit Hooks

This repository is configured with the following hooks in `.pre-commit-config.yaml`:

#### Gitleaks Secret Detection

**Repository**: `https://github.com/gitleaks/gitleaks`
**Version**: `v8.30.0`
**Hook ID**: `gitleaks`

Gitleaks scans your staged changes for over 100 types of secrets including:

- API keys and tokens (GitHub, AWS, Google Cloud, etc.)
- Private keys and certificates
- Database credentials
- OAuth tokens
- Generic high-entropy strings (potential secrets)

**How it works**:

```bash
# Runs automatically on git commit
git commit -m "your message"
# → Gitleaks scans staged files
# → Blocks commit if secrets detected
```

**When it runs**:

- On every `git commit` command
- Only scans **staged changes** (fast, not full history)
- Runs before commit is created

### Gitleaks Configuration

#### Default Configuration

This repository uses gitleaks' default secret detection rules (no custom `gitleaks.toml` file). The default configuration includes:

- **AWS secrets**: Access keys, secret keys, session tokens
- **GitHub tokens**: Personal access tokens, OAuth tokens
- **Google Cloud**: API keys, OAuth tokens
- **Private keys**: RSA, SSH, PGP keys
- **Generic patterns**: High-entropy strings, base64-encoded secrets
- **And 100+ more patterns**

See the [official gitleaks rules](https://github.com/gitleaks/gitleaks#configuration) for the complete list.

#### Custom Exceptions: .gitleaksignore

The `.gitleaksignore` file tells gitleaks to ignore specific false positives:

**File format**:

```
filepath:rule-id:line-number
```

**Current exceptions in this repository**:

```
.chezmoidata/pillager-rules.toml:private-key:16
.chezmoidata/pillager-rules.toml:private-key:26
.chezmoidata/pillager-rules.toml:private-key:46
dot_hammerspoon/Spoons/VimMode.spoon/lib/contextual_modal.lua:generic-api-key:78
docs/workflows/new-machine-setup.md:generic-api-key:271
```

**Why these are ignored**:

- `pillager-rules.toml` - Example patterns in documentation, not real keys
- `contextual_modal.lua` - String literal that looks like a key pattern
- `new-machine-setup.md` - Documentation example, not actual secret

#### Adding Entries to .gitleaksignore

When gitleaks reports a false positive:

**Step 1**: Identify the detection from gitleaks output:

```bash
git commit -m "message"
# Output shows:
# Finding:     some-string-that-looks-like-a-secret
# Secret:      generic-api-key
# File:        dot_config/tool/config.yaml
# Line:        42
```

**Step 2**: Add to `.gitleaksignore`:

```bash
cd ~/.local/share/chezmoi

# Format: filepath:rule-id:line-number
echo "dot_config/tool/config.yaml:generic-api-key:42" >> .gitleaksignore
```

**Step 3**: Commit both files:

```bash
git add .gitleaksignore dot_config/tool/config.yaml
git commit -m "feat: add tool config with gitleaks exception"
```

**Security considerations**:

- **Verify it's actually a false positive**: Double-check the detected string is not a real secret
- **Be specific**: Include line numbers to avoid blanket ignores
- **Document why**: Add a comment explaining why it's safe
- **Review regularly**: Periodically audit `.gitleaksignore` for outdated entries

### Secret Scanning Workflow

#### Normal Workflow (No Secrets Detected)

```bash
# 1. Stage your changes
git add dot_config/tool/config.yaml

# 2. Commit
git commit -m "feat: add tool configuration"

# → Pre-commit runs gitleaks automatically
# → Gitleaks scans: ✅ Passed
# → Commit succeeds

# 3. Push to remote
git push
```

#### When Secrets are Detected

**Scenario 1: False Positive**

```bash
# 1. Attempt commit
git commit -m "feat: add config"

# → Gitleaks detects: generic-api-key at line 42
# → Commit blocked

# 2. Verify it's not a real secret
cat dot_config/tool/config.yaml | sed -n '42p'
# example_api_key_format = "key-xxxx-yyyy"  # This is documentation

# 3. Add to .gitleaksignore
echo "dot_config/tool/config.yaml:generic-api-key:42" >> .gitleaksignore

# 4. Commit again
git add .gitleaksignore dot_config/tool/config.yaml
git commit -m "feat: add tool config with gitleaks exception"
# ✅ Succeeds
```

**Scenario 2: Real Secret Detected**

```bash
# 1. Attempt commit
git commit -m "feat: add API config"

# → Gitleaks detects: generic-api-key at line 15
# → Commit blocked

# 2. Verify it's a real secret
cat dot_config/tool/config.yaml | sed -n '15p'
# api_key = "sk_live_abc123xyz..."  # This IS a real secret!

# 3. DO NOT COMMIT THIS!
# Remove the secret from the file

# Option A: Move to secrets submodule
mv dot_config/tool/config.yaml secrets/private_dot_config/tool/config.yaml
git add secrets/private_dot_config/tool/config.yaml

# Option B: Use 1Password integration
# Edit the file to use template:
# api_key = {{ (onepassword "tool-credentials").fields.api_key | quote }}
chezmoi edit ~/.config/tool/config.yaml

# Option C: Encrypt with GPG
chezmoi add --encrypt ~/.config/tool/config.yaml

# 4. Commit the safe version
git add .
git commit -m "feat: add tool config (secret moved to secrets/)"
# ✅ Succeeds
```

### What Gets Scanned

Gitleaks scans:

- ✅ **All staged files**: Files you've `git add`-ed
- ✅ **Modified content**: Only the changed lines
- ✅ **New files**: Entire content of newly added files
- ✅ **File contents**: Text inside files

Gitleaks does NOT scan:

- ❌ **Unstaged changes**: Files modified but not `git add`-ed
- ❌ **Untracked files**: Files not yet added to git
- ❌ **Committed history**: Previous commits (use `gitleaks detect` for that)
- ❌ **Binary files**: Images, executables, etc.

### Handling Secrets Properly

#### 1. Move to Secrets Submodule

For configuration files containing secrets:

```bash
cd ~/.local/share/chezmoi

# Move to secrets/ directory
mv dot_config/tool/config.yaml secrets/private_dot_config/tool/config.yaml

# Secrets submodule is a separate private repository
# Commit there, not in main dotfiles repo
cd secrets
git add private_dot_config/tool/config.yaml
git commit -m "feat: add tool secrets"
git push
cd ..
```

#### 2. Use 1Password Integration

For dynamic secret injection:

```go
# In your template file (config.yaml.tmpl)
[api]
    key = {{ (onepassword "tool-credentials").fields.api_key | quote }}
    secret = {{ (onepassword "tool-credentials").fields.api_secret | quote }}
```

**Benefits**:

- Secrets stored securely in 1Password
- No secrets in git repository
- Easy to rotate credentials

#### 3. Use GPG Encryption

For encrypting entire files:

```bash
# Add file with encryption
chezmoi add --encrypt ~/.config/tool/config.yaml

# Creates: encrypted_dot_config/tool/config.yaml.asc
# Encrypted with your GPG passphrase

# Commit encrypted file
chezmoi cd
git add encrypted_dot_config/tool/config.yaml.asc
git commit -m "feat: add encrypted tool config"
git push
```

#### 4. Use Environment Variables

For runtime secrets:

```bash
# In config file, reference environment variable
api_key = "${TOOL_API_KEY}"

# Set in ~/.config/fish/config.fish
set -gx TOOL_API_KEY "your-secret-here"

# And add that file to secrets submodule
mv ~/.config/fish/config.fish secrets/private_dot_config/fish/config.fish
```

### Pre-commit Hook Setup

Pre-commit hooks are automatically installed during initial setup. To manually install or update:

#### Initial Installation

```bash
cd ~/.local/share/chezmoi

# Install pre-commit hooks
pre-commit install

# Verify installation
pre-commit --version
```

#### Update Hooks

```bash
cd ~/.local/share/chezmoi

# Update to latest hook versions
pre-commit autoupdate

# Commit updated config
git add .pre-commit-config.yaml
git commit -m "chore: update pre-commit hooks"
git push
```

#### Manual Hook Execution

Run hooks manually without committing:

```bash
cd ~/.local/share/chezmoi

# Run on all files (slow, thorough)
pre-commit run --all-files

# Run on specific files
pre-commit run --files dot_config/tool/config.yaml

# Run on staged files only (default)
pre-commit run
```

### Bypassing Hooks (Emergency Use Only)

**WARNING**: Bypassing hooks should be rare and only for emergencies.

```bash
# Skip all pre-commit hooks
git commit --no-verify -m "emergency commit"

# ⚠️ This bypasses security checks!
# Only use when absolutely necessary
```

**When to bypass**:

- Critical hotfix needed immediately
- Pre-commit hook has a bug
- Temporary workaround while debugging

**What to do after bypassing**:

```bash
# 1. Fix the issue that required bypass
# 2. Run hooks manually
pre-commit run --all-files

# 3. Address any issues found
# 4. Make a proper commit
git commit -m "fix: address issues found by pre-commit"
```

### Troubleshooting Pre-commit Hooks

#### Hook Fails on Every Commit

**Problem**: Gitleaks fails even with valid changes

**Diagnosis**:

```bash
cd ~/.local/share/chezmoi

# Run gitleaks manually to see detailed output
gitleaks detect --verbose --no-git

# Or just on staged files
gitleaks protect --verbose --staged
```

**Common causes**:

1. **Real secret detected**: Remove the secret (see "Handling Secrets Properly")
2. **False positive**: Add to `.gitleaksignore`
3. **Gitleaks configuration error**: Check `.pre-commit-config.yaml` syntax

**Solution**: See [TROUBLESHOOTING.md](./TROUBLESHOOTING.md#pre-commit-hooks-and-gitleaks) for detailed steps.

#### Slow Pre-commit Hooks

**Problem**: `git commit` takes a long time

**Cause**: Gitleaks scanning too many files

**Solution**:

```bash
# Verify hook is in "protect" mode (fast)
cat .pre-commit-config.yaml
# Should show: id: gitleaks

# If it's slow, ensure you're not in "detect" mode
# Protect mode only scans staged changes (fast)
# Detect mode scans entire repo history (slow)
```

#### Pre-commit Not Running

**Problem**: Hooks don't run on `git commit`

**Diagnosis**:

```bash
# Check if hooks are installed
ls -la .git/hooks/pre-commit

# Should show pre-commit script
```

**Solution**:

```bash
# Reinstall hooks
pre-commit install

# Verify
pre-commit run --all-files
```

### Best Practices for Secret Management

1. **Never commit secrets to the main repository**
   - Use `secrets/` submodule for sensitive configs
   - Use 1Password integration for API keys
   - Use GPG encryption for secret files

2. **Review gitleaks output carefully**
   - Don't blindly add to `.gitleaksignore`
   - Verify each detection is truly a false positive
   - Document why it's safe to ignore

3. **Keep .gitleaksignore minimal**
   - Only add confirmed false positives
   - Include line numbers for specificity
   - Review and clean up periodically

4. **Test hooks before pushing**

   ```bash
   # Run hooks manually before committing
   pre-commit run --all-files
   ```

5. **Update hooks regularly**

   ```bash
   # Keep gitleaks version current
   pre-commit autoupdate
   ```

6. **Educate team members**
   - Document common false positives
   - Share proper secret management workflows
   - Review `.gitleaksignore` in code reviews

### Integration with Chezmoi Workflow

Pre-commit hooks integrate seamlessly with the standard chezmoi workflow:

```bash
# 1. Edit configuration
chezmoi edit ~/.config/tool/config.yaml

# 2. Preview changes
chezmoi diff

# 3. Apply changes
chezmoi apply

# 4. Test the configuration
# (verify it works)

# 5. Commit to git
chezmoi cd
git add .
git status

# 6. Pre-commit hooks run automatically
git commit -m "feat: update tool configuration"
# → Gitleaks scans for secrets
# → ✅ Passed (or ❌ Blocked if secrets found)

# 7. Push if commit succeeded
git push
exit
```

**The pre-commit hook acts as a safety net**: It catches secrets before they enter git history, even if you forgot to check manually.

### Related Documentation

For more information on pre-commit hooks and secret management:

- **[TROUBLESHOOTING.md](./TROUBLESHOOTING.md#pre-commit-hooks-and-gitleaks)** - Detailed troubleshooting for hook failures
- **[INSTALL.md](./INSTALL.md#verification-checklist)** - Pre-commit setup verification steps
- **[docs/workflows/secrets-management.md](./docs/workflows/secrets-management.md)** - Comprehensive secrets workflow guide
- **[Gitleaks Documentation](https://github.com/gitleaks/gitleaks)** - Official gitleaks usage and configuration
- **[Pre-commit Documentation](https://pre-commit.com/)** - Pre-commit framework user guide

---

## Summary

The pre-commit hook system provides automated security checks before each commit, preventing accidental secret leaks. Combined with proper secret management (1Password, GPG encryption, secrets submodule), you can confidently version control your configurations without exposing sensitive data.

**Key takeaways**:

- Pre-commit hooks run automatically on `git commit`
- Gitleaks scans for 100+ types of secrets
- Use `.gitleaksignore` for false positives (carefully)
- Never commit real secrets - use proper secret management
- Bypass hooks only in emergencies with `--no-verify`
