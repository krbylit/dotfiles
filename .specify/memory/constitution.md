<!--
SYNC IMPACT REPORT
===================
Version Change: INITIAL → 1.0.0
Modified Principles: N/A (initial creation)
Added Sections: All sections (initial constitution)
Removed Sections: None
Templates Requiring Updates:
  ✅ plan-template.md - Updated Constitution Check section
  ✅ spec-template.md - No changes needed (generic template)
  ✅ tasks-template.md - No changes needed (generic template)
Follow-up TODOs: None
===================
-->

# Personal Dotfiles Constitution

## Core Principles

### I. Configuration as Code

All configuration MUST be version controlled and reproducible. Every tool configuration, script, and setting MUST be managed through chezmoi such that a fresh machine can be fully configured by running a single command. Manual configuration changes MUST be captured back into the chezmoi source state.

**Rationale**: Ensures environment reproducibility, disaster recovery, and knowledge preservation. Eliminates "works on my machine" problems and provides audit trail of all configuration changes.

### II. Security First

Secrets and sensitive data MUST NEVER be committed to version control in plaintext. All secrets MUST use either 1Password integration or chezmoi encryption. The gitleaks pre-commit hook MUST pass on every commit. Public repository syncs MUST exclude all encrypted files and secrets.

**Rationale**: Protects credentials, API keys, and personal data from exposure. Automated scanning prevents accidental leaks. Defense in depth through multiple protection layers (encryption, scanning, sync filtering).

### III. Idempotent Operations

All scripts and chezmoi operations MUST be safe to run multiple times without destructive side effects. Applying configurations MUST not break existing working setups. Changes MUST be reviewable via `chezmoi diff` before application.

**Rationale**: Enables safe experimentation and updates. Prevents configuration drift and accidental system corruption. Allows rollback and validation workflows.

### IV. Format Consistency

All code and configuration MUST follow language-specific formatting conventions using automated formatters: `stylua` for Lua, `fish_indent` for Fish shell, `shfmt` for shell scripts, `prettierd` for JavaScript/TypeScript/JSON/Markdown, `yapf` for Python. Formatters MUST be run before committing changes.

**Rationale**: Maintains readability, reduces merge conflicts, and ensures professional quality. Automated formatting eliminates style debates and cognitive load.

### V. Self-Documentation

Each tool's configuration directory MUST include a README explaining purpose, dependencies, and usage patterns. Complex configurations MUST include inline comments explaining non-obvious settings. The repository README MUST maintain accurate setup instructions.

**Rationale**: Ensures configurations remain understandable over time. Aids onboarding on new machines. Preserves rationale for configuration decisions. Enables confident modification without fear of breaking undocumented assumptions.

## Operational Requirements

### Chezmoi Workflow

- **Source State**: All changes MUST be made via `chezmoi edit <file>`
- **Application**: Changes MUST be reviewed with `chezmoi diff` before `chezmoi apply`
- **Externally Modified Files**: Files modified by running programs (e.g., `btop.conf`, `karabiner.json`) MUST use chezmoi's external modification handling
- **Updates**: Pull remote changes with `chezmoi update`, not direct git operations

### Secret Management

- **1Password**: Service account token MUST be set in `OP_SERVICE_ACCOUNT_TOKEN` environment variable
- **Encryption**: Passphrase-encrypted files MUST use chezmoi encryption mode configured in `.chezmoi.toml`
- **Editing Encrypted Files**: MUST use `chezmoi edit <file>` workflow; `chezmoi.nvim` does not support encrypted files
- **Scanning**: `gitleaks` MUST run on every commit via pre-commit hook

### Repository Synchronization

- **Private Repository**: Contains full configuration including secrets and encrypted files
- **Public Repository**: Synchronized subset excluding all sensitive data
- **Sync Validation**: GitHub Actions MUST verify no secrets leaked to public repository
- **Encrypted File Handling**: All `encrypted_*` files MUST be removed before public commits

## Development Workflow

### Change Process

1. **Edit**: Use `chezmoi edit <file>` to modify source state
2. **Review**: Run `chezmoi diff` to preview changes to destination state
3. **Validate**: Ensure formatters pass for modified files
4. **Test**: Verify changes work as expected (e.g., source updated shell config)
5. **Apply**: Run `chezmoi apply` to update destination state
6. **Commit**: Create isolated commit per file with conventional commit message

### Commit Standards

- **Isolation**: Each modified/created file MUST be committed separately
- **Message Format**: MUST follow Conventional Commits (e.g., `feat: add ghostty config`, `fix: correct fish prompt spacing`)
- **Subject Line**: Maximum 50 characters
- **Body**: MUST include detailed explanation of changes and justification

### Quality Gates

- **Format Check**: All formatters MUST pass before commit
- **Secret Scan**: `gitleaks` pre-commit hook MUST pass
- **Syntax Validation**: Language-specific linters MUST pass where configured (pyright, ruff, eslint)
- **Documentation**: New tool configurations MUST include README

### Testing Changes

- **Preview**: Use `chezmoi diff` to review impact
- **Incremental**: Test changes on non-critical configurations first
- **Rollback**: Keep previous working state accessible via git history
- **Validation**: Source updated configurations to verify functionality

## Governance

This constitution supersedes all other development practices. Changes to this constitution require:

1. **Documentation**: Proposed changes documented with rationale
2. **Impact Analysis**: Assessment of affected configurations and workflows
3. **Migration Plan**: Steps to update existing configurations for compliance
4. **Version Bump**: Semantic versioning applied based on change scope

All configuration changes MUST verify compliance with these principles. Complexity or deviations MUST be explicitly justified. Unjustified violations MUST be rejected or refactored.

**Version**: 1.0.0 | **Ratified**: 2025-12-11 | **Last Amended**: 2025-12-11
