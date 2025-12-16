# Installation Timing Template

## Purpose

This template provides a structured format for recording timing data during fresh macOS installation testing. Use this to track progress against the **60-minute target (SC-001)** and identify bottlenecks in the installation process.

---

## Test Metadata

- **Tester name**: _____________________________________________
- **Test date**: _____________________________________________
- **Test start time**: _____________________________________________
- **Test end time**: _____________________________________________
- **Total elapsed time**: _________ minutes

---

## Machine Information

- **Machine model**: _____________________________________________
- **Processor**: _____________________________________________
- **RAM**: _________ GB
- **Storage type**: SSD / HDD
- **macOS version**: _____________________________________________
- **macOS build**: _____________________________________________

---

## Network Information

- **Connection type**: WiFi / Ethernet / Cellular
- **Download speed**: _________ Mbps
- **Upload speed**: _________ Mbps
- **Latency to GitHub**: _________ ms

---

## Installation Timing Breakdown

### Step 1: Prerequisites Validation

| Checkpoint | Time | Duration | Notes |
|------------|------|----------|-------|
| Start | _________ | — | Review prerequisites |
| Prerequisites verified | _________ | _________ min | |
| **Total** | — | **_________ min** | |

**Status**: ✅ Success / ⚠️  Issues / ❌ Failed

**Issues**:

```
[Record any issues]
```

---

### Step 2: Install Homebrew

| Checkpoint | Time | Duration | Notes |
|------------|------|----------|-------|
| Start | _________ | — | Begin Homebrew installation |
| Installation script downloaded | _________ | _________ min | |
| Homebrew installed | _________ | _________ min | |
| PATH configured | _________ | _________ min | |
| `brew --version` verified | _________ | _________ min | |
| **Total** | — | **_________ min** | |

**Homebrew version**: _____________

**Status**: ✅ Success / ⚠️  Issues / ❌ Failed

**Issues**:

```
[Record any issues]
```

---

### Step 3: Install chezmoi and Clone Repository

| Checkpoint | Time | Duration | Notes |
|------------|------|----------|-------|
| Start | _________ | — | Install chezmoi |
| `brew install chezmoi` complete | _________ | _________ min | |
| chezmoi version verified | _________ | _________ min | |
| Repository clone started | _________ | _________ min | |
| Secrets URL prompt | _________ | _________ min | |
| GPG passphrase prompt | _________ | _________ min | |
| Repository cloned | _________ | _________ min | |
| **Total** | — | **_________ min** | |

**chezmoi version**: _____________

**Repository size**: _________ MB

**Status**: ✅ Success / ⚠️  Issues / ❌ Failed

**Issues**:

```
[Record any issues]
```

---

### Step 4: Review Configuration

| Checkpoint | Time | Duration | Notes |
|------------|------|----------|-------|
| Start | _________ | — | Review what will be applied |
| `chezmoi diff` run | _________ | _________ min | |
| `chezmoi apply --dry-run` run | _________ | _________ min | |
| Configuration reviewed | _________ | _________ min | |
| **Total** | — | **_________ min** | |

**Files to be modified**: _________ count

**Status**: ✅ Success / ⚠️  Issues / ❌ Failed

**Issues**:

```
[Record any issues]
```

---

### Step 5: Apply Dotfiles

| Checkpoint | Time | Duration | Notes |
|------------|------|----------|-------|
| Start | _________ | — | Apply all configurations |
| `chezmoi apply` started | _________ | — | |
| Secrets submodule initialized | _________ | _________ min | |
| Homebrew bundle started | _________ | _________ min | |
| Homebrew formulae installed | _________ | _________ min | Number: ____ |
| Homebrew casks installed | _________ | _________ min | Number: ____ |
| Homebrew taps added | _________ | _________ min | Number: ____ |
| Fish shell setup started | _________ | _________ min | |
| Fisher plugins installed | _________ | _________ min | Number: ____ |
| Additional tools installed | _________ | _________ min | |
| Configuration files applied | _________ | _________ min | |
| **Total** | — | **_________ min** | |

**Homebrew packages installed**: _________ total

**Status**: ✅ Success / ⚠️  Issues / ❌ Failed

**Issues**:

```
[Record any issues]
```

**Bottlenecks identified**:

```
[Note any particularly slow steps]
```

---

### Step 6: Set Fish as Default Shell

| Checkpoint | Time | Duration | Notes |
|------------|------|----------|-------|
| Start | _________ | — | Configure Fish shell |
| Added Fish to `/etc/shells` | _________ | _________ min | |
| `chsh -s` command run | _________ | _________ min | |
| Terminal restarted | _________ | _________ min | |
| Fish prompt verified | _________ | _________ min | |
| Starship prompt verified | _________ | _________ min | |
| **Total** | — | **_________ min** | |

**Fish version**: _____________

**Starship version**: _____________

**Status**: ✅ Success / ⚠️  Issues / ❌ Failed

**Issues**:

```
[Record any issues]
```

---

### Step 7: Configure macOS Permissions

| Checkpoint | Time | Duration | Notes |
|------------|------|----------|-------|
| Start | _________ | — | Grant system permissions |
| Yabai accessibility granted | _________ | _________ min | |
| Skhd accessibility granted | _________ | _________ min | |
| Karabiner input monitoring granted | _________ | _________ min | |
| Karabiner accessibility granted | _________ | _________ min | |
| Hammerspoon accessibility granted | _________ | _________ min | |
| All permissions verified | _________ | _________ min | |
| **Total** | — | **_________ min** | |

**Status**: ✅ Success / ⚠️  Issues / ❌ Failed

**Issues**:

```
[Record any issues]
```

**macOS version notes**:

```
[Note any macOS-specific permission differences]
```

---

### Step 8: Start Services

| Checkpoint | Time | Duration | Notes |
|------------|------|----------|-------|
| Start | _________ | — | Start window management |
| `brew services start yabai` | _________ | _________ min | |
| `brew services start skhd` | _________ | _________ min | |
| Service status verified | _________ | _________ min | |
| Window tiling tested | _________ | _________ min | |
| **Total** | — | **_________ min** | |

**Status**: ✅ Success / ⚠️  Issues / ❌ Failed

**Issues**:

```
[Record any issues]
```

---

### Step 9: Verify Installation

| Checkpoint | Time | Duration | Notes |
|------------|------|----------|-------|
| Start | _________ | — | Run verification checklist |
| Shell environment verified | _________ | _________ min | |
| Development tools verified | _________ | _________ min | |
| Window management verified | _________ | _________ min | |
| Keyboard customization verified | _________ | _________ min | |
| Text editor verified | _________ | _________ min | |
| Git configuration verified | _________ | _________ min | |
| Additional tools verified | _________ | _________ min | |
| **Total** | — | **_________ min** | |

**Tools verified**: _____ / _____ total

**Status**: ✅ Success / ⚠️  Issues / ❌ Failed

**Issues**:

```
[Record any issues]
```

---

## Overall Timing Summary

### Installation Steps Totals

| Step | Duration | % of Total | Status |
|------|----------|------------|--------|
| 1. Prerequisites | _________ min | ____% | ✅ ⚠️  ❌ |
| 2. Homebrew | _________ min | ____% | ✅ ⚠️  ❌ |
| 3. chezmoi + Clone | _________ min | ____% | ✅ ⚠️  ❌ |
| 4. Review Config | _________ min | ____% | ✅ ⚠️  ❌ |
| 5. Apply Dotfiles | _________ min | ____% | ✅ ⚠️  ❌ |
| 6. Set Fish Shell | _________ min | ____% | ✅ ⚠️  ❌ |
| 7. Permissions | _________ min | ____% | ✅ ⚠️  ❌ |
| 8. Start Services | _________ min | ____% | ✅ ⚠️  ❌ |
| 9. Verify | _________ min | ____% | ✅ ⚠️  ❌ |
| **TOTAL** | **_________ min** | **100%** | |

### Category Breakdown

| Category | Duration | % of Total |
|----------|----------|------------|
| System prerequisites | _________ min | ____% |
| Package installation (Homebrew) | _________ min | ____% |
| Configuration application | _________ min | ____% |
| Permission granting | _________ min | ____% |
| Verification testing | _________ min | ____% |
| **TOTAL** | **_________ min** | **100%** |

---

## Target Comparison

### SC-001: Installation Time Target

- **Target**: < 60 minutes
- **Actual time**: _________ minutes
- **Difference**: _________ minutes (under/over target)
- **Percentage of target**: _____%
- **Met**: ✅ Yes / ❌ No

### Time Breakdown Analysis

**Fastest steps** (< 2 minutes):

1. _____________________________________________
2. _____________________________________________
3. _____________________________________________

**Slowest steps** (> 10 minutes):

1. _____________________________________________
2. _____________________________________________
3. _____________________________________________

**Bottlenecks identified**:

```
[List steps that took longer than expected and why]
```

**Optimization opportunities**:

```
[Suggest ways to reduce installation time]
```

---

## Network Impact Analysis

### Download Activity

| Item | Size | Time | Speed |
|------|------|------|-------|
| Homebrew installer | _______ MB | _______ min | _______ Mbps |
| Dotfiles repository | _______ MB | _______ min | _______ Mbps |
| Homebrew formulae | _______ MB | _______ min | _______ Mbps |
| Homebrew casks | _______ MB | _______ min | _______ Mbps |
| Fish plugins | _______ MB | _______ min | _______ Mbps |
| Neovim plugins | _______ MB | _______ min | _______ Mbps |
| **Total downloaded** | **_______ MB** | **_______ min** | **avg _______ Mbps** |

**Network-dependent time**: _________ minutes (____% of total)

**Network speed impact**:

```
[Note how network speed affected installation time]
```

---

## Machine Performance Impact

### CPU Usage

- **Average during Homebrew install**: _______%
- **Peak during installation**: _______%
- **Normal idle after setup**: _______%

### Memory Usage

- **During installation**: _________ GB
- **After installation**: _________ GB
- **Available after setup**: _________ GB

### Disk Usage

- **Before installation**: _________ GB used
- **After installation**: _________ GB used
- **Space consumed**: _________ GB
- **Homebrew cache size**: _________ GB

**Performance notes**:

```
[Note any performance issues or machine-specific observations]
```

---

## Comparison with Previous Tests

### Historical Timing Data

| Test Date | macOS Version | Total Time | Network Speed | Notes |
|-----------|---------------|------------|---------------|-------|
| _________ | _____________ | _______ min | _______ Mbps | _____________ |
| _________ | _____________ | _______ min | _______ Mbps | _____________ |
| _________ | _____________ | _______ min | _______ Mbps | _____________ |
| **This test** | _____________ | **_______ min** | **_______ Mbps** | |

**Trend analysis**:

```
[Compare this test with previous tests - improving/worsening times?]
```

---

## Recommendations

### Documentation Updates

```
[Suggest updates to INSTALL.md based on timing data]

Example:
- Update "Estimated completion time" if consistently different
- Add note about Homebrew bundle taking 20-30 minutes
- Clarify which steps can be done while waiting
```

### Process Improvements

```
[Suggest workflow improvements to reduce installation time]

Example:
- Can any steps run in parallel?
- Can package installation be optimized?
- Are there unnecessary dependencies?
```

### Target Adjustments

```
[Suggest if 60-minute target should be adjusted based on data]

Example:
- If consistently over 60 minutes on good hardware/network, adjust target
- If under 60 minutes even on slow machines, tighten target
```

---

## Validation Testing Times

### Additional Tests (Not part of installation time)

| Test | Duration | Status |
|------|----------|--------|
| Window management workflow | _________ min | ✅ ⚠️  ❌ |
| Keymap discoverability (4 scenarios) | _________ min | ✅ ⚠️  ❌ |
| Fish functions (5 tested) | _________ min | ✅ ⚠️  ❌ |
| Neovim plugin system | _________ min | ✅ ⚠️  ❌ |
| Troubleshooting scenarios (3 tested) | _________ min | ✅ ⚠️  ❌ |
| Multi-machine sync (optional) | _________ min | ✅ ⚠️  ❌ N/A |
| **Total validation time** | **_________ min** | |

**Total test session time** (installation + validation): _________ minutes

---

## Notes

### General Observations

```
[Free-form notes about timing, bottlenecks, unexpected delays, etc.]
```

### macOS-Specific Observations

```
[Note any macOS version-specific timing differences]
```

### Hardware-Specific Observations

```
[Note any hardware-specific timing differences (Apple Silicon vs Intel, RAM, etc.)]
```

### Network-Specific Observations

```
[Note any network-specific observations (WiFi vs Ethernet, download speeds, etc.)]
```

---

**Data collected by**: _____________________________________________

**Collection date**: _____________________________________________

**Data quality**: Excellent / Good / Fair / Poor

**Next timing test scheduled**: _____________________________________________
