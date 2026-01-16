# Chezmoi System Documentation

> **Note**: This document covers the technical architecture and configuration of chezmoi in this repository. For day-to-day workflow (how to edit, diff, apply, and commit changes), see the [Chezmoi Workflow Guide](../CHEZMOI.md).

## Table of Contents

1. [Overview](#overview)
2. [File Ignore Patterns (.chezmoiignore)](#file-ignore-patterns-chezmoiignore)
3. [Template System](#template-system)
4. [External Files (.chezmoiexternals)](#external-files-chezmoiexternals)
5. [Scripts (.chezmoiscripts)](#scripts-chezmoiscripts)
6. [Best Practices](#best-practices)
7. [Related Documentation](#related-documentation)

---

## Overview

### What is Chezmoi in This Configuration?

This dotfiles repository uses [chezmoi](https://www.chezmoi.io/) as a sophisticated dotfiles manager that goes beyond simple file synchronization. It provides:

**Core capabilities**:

- **Version control integration**: Git-based tracking of all configuration changes
- **Template processing**: Machine-specific configurations using Go templates
- **Automated setup**: Scripts that run during initialization and updates
- **Secret management**: Integration with GPG encryption and 1Password
- **File transformation**: Intelligent naming conventions for permissions and file types
- **Selective sync**: Ignore patterns to exclude files from public repositories

**Repository structure**:

```
~/.local/share/chezmoi/          # Source directory (git repository)
├── .chezmoiignore               # Files to exclude from target state
├── .chezmoi.toml.tmpl           # Chezmoi configuration (templated)
├── .chezmoiscripts/             # Automated setup scripts
├── .chezmoidata/                # Template data (TOML files)
├── .chezmoiexternals/           # External file definitions
├── cm-util/                     # Shared configurations (ignored)
├── secrets/                     # Private secrets submodule (ignored)
├── dot_config/                  # Configuration files
└── docs/                        # Documentation (this file)
```

**State model**:

- **Source State**: Files in `~/.local/share/chezmoi/` (git-tracked)
- **Target State**: Computed files after template rendering (machine-specific)
- **Destination State**: Actual dotfiles in `$HOME` (what applications read)

For basic chezmoi workflow (edit, diff, apply, commit), see the [Chezmoi Workflow Guide](../CHEZMOI.md) in the repository root.

---

## File Ignore Patterns (.chezmoiignore)

### Purpose and Security Considerations

The `.chezmoiignore` file controls which files from the **source directory** are excluded from the **target state**. This serves several critical purposes:

1. **Security**: Prevent sensitive files from being copied to `$HOME`
2. **Repository hygiene**: Exclude metadata and development files
3. **Public/private separation**: Keep private configs out of public sync
4. **Build artifacts**: Ignore generated files and caches

**Critical distinction**: `.chezmoiignore` affects **target state** (what gets applied to `$HOME`), not what gets committed to git. For git exclusions, use `.gitignore`.

### Current Ignore Patterns Explained

**File location**: `/Users/kirbylittle/.local/share/chezmoi/.chezmoiignore`

```bash
# https://www.chezmoi.io/reference/special-files-and-directories/chezmoiignore/
# Patterns added here will match against the target path and be ignored
# I.e., these will not be copied into the local environment
# `dir/**/*` will ignore all files in all subdirs, but still copy the empty dir.
# `dir` will ignore the dir and all its contents.
README.md
cm-util
secrets
.aiderignore
.aider.input.history
.aider.chat.history.md
.aider.tags*
```

**Pattern breakdown**:

#### 1. `README.md`

**Why**: Repository documentation file, not a configuration file
**Effect**: `~/README.md` is not created in your home directory
**Security**: Low - just keeps documentation in the repository
**Rationale**: The repository README is for GitHub, not for your home directory

#### 2. `cm-util`

**Why**: Shared configuration directory used only for symlink targets
**Effect**: `~/cm-util/` directory is never created
**Security**: Medium - prevents duplication and maintains symlink strategy
**Rationale**:

- Files in `cm-util/` are accessed through symlinks (e.g., `~/Brewfile` → `~/.local/share/chezmoi/cm-util/ctrld-configs/homebrew/Brewfile`)
- Creating `~/cm-util/` would duplicate these files unnecessarily
- Symlinks point to the **source directory**, not destination
- This pattern enables sharing configs between multiple tools

**Example**:

```bash
# Without ignore: Duplication
~/.local/share/chezmoi/cm-util/ctrld-configs/karabiner/karabiner.json
~/cm-util/ctrld-configs/karabiner/karabiner.json  # Duplicate!
~/.config/karabiner/karabiner.json → (symlink to source)

# With ignore: Clean symlink strategy
~/.local/share/chezmoi/cm-util/ctrld-configs/karabiner/karabiner.json
~/.config/karabiner/karabiner.json → ~/.local/share/chezmoi/cm-util/...
```

#### 3. `secrets`

**Why**: Private git submodule containing sensitive configuration files
**Effect**: `~/secrets/` is never created
**Security**: **CRITICAL** - prevents secrets from being exposed
**Rationale**:

- The `secrets/` directory contains sensitive data (API keys, credentials, private configs)
- It's a separate private git repository (submodule)
- Files are accessed through templates or symlinks, not direct copying
- This is the **primary security boundary** for sensitive data
- Prevents accidental exposure if dotfiles repository becomes public

**How secrets are used**:

```bash
# secrets/ is excluded from target state
# But templates can reference it:

# In a template file:
{{- $privateBashRc := (joinPath .chezmoi.sourceDir .path.secrets "private_dot_bashrc") -}}
{{- if (stat $privateBashRc) -}}
{{ include $privateBashRc | trim }}
{{- end -}}

# This includes content from secrets/ WITHOUT copying the directory
```

**Security impact**:

- **High**: If removed, secrets would be copied to `$HOME` and potentially synced to public repositories
- **Critical**: This pattern must NEVER be removed
- **Defense-in-depth**: Complements `.gitignore` (which prevents git commits) and public sync workflows

#### 4. `.aiderignore`, `.aider.input.history`, `.aider.chat.history.md`, `.aider.tags*`

**Why**: Development tool metadata for Aider AI coding assistant
**Effect**: Aider configuration files stay in source directory only
**Security**: Low - prevents clutter in home directory
**Rationale**:

- These files are specific to Aider when working on the dotfiles repository
- No reason to copy them to `$HOME`
- Keeps development metadata isolated
- The `.aider.tags*` pattern matches multiple tag cache files

**What are these files**:

- `.aiderignore`: Tells Aider which files to ignore in the repository
- `.aider.input.history`: Command history for Aider CLI
- `.aider.chat.history.md`: Conversation history with Aider
- `.aider.tags*`: Code tag caches for navigation

### Pattern Syntax Reference

Chezmoi ignore patterns use **glob syntax** and match against the **target path** (the destination path after name transformations):

**Basic syntax**:

```bash
# Exact match
filename.txt           # Matches ~/filename.txt

# Wildcard (single directory)
*.log                  # Matches ~/debug.log, ~/app.log
test_*                 # Matches ~/test_file, ~/test_data

# Recursive wildcard (all subdirectories)
**/*.tmp               # Matches ~/dir/file.tmp, ~/a/b/c/test.tmp

# Directory (exclude all contents)
directory              # Matches ~/directory and everything inside
directory/             # Same as above (trailing slash optional)

# Files in subdirectories only
directory/**/*         # Matches files inside but keeps empty dir
```

**Important**: Patterns match the **target path**, not the source path. Source transformations happen **before** ignore patterns are applied:

```bash
# Source file: dot_config/tool/config.yaml
# Target path: ~/.config/tool/config.yaml
# Ignore pattern should match: .config/tool/config.yaml

# Example:
.config/tool/*.yaml    # Ignores ~/.config/tool/config.yaml
```

**Templated ignore patterns**:

You can use Go templates in `.chezmoiignore` for machine-specific exclusions:

```bash
# .chezmoiignore

# Ignore work configs on personal machines
{{ if ne .chezmoi.hostname "work-laptop" }}
.config/work/
{{ end }}

# Ignore personal configs on work machines
{{ if ne .chezmoi.hostname "personal-desktop" }}
.config/personal/
{{ end }}

# OS-specific ignores
{{ if ne .chezmoi.os "darwin" }}
.config/macos/
{{ end }}

{{ if ne .chezmoi.os "linux" }}
.config/linux/
{{ end }}
```

### Public Sync and GitHub Actions

This repository uses GitHub Actions to sync configurations to a public repository while respecting ignore patterns.

**Workflow files**:

- `.github/workflows/daily_sync_main.yaml` - Syncs `main` branch to public repo daily
- `.github/workflows/daily_sync_dev.yaml` - Syncs development branch daily

**How it works**:

1. Private repository (`dotfiles-private`) contains ALL configurations
2. GitHub Actions runs daily sync workflow
3. Workflow pulls from private repo, applies filters, pushes to public repo (`dotfiles`)
4. Public repo contains only non-sensitive configurations

**What gets excluded from public sync**:

- Files in `secrets/` directory (git submodule, separate repo)
- Files matched by `.chezmoiignore` (not applied to target state)
- Files in `.gitignore` (not committed to git at all)
- Encrypted files (if configured)

**Security layers**:

| Layer                 | File    | Purpose                                      | What it protects                                |
| --------------------- | ------- | -------------------------------------------- | ----------------------------------------------- |
| `.gitignore`          | Git     | Prevents files from being committed          | Build artifacts, local caches, temp files       |
| `.chezmoiignore`      | Chezmoi | Prevents files from being applied to `$HOME` | Shared configs, secrets directory, dev metadata |
| `secrets/` submodule  | Git     | Separate private repository                  | API keys, credentials, sensitive configs        |
| GitHub Actions filter | CI/CD   | Syncs only approved files to public repo     | Private information in public dotfiles          |

**Example flow**:

```
Source file: ~/.local/share/chezmoi/secrets/private_dot_bashrc

Git (.gitignore):
  ❌ Not in .gitignore → File IS committed to private repo

Chezmoi (.chezmoiignore):
  ✅ Matches pattern "secrets" → File NOT applied to ~/

GitHub Actions (public sync):
  ✅ In secrets/ submodule → File NOT synced to public repo

Result:
  - File exists in private repo
  - File NOT in home directory
  - File NOT in public repo
  - File accessible via templates in private repo
```

### When to Add Ignore Patterns

**Add to `.chezmoiignore` when**:

1. **Development metadata**: Files specific to working on the dotfiles repo

   ```bash
   .aider*
   .specify/
   .git/
   ```

2. **Shared configuration storage**: Directories used only as symlink targets

   ```bash
   cm-util
   pkg-backups
   ```

3. **Secrets and sensitive data**: Private information that should never leave source directory

   ```bash
   secrets
   .env
   *.key
   ```

4. **Documentation**: README and docs that belong in the repo, not `$HOME`

   ```bash
   README.md
   LICENSE
   docs/
   specs/
   ```

5. **Build artifacts**: Generated files that shouldn't be in destination

   ```bash
   *.log
   *.cache
   .DS_Store
   ```

**Common mistake**: Don't confuse `.chezmoiignore` with `.gitignore`:

- `.gitignore`: Prevents git commits (affects source state)
- `.chezmoiignore`: Prevents applying to `$HOME` (affects target state)

**Example scenario**:

```bash
# You have: dot_config/tool/config.yaml
# You want: File in git, but NOT copied to ~/.config/tool/

# ❌ Wrong: Add to .gitignore
# Result: File not committed to git, lost

# ✅ Right: Add to .chezmoiignore
.config/tool/config.yaml

# Result: File in git, but not applied to ~/.config/tool/
```

### Verifying Ignore Patterns

**Test what will be applied**:

```bash
# List all files that WOULD be applied (respects .chezmoiignore)
chezmoi managed

# Check if a specific file is ignored
chezmoi managed | grep "secrets"
# No output = ignored

# Dry run to see what would be applied
chezmoi apply --dry-run --verbose
```

**Debug ignore patterns**:

```bash
# See what chezmoi thinks about a file
chezmoi target-path ~/.config/tool/config.yaml

# See source path for a target
chezmoi source-path ~/.config/tool/config.yaml

# Verify file is ignored
chezmoi cat ~/.secrets/test
# Error: file not managed by chezmoi
```

**Test template rendering in .chezmoiignore**:

```bash
# View rendered .chezmoiignore
chezmoi execute-template < .chezmoiignore

# Check what machine variables are available
chezmoi data | jq '.chezmoi'
```

---

## Template System

### Overview

Templates in chezmoi use [Go's text/template syntax](https://pkg.go.dev/text/template) to generate machine-specific configurations. Files ending in `.tmpl` are processed before being applied.

**Key features**:

- Conditional content based on OS, hostname, architecture
- Access to secrets from 1Password or environment variables
- Inclusion of external files
- Custom data from `.chezmoidata/` files
- Dynamic symlink target generation

**For detailed template usage**, see the [Template System](../CHEZMOI.md#4-template-system) section in the main chezmoi workflow guide.

### Template Data Sources

**Built-in chezmoi variables**:

```go
{{ .chezmoi.hostname }}          # Machine hostname
{{ .chezmoi.os }}                # darwin, linux, windows
{{ .chezmoi.arch }}              # arm64, amd64
{{ .chezmoi.homeDir }}           # /Users/username
{{ .chezmoi.sourceDir }}         # ~/.local/share/chezmoi
```

**Custom data from .chezmoidata/**:

Files in `.chezmoidata/` directory provide custom variables:

```
~/.local/share/chezmoi/.chezmoidata/
├── constants.toml               # Shared paths and constants
└── uv.toml                      # Python tool configurations
```

**Example: `constants.toml`**:

```toml
[path]
ctrld_configs = "/cm-util/ctrld-configs"
secrets = "/secrets"
templates = "/.chezmoitemplates"
```

**Accessing in templates**:

```go
# symlink_Brewfile.tmpl
{{ .chezmoi.sourceDir }}{{ .path.ctrld_configs }}/homebrew/Brewfile
```

**Prompt-based variables** (from `.chezmoi.toml.tmpl`):

```go
{{ .passphrase }}                # GPG encryption passphrase
{{ .secretsRepo }}               # Secrets repository URL
```

For comprehensive template examples and patterns, see:

- [Template System](../CHEZMOI.md#4-template-system) - Detailed syntax and examples
- [Multi-Machine Sync](workflows/multi-machine-sync.md) - Machine-specific templates

---

## External Files (.chezmoiexternals)

### Purpose

The `.chezmoiexternals/` directory contains TOML files that define external resources to be fetched and managed by chezmoi. These are typically git repositories that should be cloned into specific locations.

**Use cases**:

- Git repositories that should be managed as dotfiles
- Plugin directories for tools
- Shared configuration repositories
- External dependencies

### Current Configuration

**File location**: `/Users/kirbylittle/.local/share/chezmoi/.chezmoiexternals/git-repos.toml`

```toml
# If a URL to a repo containing secrets used in dotfiles was provided, add it as a git submodule.
{{ if ne .secretsRepo "" }}
["secrets"]
type = "git-repo"
url = {{ .secretsRepo | quote }}
branch = "main"
refreshPeriod = "8h"
clone.args = [{{ .secretsRepo | quote }}, "secrets"]
{{ end }}
```

**Explanation**:

1. **Conditional inclusion**: Only creates external if `.secretsRepo` is configured
2. **Type**: `git-repo` means this is a git repository
3. **URL**: Templated from prompt during `chezmoi init`
4. **Branch**: Tracks `main` branch
5. **Refresh period**: Checks for updates every 8 hours
6. **Clone args**: Additional arguments passed to `git clone`

**How it works**:

- During `chezmoi init`, user is prompted for secrets repository URL
- URL is stored in chezmoi config as `.secretsRepo`
- Template renders the external definition
- Chezmoi automatically clones the repository to `~/.local/share/chezmoi/secrets/`
- Repository is refreshed every 8 hours on `chezmoi update`

**Example flow**:

```bash
# During init
chezmoi init
# Prompt: Enter git@github.com URL to optional repo containing dotfile secrets
# Input: git@github.com:username/dotfiles-secrets.git

# Chezmoi stores in config:
# [data]
#     secretsRepo = "git@github.com:username/dotfiles-secrets.git"

# Template renders to:
["secrets"]
type = "git-repo"
url = "git@github.com:username/dotfiles-secrets.git"
branch = "main"
refreshPeriod = "8h"
clone.args = ["git@github.com:username/dotfiles-secrets.git", "secrets"]

# Chezmoi clones:
git clone git@github.com:username/dotfiles-secrets.git ~/.local/share/chezmoi/secrets/
```

### Adding External Repositories

To add a new external repository:

1. **Create a TOML file** in `.chezmoiexternals/`:

   ```bash
   # .chezmoiexternals/nvim-plugins.toml
   ["dot_config/nvim/pack/plugins/start/plugin-name"]
   type = "git-repo"
   url = "https://github.com/author/plugin-name.git"
   branch = "main"
   refreshPeriod = "168h"  # 1 week
   ```

2. **Apply the configuration**:

   ```bash
   chezmoi apply
   ```

3. **Verify the clone**:

   ```bash
   ls ~/.config/nvim/pack/plugins/start/plugin-name
   ```

**Refresh frequency options**:

- `"0"` - Never auto-refresh (manual only)
- `"1h"` - Every hour
- `"24h"` - Daily
- `"168h"` - Weekly (recommended for stable plugins)

---

## Scripts (.chezmoiscripts)

### Overview

Chezmoi scripts automate setup tasks during `chezmoi apply`. They run at specific times in the workflow and can be configured to run once or on every apply.

**Script naming convention**:

```
run_<timing>_<order>-<description>.sh[.tmpl]

Examples:
run_once_before_1-setup-secrets-submodule.sh.tmpl
run_once_after_1-install-homebrew.sh
run_after_1-setup-fish.sh
```

**Timing categories**:

- `run_once_before_*`: Runs once, before applying files (prerequisites)
- `run_once_after_*`: Runs once, after applying files (installations)
- `run_before_*`: Runs before every apply (maintenance)
- `run_after_*`: Runs after every apply (continuous setup)

**Order**: Scripts execute in numerical order within each timing category.

### Current Scripts

This repository has 6 scripts in `.chezmoiscripts/`:

| Order | Script                                              | Timing        | Purpose                                 |
| ----- | --------------------------------------------------- | ------------- | --------------------------------------- |
| 1     | `run_once_before_1-setup-secrets-submodule.sh.tmpl` | Before, once  | Initialize secrets git submodule        |
| 2     | `run_once_after_1-install-homebrew.sh`              | After, once   | Install Homebrew and run brew bundle    |
| 3     | `run_once_after_2-install-various.sh`               | After, once   | Install tools via curl, cargo, go, npm  |
| 4     | `run_once_after_3-install-uv-tools.sh.tmpl`         | After, once   | Install Python tools using uv           |
| 5     | `run_once_after_4-macos-settings.sh`                | After, once   | Configure macOS system settings         |
| 6     | `run_after_1-setup-fish.sh`                         | After, always | Link Fisher plugin files to Fish config |

**For detailed documentation** of each script, including:

- Full execution order
- Conditional logic (SSH vs local)
- Manual execution commands
- Troubleshooting steps

See: [.chezmoiscripts/README.md](../.chezmoiscripts/README.md)

### Script Templates

Scripts ending in `.tmpl` are processed as Go templates before execution:

```bash
# run_once_before_1-setup-secrets-submodule.sh.tmpl
#!/bin/bash

{{ if ne .secretsRepo "" }}
# Only create .gitmodules if secrets repo URL was provided
cat <<EOF > .gitmodules
[submodule "secrets"]
    path = secrets
    url = {{ .secretsRepo | quote }}
EOF
{{ end }}
```

**Template advantages**:

- Access to chezmoi variables (`.secretsRepo`, `.passphrase`, etc.)
- Conditional script content based on OS, hostname
- Dynamic configuration using data from `.chezmoidata/`

### Skipping Scripts

To temporarily disable scripts:

```bash
# Skip all scripts during apply
chezmoi apply --no-scripts

# Run a script manually
bash ~/.local/share/chezmoi/.chezmoiscripts/run_once_after_1-install-homebrew.sh
```

**Force re-run of one-time scripts**:

```bash
# Remove script state (re-runs ALL one-time scripts)
rm ~/.local/share/chezmoi/chezmoistate.boltdb
chezmoi apply

# Or manually run the script
bash ~/.local/share/chezmoi/.chezmoiscripts/run_once_after_1-install-homebrew.sh
```

---

## Best Practices

### 1. Understanding State Boundaries

**The three chezmoi states**:

```
┌─────────────────┐     ┌─────────────────┐     ┌──────────────────┐
│  Source State   │────▶│  Target State   │────▶│ Destination State│
│  (git repo)     │     │  (rendered)     │     │  ($HOME)         │
│                 │     │                 │     │                  │
│ .chezmoiignore  │     │ After ignore    │     │ After apply      │
│ affects nothing │     │ patterns        │     │                  │
│ here directly   │     │ applied here    │     │                  │
└─────────────────┘     └─────────────────┘     └──────────────────┘
```

**Key insights**:

- `.chezmoiignore` filters source → target (what gets applied)
- `.gitignore` filters what gets committed to source state
- GitHub Actions syncs from source state (respects git, not chezmoiignore)
- Secrets must be excluded at ALL levels (git, chezmoi, public sync)

### 2. Secrets Management Strategy

**Defense in depth**:

```
Layer 1: .gitignore
  Purpose: Prevent committing to git
  File: .gitignore
  Protects: Temporary credentials, local .env files

Layer 2: Separate repository
  Purpose: Isolated secrets repository
  File: secrets/ (git submodule)
  Protects: API keys, credentials, private configs
  Controlled by: .gitmodules

Layer 3: Chezmoi ignore
  Purpose: Prevent applying to $HOME
  File: .chezmoiignore
  Protects: Secrets directory, shared configs
  Pattern: "secrets"

Layer 4: Encryption
  Purpose: Encrypt individual files
  Method: GPG symmetric encryption
  Protects: Single sensitive files that must be in main repo

Layer 5: 1Password
  Purpose: Dynamic secret retrieval
  Method: Templates with onepasswordRead
  Protects: Rotating credentials, shared team secrets
```

**Decision tree for storing secrets**:

```
Is this a team secret that rotates?
├─ YES → Use 1Password integration (onepasswordRead)
└─ NO → Continue

    Is this a single sensitive file?
    ├─ YES → Use GPG encryption (encrypted_ prefix)
    └─ NO → Continue

        Does this involve multiple related files?
        ├─ YES → Use secrets/ submodule (separate private repo)
        └─ NO → Reconsider if this is actually a secret
```

### 3. Ignore Pattern Guidelines

**Patterns to always include**:

```bash
# .chezmoiignore

# Repository documentation and metadata
README.md
LICENSE
.gitignore
.github/

# Secrets (CRITICAL)
secrets

# Shared config storage (symlink targets)
cm-util

# Development tools
.aider*
.specify/
specs/

# Build artifacts
*.log
*.cache
.DS_Store
```

**Machine-specific ignores**:

```bash
# .chezmoiignore

# Work-specific configs (ignore on personal machines)
{{ if ne .chezmoi.hostname "work-laptop" }}
.config/work/
{{ end }}

# GUI apps (ignore on SSH servers)
{{ if env "SSH_CONNECTION" }}
.config/hammerspoon/
.config/yabai/
{{ end }}
```

### 4. Template Best Practices

**Use templates for**:

- Machine-specific paths and settings
- Symlink target generation (required)
- OS-specific configurations
- Hostname-based conditional content

**Don't use templates for**:

- Static configuration that's the same everywhere
- Files that will never change between machines
- Simple text files without variables

**Template performance**:

```go
# ❌ Bad: Template with no variables
# config.yaml.tmpl
setting: value
another: option

# ✅ Good: Regular file
# config.yaml
setting: value
another: option
```

### 5. Script Execution Principles

**Design scripts to be idempotent**:

```bash
# ✅ Good: Check before installing
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# ❌ Bad: Always tries to install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**Use conditional execution for environment-specific tasks**:

```bash
# run_once_after_2-install-various.sh
if [ -z "$SSH_CONNECTION" ]; then
    # Local machine only: Install GUI apps
    brew install --cask hammerspoon
fi
```

**Order scripts by dependency**:

```
1. run_once_before_*: Prerequisites (git submodules, directories)
2. run_once_after_1-*: Package managers (Homebrew)
3. run_once_after_2-*: Tools requiring package manager
4. run_once_after_3-*: Language-specific tools
5. run_once_after_4-*: System settings
```

### 6. Testing Changes Before Committing

**Always preview before applying**:

```bash
# See what would change
chezmoi diff

# Dry run with verbose output
chezmoi apply --dry-run --verbose

# Apply single file for testing
chezmoi apply ~/.config/fish/config.fish

# Verify it works, THEN apply everything
chezmoi apply
```

**Test templates on target machines**:

```bash
# Preview rendered template
chezmoi cat ~/.config/fish/config.fish

# Test template syntax
chezmoi execute-template '{{ .chezmoi.hostname }}'

# Verify template data
chezmoi data
```

### 7. Commit Hygiene

**Meaningful commit messages**:

```bash
# ✅ Good: Descriptive and follows convention
git commit -m "feat(fish): add alias for git status with branch info"
git commit -m "fix(nvim): correct LSP configuration for Python"
git commit -m "docs(chezmoi): add ignore patterns explanation"

# ❌ Bad: Vague or no context
git commit -m "update"
git commit -m "fixes"
```

**Commit frequently with logical groupings**:

```bash
# ✅ Good: One logical change per commit
git add dot_config/fish/config.fish
git commit -m "feat(fish): add git aliases"

git add dot_config/starship.toml
git commit -m "feat(starship): customize prompt with git status"

# ❌ Bad: Unrelated changes in one commit
git add .
git commit -m "various updates"
```

---

## Related Documentation

### Workflow Guides

- [Chezmoi Workflow Guide](../CHEZMOI.md) - Complete chezmoi workflow (edit, diff, apply, commit)
- [workflows/configuration-changes.md](workflows/configuration-changes.md) - Step-by-step modification procedures
- [workflows/secrets-management.md](workflows/secrets-management.md) - Handling secrets and sensitive data
- [workflows/multi-machine-sync.md](workflows/multi-machine-sync.md) - Syncing configurations across machines

### Setup and Troubleshooting

- [INSTALL.md](../INSTALL.md) - Initial installation and setup
- [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) - Common issues and solutions
- [.chezmoiscripts/README.md](../.chezmoiscripts/README.md) - Automated setup scripts documentation

### Architecture and Reference

- [ARCHITECTURE.md](ARCHITECTURE.md) - System architecture and component interactions
- [KEYMAPS.md](KEYMAPS.md) - Unified keymap reference across all tools

### Official Chezmoi Documentation

- [Chezmoi Quick Start](https://www.chezmoi.io/quick-start/) - Official getting started guide
- [Chezmoi User Guide](https://www.chezmoi.io/user-guide/) - Comprehensive usage documentation
- [Chezmoi Reference](https://www.chezmoi.io/reference/) - Complete reference manual
- [Template Variables](https://www.chezmoi.io/reference/templates/) - Go template syntax and functions
- [.chezmoiignore Reference](https://www.chezmoi.io/reference/special-files-and-directories/chezmoiignore/) - Ignore pattern documentation

---

**Last Updated**: 2025-12-12
**Chezmoi Version**: v2.0.0+
**Related**: [Task T051](../specs/001-comprehensive-docs/tasks.md#phase-9-polish--cross-cutting-concerns)
