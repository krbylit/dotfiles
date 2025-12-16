# Implementation Plan: Comprehensive Dotfiles Documentation

**Branch**: `001-comprehensive-docs` | **Date**: 2025-12-11 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-comprehensive-docs/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

Create comprehensive documentation throughout the dotfiles repository to enable intermediate users (familiar with CLIs and git) to install, understand, customize, and troubleshoot the dotfiles configuration. Documentation will cover installation workflows, keymap references across multiple tools (Karabiner, skhd, Yabai), chezmoi-specific workflows, tool-specific configurations (Neovim, Fish, etc.), architecture diagrams, and troubleshooting guides. Target is setup completion in <60 minutes for new users and <2 minute keymap lookups.

## Technical Context

**Language/Version**: Markdown (GitHub-flavored), Mermaid for diagrams
**Primary Dependencies**: Documentation tools (markdown linters: markdownlint-cli), diagram generation (mermaid-cli for pre-rendering diagrams), repository analysis tools (tree, ripgrep for codebase surveying)
**Storage**: Markdown files stored in repository (co-located with configurations), static documentation assets
**Testing**: Manual validation against success criteria (setup time, keymap lookup time), documentation review checklist
**Target Platform**: macOS (latest versions assumed per clarifications)
**Project Type**: Documentation project - no executable code, only markdown files and diagrams
**Performance Goals**: User can complete new machine setup in <60 minutes, locate any keymap in <2 minutes, modify configuration on first attempt
**Constraints**: Must use Markdown format for GitHub compatibility, must be co-located with relevant configurations, must target intermediate CLI users without over-explaining basics
**Scale/Scope**: ~7 major tool configurations (Neovim, Fish, Yabai, Skhd, Karabiner, Git, Chezmoi), ~50+ Fish functions to document, 3+ architecture diagrams, unified keymap reference across 4 layers

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Verify compliance with `.specify/memory/constitution.md` principles:

**I. Configuration as Code**

- [x] All changes managed through chezmoi workflow (documentation files will be added via chezmoi)
- [x] Configuration reproducible on fresh machine (documentation supports this goal)
- [x] Manual changes captured back to source state (documentation workflow will be documented)

**II. Security First**

- [x] No secrets in plaintext (documentation will explain secrets management, not contain secrets)
- [x] Gitleaks pre-commit hook passes (documentation is plaintext, no secrets)
- [x] Public sync excludes encrypted files (documentation will explain this, is itself public)

**III. Idempotent Operations**

- [x] Safe to run multiple times (reading documentation is idempotent)
- [x] `chezmoi diff` reviewed before apply (documentation will teach this)
- [x] No destructive side effects (documentation has no executable components)

**IV. Format Consistency**

- [x] Appropriate formatter identified (markdownlint-cli via prettierd for markdown)
- [x] Format check passes before commit (will apply markdown formatting standards)

**V. Self-Documentation**

- [x] README exists or updated for tool configuration (this feature IS creating those READMEs)
- [x] Complex settings have inline comments (documentation will explain what to comment)
- [x] Repository README updated if setup changes (root README will be updated with installation instructions)

**Constitution Compliance**: ✅ PASS - No violations. This feature directly supports all constitutional principles, especially Principle V (Self-Documentation).

## Project Structure

### Documentation (this feature)

```text
specs/001-comprehensive-docs/
├── plan.md              # This file
├── spec.md              # Feature specification
├── research.md          # Phase 0 output (repository survey findings)
├── data-model.md        # Phase 1 output (documentation structure/taxonomy)
├── quickstart.md        # Phase 1 output (how to use the documentation)
├── contracts/           # Phase 1 output (documentation file templates)
└── tasks.md             # Phase 2 output (NOT created by /speckit.plan)
```

### Source Code (repository root)

This is a documentation project, so "source code" refers to where documentation files will be created:

```text
/Users/kirbylittle/.local/share/chezmoi/  (chezmoi source directory)
├── README.md                             # Root overview (UPDATED)
├── INSTALL.md                            # NEW: Installation guide
├── CHEZMOI.md                            # NEW: Chezmoi workflow guide
├── TROUBLESHOOTING.md                    # NEW: Common issues guide
├── docs/                                 # NEW: Centralized documentation
│   ├── KEYMAPS.md                       # NEW: Unified keymap reference
│   ├── ARCHITECTURE.md                  # NEW: System architecture & diagrams
│   ├── DESIGN.md                        # NEW: Design philosophy & rationale
│   └── workflows/                       # NEW: Workflow documentation
│       ├── new-machine-setup.md
│       ├── configuration-changes.md
│       ├── multi-machine-sync.md
│       └── secrets-management.md
├── dot_config/
│   ├── exact_nvim/
│   │   └── README.md                    # NEW: Neovim configuration overview
│   ├── exact_yabai/
│   │   └── README.md                    # NEW: Yabai configuration overview
│   ├── exact_skhd/
│   │   └── README.md                    # NEW: Skhd configuration overview
│   ├── karabiner/
│   │   └── README.md                    # NEW: Karabiner configuration overview
│   ├── fish/
│   │   ├── README.md                    # UPDATED: Fish configuration overview
│   │   └── TOOLS.md                     # NEW: CLI tools reference
│   └── git/
│       └── README.md                    # NEW: Git/Delta configuration overview
└── .chezmoiscripts/
    └── README.md                        # NEW: Run scripts documentation
```

**Structure Decision**: Documentation files follow industry standard patterns:

- **Root level**: High-level guides (README, INSTALL, CHEZMOI, TROUBLESHOOTING)
- **docs/**: Centralized reference documentation (keymaps, architecture, workflows)
- **Tool directories**: Co-located README.md files explaining each tool's configuration
- **Separation of concerns**: README.md for overview, dedicated files (TOOLS.md, KEYMAPS.md) for exhaustive references

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

No violations - this section intentionally left empty.
