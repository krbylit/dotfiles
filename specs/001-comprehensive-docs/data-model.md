# Documentation Structure & Taxonomy

**Feature**: Comprehensive Dotfiles Documentation
**Purpose**: Define the organization, taxonomy, and structure of all documentation files

## Documentation Taxonomy

### Level 1: Entry Points (Root Directory)

**Purpose**: Provide immediate access to critical information for new and returning users

| Document | Location | Audience | Purpose |
|----------|----------|----------|---------|
| README.md | `/README.md` | All users | Repository overview, quick links, project description |
| INSTALL.md | `/INSTALL.md` | New users | Step-by-step installation instructions for fresh macOS setup |
| CHEZMOI.md | `/CHEZMOI.md` | All users | Chezmoi workflow guide (edit, diff, apply, commit) |
| TROUBLESHOOTING.md | `/TROUBLESHOOTING.md` | All users | Common issues and resolutions |

**Naming Convention**: UPPERCASE.md for top-level guides (industry standard)

### Level 2: Reference Documentation (docs/ Directory)

**Purpose**: Centralized reference material for looking up specific information

| Document | Location | Audience | Purpose |
|----------|----------|----------|---------|
| KEYMAPS.md | `/docs/KEYMAPS.md` | All users | Unified keymap reference across all layers |
| ARCHITECTURE.md | `/docs/ARCHITECTURE.md` | Intermediate/Advanced | System architecture diagrams and tool interactions |
| DESIGN.md | `/docs/DESIGN.md` | Intermediate/Advanced | Design philosophy and rationale for tool choices |

**Naming Convention**: UPPERCASE.md for reference docs

### Level 3: Workflow Guides (docs/workflows/ Directory)

**Purpose**: Step-by-step procedures for specific tasks

| Document | Location | Audience | Purpose |
|----------|----------|----------|---------|
| new-machine-setup.md | `/docs/workflows/new-machine-setup.md` | New users | Complete new machine setup procedure |
| configuration-changes.md | `/docs/workflows/configuration-changes.md` | All users | How to modify configurations safely |
| multi-machine-sync.md | `/docs/workflows/multi-machine-sync.md` | Advanced users | Managing dotfiles across multiple machines |
| secrets-management.md | `/docs/workflows/secrets-management.md` | All users | GPG, 1Password, encryption workflows |

**Naming Convention**: kebab-case.md for workflow docs (descriptive, scannable)

### Level 4: Tool-Specific Documentation (Co-located with Configurations)

**Purpose**: Explain how each tool is configured in this repository

| Tool | Location | Purpose |
|------|----------|---------|
| Neovim | `/dot_config/exact_nvim/README.md` | Plugin architecture, LSP setup, keybindings |
| Fish Shell | `/dot_config/fish/README.md` | Configuration overview, custom functions summary |
| Fish Tools | `/dot_config/fish/TOOLS.md` | Exhaustive CLI tools reference |
| Yabai | `/dot_config/exact_yabai/README.md` | Window manager configuration, rules |
| Skhd | `/dot_config/exact_skhd/README.md` | Hotkey configuration |
| Karabiner | `/dot_config/karabiner/README.md` | Hardware key remapping |
| Git/Delta | `/dot_config/git/README.md` | Git configuration and Delta integration |
| Chezmoi Scripts | `/.chezmoiscripts/README.md` | Run script execution order and purpose |

**Naming Convention**: README.md for overview, UPPERCASE.md for exhaustive references

## Documentation Components

### Standard Sections for READMEs

Each tool-specific README.md should include:

1. **Overview**: What this tool does and why it's part of the dotfiles
2. **Configuration Files**: List of files and their purpose
3. **Key Features**: Highlight important configurations or customizations
4. **Customization Guide**: How to modify common settings
5. **Integration Points**: How this tool interacts with others
6. **Troubleshooting**: Common issues specific to this tool
7. **External Links**: Official documentation for reference

### Diagram Types

Architecture diagrams using Mermaid syntax:

1. **System Integration Diagram**: How all tools connect
2. **Keyboard Input Flow**: Karabiner → skhd → Yabai → Window Actions
3. **Shell Environment Flow**: Fish → Starship → Git → Delta
4. **Neovim Toolchain**: Neovim → LSPs → Mason → Language Servers

### Keymap Reference Structure

The unified keymap reference (KEYMAPS.md) should organize by:

- **Layer**: Karabiner (hardware), skhd (window management), application-specific
- **Category**: Navigation, window management, application launching, etc.
- **Action**: Specific action with key combination and effect
- **Searchability**: Include synonyms and alternative descriptions

## Content Principles

### Tone & Style

- **Direct**: Short sentences, active voice
- **Practical**: Focus on "how" and "why" over theory
- **Scannable**: Use headings, lists, tables for quick lookup
- **Consistent**: Same terminology throughout (e.g., "source state" not "source directory")

### Audience Assumptions

Per spec clarifications:

- Intermediate CLI users (no need to explain `cd`, `ls`, basic git)
- New to dotfiles and chezmoi (explain these concepts thoroughly)
- Latest tool versions (no version compatibility matrices)

### Link Strategy

- **External Links**: Official documentation for comprehensive reference
- **Internal Links**: Cross-reference between documentation files
- **Relative Paths**: Use relative links for portability

## Validation Criteria

Each document must be validated against:

1. **Completeness**: All required sections present
2. **Accuracy**: Information matches actual configurations
3. **Clarity**: Intermediate user can understand without additional research
4. **Searchability**: Key terms present for Cmd+F discovery
5. **Formatting**: Markdown linted with markdownlint-cli
6. **Links**: All internal and external links functional

## Dependencies

| Dependency | Purpose | Installation |
|------------|---------|--------------|
| markdownlint-cli | Lint markdown files | `brew install markdownlint-cli` |
| mermaid-cli | Generate diagram SVGs | `npm install -g @mermaid-js/mermaid-cli` |
| tree | Generate directory structures | `brew install tree` |
| ripgrep | Search for patterns in config files | `brew install ripgrep` |

## Maintenance

Documentation should be updated when:

- New tools added to dotfiles
- Configuration patterns change significantly
- User feedback indicates confusion or missing information
- Major tool updates change workflows

Documentation versioning strategy: Keep in sync with dotfiles repository (no separate versioning).
