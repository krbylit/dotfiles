# Dotfiles

Personal macOS development environment managed with [chezmoi](https://www.chezmoi.io/).

## Table of Contents

- [Quick Start](#quick-start)
- [What's Included](#whats-included)
- [Core Tools](#core-tools)
  - [Priority 1: Essential Configuration](#priority-1-essential-configuration)
  - [Priority 2: Supporting Tools](#priority-2-supporting-tools)
  - [Priority 3: Supplementary Tools](#priority-3-supplementary-tools)
- [Documentation](#documentation)
  - [Getting Started](#getting-started)
  - [Reference Guides](#reference-guides)
  - [Workflows](#workflows)
  - [Tool-Specific Documentation](#tool-specific-documentation)
- [Key Features](#key-features)
  - [Secrets Management](#secrets-management)
  - [Multi-Machine Support](#multi-machine-support)
  - [Automation Scripts](#automation-scripts)
  - [Quality Gates](#quality-gates)
- [Common Tasks](#common-tasks)
  - [Making Configuration Changes](#making-configuration-changes)
  - [Syncing Multiple Machines](#syncing-multiple-machines)
  - [Finding Keyboard Shortcuts](#finding-keyboard-shortcuts)
  - [Troubleshooting Common Issues](#troubleshooting-common-issues)
- [Manual Dependencies](#manual-dependencies)
- [Chezmoi Quick Reference](#chezmoi-quick-reference)
  - [Essential Commands](#essential-commands)
  - [State Terminology](#state-terminology)
  - [File Naming Conventions](#file-naming-conventions)
- [Secrets and Encryption](#secrets-and-encryption)
  - [GPG Encryption](#gpg-encryption)
  - [1Password Integration](#1password-integration)
  - [Pre-commit Secret Scanning](#pre-commit-secret-scanning)
- [GitHub Actions](#github-actions)
- [Neovim Configuration](#neovim-configuration)
- [Support](#support)
  - [Getting Help](#getting-help)
  - [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)

## Quick Start

**New to these dotfiles?** Start here:

1. **[Installation Guide](./INSTALL.md)** - Complete setup instructions for fresh macOS installation (~60 minutes)
2. **[Chezmoi Workflow](./CHEZMOI.md)** - How to make configuration changes safely *(coming soon)*
3. **[Keymaps Reference](./docs/KEYMAPS.md)** - Find any keyboard shortcut across all tools *(coming soon)*
4. **[Troubleshooting](./TROUBLESHOOTING.md)** - Common issues and solutions *(coming soon)*

## What's Included

This repository contains configurations for a complete macOS development environment with:

- **Shell**: Fish with Starship prompt and 77+ custom functions
- **Editor**: Neovim with LSP, plugins, and extensive customization
- **Window Management**: Yabai + skhd + Karabiner for tiling and keyboard-driven workflow
- **Terminal**: Ghostty, Tmux, Zellij for multiplexing
- **Git**: Custom aliases, Delta diff viewer, lazygit TUI
- **File Management**: Yazi TUI file manager with custom keybindings
- **Development Tools**: Language servers, formatters, linters, and build tools
- **Security**: Pre-commit hooks with gitleaks, GPG encryption, secrets management

## Core Tools

### Priority 1: Essential Configuration

| Tool | Purpose | Config Location |
|------|---------|----------------|
| **Fish Shell** | Primary shell with 77+ custom functions | `dot_config/fish/` |
| **Neovim** | Primary text editor with LSP and plugins | `dot_config/exact_nvim/` |
| **Yabai** | Tiling window manager | `dot_config/exact_yabai/` |
| **Skhd** | Hotkey daemon for window management | `dot_config/exact_skhd/` |
| **Karabiner** | Hardware keyboard remapping | `dot_config/karabiner/` |
| **Git** | Version control with Delta diff viewer | `dot_gitconfig`, `dot_config/git/` |
| **Starship** | Shell prompt | `dot_config/starship.toml` |
| **Chezmoi** | Dotfiles management | `.chezmoi.toml.tmpl`, `.chezmoiscripts/` |

### Priority 2: Supporting Tools

| Tool | Purpose | Config Location |
|------|---------|----------------|
| **Ghostty** | Terminal emulator | `dot_config/ghostty/` |
| **Tmux** | Terminal multiplexer | `dot_config/tmux/` |
| **Zellij** | Modern terminal workspace | `dot_config/zellij/` |
| **Yazi** | TUI file manager | `dot_config/yazi/` |
| **Lazygit** | TUI git client | `dot_config/lazygit/` |
| **Lazydocker** | TUI docker client | `dot_config/lazydocker/` |
| **Atuin** | Shell history with sync | `dot_config/atuin/` |
| **Bat** | Enhanced `cat` with syntax highlighting | `dot_config/bat/` |
| **Bottom/Btop** | System monitoring | `dot_config/bottom/`, `dot_config/btop/` |
| **Ripgrep** | Fast text search | `dot_config/ripgrep/` |

### Priority 3: Supplementary Tools

Additional configured tools: AiChat, Delta, Eza, Fish plugins (Fisher), FZF, Television, and more. See `Brewfile` for the complete list of 100+ installed packages.

## Documentation

### Getting Started

- **[INSTALL.md](./INSTALL.md)** - Step-by-step installation guide
- **[CHEZMOI.md](./CHEZMOI.md)** - Chezmoi workflow for configuration changes *(coming soon)*

### Reference Guides

- **[docs/KEYMAPS.md](./docs/KEYMAPS.md)** - Unified keyboard shortcuts reference *(coming soon)*
- **[docs/ARCHITECTURE.md](./docs/ARCHITECTURE.md)** - System architecture and tool interactions *(coming soon)*
- **[docs/DESIGN.md](./docs/DESIGN.md)** - Design philosophy and rationale *(coming soon)*

### Workflows

- **[docs/workflows/new-machine-setup.md](./docs/workflows/new-machine-setup.md)** - Setting up additional machines *(coming soon)*
- **[docs/workflows/configuration-changes.md](./docs/workflows/configuration-changes.md)** - Making safe modifications *(coming soon)*
- **[docs/workflows/multi-machine-sync.md](./docs/workflows/multi-machine-sync.md)** - Keeping machines in sync *(coming soon)*
- **[docs/workflows/secrets-management.md](./docs/workflows/secrets-management.md)** - Managing secrets and encryption

### Tool-Specific Documentation

Each major tool has its own README with configuration details and customization guides:

- [Fish Shell](./dot_config/fish/README.md) - Shell configuration and custom functions
- [Neovim](./dot_config/exact_nvim/README.md) - Editor plugins and LSP setup
- [Yabai](./dot_config/yabai/README.md) - Window management rules
- [Skhd](./dot_config/skhd/README.md) - Hotkey configuration
- [Karabiner](./dot_config/karabiner/README.md) - Hardware key remapping
- [Chezmoi Scripts](./.chezmoiscripts/README.md) - Automation scripts and execution order

## Key Features

### Secrets Management

This repository uses a multi-layered approach to secrets:

- **Git submodule** (`secrets/`) for sensitive configuration files
- **GPG encryption** for individual encrypted files (using `encrypted_*` prefix)
- **1Password integration** for programmatic secret access
- **Pre-commit scanning** with gitleaks to prevent accidental secret commits

See [docs/workflows/secrets-management.md](./docs/workflows/secrets-management.md) for detailed workflows.

### Multi-Machine Support

The configuration automatically detects SSH vs local machines and adjusts:

- **Local machines**: Full GUI applications (Hammerspoon, Cursor, Ghostty, etc.)
- **Remote SSH machines**: Minimal CLI-only setup via `Brewfile_ssh`
- **Machine-specific configs**: Use `.chezmoidata/` for machine-specific settings

### Automation Scripts

Six chezmoi scripts handle setup automatically:

1. **Secrets submodule initialization** - Sets up private secrets repository
2. **Homebrew installation** - Installs Homebrew and runs `brew bundle`
3. **Additional tools** - Installs tools not in Homebrew
4. **Python tools via uv** - Manages Python development tools
5. **macOS settings** - Configures system preferences
6. **Fish setup** - Links Fisher plugin files

See [.chezmoiscripts/README.md](./.chezmoiscripts/README.md) for execution order and details.

### Quality Gates

- **Pre-commit hooks**: Gitleaks scans for secrets before every commit
- **Code formatters**: Stylua, fish_indent, shfmt, prettierd, yapf
- **Linters**: Configured for Python, JavaScript/TypeScript, and shell scripts

## Common Tasks

### Making Configuration Changes

```bash
# Edit a configuration file
chezmoi edit ~/.config/fish/config.fish

# Preview changes before applying
chezmoi diff

# Apply changes to your system
chezmoi apply

# Commit changes to repository
cd ~/.local/share/chezmoi
git add .
git commit -m "Update fish config"
git push
```

See [CHEZMOI.md](./CHEZMOI.md) for the complete workflow *(coming soon)*.

### Syncing Multiple Machines

```bash
# Pull latest changes from repository
chezmoi update

# Push local changes to repository
cd ~/.local/share/chezmoi
git push
```

### Finding Keyboard Shortcuts

See [docs/KEYMAPS.md](./docs/KEYMAPS.md) for searchable keymap reference across all layers *(coming soon)*.

### Troubleshooting Common Issues

See [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) for solutions to common problems *(coming soon)*.

## Manual Dependencies

These tools are not installed automatically and require manual installation:

- **Docker Desktop**: Download from [docker.com](https://www.docker.com/products/docker-desktop)
- **YabaiIndicator**: Menu bar status for yabai - [GitHub](https://github.com/xiamaz/YabaiIndicator)
- **Firefox Extensions** (if using Firefox):
  - [Sidebery](https://addons.mozilla.org/en-US/firefox/addon/sidebery/) - Container management
  - [Vimium](https://addons.mozilla.org/en-US/firefox/addon/vimium-ff/) - Vim-like navigation
  - [Firenvim](https://addons.mozilla.org/en-US/firefox/addon/firenvim/) - Neovim in browser

### Optional: Vim Motion Apps for macOS

Tools for Vim-like navigation system-wide:

- [Homerow](https://www.homerow.app/) - Vimium-like labeled-link navigation (highly recommended)
- [kindaVim](https://github.com/godbout/kindaVim.blahblah) - Vim motions for text editing
- [ti-vim](https://vim.tonisives.com/index.html) - Alternative Vim motion implementation
- [Wooshy](https://wooshy.app/) - Mouse-free interaction
- [Scrolla](https://scrolla.app/) - Scrolling enhancements

## Chezmoi Quick Reference

### Essential Commands

```bash
# Edit files in chezmoi source state
chezmoi edit <file>

# Show differences between source and destination
chezmoi diff

# Apply changes from source to destination
chezmoi apply

# Pull latest changes and apply
chezmoi update

# Change to chezmoi source directory
chezmoi cd
```

### State Terminology

- **Source state**: Files in `~/.local/share/chezmoi/` (the chezmoi directory)
- **Destination state**: Current files in your home directory
- **Target state**: Desired state that chezmoi will apply

### File Naming Conventions

- `dot_*` → `.` (dotfiles)
- `exact_*` → Directory managed exactly (removes untracked files)
- `private_*` → File with restricted permissions (0600)
- `executable_*` → File with execute permissions
- `symlink_*` → Symbolic link
- `encrypted_*` → GPG-encrypted file
- `*.tmpl` → Template file (processed with Go templates)

See [CHEZMOI.md](./CHEZMOI.md) for detailed explanations *(coming soon)*.

## Secrets and Encryption

### GPG Encryption

Files with `encrypted_` prefix are automatically encrypted/decrypted by chezmoi:

```bash
# Add an encrypted file
chezmoi add --encrypt ~/.config/tool/secret-config.conf

# Edit encrypted files
chezmoi edit ~/.config/tool/encrypted_secret-config.conf
```

### 1Password Integration

Configuration uses 1Password service accounts:

- Set `OP_SERVICE_ACCOUNT_TOKEN` environment variable
- Configured for `onepassword.mode="service"` in `.chezmoi.toml`
- Access secrets in templates: `{{ (onepassword "item-name").password }}`

### Pre-commit Secret Scanning

Gitleaks automatically scans every commit for potential secrets:

```bash
# Manually scan repository
cd ~/.local/share/chezmoi
pre-commit run --all-files

# Scan including git history
gitleaks detect --report-path gitleaks-report.json
```

See `.gitleaksignore` to suppress false positives.

## GitHub Actions

This repository syncs between private and public versions:

- **Private repository**: Contains all configurations including secrets
- **Public repository**: Sanitized version excluding secrets and encrypted files
- **Workflows**: `daily_sync_main.yaml` and `daily_sync_dev.yaml` automate synchronization

Files excluded from public sync are defined in `.chezmoiignore`.

## Neovim Configuration

The Neovim configuration is managed with chezmoi.nvim:

```bash
# Edit Neovim config
vc  # Fish function alias for editing vim config

# Manual editing
chezmoi edit ~/.config/nvim/lua/config/keymaps.lua
```

**Note**: Changes made in `~/.local/share/chezmoi` are automatically applied to the target state when using `chezmoi.nvim`, so you don't need to run `chezmoi apply` manually.

## Support

### Getting Help

1. **Check [TROUBLESHOOTING.md](./TROUBLESHOOTING.md)** for comprehensive troubleshooting coverage:
   - macOS accessibility and Input Monitoring permissions
   - Pre-commit hooks and gitleaks errors
   - Neovim LSP issues and Mason setup
   - Chezmoi apply conflicts and template errors
   - GitHub Actions sync failures
   - Shell, terminal, and tool-specific issues
2. Review tool-specific READMEs in `~/.config/<tool>/README.md`
3. Consult official tool documentation (linked in each README)
4. Search GitHub issues in this repository

### Contributing

To improve this configuration:

1. Use the chezmoi workflow: `chezmoi edit <file>`
2. Test changes locally before committing
3. Follow existing patterns and conventions
4. Update relevant documentation
5. Run pre-commit hooks: `pre-commit run --all-files`
6. Submit changes via pull request

## License

Personal dotfiles configuration. Feel free to use as reference or fork for your own use.

## Acknowledgments

Built on the shoulders of:

- [chezmoi](https://www.chezmoi.io/) - Dotfiles management
- [Fish shell](https://fishshell.com/) - Friendly interactive shell
- [Neovim](https://neovim.io/) - Hyperextensible Vim-based text editor
- [Yabai](https://github.com/koekeishiya/yabai) - Tiling window manager
- [Starship](https://starship.rs/) - Cross-shell prompt

And the countless open-source projects that make this development environment possible.
