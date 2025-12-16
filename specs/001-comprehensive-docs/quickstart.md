# Documentation Quick Start Guide

**Feature**: Comprehensive Dotfiles Documentation
**Audience**: Future documentation readers and maintainers

## Purpose

This guide explains how to navigate and use the dotfiles documentation created by this feature.

## Documentation Structure

### For New Users: Start Here

1. **[README.md](../../README.md)** - Repository overview and quick orientation
2. **[INSTALL.md](../../INSTALL.md)** - Complete installation instructions for new machine setup
3. **[CHEZMOI.md](../../CHEZMOI.md)** - Essential chezmoi workflow (edit, diff, apply, commit)

**Time investment**: ~10-15 minutes to read, ~60 minutes to complete first installation

### For Daily Use: Quick References

- **[docs/KEYMAPS.md](../../docs/KEYMAPS.md)** - Find any keyboard shortcut across all tools
- **[TROUBLESHOOTING.md](../../TROUBLESHOOTING.md)** - Resolve common issues quickly
- **[dot_config/fish/TOOLS.md](../../dot_config/fish/TOOLS.md)** - Look up Fish shell custom functions

**Time investment**: <2 minutes per lookup

### For Configuration Changes: Workflows

Navigate to `docs/workflows/` for step-by-step procedures:

- [new-machine-setup.md](../../docs/workflows/new-machine-setup.md) - Setting up a second/third machine
- [configuration-changes.md](../../docs/workflows/configuration-changes.md) - Making safe modifications
- [multi-machine-sync.md](../../docs/workflows/multi-machine-sync.md) - Keeping machines in sync
- [secrets-management.md](../../docs/workflows/secrets-management.md) - Managing secrets and encryption

**Time investment**: 5-15 minutes per workflow

### For Deep Understanding: Tool-Specific Docs

Each major tool has a README co-located with its configuration:

| Tool | Documentation Location | What You'll Learn |
|------|------------------------|-------------------|
| Neovim | `dot_config/exact_nvim/README.md` | Plugins, LSPs, keybindings |
| Fish Shell | `dot_config/fish/README.md` | Configuration overview |
| Yabai | `dot_config/exact_yabai/README.md` | Window manager rules |
| Skhd | `dot_config/exact_skhd/README.md` | Hotkey configuration |
| Karabiner | `dot_config/karabiner/README.md` | Hardware key remapping |
| Git/Delta | `dot_config/git/README.md` | Git configuration and diff viewer |

**Time investment**: 10-20 minutes per tool

### For System Understanding: Architecture

- **[docs/ARCHITECTURE.md](../../docs/ARCHITECTURE.md)** - System diagrams showing how tools interact
- **[docs/DESIGN.md](../../docs/DESIGN.md)** - Design philosophy and rationale

**Time investment**: 20-30 minutes for complete system understanding

## Navigation Tips

### Finding Information

**By Tool**: Look in `dot_config/<tool>/README.md`

**By Task**: Check `docs/workflows/` for procedures

**By Problem**: Start with `TROUBLESHOOTING.md`

**By Keybinding**: Use `docs/KEYMAPS.md` and Cmd+F

### Using Internal Links

Documentation uses relative links for cross-referencing. Click links to navigate between related documents.

### Searching

Use your text editor or GitHub's search to find specific terms:

- In repository: `rg "search term" --type md`
- In GitHub web UI: Press `/` and type your search

## Common User Journeys

### Journey 1: "I just cloned this repo, where do I start?"

1. Read [README.md](../../README.md) (2 min)
2. Follow [INSTALL.md](../../INSTALL.md) (60 min)
3. Skim [CHEZMOI.md](../../CHEZMOI.md) (5 min)
4. Bookmark [TROUBLESHOOTING.md](../../TROUBLESHOOTING.md) for later

**Total time**: ~70 minutes to fully functional setup

### Journey 2: "I want to customize [tool]"

1. Read `dot_config/<tool>/README.md`
2. Follow customization guide in that README
3. Use [docs/workflows/configuration-changes.md](../../docs/workflows/configuration-changes.md) to apply safely

**Total time**: 15-30 minutes

### Journey 3: "Something broke after macOS update"

1. Check [TROUBLESHOOTING.md](../../TROUBLESHOOTING.md) for the symptom
2. Follow resolution steps
3. If not covered, check tool-specific README troubleshooting section

**Total time**: 5-15 minutes

### Journey 4: "What does this keyboard shortcut do?"

1. Open [docs/KEYMAPS.md](../../docs/KEYMAPS.md)
2. Cmd+F for the key combination or action description
3. Note which layer/tool it belongs to for further customization

**Total time**: <2 minutes

### Journey 5: "I want to set up dotfiles on my work machine"

1. Review [docs/workflows/multi-machine-sync.md](../../docs/workflows/multi-machine-sync.md)
2. Understand machine-specific configuration strategies
3. Follow [docs/workflows/new-machine-setup.md](../../docs/workflows/new-machine-setup.md)

**Total time**: 30-45 minutes

## Maintenance

### Keeping Documentation Current

When making configuration changes:

1. Update relevant README if behavior changes significantly
2. Add new troubleshooting entries if you encounter novel issues
3. Update KEYMAPS.md if you modify keyboard shortcuts

### Documentation Standards

All documentation follows these principles:

- **Markdown format**: GitHub-flavored Markdown
- **Intermediate audience**: Assumes CLI/git familiarity, explains dotfiles concepts
- **Scannable**: Heavy use of headings, lists, tables
- **Linked**: Cross-references between related documents
- **Tested**: Validated against actual configurations

## Getting Help

If documentation is unclear or missing:

1. Check if official tool documentation has the answer (linked from each README)
2. Search existing GitHub issues for this repository
3. Create a new issue describing what documentation is needed

## Contributing

To improve documentation:

1. Use the chezmoi workflow: `chezmoi edit <file>`
2. Follow the templates in `specs/001-comprehensive-docs/contracts/`
3. Maintain consistent tone and structure with existing docs
4. Submit changes via PR with descriptive commit messages

## Success Metrics

Good documentation should enable:

- ✅ New machine setup in <60 minutes
- ✅ Keymap lookups in <2 minutes
- ✅ First-attempt configuration modifications
- ✅ 90% of troubleshooting scenarios covered
- ✅ Independent tool customization without external research

If you're not achieving these, the documentation needs improvement!
