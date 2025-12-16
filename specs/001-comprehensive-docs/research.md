# Repository Research Findings

**Feature**: Comprehensive Dotfiles Documentation
**Research Date**: 2025-12-11
**Purpose**: Survey dotfiles repository to inform documentation structure and content

## Executive Summary

The dotfiles repository contains **31 major tool configurations**, **77 Fish shell custom functions**, **6 chezmoi setup scripts**, and extensive configuration across multiple layers (shell, window management, text editing, terminal emulators, TUI tools). Documentation will need to cover:

- **Entry-level guides**: Installation, chezmoi workflow, troubleshooting
- **Tool-specific docs**: READMEs for 8 major tools (priority based on complexity)
- **Reference docs**: Unified keymap reference, architecture diagrams, CLI tools index
- **Workflow guides**: Setup, configuration changes, multi-machine sync, secrets

## Tool Configurations Inventory

### Priority 1: Core Tools (Must Document)

These tools form the foundation and have significant configuration complexity:

| Tool | Config Location | Complexity | Documentation Need |
|------|----------------|------------|-------------------|
| **Fish Shell** | `dot_config/fish/` | High | 77 custom functions, conf.d, multiple fish files |
| **Neovim** | `dot_config/exact_nvim/` | Very High | Extensive Lua config, plugins, LSPs, keymaps |
| **Yabai** | `dot_config/yabai/` | High | Window manager rules, spaces configuration |
| **Skhd** | `dot_config/skhd/` | Medium | Hotkey bindings layered with Yabai |
| **Karabiner** | `dot_config/karabiner/` | Medium | Hardware key remapping (JSON config) |
| **Git/Delta** | `dot_gitconfig`, `dot_config/delta/` | Medium | Git aliases, Delta diff viewer integration |
| **Starship** | `dot_config/starship.toml` | Medium | Prompt configuration |
| **Chezmoi** | `.chezmoi.toml.tmpl`, `.chezmoiscripts/` | High | 6 setup scripts, templating, externals |

**Existing Documentation Found**:

- ✅ `dot_config/fish/README.md` (partial - needs enhancement)
- ✅ `dot_config/exact_nvim/README.md` (partial - needs enhancement)
- ✅ `dot_config/yabai/README.md` (partial - needs enhancement)
- ✅ `dot_config/karabiner/README.md` (partial - needs enhancement)
- ✅ `dot_config/skhd/README.md` (partial - needs enhancement)
- ✅ `secrets/README.md` (explains secrets submodule)
- ✅ `README.md` (root - needs complete rewrite)

### Priority 2: Supporting Tools (Should Document)

These tools enhance the experience but are less critical:

| Tool | Config Location | Documentation Need |
|------|----------------|-------------------|
| **Ghostty** | `dot_config/ghostty/` | README explaining terminal config |
| **Tmux** | `dot_config/tmux/` | README for multiplexer config |
| **Zellij** | `dot_config/zellij/` | README for terminal workspace |
| **Yazi** | `dot_config/yazi/` | README for file manager keybindings |
| **Lazygit** | `dot_config/lazygit/` | README for TUI git client |
| **Atuin** | `dot_config/atuin/` | README for shell history |

### Priority 3: Supplementary Tools (Optional Documentation)

These have simpler configs or are self-explanatory:

| Tool | Config Location |
|------|----------------|
| Bat, Bottom, Btop, Ripgrep, AiChat, Lazydocker, Television, etc. | `dot_config/<tool>/` |

**Decision**: Create minimal documentation (one-liner in root README) for P3 tools, point to official docs.

## Fish Shell Functions Analysis

**Total Functions**: 77 custom functions in `dot_config/fish/exact_functions/`

### Documentation Strategy

Create `/Users/kirbylittle/.local/share/chezmoi/dot_config/fish/TOOLS.md` with:

1. **Categorized Function List**:
   - File/Directory Navigation
   - Git Shortcuts
   - Development Workflows
   - System Utilities
   - AI/LLM Tools
   - Configuration Management

2. **Function Documentation Format**:

   ```markdown
   ### `function_name`

   **Purpose**: Brief description
   **Usage**: `function_name [args]`
   **Example**: `function_name example-input`
   **See also**: Related functions
   ```

3. **Discovery Method**: Parse each `.fish` file's comments/docstrings for descriptions

**Sample Functions to Document** (from file list):

- `ai.fish` - AI chat interface
- `lg.fish` - Lazygit launcher
- `y.fish` - Yazi file manager
- `vc.fish` - Edit nvim config
- `v.fish` - Neovim launcher
- `cm.fish` - Chezmoi shortcut
- Plus 71 more

## Chezmoi Scripts Inventory

**Total Scripts**: 6 in `.chezmoiscripts/`

### Script Execution Order & Purpose

| Order | Script | Purpose |
|-------|--------|---------|
| 1 (before) | `run_once_before_1-setup-secrets-submodule.sh.tmpl` | Initialize secrets submodule |
| 2 (after) | `run_once_after_1-install-homebrew.sh` | Install Homebrew if missing |
| 3 (after) | `run_after_1-setup-fish.sh` | Configure Fish shell |
| 4 (after) | `run_after_2-install-various.sh` | Install additional tools |
| 5 (various) | Additional macOS setup scripts | macOS-specific configurations |

**Documentation Need**: Create `.chezmoiscripts/README.md` explaining execution order and when each script runs.

## Keymap Sources Identified

### Layer 1: Hardware Remapping (Karabiner)

**Config**: `dot_config/karabiner/karabiner.json`
**Documentation Need**: Extract all complex modifications and document reasoning

### Layer 2: Window Management (Skhd + Yabai)

**Config**: `dot_config/skhd/skhdrc`
**Key Count**: Extensive (needs parsing)
**Documentation Need**: Categorize by action (focus, move, resize, spaces)

### Layer 3: Application-Specific

**Neovim**: Multiple keymap files in `dot_config/exact_nvim/lua/config/keymaps.lua` and plugins
**Tmux**: `dot_config/tmux/tmux.conf`
**Yazi**: `dot_config/yazi/keymap.toml`
**Fish**: Vi-mode keybindings in fish config

**Documentation Strategy**: Create unified `docs/KEYMAPS.md` with searchable table format

## Secrets Management Architecture

### Components Identified

1. **Secrets Submodule**: `secrets/` (git submodule)
2. **Encrypted Files**: Pattern `encrypted_*` (chezmoi encryption)
3. **1Password Integration**: Template usage in `.chezmoi.toml.tmpl`
4. **GPG**: Used for chezmoi encryption (passphrase-based)
5. **Pre-commit Scanning**: Gitleaks configuration in `.pre-commit-config.yaml`

**Documentation Need**: `docs/workflows/secrets-management.md` explaining:

- How to initialize secrets submodule
- How to add new secrets
- GPG passphrase setup
- 1Password service account configuration
- What gets encrypted vs what goes in submodule

## GitHub Actions Workflows

**Workflows Found**: `daily_sync_main.yaml`, `daily_sync_dev.yaml`

**Purpose**: Synchronize private dotfiles repository with public version, excluding secrets

**Documentation Need**: Section in root README + detailed workflow in `docs/workflows/` explaining:

- How sync works
- What gets excluded (`.chezmoiignore` patterns)
- How to trigger manual sync
- Troubleshooting sync failures

## Chezmoi Special Features

### Template System

**Templates Found**: `*.tmpl` pattern throughout repository
**Template Data**: `.chezmoidata/constants.toml`, `.chezmoidata/uv.toml`

**Documentation Need**: Explain in `CHEZMOI.md`:

- When to use templates
- How to access template data
- Common template patterns

### External Repositories

**Config**: `.chezmoiexternals`, `.chezmoiexternals/git-repos.toml`

**Purpose**: Manage external git repositories (e.g., vim plugins, tool configs)

**Documentation Need**: Explain external repos strategy

### Symlink Strategy (cm-util/)

**Pattern**: `symlink_*.tmpl` files linking to `cm-util/`

**Rationale**: Share common configs across multiple tools without duplication

**Documentation Need**: `docs/DESIGN.md` section explaining this architectural decision

## Existing Documentation Gaps

### Critical Gaps (Blocking Success Criteria)

1. **No installation guide** - Users cannot complete setup in <60 minutes without step-by-step instructions
2. **No unified keymap reference** - Cannot locate keymaps in <2 minutes
3. **No chezmoi workflow guide** - First-time modification success at risk
4. **No troubleshooting guide** - Common issues undocumented
5. **Incomplete tool READMEs** - Existing READMEs lack customization guides and integration points

### Secondary Gaps

1. **No architecture diagrams** - System interactions unclear
2. **No Fish functions index** - 77 functions undiscoverable
3. **No design philosophy doc** - Architectural decisions unexplained
4. **No multi-machine sync guide** - Advanced use case unsupported

## Documentation Structure Decision

### Root Level Documentation

**Files to Create/Update**:

- `README.md` (UPDATE) - Repository overview, quick links
- `INSTALL.md` (NEW) - Step-by-step installation
- `CHEZMOI.md` (NEW) - Chezmoi workflow guide
- `TROUBLESHOOTING.md` (NEW) - Common issues

### Reference Documentation (docs/)

**Directory to Create**: `docs/`

**Files to Create**:

- `docs/KEYMAPS.md` - Unified keymap reference
- `docs/ARCHITECTURE.md` - System architecture diagrams
- `docs/DESIGN.md` - Design philosophy
- `docs/workflows/new-machine-setup.md`
- `docs/workflows/configuration-changes.md`
- `docs/workflows/multi-machine-sync.md`
- `docs/workflows/secrets-management.md`

### Tool-Specific Documentation

**Files to Create/Update**:

- `dot_config/fish/TOOLS.md` (NEW) - All 77 functions documented
- `dot_config/fish/README.md` (UPDATE) - Enhanced with integration points
- `dot_config/exact_nvim/README.md` (UPDATE) - Plugin architecture, LSP setup
- `dot_config/yabai/README.md` (UPDATE) - Window management rules
- `dot_config/skhd/README.md` (UPDATE) - Hotkey categories
- `dot_config/karabiner/README.md` (UPDATE) - Hardware remapping rationale
- `dot_config/git/README.md` (NEW) - Git + Delta integration
- `.chezmoiscripts/README.md` (NEW) - Script execution order

## Diagram Requirements

### Diagram 1: Keyboard Input Flow

```
Hardware Keyboard Input
  ↓
Karabiner Elements (Hardware key remapping)
  ↓
Skhd (Hotkey daemon)
  ↓
Yabai (Window manager actions)
  ↓
Window/Application Focus/Move/Resize
```

### Diagram 2: Shell Environment Flow

```
Fish Shell Launch
  ↓
conf.d/ initialization scripts
  ↓
Starship Prompt (git, directory context)
  ↓
User Command
  ↓
Custom Fish Function (77 available)
  ↓
Git Operations → Delta (diff viewer)
```

### Diagram 3: Neovim Toolchain

```
Neovim Launch
  ↓
Lazy.nvim (Plugin manager)
  ↓
Plugins Load (from lua/plugins/)
  ↓
Mason (LSP manager)
  ↓
Language Servers (configured per language)
  ↓
LSP Features (completion, diagnostics, formatting)
```

**Format**: Mermaid syntax for version control and rendering flexibility

## Implementation Priorities

### Phase 1: Critical Path (Blocks Success Criteria)

1. `INSTALL.md` - Enables <60 min setup (SC-001)
2. `docs/KEYMAPS.md` - Enables <2 min lookups (SC-002)
3. `CHEZMOI.md` - Enables first-attempt modifications (SC-003)
4. `TROUBLESHOOTING.md` - Covers 90% of issues (SC-004)

### Phase 2: Tool Documentation (Supports SC-005)

1. Update 8 priority tool READMEs with customization guides
2. Create `dot_config/fish/TOOLS.md` for all 77 functions (SC-006)

### Phase 3: Architecture & Design (Supports SC-007, SC-008)

1. Create 3+ architecture diagrams (SC-007)
2. Document hidden features and cross-file configs (SC-008)
3. Create `docs/DESIGN.md` explaining architectural decisions

### Phase 4: Workflow Guides (Supports SC-010)

1. Create 4 workflow guides in `docs/workflows/`

## Best Practices Research

### Markdown Documentation Standards

**Industry Practices Identified**:

- Use UPPERCASE.md for top-level guides (README, INSTALL, TROUBLESHOOTING)
- Use kebab-case.md for workflow documentation
- Use README.md for directory-specific overviews
- Include tables of contents for docs >100 lines
- Use relative links for cross-referencing
- Include code blocks with syntax highlighting
- Use collapsible sections for long content

### Keymap Documentation Patterns

**Research from popular dotfiles**:

- Organize by category (navigation, windows, applications, etc.)
- Include "Why" column explaining rationale
- Provide search keywords for discoverability
- Cross-reference between layers (e.g., "This skhd binding triggers that yabai command")

### Architecture Diagram Best Practices

**Standards**:

- Use Mermaid for version-controlled diagrams
- Keep diagrams simple (max 7-9 boxes per diagram)
- Use consistent shapes (rectangles for components, diamonds for decisions)
- Include legend if symbols are non-obvious

## Alternatives Considered & Rejected

### Alternative 1: Single Monolithic README

**Rejected Because**: Would be 1000+ lines, unscannable, violates industry best practices for discoverability

### Alternative 2: Wiki or External Documentation Site

**Rejected Because**: Adds deployment complexity, separates docs from code, harder to keep in sync

### Alternative 3: Inline Comments Only

**Rejected Because**: Doesn't provide high-level overview, poor discoverability, doesn't meet "comprehensive" requirement

## Validation Approach

Each documentation file will be validated against:

1. **Markdown Linting**: `markdownlint-cli` for formatting consistency
2. **Link Checking**: Verify all internal and external links are valid
3. **Success Criteria Testing**:
   - Time a fresh installation following INSTALL.md
   - Time keymap lookups in KEYMAPS.md
   - Attempt first-time config modification following CHEZMOI.md
   - Check troubleshooting coverage against known issues
4. **Peer Review**: Have intermediate CLI user review for clarity

## Next Steps (Phase 1)

Based on research findings, proceed to Phase 1 design:

1. Create data-model.md defining documentation taxonomy ✅ (Already created)
2. Create contracts/ with documentation templates ✅ (Already created)
3. Create quickstart.md explaining how to navigate documentation ✅ (Already created)
4. Update agent context with new documentation tools
5. Begin implementation via /speckit.tasks

## Research Artifacts

This research was conducted by:

- Manual file system exploration
- Reading existing configuration files
- Analyzing chezmoi structure
- Reviewing existing (partial) documentation
- Counting files and directories to determine scope

**Confidence Level**: High - comprehensive repository survey completed
