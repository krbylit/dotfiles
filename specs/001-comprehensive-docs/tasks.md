---

description: "Task list for comprehensive dotfiles documentation"
---

# Tasks: Comprehensive Dotfiles Documentation

**Input**: Design documents from `/specs/001-comprehensive-docs/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: No tests required (documentation project - manual validation against success criteria)

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Root level**: `/Users/kirbylittle/.local/share/chezmoi/` (README.md, INSTALL.md, CHEZMOI.md, TROUBLESHOOTING.md)
- **Reference docs**: `/Users/kirbylittle/.local/share/chezmoi/docs/` (KEYMAPS.md, ARCHITECTURE.md, DESIGN.md)
- **Workflow guides**: `/Users/kirbylittle/.local/share/chezmoi/docs/workflows/`
- **Tool docs**: `/Users/kirbylittle/.local/share/chezmoi/dot_config/<tool>/README.md`

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and documentation directory structure

- [X] T001 Create docs/ directory in /Users/kirbylittle/.local/share/chezmoi/docs/
- [X] T002 Create docs/workflows/ directory in /Users/kirbylittle/.local/share/chezmoi/docs/workflows/
- [X] T003 Install documentation dependencies (markdownlint-cli, mermaid-cli) via Homebrew or npm

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T004 [P] Survey all 77 Fish functions in /Users/kirbylittle/.local/share/chezmoi/dot_config/fish/exact_functions/ and extract descriptions from comments
- [X] T005 [P] Parse Karabiner config at /Users/kirbylittle/.local/share/chezmoi/dot_config/karabiner/karabiner.json and extract all complex modifications
- [X] T006 [P] Parse skhd config at /Users/kirbylittle/.local/share/chezmoi/dot_config/skhd/skhdrc and categorize all hotkeys by action type
- [X] T007 [P] Identify all Neovim keymaps in /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/ (lua/config/keymaps.lua and plugin configs)
- [X] T008 [P] List all 6 chezmoi scripts in /Users/kirbylittle/.local/share/chezmoi/.chezmoiscripts/ and determine execution order

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - Initial Setup on New Machine (Priority: P1) 🎯 MVP

**Goal**: Enable new users to install and configure dotfiles environment from scratch in <60 minutes

**Independent Test**: Follow INSTALL.md on fresh macOS and verify all tools install, configs apply, and quality gates pass without additional documentation

### Implementation for User Story 1

- [X] T009 [P] [US1] Create /Users/kirbylittle/.local/share/chezmoi/INSTALL.md with step-by-step installation instructions (prerequisites, chezmoi installation, repository clone, initialization)
- [X] T010 [P] [US1] Document secrets setup workflow in /Users/kirbylittle/.local/share/chezmoi/docs/workflows/secrets-management.md (GPG, 1Password, submodule init)
- [X] T011 [P] [US1] Create /Users/kirbylittle/.local/share/chezmoi/.chezmoiscripts/README.md documenting all 6 scripts, execution order, and when each runs
- [X] T012 [US1] Update /Users/kirbylittle/.local/share/chezmoi/README.md with repository overview, quick links to INSTALL.md, and tools list
- [X] T013 [US1] Add verification checklist to INSTALL.md (Fish loads, Starship appears, formatters installed, pre-commit hooks active, yabai/skhd/karabiner permissions)

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently (SC-001: setup in <60 min)

---

## Phase 4: User Story 2 - Understanding Desktop Environment Keymaps (Priority: P2)

**Goal**: Enable users to find any keymap in <2 minutes and understand window management customization

**Independent Test**: Locate a specific window management action (e.g., "move window to space 2") in KEYMAPS.md in under 2 minutes

### Implementation for User Story 2

- [X] T014 [P] [US2] Create /Users/kirbylittle/.local/share/chezmoi/docs/KEYMAPS.md with unified keymap reference table (Layer, Category, Action, Keys, Effect columns)
- [X] T015 [P] [US2] Document all Karabiner hardware remappings in KEYMAPS.md (from T005 data) with rationale for each modification
- [X] T016 [P] [US2] Document all skhd hotkeys in KEYMAPS.md (from T006 data) categorized by action (focus, move, resize, space switching)
- [X] T017 [P] [US2] Document application-specific keymaps in KEYMAPS.md (Neovim from T007, Yazi, Tmux, Fish vi-mode)
- [X] T018 [P] [US2] Update /Users/kirbylittle/.local/share/chezmoi/dot_config/karabiner/README.md with configuration overview and customization guide
- [X] T019 [P] [US2] Update /Users/kirbylittle/.local/share/chezmoi/dot_config/skhd/README.md with hotkey categories and integration with Yabai
- [X] T020 [P] [US2] Update /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_yabai/README.md with window manager rules and customization guide
- [X] T021 [US2] Add cross-references in KEYMAPS.md showing how layers interact (e.g., "This skhd binding triggers this yabai action")

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently (SC-002: keymap lookup <2 min)

---

## Phase 5: User Story 3 - Making Configuration Changes (Priority: P3)

**Goal**: Enable users to modify configurations safely on first attempt using chezmoi workflow

**Independent Test**: Follow configuration-changes.md to add a simple Fish function, verify it works, and confirm it's in chezmoi source state

### Implementation for User Story 3

- [X] T022 [P] [US3] Create /Users/kirbylittle/.local/share/chezmoi/CHEZMOI.md documenting chezmoi workflow (edit, diff, apply, commit cycle)
- [X] T023 [P] [US3] Document chezmoi naming conventions in CHEZMOI.md (dot*, exact*, private*, executable*, symlink_* patterns)
- [X] T024 [P] [US3] Explain chezmoi template system in CHEZMOI.md (*.tmpl files, .chezmoidata/ usage, common patterns)
- [X] T025 [P] [US3] Document cm-util/ symlink strategy in CHEZMOI.md (rationale for shared configs)
- [X] T026 [P] [US3] Create /Users/kirbylittle/.local/share/chezmoi/docs/workflows/configuration-changes.md with step-by-step change procedure
- [X] T027 [US3] Add rollback procedures to configuration-changes.md (using git history to revert changes)

**Checkpoint**: All user stories 1-3 should now be independently functional (SC-003: first-attempt modifications succeed)

---

## Phase 6: User Story 4 - Tool-Specific Deep Dives (Priority: P4)

**Goal**: Enable users to understand and customize each major tool without reading entire config files

**Independent Test**: Read a tool README (e.g., Neovim) and successfully customize it (add LSP) without breaking setup

### Implementation for User Story 4

- [x] T028 [P] [US4] Create /Users/kirbylittle/.local/share/chezmoi/dot_config/fish/TOOLS.md documenting all 77 Fish functions (from T004 data) with categories, usage, examples
- [x] T029 [P] [US4] Update /Users/kirbylittle/.local/share/chezmoi/dot_config/fish/README.md with configuration overview, Fish-specific features, and integration points
- [x] T030 [P] [US4] Update /Users/kirbylittle/.local/share/chezmoi/dot_config/exact_nvim/README.md with plugin architecture, LSP setup via Mason, and keybindings reference
- [x] T031 [P] [US4] Create /Users/kirbylittle/.local/share/chezmoi/dot_config/yazi/README.md with file manager keybindings, configuration, and customization guide
- [x] T032 [P] [US4] Create /Users/kirbylittle/.local/share/chezmoi/dot_config/lazygit/README.md with TUI git client overview and keybindings
- [x] T033 [P] [US4] Create /Users/kirbylittle/.local/share/chezmoi/dot_config/lazydocker/README.md with TUI docker client overview and keybindings
- [x] T034 [P] [US4] Create /Users/kirbylittle/.local/share/chezmoi/dot_config/fzf/README.md (if config exists) or document fzf integration in Fish README
- [x] T035 [P] [US4] Update /Users/kirbylittle/.local/share/chezmoi/dot_config/starship.toml with inline comments explaining personal customizations (yazi subshell icon, etc.)
- [x] T036 [P] [US4] Create /Users/kirbylittle/.local/share/chezmoi/docs/ARCHITECTURE.md with 3+ Mermaid diagrams (keyboard input flow, shell environment flow, Neovim toolchain)
- [x] T037 [US4] Document tool integration points in each README (how Fish → Starship → Git → Delta interact, how Karabiner → skhd → Yabai chain works)

**Checkpoint**: All major tools documented with customization guides (SC-005, SC-006, SC-007)

---

## Phase 7: User Story 5 - Multi-Machine Synchronization (Priority: P5)

**Goal**: Enable users to set up dotfiles on second machine in <30 minutes with machine-specific configs

**Independent Test**: Follow multi-machine-sync.md to set up on second machine with different settings, verify machine-specific configs apply

### Implementation for User Story 5

- [x] T038 [P] [US5] Create /Users/kirbylittle/.local/share/chezmoi/docs/workflows/new-machine-setup.md documenting setup on additional machines
- [x] T039 [P] [US5] Create /Users/kirbylittle/.local/share/chezmoi/docs/workflows/multi-machine-sync.md explaining machine-specific templates, sync workflow, conflict resolution
- [x] T040 [P] [US5] Document chezmoi template data usage in multi-machine-sync.md (how .chezmoidata/ enables machine-specific configs)
- [x] T041 [US5] Add examples to multi-machine-sync.md showing common machine-specific scenarios (work vs personal, SSH configs, different tool versions)

**Checkpoint**: Multi-machine setup documented (SC-010: second machine setup <30 min)

---

## Phase 8: User Story 6 - Troubleshooting Common Issues (Priority: P6)

**Goal**: Enable users to quickly diagnose and fix 90% of common issues

**Independent Test**: Simulate common failure (revoke yabai permissions) and verify troubleshooting guide provides clear resolution

### Implementation for User Story 6

- [X] T042 [P] [US6] Create /Users/kirbylittle/.local/share/chezmoi/TROUBLESHOOTING.md with diagnostic steps for common issues
- [X] T043 [P] [US6] Add yabai/skhd/karabiner accessibility permissions troubleshooting to TROUBLESHOOTING.md (symptoms, solution for macOS updates)
- [X] T044 [P] [US6] Add pre-commit hook / gitleaks errors troubleshooting to TROUBLESHOOTING.md (how to review findings, update .gitleaksignore, fix leaks)
- [X] T045 [P] [US6] Add Neovim LSP troubleshooting to TROUBLESHOOTING.md (reinstalling via Mason after Python/tool upgrades)
- [X] T046 [P] [US6] Add chezmoi apply conflicts troubleshooting to TROUBLESHOOTING.md (source vs destination vs target state explanation)
- [X] T047 [P] [US6] Document GitHub Actions sync failures in TROUBLESHOOTING.md (public/private sync issues, encrypted file handling)
- [X] T048 [US6] Add tool-specific troubleshooting sections to each tool's README referencing TROUBLESHOOTING.md for common issues

**Checkpoint**: Troubleshooting guide covers 90% of common scenarios (SC-004) ✅

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories and final quality checks

- [X] T049 [P] Create /Users/kirbylittle/.local/share/chezmoi/docs/DESIGN.md explaining design philosophy (tool choices rationale, symlink strategy, secrets as submodule)
- [x] T050 [P] Document GitHub Actions workflows in DESIGN.md or workflows/ (daily_sync_main.yaml, daily_sync_dev.yaml) explaining public/private sync
- [x] T051 [P] Add .chezmoiignore patterns explanation to CHEZMOI.md (what gets excluded from public sync and why)
- [X] T052 [P] Document dependency tree in ARCHITECTURE.md showing what depends on what at system level
- [X] T053 [P] Add pre-commit hook system documentation to CHEZMOI.md (gitleaks configuration, .gitleaksignore usage, secret scanning workflow)
- [X] T054 [P] Create /Users/kirbylittle/.local/share/chezmoi/docs/workflows/daily-development.md documenting how tools work together in daily workflow
- [X] T055 Validate all internal links across documentation files are functional
- [X] T056 Validate all external links to official tool documentation are functional
- [X] T057 Run markdownlint-cli on all documentation files and fix formatting issues
- [X] T058 Verify all success criteria are met (setup <60 min, keymap lookup <2 min, 90% troubleshooting coverage, etc.)
- [X] T059 Test documentation on fresh macOS installation and time the setup process
- [X] T060 Add table of contents to documentation files >100 lines for improved navigation

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3-8)**: All depend on Foundational phase completion
  - User stories can then proceed in parallel (if staffed)
  - Or sequentially in priority order (P1 → P2 → P3 → P4 → P5 → P6)
- **Polish (Phase 9)**: Depends on all user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - No dependencies on other stories (independent)
- **User Story 3 (P3)**: Can start after Foundational (Phase 2) - No dependencies on other stories (independent)
- **User Story 4 (P4)**: Can start after Foundational (Phase 2) - No dependencies on other stories (independent)
- **User Story 5 (P5)**: Benefits from US1 being complete (references installation) but can be implemented independently
- **User Story 6 (P6)**: Benefits from all other stories being complete (references their content) but can be implemented independently

### Within Each User Story

- All tasks within a user story marked [P] can run in parallel
- Tasks without [P] may depend on previous tasks completing
- Story complete before moving to next priority (for sequential implementation)

### Parallel Opportunities

- All Setup tasks (T001-T003) can run in parallel
- All Foundational tasks (T004-T008) can run in parallel within Phase 2
- Once Foundational phase completes, ALL user stories (Phases 3-8) can start in parallel if team capacity allows
- Within each user story, most tasks are marked [P] and can run in parallel
- Polish tasks (T049-T060) can run in parallel once user stories complete

---

## Parallel Example: User Story 1

```bash
# Launch all User Story 1 tasks together after Foundational completes:
Task: "Create INSTALL.md in /Users/kirbylittle/.local/share/chezmoi/INSTALL.md"
Task: "Create secrets-management.md in /Users/kirbylittle/.local/share/chezmoi/docs/workflows/secrets-management.md"
Task: "Create .chezmoiscripts/README.md in /Users/kirbylittle/.local/share/chezmoi/.chezmoiscripts/README.md"
# Then sequentially:
Task: "Update README.md in /Users/kirbylittle/.local/share/chezmoi/README.md"
Task: "Add verification checklist to INSTALL.md"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently (time installation on fresh macOS)
5. Verify SC-001 met (<60 min setup)

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Review (MVP! - installation guide)
3. Add User Story 2 → Test independently → Deploy/Review (keymap reference)
4. Add User Story 3 → Test independently → Deploy/Review (chezmoi workflow)
5. Add User Story 4 → Test independently → Deploy/Review (tool-specific docs)
6. Add User Story 5 → Test independently → Deploy/Review (multi-machine sync)
7. Add User Story 6 → Test independently → Deploy/Review (troubleshooting)
8. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple contributors:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Contributor A: User Story 1 (T009-T013)
   - Contributor B: User Story 2 (T014-T021)
   - Contributor C: User Story 4 (T028-T037)
   - Contributor D: User Story 6 (T042-T048)
3. User Stories 3 and 5 can be picked up by available contributors
4. Stories complete and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- No tests required (documentation project - validated manually against success criteria)
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Total tasks: 60 across 6 user stories
- Parallel opportunities: Extensive (most tasks within stories can run in parallel)
- Tools documented: 10 major + Starship (minimal)
- Fish functions documented: All 77
- Architecture diagrams: 3+ Mermaid diagrams
