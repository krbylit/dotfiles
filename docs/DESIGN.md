# Design Philosophy

This document explains the design philosophy, architectural decisions, and rationale behind this dotfiles configuration. It serves as a guide for understanding why tools were chosen, how they work together, and the principles that guide configuration decisions.

## Table of Contents

1. [Overview](#overview)
2. [Design Principles](#design-principles)
3. [Tool Selection Rationale](#tool-selection-rationale)
4. [Secrets Management Strategy](#secrets-management-strategy)
5. [Symlink vs Copy Strategy](#symlink-vs-copy-strategy)
6. [Architecture Decisions](#architecture-decisions)
7. [Trade-offs and Alternatives Considered](#trade-offs-and-alternatives-considered)

---

## Overview

This dotfiles configuration is designed for a keyboard-driven macOS development workflow with a focus on:

- **Reproducibility**: Complete environment setup from a fresh macOS installation
- **Maintainability**: Clear structure with modular configuration files
- **Security**: Multi-layered secrets management with pre-commit scanning
- **Portability**: Support for both local and SSH machines with machine-specific adaptations
- **Performance**: Fast shell startup, lazy-loaded plugins, and optimized tool configurations
- **Consistency**: Unified color schemes (Catppuccin Macchiato) and keybinding patterns across all tools

The system is built on chezmoi for dotfile management, with approximately 100+ tools orchestrated through Homebrew, and a comprehensive configuration spanning shell, editor, window management, and development tools.

---

## Design Principles

### 1. Keyboard-First Workflow

**Principle**: Minimize mouse usage through comprehensive keyboard shortcuts and vim-style bindings.

**Implementation**:

- **Karabiner-Elements**: Low-level key remapping (e.g., Alt+h/j/k/l → arrow keys in terminals)
- **skhd**: Hotkey daemon for window management commands
- **Yabai**: Tiling window manager with keyboard-driven navigation
- **Fish + Vi-mode**: Modal shell editing with vim keybindings
- **Neovim**: Primary editor with extensive vim bindings
- **Yazi**: TUI file manager with vim navigation

**Rationale**: Keyboard-driven workflows are faster, more ergonomic, and reduce context-switching between keyboard and mouse. This design choice prioritizes efficiency for developers who spend extended periods in terminal and editor environments.

### 2. Modularity and Separation of Concerns

**Principle**: Each tool has a single, well-defined responsibility. Configuration is organized by tool and purpose.

**Implementation**:

- **Layer separation**: Input (Karabiner) → Hotkeys (skhd) → Window Management (Yabai)
- **Shell modularity**: Fish configuration split into `conf.d/` files by domain
- **Plugin architecture**: Neovim plugins organized by functionality (~54 plugin specs)
- **Tool-specific READMEs**: Each configuration directory documents its purpose and usage

**Rationale**: Modular systems are easier to debug, maintain, and extend. If a component fails, it doesn't bring down the entire system. New tools can be added without refactoring existing configurations.

### 3. Documentation as Code

**Principle**: Configuration files are self-documenting through inline comments and companion README files.

**Implementation**:

- **Inline comments**: Every non-obvious configuration line includes explanatory comments
- **Tool READMEs**: `dot_config/<tool>/README.md` documents architecture and usage
- **Workflow guides**: Step-by-step procedures in `docs/workflows/`
- **Reference documentation**: `docs/KEYMAPS.md`, `docs/ARCHITECTURE.md`, this file

**Rationale**: Future-you (and other users) won't remember why a specific configuration choice was made. Documentation prevents cargo-cult programming and enables confident modifications.

### 4. Security by Default

**Principle**: Secrets never appear in the main repository, and multiple layers prevent accidental leaks.

**Implementation**:

- **Secrets submodule**: Private git repository for sensitive files (excluded from target state)
- **GPG encryption**: Symmetric encryption for individual secret files
- **1Password integration**: Dynamic secret retrieval without disk storage
- **Pre-commit scanning**: Gitleaks prevents accidental secret commits
- **Gitignore patterns**: Aggressive exclusion of sensitive file types

**Rationale**: A single leaked secret can compromise entire systems. Defense in depth ensures that even if one layer fails (e.g., accidentally adding a file), other layers (pre-commit hooks, encryption) catch the mistake.

### 5. Graceful Degradation

**Principle**: The system works on minimal installations and degrades gracefully when tools are missing.

**Implementation**:

- **SSH vs local detection**: Different Brewfile installations for remote machines
- **Conditional tool loading**: Fish checks for tool existence before initialization
- **Fallback mechanisms**: If Starship isn't installed, Fish still works
- **Optional dependencies**: Core functionality doesn't require all 100+ tools

**Rationale**: Not every machine needs the full setup. SSH servers don't need GUI applications. Development laptops may not have all tools installed immediately. The configuration should work in all contexts.

### 6. Performance Optimization

**Principle**: Fast shell startup and responsive tools through lazy loading and caching.

**Implementation**:

- **Fish startup**: ~50ms through modular `conf.d/` loading
- **Starship**: Parallel module execution for prompt rendering
- **Neovim lazy loading**: Plugins load on-demand via Lazy.nvim
- **Zoxide**: Async database updates to avoid blocking shell
- **Chezmoi caching**: Template results cached to avoid recomputation

**Rationale**: Slow tools disrupt flow state. A 500ms shell startup adds up to minutes wasted daily. Performance isn't premature optimization—it's user experience.

### 7. Declarative Configuration

**Principle**: Configuration declares desired state, not imperative steps to achieve it.

**Implementation**:

- **Chezmoi**: Declares target state, applies differences
- **Brewfile**: Lists packages, Homebrew handles installation
- **Neovim lazy.nvim**: Plugin specs declare dependencies and load conditions
- **Fish functions**: Declarative syntax over bash scripting

**Rationale**: Declarative systems are easier to reason about, test, and maintain. You see what the end state should be, not the steps to get there. This also enables idempotent operations—running setup twice produces the same result.

---

## Tool Selection Rationale

### Shell: Fish Shell

**Why Fish over Bash/Zsh?**

- **Out-of-the-box features**: Syntax highlighting, autosuggestions, and completions without plugins
- **Scripting clarity**: More readable syntax than bash (`if test -f file` vs `if [[ -f file ]]`)
- **No hidden state**: No `.bashrc` vs `.bash_profile` confusion
- **Universal variables**: Persistent configuration across sessions
- **Modern conventions**: Follows XDG base directory specification

**Trade-offs**:

- ❌ POSIX incompatibility (can't run bash scripts directly)
- ✅ Cleaner scripting for custom functions (77+ functions in this config)
- ✅ Better error messages and helpful suggestions
- ✅ Faster startup than heavily-customized Zsh

**Alternatives considered**: Zsh (too much configuration needed), Nushell (too experimental), Bash (outdated syntax).

### Editor: Neovim

**Why Neovim over VS Code / IntelliJ / Emacs?**

- **Keyboard-first**: Modal editing aligns with keyboard-driven workflow principle
- **Extensibility**: Lua-based configuration is more maintainable than Vimscript
- **LSP integration**: Built-in LSP client provides IDE features
- **Performance**: Faster startup and lower memory usage than Electron-based editors
- **Terminal integration**: Runs in terminal, SSH-friendly, tmux-compatible

**Trade-offs**:

- ❌ Steeper learning curve than GUI editors
- ✅ Once mastered, editing speed far exceeds GUI editors
- ✅ LazyVim provides sensible defaults, reducing configuration burden
- ✅ Portable across macOS, Linux, SSH environments

**Alternatives considered**: VS Code (too heavy, Electron), Helix (too minimal, no plugins), Emacs (Elisp vs Lua preference).

### Window Manager: Yabai + skhd + Karabiner

**Why Yabai over Rectangle / Amethyst / Magnet?**

- **Tiling paradigm**: BSP layout automatically organizes windows without manual positioning
- **Scriptability**: Full CLI control enables complex workflows
- **Space management**: Nine labeled spaces for context separation
- **Integration**: Works seamlessly with skhd for hotkeys

**Why skhd?**

- Dedicated hotkey daemon separates concerns from window manager
- Simple configuration syntax
- Reliable keyboard event handling

**Why Karabiner?**

- Low-level key remapping (hardware-level modifications)
- Complex modifications enable context-aware bindings
- Separates key remapping from hotkey execution

**Trade-offs**:

- ❌ Requires disabling SIP for Scripting Addition (security consideration)
- ✅ Far more powerful than GUI-based window managers
- ✅ Free and open-source (vs $10-15 for commercial alternatives)
- ✅ Automatable and reproducible through configuration files

**Alternatives considered**: Rectangle (too limited), Amethyst (less maintained), Hammerspoon (Lua overhead for window management).

### Terminal: Ghostty

**Why Ghostty over iTerm2 / Kitty / Alacritty?**

- **GPU acceleration**: Fast rendering for large outputs
- **Modern**: Built with Zig, actively developed
- **Configuration**: Simple TOML-based configuration
- **Performance**: Low latency, high throughput

**Trade-offs**:

- ❌ Relatively new (less community resources)
- ✅ Faster than iTerm2 and more actively developed than Kitty
- ✅ No Electron overhead (unlike Hyper or Warp)

**Alternatives considered**: Kitty (good, used as backup), Alacritty (minimal features), iTerm2 (legacy, slower).

### Dotfile Manager: Chezmoi

**Why chezmoi over GNU Stow / Yadm / Bare Git?**

- **Template system**: Machine-specific configurations through Go templates
- **Secret management**: Integrates with GPG and 1Password
- **State management**: Three-state model (source, target, destination) prevents mistakes
- **Naming conventions**: Special prefixes handle permissions, symlinks, and encryption
- **Cross-platform**: Works on macOS, Linux, SSH environments

**Trade-offs**:

- ❌ Learning curve for template syntax and naming conventions
- ✅ Far more powerful than symlink-based managers
- ✅ Secrets integration eliminates external secret management
- ✅ Dry-run and diff capabilities prevent destructive changes

**Alternatives considered**: GNU Stow (too simple), Yadm (bash-heavy), Bare Git (manual state management).

### Prompt: Starship

**Why Starship over Oh-My-Zsh / Powerline / Pure?**

- **Cross-shell**: Same configuration works in Fish, Zsh, Bash
- **Performance**: Written in Rust, parallel module execution
- **Customizability**: TOML-based configuration with extensive module library
- **Transient mode**: Reduces visual clutter in terminal history

**Trade-offs**:

- ❌ Additional dependency (not shell-native)
- ✅ Faster than interpreted prompt generators
- ✅ Unified configuration across shells
- ✅ Active development and community

**Alternatives considered**: Native Fish prompt (limited features), Oh-My-Zsh (Zsh-only, slow), Powerline (Python overhead).

### Package Manager: Homebrew

**Why Homebrew over MacPorts / Nix / Asdf?**

- **Ecosystem**: Largest package repository for macOS
- **Brewfile**: Declarative package management with `brew bundle`
- **Cask support**: GUI applications alongside CLI tools
- **Community**: Well-documented, widely-used

**Trade-offs**:

- ❌ Not as reproducible as Nix (no hermetic builds)
- ✅ Simpler than Nix for most use cases
- ✅ Better macOS integration than MacPorts
- ✅ Faster installation than compiling from source

**Alternatives considered**: Nix (too complex for this use case), MacPorts (smaller community), Asdf (language-specific, not general-purpose).

---

## Secrets Management Strategy

### Multi-Layered Approach

This configuration uses **four complementary layers** for secrets management, each addressing different use cases:

#### Layer 1: Secrets Submodule

**Purpose**: Store sensitive configuration files that should never appear in the public repository.

**Implementation**:

- Private git repository added as a submodule (`secrets/`)
- Configured via `.chezmoiexternals/git-repos.toml`
- Excluded from target state via `.chezmoiignore` (files stay in source, never copied to `$HOME`)
- Initialized automatically during `chezmoi init` via `run_once_before_1-setup-secrets-submodule.sh.tmpl`

**Use cases**:

- API configuration files with embedded credentials
- Private shell environment variables
- Service-specific secrets
- Machine-specific sensitive data

**Rationale**: Git submodules provide version-controlled secret storage without exposing secrets in the main repository. The separation allows public sharing of the main dotfiles while keeping secrets truly private.

#### Layer 2: GPG Symmetric Encryption

**Purpose**: Encrypt individual files within the main repository using passphrase-based encryption.

**Implementation**:

- Files prefixed with `encrypted_` are automatically encrypted by chezmoi
- Passphrase configured during `chezmoi init` and stored in `chezmoi.toml`
- GPG handles encryption/decryption transparently
- Encrypted files are committed to the main repository (safe to share)

**Use cases**:

- Single sensitive files that need version control in the main repo
- Small credentials that don't warrant a full submodule
- Cross-machine secrets that need centralized storage

**Rationale**: GPG encryption allows secrets to be version-controlled alongside their configurations without exposure. The passphrase acts as the master key, and chezmoi handles the encryption workflow.

#### Layer 3: 1Password Integration

**Purpose**: Dynamically retrieve secrets from 1Password vaults without storing them in the repository at all.

**Implementation**:

- 1Password CLI (`op`) installed via Homebrew
- Service account token stored as environment variable (`OP_SERVICE_ACCOUNT_TOKEN`)
- Templates reference secrets via `onepasswordRead` function
- Secrets fetched on-demand during `chezmoi apply`

**Use cases**:

- Shared team credentials
- Rotating API keys
- Secrets that should never touch disk in plain text
- Cross-team password sharing

**Rationale**: 1Password provides centralized secret management with audit logging, access control, and secret rotation. Templates remain portable while secrets stay in a secure vault.

#### Layer 4: Gitleaks Pre-commit Scanning

**Purpose**: Prevent accidental secret commits through automated scanning.

**Implementation**:

- Pre-commit hook configured in `.pre-commit-config.yaml`
- Gitleaks scans all commits for secret patterns (AWS keys, GitHub tokens, private keys, etc.)
- False positives suppressed via `.gitleaksignore`
- Blocks commits containing detected secrets

**Use cases**:

- Catching hardcoded credentials before they reach GitHub
- Preventing accidental leaks of API keys in code examples
- Validating all changes before version control

**Rationale**: Human error is inevitable. Automated scanning acts as a safety net, catching mistakes before secrets are committed and pushed to remote repositories.

### Design Decision: Why Multiple Layers?

Each layer addresses different threat models and use cases:

| Layer          | Storage Location      | Version Controlled | Shared             | Best For                        |
| -------------- | --------------------- | ------------------ | ------------------ | ------------------------------- |
| Submodule      | Private Git repo      | ✅ Yes             | ❌ No              | Project-specific secrets        |
| GPG Encryption | Main repo (encrypted) | ✅ Yes             | ⚠️ With passphrase | Cross-machine secrets           |
| 1Password      | Vault (external)      | ❌ No              | ✅ Yes             | Team credentials, rotating keys |
| Gitleaks       | N/A (validation)      | N/A                | N/A                | Mistake prevention              |

**Defense in depth**: If you forget to encrypt a file, pre-commit hooks catch it. If a template accidentally exposes a secret, gitleaks blocks the commit. If a machine doesn't have 1Password access, GPG-encrypted files provide fallback credentials.

---

## Symlink vs Copy Strategy

### The cm-util/ Approach

This configuration uses a **symlink-heavy strategy** for shared configurations through the `cm-util/` directory structure.

#### How It Works

```
~/.local/share/chezmoi/
├── cm-util/
│   └── ctrld-configs/        # "Controlled configs" - shared content
│       ├── homebrew/Brewfile
│       ├── karabiner/karabiner.json
│       ├── lazygit/config.yml
│       └── ...
├── symlink_Brewfile.tmpl     # Symlinks to cm-util/ctrld-configs/homebrew/Brewfile
└── dot_config/
    └── karabiner/
        └── symlink_karabiner.json.tmpl
```

**Symlink templates** contain a single line outputting the target path:

```go
{{ .chezmoi.sourceDir }}{{ .path.ctrld_configs }}/karabiner/karabiner.json
```

After `chezmoi apply`:

```bash
~/Brewfile → ~/.local/share/chezmoi/cm-util/ctrld-configs/homebrew/Brewfile
~/.config/karabiner/karabiner.json → ~/.local/share/chezmoi/cm-util/.../karabiner.json
```

#### Why Symlinks Over Copies?

**1. Single Source of Truth**

- Configuration exists in one location (`cm-util/ctrld-configs/`)
- No duplication means no sync issues
- Edit once, applies everywhere

**2. Cross-Tool Sharing**

- Multiple tools can reference the same configuration
- Example: Brewfile shared between local and deployment contexts

**3. Easier Updates**

- Edit the file directly (via symlink or in `cm-util/`)
- Changes are immediately reflected in target state
- Git tracks only the actual content, not duplicates

**4. Cleaner Repository Structure**

- Separates **file layout** (`dot_config/tool/`) from **file content** (`cm-util/`)
- Reduces repository size (no large duplicated files)
- Easier to browse and understand

#### When to Use Symlinks vs Copies

| Use Symlinks When                     | Use Copies When                               |
| ------------------------------------- | --------------------------------------------- |
| Configuration is shared between tools | Configuration is tool-specific                |
| File is large (reduces duplication)   | File is small and simple                      |
| You want a single source of truth     | Configuration needs per-machine customization |
| Content doesn't change per-machine    | Template variables are needed                 |

**Examples from this config**:

- ✅ Symlink: `Brewfile` (large, shared, single source)
- ✅ Symlink: `karabiner.json` (500+ lines, complex)
- ✅ Symlink: `lazy-lock.json` (shared Neovim plugin versions)
- ❌ Copy: `config.fish` (needs template variables for paths)
- ❌ Copy: `ghostty.conf.tmpl` (machine-specific settings)

#### Design Decision: Why Not Use Chezmoi Templates for Sharing?

**Alternative approach**: Use `{{ include }}` to embed files in templates.

**Why we use symlinks instead**:

- **Performance**: Symlinks don't require template processing
- **Editing**: Can edit the file directly in `$HOME`, changes appear in `cm-util/`
- **Debugging**: Easier to verify symlink targets than template inclusion
- **Tool compatibility**: Some tools expect real files, not copied templates

**Trade-off**: Symlinks require absolute paths (generated via templates), which adds a layer of indirection. However, the benefits outweigh this complexity.

---

## Architecture Decisions

### 1. Three-State Model (Chezmoi)

**Decision**: Use chezmoi's source → target → destination model instead of simple symlink managers.

**Rationale**:

- **Source state**: Git-tracked files with special naming (e.g., `dot_config/`)
- **Target state**: Desired state after template processing and transformations
- **Destination state**: Actual files in `$HOME`

**Benefits**:

- Preview changes before applying (`chezmoi diff`)
- Dry-run capability prevents destructive operations
- Template system enables machine-specific configurations
- State comparison detects drift

**Trade-offs**:

- More complex than `ln -s ~/.dotfiles/.vimrc ~/.vimrc`
- Learning curve for naming conventions and templates
- Additional abstraction layer between source and destination

**Why we accept the complexity**: The safety mechanisms (diff, dry-run) and flexibility (templates, secrets) justify the added complexity. Manual symlink management doesn't scale to 100+ configuration files across multiple machines.

### 2. Modular Shell Configuration (conf.d/)

**Decision**: Split Fish configuration into multiple files in `conf.d/` instead of a monolithic `config.fish`.

**Structure**:

```
conf.d/
├── _fish_general_config.fish     # Environment variables, editor
├── _fish_vi_mode_config.fish     # Vi-mode, cursor
├── _fish_fzf_config.fish         # FZF integration
├── _fish_keymaps_config.fish     # Custom keybindings
├── _fish_starship_config.fish    # Starship prompt
├── _fish_path_config.fish        # PATH modifications
├── _fish_python_config.fish      # Python environment
├── _fish_javascript_config.fish  # Node/JavaScript
└── _fish_rust_config.fish        # Rust tooling
```

**Rationale**:

- **Organization**: Each file handles one domain (FZF, vi-mode, etc.)
- **Debugging**: Easier to identify which file causes issues
- **Selective loading**: Can disable features by renaming files
- **Collaboration**: Multiple people can work on different aspects without merge conflicts

**Trade-offs**:

- ❌ More files to manage
- ✅ Clearer separation of concerns
- ✅ Faster to locate specific configurations

### 3. Plugin Architecture (Neovim + Fish)

**Decision**: Use plugin managers (Lazy.nvim, Fisher) instead of monolithic configurations.

**Neovim plugins**: ~54 plugin files in `lua/plugins/`, each configuring one or more related plugins.

**Fish plugins**: Managed via Fisher with `fish_plugins` file (symlinked from `cm-util/`).

**Rationale**:

- **Lazy loading**: Plugins load on-demand (Neovim startup: ~50ms)
- **Version locking**: `lazy-lock.json` ensures reproducible setups
- **Modularity**: Can disable plugins by moving to `_disabled.lua`
- **Updates**: Centralized update mechanism (`Lazy update`, `fisher update`)

**Trade-offs**:

- ❌ Additional dependencies (plugin managers)
- ✅ Faster startup than loading all plugins
- ✅ Easier to experiment with new plugins
- ✅ Community ecosystem (can use others' plugin configs)

### 4. Layer Separation (Karabiner → skhd → Yabai)

**Decision**: Separate key remapping, hotkey handling, and window management into three distinct tools.

**Layers**:

1. **Karabiner-Elements**: Hardware-level key remapping (e.g., Alt+h → Left Arrow)
2. **skhd**: Hotkey daemon executes shell commands (e.g., Ctrl+Alt+h → `yabai -m window --focus west`)
3. **Yabai**: Window manager receives commands via CLI

**Rationale**:

- **Single responsibility**: Each tool does one thing well
- **Composability**: Can swap out layers (e.g., replace skhd with Hammerspoon)
- **Debugging**: Easier to isolate issues (is it key remapping or window management?)
- **Reusability**: Karabiner remaps work in all apps, not just window management

**Trade-offs**:

- ❌ Three configurations instead of one
- ✅ More reliable (single-purpose tools less likely to conflict)
- ✅ Easier to understand (clear data flow)

### 5. Declarative Package Management (Brewfile)

**Decision**: Use `Brewfile` to declare all installed packages instead of imperative install scripts.

**Implementation**:

- `Brewfile`: ~100+ packages for local machines
- `Brewfile_ssh`: Minimal CLI-only tools for SSH servers
- `brew bundle`: Installs all declared packages

**Rationale**:

- **Reproducibility**: Same `Brewfile` always installs same packages
- **Idempotency**: Running `brew bundle` multiple times is safe
- **Documentation**: Brewfile serves as a list of installed tools
- **Cross-machine sync**: Easy to see differences between machines

**Trade-offs**:

- ❌ Slower than manual installs (checks all packages)
- ✅ Guaranteed consistency across machines
- ✅ Easy to revert to previous package set (git history)

### 6. SSH vs Local Detection

**Decision**: Automatically detect SSH context and load minimal configuration.

**Implementation**:

```bash
# In .chezmoiscripts/
if [ -z "$SSH_CONNECTION" ]; then
    # Local machine - install GUI apps
    brew bundle --file=Brewfile
else
    # SSH machine - CLI only
    brew bundle --file=Brewfile_ssh
fi
```

**Rationale**:

- **Performance**: SSH servers don't need 100+ packages
- **Storage**: Minimal installation on remote servers
- **Security**: Fewer installed packages = smaller attack surface
- **Usability**: Same dotfiles work everywhere, adapted to context

**Trade-offs**:

- ❌ Two Brewfiles to maintain
- ✅ Faster setup on SSH servers
- ✅ Appropriate tool selection per environment

---

## Trade-offs and Alternatives Considered

### 1. Neovim vs VS Code

**Chosen**: Neovim (LazyVim distribution)

**Why not VS Code?**

- ❌ Electron-based (high memory usage, slower startup)
- ❌ GUI-first (doesn't work well over SSH)
- ❌ Mouse-centric (conflicts with keyboard-first principle)
- ✅ Better extension ecosystem for some languages
- ✅ Lower learning curve
- ✅ Integrated terminal and debugger

**Why Neovim?**

- ✅ Terminal-native (works over SSH, tmux)
- ✅ Keyboard-first (modal editing)
- ✅ Fast (50ms startup with lazy loading)
- ✅ Extensible (Lua plugins, LSP)
- ❌ Steeper learning curve
- ❌ Requires more configuration

**Decision**: Accept learning curve for long-term efficiency gains. LazyVim reduces configuration burden.

### 2. Fish vs Zsh

**Chosen**: Fish shell

**Why not Zsh?**

- ❌ Requires extensive configuration (Oh-My-Zsh, plugins)
- ❌ POSIX compatibility adds complexity (e.g., `[[ ]]` vs `test`)
- ❌ Slower startup with many plugins
- ✅ More ubiquitous (default on macOS)
- ✅ Larger plugin ecosystem

**Why Fish?**

- ✅ Out-of-the-box features (autosuggestions, syntax highlighting)
- ✅ Cleaner scripting syntax
- ✅ Faster startup (~50ms)
- ✅ Better error messages
- ❌ POSIX incompatibility (can't run bash scripts)
- ❌ Smaller community than Zsh

**Decision**: Trade POSIX compatibility for usability. Bash scripts can still run via `bash script.sh`.

### 3. Yabai vs Hammerspoon

**Chosen**: Yabai + skhd

**Why not Hammerspoon?**

- ❌ Lua-based configuration (yet another language)
- ❌ More general-purpose (includes window management, automation, etc.)
- ❌ Slower for pure window management
- ✅ More flexible (Lua scripting)
- ✅ Single tool instead of two (Yabai + skhd)

**Why Yabai + skhd?**

- ✅ Purpose-built for window management
- ✅ BSP layout (not just resizing)
- ✅ Faster (native code vs Lua)
- ✅ Simpler configuration (shell commands vs Lua functions)
- ❌ Requires SIP disabling for Scripting Addition
- ❌ Two tools instead of one

**Decision**: Specialized tools outperform general-purpose solutions. SIP requirement is acceptable for gained functionality.

### 4. Chezmoi vs Bare Git Repository

**Chosen**: Chezmoi

**Why not Bare Git?**

- ❌ Manual state management (`git --work-tree=$HOME`)
- ❌ No template system (machine-specific configs require separate branches)
- ❌ No secret management (separate tool needed)
- ❌ No diff preview (manual git diff)
- ✅ Simpler (no additional tool)
- ✅ Direct control (no abstraction layer)

**Why Chezmoi?**

- ✅ Template system (machine-specific configs)
- ✅ Secret management (GPG, 1Password integration)
- ✅ State preview (`chezmoi diff`)
- ✅ Naming conventions (permissions, symlinks)
- ❌ Learning curve (templates, naming)
- ❌ Additional abstraction layer

**Decision**: Template system and secret management justify complexity. Manual bare git doesn't scale to multi-machine setups with secrets.

### 5. Homebrew vs Nix

**Chosen**: Homebrew

**Why not Nix?**

- ❌ Steeper learning curve (Nix language)
- ❌ Smaller macOS package repository
- ❌ More complex mental model (derivations, profiles)
- ✅ Hermetic builds (reproducible to the byte)
- ✅ Declarative system configuration
- ✅ Atomic rollbacks

**Why Homebrew?**

- ✅ Largest macOS package ecosystem
- ✅ Simpler mental model (install, upgrade, uninstall)
- ✅ Better macOS integration (GUI apps via Casks)
- ✅ Widely used (better community support)
- ❌ Not hermetic (builds vary slightly)
- ❌ No atomic rollbacks

**Decision**: Simplicity and ecosystem size outweigh reproducibility guarantees for this use case. Nix considered for future migration.

### 6. Secrets Submodule vs Environment Variables

**Chosen**: Secrets submodule + GPG + 1Password

**Why not just environment variables?**

- ❌ No version control (hard to track changes)
- ❌ No backup (lost if machine dies)
- ❌ No sharing (each machine configured manually)
- ✅ Simpler (no additional repos)
- ✅ Standard practice (most apps read from env)

**Why multi-layered secrets?**

- ✅ Version-controlled (git history)
- ✅ Backed up (in git remote)
- ✅ Portable (same secrets on all machines)
- ✅ Selective sharing (1Password for teams)
- ❌ More complex (multiple layers)
- ❌ More tools (GPG, 1Password CLI)

**Decision**: Accept complexity for safety, portability, and version control. Defense in depth prevents secret leaks.

---

## Conclusion

This dotfiles configuration prioritizes:

1. **Keyboard efficiency** through Karabiner → skhd → Yabai → Neovim → Fish chain
2. **Modularity** via separated concerns (each tool does one thing)
3. **Security** through multi-layered secrets management
4. **Portability** via chezmoi templates and SSH detection
5. **Performance** through lazy loading and optimized configurations
6. **Maintainability** via documentation-as-code and declarative state

The design accepts complexity in configuration management (chezmoi templates, naming conventions) to gain safety (diff previews, secret scanning) and flexibility (machine-specific configs, template system).

Trade-offs favor long-term efficiency over short-term simplicity: Neovim's learning curve pays off in editing speed, Yabai's SIP requirement enables powerful window management, and chezmoi's abstraction layer prevents configuration mistakes.

This philosophy guides all configuration decisions and should inform future modifications: prefer keyboard over mouse, specialized tools over general-purpose, declarative over imperative, and safe over simple.

---

## Related Documentation

- [ARCHITECTURE.md](./ARCHITECTURE.md) - System architecture and component interactions
- [INSTALL.md](../INSTALL.md) - Complete installation guide
- [CHEZMOI.md](../CHEZMOI.md) - Chezmoi workflow and usage
- [docs/workflows/secrets-management.md](./workflows/secrets-management.md) - Secrets management procedures
- [README.md](../README.md) - Repository overview and quick start

## Future Considerations

**Potential improvements aligned with design philosophy**:

1. **Nix/Home Manager**: Hermetic builds for ultimate reproducibility
2. **Ansible**: Automated macOS setup and application installation
3. **SketchyBar**: Custom macOS menu bar (keyboard-first status indicators)
4. **Atuin**: Shell history sync across machines (currently configured but underutilized)
5. **MCP Servers**: Claude AI integration for enhanced development workflow

**Experimental explorations**:

- **Wezterm**: Alternative GPU-accelerated terminal (evaluating vs Ghostty)
- **Helix**: Modal editor as Neovim alternative (monitoring maturity)
- **Nushell**: Structured data shell (exploring for scripting use cases)

These align with the design principles (keyboard-first, modular, portable) and would be adopted only if they improve upon existing solutions without compromising core values.
