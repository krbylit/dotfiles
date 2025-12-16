# Fresh Installation Validation Guide

## Overview

### Purpose

This testing guide provides a comprehensive protocol for validating the dotfiles documentation and installation process on a fresh macOS machine. Use this guide to:

- **Verify installation procedures** work as documented
- **Validate documentation accuracy** by following it exactly
- **Measure setup time** against the <60 minute target (SC-001)
- **Test keymap discoverability** against the <2 minute target (SC-002)
- **Identify documentation gaps** and areas for improvement
- **Ensure multi-machine compatibility** by testing on different hardware

### When to Use This Guide

- **Fresh macOS installation**: New machine or clean install
- **Major macOS updates**: After OS upgrades that might affect permissions or tooling
- **Documentation updates**: After significant changes to INSTALL.md or other docs
- **Multi-machine validation**: Testing dotfiles on a second/third machine
- **Quarterly validation**: Regular testing to ensure documentation stays current

### Expected Outcomes

After completing this validation:

- ✅ All tools installed and functional
- ✅ All permissions granted correctly
- ✅ Window management working (Yabai + skhd + Karabiner)
- ✅ Shell environment configured (Fish + Starship + functions)
- ✅ Editor ready (Neovim + LSP + plugins)
- ✅ Documentation tested and validated
- ✅ Timing data collected for analysis
- ✅ Issues documented for improvement

---

## Prerequisites

### System Requirements

Before beginning, ensure you have:

- [ ] **Fresh macOS installation** (macOS 15.0+ recommended)
  - Version: _____________
  - Build: _____________
- [ ] **Administrator access** with sudo privileges
- [ ] **Stable internet connection**
  - Speed test result: _________ Mbps download
  - Connection type: WiFi / Ethernet
- [ ] **GitHub account** with SSH keys configured
  - SSH key added to GitHub: Yes / No
  - Test connection: `ssh -T git@github.com`
- [ ] **Apple ID** signed in to the Mac
- [ ] **At least 90 minutes** of uninterrupted time
  - Target: 60 minutes for installation
  - Buffer: 30 minutes for documentation, troubleshooting, and validation

### Optional Prerequisites

Nice to have but not required:

- [ ] **1Password account** (for secrets management testing)
- [ ] **Private secrets repository** (for full secrets workflow testing)
- [ ] **Second monitor** (for testing multi-display window management)
- [ ] **External keyboard** (for testing HHKB-specific configurations)

### Testing Materials

Have ready:

- [ ] This testing guide printed or on separate device
- [ ] Timing template (docs/testing/timing-template.md)
- [ ] Notepad for observations and issues
- [ ] INSTALL.md, KEYMAPS.md, and TROUBLESHOOTING.md open for reference

---

## Testing Procedure

Follow INSTALL.md exactly as written, recording times and observations at each step.

### Step 1: Prerequisites Validation

**Reference**: INSTALL.md - Prerequisites section

**Start time**: _________

**Actions**:

1. Verify you meet all prerequisites listed in INSTALL.md
2. Check macOS version compatibility
3. Confirm administrator access
4. Test internet connection stability
5. Verify GitHub SSH access

**Validation**:

- [ ] All prerequisites in INSTALL.md are clear and achievable
- [ ] No additional prerequisites discovered during testing
- [ ] Prerequisites section is complete and accurate

**End time**: _________

**Duration**: _________ minutes

**Issues found**:

```
[Record any issues, missing prerequisites, or unclear instructions]
```

**Documentation gaps**:

```
[Note any missing information or ambiguous instructions]
```

---

### Step 2: Install Homebrew

**Reference**: INSTALL.md - Step 1: Install Homebrew

**Start time**: _________

**Actions**:

1. Run Homebrew installation command from INSTALL.md
2. Follow post-installation setup for your Mac architecture (Apple Silicon vs Intel)
3. Add Homebrew to PATH as documented
4. Verify installation with `brew --version`

**Validation**:

- [ ] Homebrew installed successfully
- [ ] PATH correctly configured
- [ ] `brew --version` shows version information
- [ ] Installation instructions clear for both Apple Silicon and Intel
- [ ] No errors during installation

**End time**: _________

**Duration**: _________ minutes

**Homebrew version**: _____________

**Issues found**:

```
[Record installation errors, PATH issues, or unclear steps]
```

---

### Step 3: Install chezmoi and Clone Repository

**Reference**: INSTALL.md - Steps 2-3

**Start time**: _________

**Actions**:

1. Install chezmoi via Homebrew
2. Verify chezmoi installation with `chezmoi --version`
3. Initialize chezmoi with dotfiles repository
4. Provide secrets repository URL (if applicable)
5. Enter GPG passphrase when prompted

**Validation**:

- [ ] chezmoi installed successfully
- [ ] Repository cloned to `~/.local/share/chezmoi`
- [ ] Prompts for secrets URL and passphrase appeared
- [ ] Instructions for what to enter are clear
- [ ] chezmoi.toml created with correct configuration

**End time**: _________

**Duration**: _________ minutes

**chezmoi version**: _____________

**Issues found**:

```
[Record clone errors, prompt confusion, or authentication issues]
```

---

### Step 4: Review Configuration

**Reference**: INSTALL.md - Step 4: Review configuration before applying

**Start time**: _________

**Actions**:

1. Run `chezmoi diff` to preview changes
2. Run `chezmoi apply --dry-run --verbose` to see what will happen
3. Review the list of files that will be created
4. Verify key configuration files are present in the diff

**Validation**:

- [ ] `chezmoi diff` shows expected files
- [ ] No unexpected files or modifications
- [ ] Important files documented in INSTALL.md appear in diff
- [ ] Instructions for interpreting diff output are clear

**End time**: _________

**Duration**: _________ minutes

**File count**: _________ files to be created/modified

**Issues found**:

```
[Record unexpected files, missing files, or diff interpretation issues]
```

---

### Step 5: Apply Dotfiles

**Reference**: INSTALL.md - Step 5: Apply dotfiles

**Start time**: _________

**Actions**:

1. Run `chezmoi apply`
2. Monitor automatic setup scripts (secrets, Homebrew bundle, Fish setup, etc.)
3. Note approximate time for Homebrew package installation
4. Watch for errors during script execution

**Validation**:

- [ ] All files applied successfully
- [ ] Secrets submodule initialized (if configured)
- [ ] Homebrew bundle installation started
- [ ] Fish shell configured with fisher plugins
- [ ] No critical errors during application
- [ ] INSTALL.md accurately describes what happens during this step

**End time**: _________

**Duration**: _________ minutes

**Homebrew packages installed**: _________ (approximate count)

**Issues found**:

```
[Record apply errors, script failures, or package installation issues]
```

---

### Step 6: Set Fish as Default Shell

**Reference**: INSTALL.md - Step 6: Set Fish as your default shell

**Start time**: _________

**Actions**:

1. Add Fish to `/etc/shells` if not present
2. Run `chsh -s /opt/homebrew/bin/fish`
3. Close and reopen terminal
4. Verify Fish shell loads with Starship prompt

**Validation**:

- [ ] Fish added to `/etc/shells` successfully
- [ ] Default shell changed to Fish
- [ ] New terminal windows open with Fish
- [ ] Starship prompt appears correctly
- [ ] Instructions are clear and complete

**End time**: _________

**Duration**: _________ minutes

**Fish version**: _____________

**Starship version**: _____________

**Issues found**:

```
[Record shell change issues, prompt problems, or permission errors]
```

---

### Step 7: Configure macOS Permissions

**Reference**: INSTALL.md - Step 7: Configure macOS permissions

**Start time**: _________

**Actions**:

1. Grant Accessibility permission to Yabai
2. Grant Accessibility permission to Skhd
3. Grant Input Monitoring and Accessibility to Karabiner Elements
4. Grant Accessibility to Hammerspoon
5. Verify all permissions are granted in System Settings

**Validation**:

- [ ] Yabai has Accessibility permission
- [ ] Skhd has Accessibility permission
- [ ] Karabiner has Input Monitoring permission
- [ ] Karabiner has Accessibility permission
- [ ] Hammerspoon has Accessibility permission
- [ ] Instructions for granting permissions are clear
- [ ] Screenshots or detailed steps provided (if needed)

**End time**: _________

**Duration**: _________ minutes

**Issues found**:

```
[Record permission issues, System Settings navigation problems, or unclear steps]
```

---

### Step 8: Start Services

**Reference**: INSTALL.md - Step 8: Start services

**Start time**: _________

**Actions**:

1. Start yabai service with `brew services start yabai`
2. Start skhd service with `brew services start skhd`
3. Verify services are running with `brew services list`
4. Test window tiling behavior by opening multiple applications

**Validation**:

- [ ] Yabai service started successfully
- [ ] Skhd service started successfully
- [ ] Both services show "started" status
- [ ] Window tiling behavior works
- [ ] No errors in service logs

**End time**: _________

**Duration**: _________ minutes

**Issues found**:

```
[Record service start errors, tiling problems, or log errors]
```

---

### Step 9: Verify Installation

**Reference**: INSTALL.md - Verification Checklist

**Start time**: _________

**Actions**:

Go through INSTALL.md's verification checklist systematically:

#### Shell Environment

- [ ] Fish shell loads successfully
- [ ] Starship prompt appears with git information
- [ ] Fish functions are available (`functions` command works)
- [ ] Test custom function: `lg` (should open lazygit)

#### Development Tools

- [ ] stylua installed: `stylua --version`
- [ ] fish_indent available: `fish_indent --version`
- [ ] shfmt installed: `shfmt --version`
- [ ] prettier installed: `prettier --version`
- [ ] yapf installed: `yapf --version`
- [ ] pre-commit hooks active: `cd ~/.local/share/chezmoi && pre-commit run --all-files`

#### Window Management

- [ ] Yabai has accessibility permissions
- [ ] Skhd has accessibility permissions
- [ ] Window tiling works correctly
- [ ] `yabai -m query --windows` returns window information
- [ ] Test hotkey works (e.g., Ctrl+Return opens terminal)

#### Keyboard Customization

- [ ] Karabiner has input monitoring permission
- [ ] Karabiner has accessibility permission
- [ ] Keyboard modifications work (test Caps Lock → Escape/Control)
- [ ] `karabiner_cli --show-current-profile-name` shows profile

#### Text Editor

- [ ] Neovim opens without errors
- [ ] `:checkhealth` shows no critical errors
- [ ] Plugins loaded correctly (`:Lazy` shows status)
- [ ] LSP works for at least one language

#### Git Configuration

- [ ] Git user name configured: `git config --get user.name`
- [ ] Git user email configured: `git config --get user.email`
- [ ] Git aliases work: `git st` (runs `git status`)

#### Additional Verifications

- [ ] Homebrew packages installed: `brew list` shows packages
- [ ] Fisher plugins installed: `fisher list` shows plugins
- [ ] No critical errors in any tool

**End time**: _________

**Duration**: _________ minutes

**Issues found**:

```
[Record any verification failures or tools not working as expected]
```

---

## Validation Tests

After basic installation, test specific workflows and documentation.

### Test 1: Window Management Workflow

**Reference**: KEYMAPS.md - Window Management section

**Start time**: _________

**Actions**:

1. Open 3-4 applications
2. Test space switching: Alt + 1-9
3. Test window focus: Ctrl + Alt + hjkl
4. Test window movement: Shift + Alt + hjkl
5. Test layout changes: Alt + b (BSP), Alt + f (float)
6. Test window state: Shift + Alt + t (float), Shift + Alt + m (zoom)

**Validation**:

- [ ] Space switching works correctly
- [ ] Window focus navigation works
- [ ] Window movement/warping works
- [ ] Layout modes change as expected
- [ ] Window state toggles work
- [ ] All hotkeys documented in KEYMAPS.md

**End time**: _________

**Duration**: _________ minutes

**Issues found**:

```
[Record window management issues or undocumented hotkeys]
```

---

### Test 2: Keymap Discoverability (SC-002)

**Reference**: KEYMAPS.md

**Target**: Find any keymap in < 2 minutes

**Test scenarios**:

#### Scenario 1: Find "move window to space 2"

- Start time: _________
- Method used: Cmd+F search / Table of contents / Reading sections
- Found in: _________ seconds
- Location: Page/section _____________
- Success: Yes / No

#### Scenario 2: Find "toggle Neovim file explorer"

- Start time: _________
- Method used: _____________
- Found in: _________ seconds
- Location: _____________
- Success: Yes / No

#### Scenario 3: Find "open Yazi from Neovim"

- Start time: _________
- Method used: _____________
- Found in: _________ seconds
- Location: _____________
- Success: Yes / No

#### Scenario 4: Find "Fish vi-mode escape key"

- Start time: _________
- Method used: _____________
- Found in: _________ seconds
- Location: _____________
- Success: Yes / No

**Validation**:

- [ ] All 4 scenarios completed in < 2 minutes each
- [ ] KEYMAPS.md structure supports quick lookup
- [ ] Table of contents is helpful
- [ ] Cross-references work correctly
- [ ] Search functionality effective

**Average lookup time**: _________ seconds

**SC-002 met** (< 2 min): Yes / No

**Issues found**:

```
[Record navigation difficulties or missing information]
```

---

### Test 3: Fish Functions Discovery

**Reference**: dot_config/fish/TOOLS.md

**Start time**: _________

**Actions**:

1. Open TOOLS.md
2. Find description for 5 random functions
3. Test each function to verify it works
4. Check if function documentation is accurate

**Functions tested**:

1. Function: _____________ | Works: Yes/No | Doc accurate: Yes/No
2. Function: _____________ | Works: Yes/No | Doc accurate: Yes/No
3. Function: _____________ | Works: Yes/No | Doc accurate: Yes/No
4. Function: _____________ | Works: Yes/No | Doc accurate: Yes/No
5. Function: _____________ | Works: Yes/No | Doc accurate: Yes/No

**Validation**:

- [ ] All tested functions work as documented
- [ ] TOOLS.md descriptions are accurate
- [ ] Function categories are helpful
- [ ] Examples provided are correct

**End time**: _________

**Duration**: _________ minutes

**Issues found**:

```
[Record function issues or documentation inaccuracies]
```

---

### Test 4: Neovim Plugin System

**Reference**: dot_config/exact_nvim/README.md

**Start time**: _________

**Actions**:

1. Open Neovim
2. Run `:Lazy` to check plugin status
3. Test 5 key plugins:
   - File navigation (Telescope/Snacks picker)
   - LSP functionality (go to definition, hover)
   - Git integration (Lazygit)
   - File manager (Yazi integration)
   - Code completion (nvim-cmp)
4. Run `:checkhealth` and review results

**Validation**:

- [ ] All plugins loaded successfully
- [ ] No critical errors in `:checkhealth`
- [ ] File navigation works
- [ ] LSP provides completions and diagnostics
- [ ] Git integration functional
- [ ] Yazi integration works
- [ ] README.md accurately describes setup

**End time**: _________

**Duration**: _________ minutes

**Issues found**:

```
[Record plugin errors or missing documentation]
```

---

### Test 5: Troubleshooting Scenarios

**Reference**: TROUBLESHOOTING.md

**Goal**: Verify troubleshooting guide covers common issues

**Scenario 1: Simulate Yabai permission loss**

1. Revoke Yabai accessibility permission
2. Attempt to use window management
3. Follow TROUBLESHOOTING.md to resolve
4. Document time to resolution: _________ minutes
5. Success: Yes / No

**Scenario 2: Simulate Fish function not found**

1. Temporarily rename a Fish function file
2. Try to use the function
3. Follow TROUBLESHOOTING.md to diagnose
4. Document time to resolution: _________ minutes
5. Success: Yes / No

**Scenario 3: Simulate LSP not working**

1. Open file type without LSP installed
2. Notice lack of completions
3. Follow TROUBLESHOOTING.md to install LSP
4. Document time to resolution: _________ minutes
5. Success: Yes / No

**Validation**:

- [ ] Troubleshooting guide covers all scenarios tested
- [ ] Resolution steps are clear and correct
- [ ] Diagnostic commands work as documented
- [ ] Time to resolution is reasonable

**SC-003 met** (90%+ issues self-serviceable): Yes / No

**Issues found**:

```
[Record missing troubleshooting content or unclear solutions]
```

---

### Test 6: Multi-Machine Workflow (Optional)

**Reference**: docs/workflows/multi-machine-sync.md

**Prerequisites**: Access to second machine or VM

**Start time**: _________

**Actions**:

1. Follow multi-machine-sync.md to set up on second machine
2. Test machine-specific configuration templates
3. Verify synchronization workflow
4. Test making changes and syncing between machines

**Validation**:

- [ ] Second machine setup completes in < 30 minutes (SC-010)
- [ ] Machine-specific configs apply correctly
- [ ] Sync workflow documented clearly
- [ ] No conflicts during synchronization

**End time**: _________

**Duration**: _________ minutes

**SC-010 met** (< 30 min): Yes / No

**Issues found**:

```
[Record multi-machine issues or unclear sync instructions]
```

---

## Success Criteria Verification

Review all success criteria from the project specification:

### SC-001: Setup Time

- **Target**: Complete fresh installation in < 60 minutes
- **Actual time**: _________ minutes (Steps 1-8 total)
- **Met**: Yes / No
- **Notes**: _____________________________________________

### SC-002: Keymap Lookup Time

- **Target**: Find any keymap in < 2 minutes
- **Actual average**: _________ seconds
- **Met**: Yes / No
- **Notes**: _____________________________________________

### SC-003: Self-Service Troubleshooting

- **Target**: 90%+ common issues resolvable via docs
- **Tested scenarios**: _________ total
- **Resolved via docs**: _________ count
- **Percentage**: _________ %
- **Met**: Yes / No
- **Notes**: _____________________________________________

### SC-004: Multi-Machine Comparison

- **Target**: Document findings from multiple machines
- **Machines tested**: _____________
- **Findings documented**: Yes / No
- **Met**: Yes / No / N/A
- **Notes**: _____________________________________________

### SC-010: Second Machine Setup

- **Target**: < 30 minutes
- **Actual time**: _________ minutes
- **Met**: Yes / No / N/A
- **Notes**: _____________________________________________

---

## Test Results Summary

### Machine Specifications

- **Model**: _____________________________________________
- **Processor**: _____________________________________________
- **RAM**: _____________________________________________
- **Storage**: _____________________________________________
- **macOS Version**: _____________________________________________
- **macOS Build**: _____________________________________________

### Network Information

- **Connection type**: WiFi / Ethernet
- **Download speed**: _________ Mbps
- **Upload speed**: _________ Mbps
- **Latency**: _________ ms

### Overall Timing

- **Total installation time**: _________ minutes
- **Homebrew packages**: _________ minutes
- **Configuration application**: _________ minutes
- **Permissions setup**: _________ minutes
- **Verification**: _________ minutes

### Overall Results

- **Installation successful**: Yes / No
- **All tools functional**: Yes / No
- **Documentation accurate**: Yes / No
- **Success criteria met**: ___ / 5

### Pass/Fail Assessment

**Overall result**: PASS / FAIL

**Justification**:

```
[Explain the overall assessment]
```

---

## Issues and Documentation Gaps

### Critical Issues (Blockers)

```
1. [Issue description]
   - Impact: [High/Medium/Low]
   - Affected document: [File path]
   - Suggested fix: [Description]

2. [Issue description]
   - Impact: [High/Medium/Low]
   - Affected document: [File path]
   - Suggested fix: [Description]
```

### Major Issues (Significant Impact)

```
1. [Issue description]
   - Impact: [High/Medium/Low]
   - Affected document: [File path]
   - Suggested fix: [Description]
```

### Minor Issues (Polish)

```
1. [Issue description]
   - Impact: [High/Medium/Low]
   - Affected document: [File path]
   - Suggested fix: [Description]
```

### Documentation Gaps

```
1. [Missing information]
   - Should be documented in: [File path]
   - Content needed: [Description]

2. [Unclear instruction]
   - Location: [File and section]
   - Clarification needed: [Description]
```

### Positive Findings

```
[Document what worked well, clear instructions, helpful examples, etc.]
```

---

## Post-Testing Actions

### Immediate Actions

- [ ] Document all issues found in GitHub issues
- [ ] Create pull requests for critical documentation fixes
- [ ] Update timing estimates in INSTALL.md if needed
- [ ] Share test results with team

### Follow-Up Tasks

- [ ] Re-test on different macOS versions if issues found
- [ ] Validate fixes for all documented issues
- [ ] Update TROUBLESHOOTING.md with new issues discovered
- [ ] Schedule next validation test (quarterly recommended)

### Recommendations

```
[List recommendations for documentation improvements, workflow changes, etc.]
```

---

## Notes and Observations

### General Observations

```
[Free-form notes about the testing experience, documentation quality, etc.]
```

### Tool-Specific Notes

#### Homebrew

```
[Notes about Homebrew installation, package installation speed, etc.]
```

#### chezmoi

```
[Notes about chezmoi workflow, template rendering, etc.]
```

#### Yabai/skhd/Karabiner

```
[Notes about window management setup, permission granting, etc.]
```

#### Fish Shell

```
[Notes about Fish configuration, function availability, etc.]
```

#### Neovim

```
[Notes about Neovim setup, plugin installation, LSP configuration, etc.]
```

### Documentation Quality Notes

```
[Notes about documentation clarity, completeness, organization, etc.]
```

---

## Appendix: Testing Checklist

Quick reference checklist for testing:

### Pre-Testing

- [ ] Fresh macOS installation ready
- [ ] Administrator access verified
- [ ] Internet connection tested
- [ ] GitHub SSH access confirmed
- [ ] Testing materials prepared
- [ ] Timing template ready

### During Testing

- [ ] Record start/end times for each step
- [ ] Document all issues immediately
- [ ] Take screenshots of errors
- [ ] Note unclear documentation
- [ ] Test all verification steps

### Post-Testing

- [ ] Complete test results template
- [ ] Calculate total timing
- [ ] Verify success criteria
- [ ] Document all issues found
- [ ] Create GitHub issues for bugs
- [ ] Share results with team

### Validation Tests

- [ ] Window management workflow
- [ ] Keymap discoverability
- [ ] Fish functions
- [ ] Neovim plugins
- [ ] Troubleshooting scenarios
- [ ] Multi-machine sync (optional)

---

**Test conducted by**: _____________________________________________

**Test date**: _____________________________________________

**Test duration**: _________ hours

**Next test scheduled**: _____________________________________________
