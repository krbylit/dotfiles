# Feature Specification: Comprehensive Dotfiles Documentation

**Feature Branch**: `001-comprehensive-docs`
**Created**: 2025-12-11
**Status**: Draft
**Input**: User description: "Goal: create comprehensive documentation throughout the dotfiles repository. Documentation should be aimed at helping new users of the dotfiles configuration familiarize themselves with the workflows present, specific tools available and how to use them, and how to install and manage the dotfiles configuration with chezmoi and GitHub."

## Clarifications

### Session 2025-12-11

- Q: What is the target skill level for the primary audience of this documentation? → A: Intermediate users (familiar with CLIs and git basics, but new to dotfiles/chezmoi)
- Q: What level of detail should tool-specific documentation provide for each tool (Neovim, Fish, Yabai, etc.)? → A: Configuration overview with customization guides (explain how the tool is configured in this repo, common customization patterns, integration points)
- Q: Should documentation specify minimum version requirements for critical dependencies? → A: Assume latest versions only (no version documentation, users expected to use current releases)

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Initial Setup on New Machine (Priority: P1)

A new user (or the repository owner on a fresh machine) needs to install and configure the entire dotfiles environment from scratch, understanding what will be installed, how to handle secrets, and how to verify the installation succeeded.

**Why this priority**: This is the entry point for anyone using the dotfiles. Without clear setup documentation, the repository is unusable. It represents the highest-friction moment that will determine if someone can successfully adopt these dotfiles.

**Independent Test**: Can be fully tested by following setup documentation on a fresh macOS installation and confirming all tools are installed, configured, and functional without requiring additional undocumented steps.

**Acceptance Scenarios**:

1. **Given** a fresh macOS installation, **When** user follows the installation documentation, **Then** chezmoi is installed and initialized with the dotfiles repository
2. **Given** chezmoi is initialized, **When** user follows the secrets setup documentation, **Then** GPG encryption, 1Password integration, and secrets submodule are properly configured
3. **Given** setup is complete, **When** user opens a new terminal, **Then** Fish shell loads with all custom functions, Starship prompt appears, and all CLI tools are available
4. **Given** installation is complete, **When** user verifies the setup, **Then** all quality gates pass (formatters installed, pre-commit hooks active, accessibility permissions granted for yabai/skhd/karabiner)

---

### User Story 2 - Understanding Desktop Environment Keymaps (Priority: P2)

A user wants to understand and customize the window management and keyboard shortcuts across Karabiner, skhd, and Yabai to control their desktop environment effectively.

**Why this priority**: The desktop environment is a core differentiator of this dotfiles configuration. Without understanding the keymap layers, users cannot effectively use window management features or customize them to their preferences.

**Independent Test**: Can be tested by reading the keymap documentation and successfully executing documented shortcuts for window management, workspace switching, and application launching without trial-and-error.

**Acceptance Scenarios**:

1. **Given** the keymap documentation, **When** user reads the Karabiner section, **Then** they understand which hardware keys are remapped and why
2. **Given** the keymap documentation, **When** user reads the skhd section, **Then** they can execute all documented window management commands (focus, move, resize, space switching)
3. **Given** the keymap documentation, **When** user wants to customize a keybinding, **Then** they know which file to edit and understand the syntax for modification
4. **Given** the unified keymap reference, **When** user searches for a specific action (e.g., "move window to space 2"), **Then** they can locate the exact key combination across all layers

---

### User Story 3 - Making Configuration Changes (Priority: P3)

A user wants to modify an existing configuration (e.g., add a Fish function, change a Neovim setting, or update yabai rules) using the proper chezmoi workflow without breaking the setup or losing changes.

**Why this priority**: Configuration modification is a frequent task but requires understanding chezmoi's workflow to avoid common pitfalls (editing destination files instead of source, not applying changes, forgetting to commit).

**Independent Test**: Can be tested by following the configuration change workflow documentation to add a simple Fish function, verify it works, and confirm it's properly version-controlled in the chezmoi source state.

**Acceptance Scenarios**:

1. **Given** a desired configuration change, **When** user follows the workflow documentation, **Then** they edit the file via `chezmoi edit`, preview changes with `chezmoi diff`, and apply with `chezmoi apply`
2. **Given** changes are applied, **When** user tests the configuration, **Then** the change takes effect immediately (e.g., new Fish function is available, Neovim setting applies)
3. **Given** working changes, **When** user follows commit guidelines, **Then** each file is committed separately with a conventional commit message
4. **Given** a change breaks something, **When** user follows rollback procedures, **Then** they can revert to the previous working state using git history

---

### User Story 4 - Tool-Specific Deep Dives (Priority: P4)

A user wants to understand how a specific tool works within the dotfiles context (e.g., how Neovim LSPs are configured, what Fish functions do, or how Git Delta is integrated) to customize or troubleshoot that tool.

**Why this priority**: Enables users to deeply understand and customize individual tools without needing to read entire configuration files. Supports maintenance and troubleshooting.

**Independent Test**: Can be tested by reading tool-specific documentation (e.g., Neovim README) and successfully customizing the tool (adding an LSP, modifying a plugin configuration) without breaking the overall setup.

**Acceptance Scenarios**:

1. **Given** tool-specific documentation, **When** user reads about Neovim, **Then** they understand the plugin architecture, LSP configuration via Mason, and available keybindings
2. **Given** Fish shell documentation, **When** user browses the CLI tools reference, **Then** they discover available custom functions with descriptions and usage examples
3. **Given** a tool's configuration files, **When** user reads inline comments, **Then** they understand the purpose of non-obvious settings without external research
4. **Given** integration documentation, **When** user reads about the Fish → Starship → Git → Delta pipeline, **Then** they understand how these tools interact and where to customize each layer

---

### User Story 5 - Multi-Machine Synchronization (Priority: P5)

A user maintaining dotfiles across multiple machines wants to understand how to keep configurations in sync, handle machine-specific differences (SSH vs local configs), and resolve conflicts when configurations diverge.

**Why this priority**: Supports advanced use case of managing configurations across multiple machines, which is a common dotfiles pattern but requires understanding chezmoi's templating and synchronization features.

**Independent Test**: Can be tested by following multi-machine sync documentation to set up dotfiles on a second machine with different configurations (e.g., work vs personal), verify machine-specific settings apply correctly, and successfully pull/push changes between machines.

**Acceptance Scenarios**:

1. **Given** multi-machine documentation, **When** user sets up dotfiles on a second machine, **Then** they understand how to handle machine-specific configurations using chezmoi templates
2. **Given** configuration changes on machine A, **When** user follows sync workflow, **Then** changes are committed, pushed to GitHub, and can be pulled on machine B
3. **Given** conflicting changes on two machines, **When** user follows conflict resolution procedures, **Then** they can merge changes without losing work
4. **Given** machine-specific secrets, **When** user follows secrets sync documentation, **Then** each machine maintains its own secrets while sharing common configurations

---

### User Story 6 - Troubleshooting Common Issues (Priority: P6)

A user encounters a common problem (accessibility permissions lost, pre-commit hook failing, LSP not working) and needs to quickly diagnose and fix the issue without deep system knowledge.

**Why this priority**: Reduces friction when things go wrong, which is inevitable with complex system configurations. Improves user confidence and reduces abandonment.

**Independent Test**: Can be tested by simulating common failure scenarios (revoking yabai permissions, breaking a git hook) and verifying the troubleshooting guide provides clear steps to resolution.

**Acceptance Scenarios**:

1. **Given** yabai stops working after macOS update, **When** user consults troubleshooting guide, **Then** they find steps to re-grant accessibility permissions and restart services
2. **Given** pre-commit hook fails with gitleaks errors, **When** user follows troubleshooting steps, **Then** they understand how to review findings, update .gitleaksignore if needed, or fix the secret leak
3. **Given** Neovim LSP not working after Python upgrade, **When** user follows LSP troubleshooting, **Then** they can reinstall language servers via Mason and verify functionality
4. **Given** chezmoi apply shows conflicts, **When** user reads conflict resolution guide, **Then** they understand the difference between source/destination/target state and can resolve the conflict

---

### Edge Cases

- What happens when user runs setup on an already-configured machine (idempotency)?
- What if a user doesn't want to use all tools (partial adoption)?
- How are breaking changes to configurations communicated?
- What if GitHub is unavailable (offline setup scenarios)?
- How does documentation stay current as tools and configurations evolve?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Documentation MUST provide step-by-step installation instructions for a fresh macOS machine, including prerequisites, chezmoi installation, repository initialization, and verification steps
- **FR-002**: Documentation MUST explain the secrets management workflow including GPG setup, 1Password service account configuration, secrets submodule initialization, and recovery procedures
- **FR-003**: Documentation MUST include a unified keymap reference that covers all layers (Karabiner hardware remapping, skhd window management, application-specific bindings) with search capability
- **FR-004**: Documentation MUST explain the chezmoi workflow including file naming conventions (dot*, exact*, private*, executable*, symlink_*), template system, run script execution order, and the rationale for symlinking cm-util/
- **FR-005**: Documentation MUST document all critical workflows including new machine setup, daily development workflow, configuration change process (edit → test → apply → commit), and multi-machine synchronization
- **FR-006**: Documentation MUST provide tool-specific documentation for major configurations (Neovim, Fish, Yabai, Skhd, Karabiner) located near the relevant configuration files, including configuration overview, common customization patterns, and integration points (not exhaustive reference documentation)
- **FR-007**: Documentation MUST include system architecture diagrams showing tool interaction pipelines (keyboard input flow, shell environment flow, Neovim toolchain flow)
- **FR-008**: Documentation MUST explain design philosophy including rationale for tool choices, symlink strategy, secrets as submodule, and overall architectural decisions
- **FR-009**: Documentation MUST provide a troubleshooting guide covering common issues with clear diagnostic steps and resolution procedures
- **FR-010**: Documentation MUST enumerate all available CLI tools (Fish functions) with descriptions, usage examples, and tips from user experience
- **FR-011**: Documentation MUST follow industry best practices with README.md for overview content and co-located documentation near relevant code/configuration
- **FR-012**: Documentation MUST explain the pre-commit hook system including gitleaks configuration, .gitleaksignore usage, and secret scanning workflow
- **FR-013**: Documentation MUST document the GitHub Actions workflow for public/private repository synchronization including how encrypted files are handled
- **FR-014**: Documentation MUST include dependency information showing what depends on what at the system level
- **FR-015**: Documentation MUST be written for intermediate users (familiar with CLIs and git basics) who are not the original author, avoiding assumptions about dotfiles-specific or chezmoi-specific knowledge while not over-explaining fundamental CLI/git concepts
- **FR-016**: Documentation MUST link to official tool documentation for comprehensive reference material while focusing on repository-specific configuration, customization patterns, and integration strategies

### Key Entities

- **Documentation File**: A markdown file containing explanatory content, located according to documentation standards (README.md for overviews, tool-specific docs near configurations)
- **Workflow Guide**: Step-by-step procedures for common tasks (setup, configuration changes, synchronization, troubleshooting)
- **Keymap Reference**: Unified documentation of all keyboard shortcuts across multiple tools and layers
- **Architecture Diagram**: Visual representation of how tools interact and depend on each other
- **Tool Reference**: Comprehensive listing of available CLI tools with usage information
- **Configuration Example**: Inline documentation within configuration files explaining non-obvious settings

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A new user with no prior knowledge of the repository can complete initial setup on a fresh macOS machine in under 60 minutes following the documentation alone
- **SC-002**: Users can locate the documentation for any keymap or shortcut in under 2 minutes using the unified keymap reference
- **SC-003**: Users can successfully modify a configuration using the chezmoi workflow on their first attempt after reading the workflow documentation
- **SC-004**: 90% of common troubleshooting scenarios are covered in the troubleshooting guide with clear resolution steps
- **SC-005**: Each major tool (Neovim, Fish, Yabai, Skhd, Karabiner, Git, Chezmoi) has dedicated documentation explaining its configuration, customization, and integration with other tools
- **SC-006**: Users can understand the purpose and usage of any CLI tool available in the Fish shell by consulting the tools reference
- **SC-007**: Documentation includes visual diagrams for at least 3 major tool interaction pipelines (keyboard input, shell environment, Neovim toolchain)
- **SC-008**: All undocumented "hidden" features and cross-file configurations spanning multiple repository areas are discovered and documented
- **SC-009**: Documentation follows a consistent structure and naming convention across all files, making it predictable and easy to navigate
- **SC-010**: Users can set up dotfiles on a second machine with different configuration needs in under 30 minutes using the multi-machine synchronization documentation

## Assumptions

- Target audience is intermediate users: comfortable with command-line interfaces, text editors, and basic git workflows, but new to dotfiles management and chezmoi
- Users are working on macOS (as indicated by macOS-specific tools like yabai, skhd)
- Users have access to GitHub for repository cloning and synchronization
- Users understand basic git concepts (clone, commit, push, pull) but may not know advanced features
- Documentation will be maintained in Markdown format for GitHub compatibility
- Users have administrator access on their machines for installing tools and granting permissions
- The repository owner wants to maintain both public and private versions with automated synchronization
- Documentation will be versioned alongside configuration changes to stay current
- Documentation will not explain fundamental CLI concepts (cd, ls, mkdir) but will explain dotfiles-specific and chezmoi-specific concepts in detail
- Users are expected to use current/latest versions of all tools (macOS, chezmoi, Homebrew packages); documentation will not maintain version compatibility matrices
