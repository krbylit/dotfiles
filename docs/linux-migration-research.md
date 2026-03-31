# macOS-to-Linux Migration Research

Research document identifying all macOS-specific configurations in the chezmoi dotfiles that need Linux equivalents for parity on Arch/HyDE.

## Table of Contents

1. [Keyboard Remapping (Karabiner)](#1-keyboard-remapping-karabiner)
2. [Window Management (Yabai + skhd)](#2-window-management-yabai--skhd)
3. [System Automation (Hammerspoon)](#3-system-automation-hammerspoon)
4. [Application Launcher (Raycast)](#4-application-launcher-raycast)
5. [Background Services (LaunchAgents)](#5-background-services-launchagents)
6. [Terminal Keybindings (Ghostty)](#6-terminal-keybindings-ghostty)
7. [Key Repeat / Input Speed](#7-key-repeat--input-speed)
8. [macOS System Defaults](#8-macos-system-defaults)
9. [Homebrew macOS-Only Packages](#9-homebrew-macos-only-packages)
10. [Shell Config Issues](#10-shell-config-issues)
11. [chezmoi Ignore Gaps](#11-chezmoi-ignore-gaps)
12. [Summary: What Exists vs What's Missing](#12-summary)

---

## 1. Keyboard Remapping (Karabiner)

**Source**: `cm-util/ctrld-configs/karabiner/karabiner.json`
**Ignored on Linux**: Yes (via `.chezmoiignore.tmpl`)
**Linux equivalent needed**: Yes — no replacement configured

### Active Rules (15)

| Rule | macOS Behavior | Linux Replacement Tool |
|------|---------------|----------------------|
| Right Option + hjkl → Arrow keys | Terminal-only (Ghostty/Kitty) | `keyd`, `kanata`, or Hyprland `bind` |
| Left Ctrl + hjkl → Arrow keys | Non-terminal apps | `keyd` / `kanata` (system-wide) |
| Ctrl+Shift + hjkl → Shift+Arrow | Text selection | `keyd` / `kanata` |
| Ctrl+w → Option+Backspace | Delete previous word (not in Ghostty) | `keyd` / `kanata` |
| Option+f → Cmd+Tab | App switcher forward | Hyprland already has Alt+Tab |
| Option+s → Cmd+Shift+Tab | App switcher backward | Hyprland keybind |
| **HHKB**: Left Ctrl → Ctrl held / Esc tapped | Dual-function key | `keyd` / `kanata` (supports dual-function) |
| **Mac KB**: Left Ctrl → Left Option | Modifier remap | `keyd` / `kanata` |
| **Mac KB**: Caps Lock → Ctrl held / Esc tapped | Dual-function key | `keyd` / `kanata` |
| Right Shift double-tap → Caps Lock | Safety toggle | `keyd` / `kanata` |
| Cmd+q double-tap → Quit | Prevent accidental quit | Hyprland keybind (already `Super+Q` to close) |
| Cmd+h → Disabled | Prevent window hiding | N/A on Linux (no hide behavior) |
| Cmd+Option+h → Disabled | Prevent hide-all | N/A on Linux |
| Cmd+Option+m → Disabled | Prevent minimize-all | N/A on Linux |

### Hardware Detection

Karabiner detects HHKB keyboard (vendor_id: 1278, product_id: 33) vs Mac keyboard and applies different rules. Linux equivalents:
- `keyd`: Can match by device ID
- `kanata`: Can match by device path/name

### Disabled Rules (8, for reference)

- Caps Lock → Hyper key (Cmd+Ctrl+Option+Shift)
- Right Command + hjkl → Arrow keys
- Spacebar → Left Shift (dual-function)
- Various Hyper key configurations

---

## 2. Window Management (Yabai + skhd)

**Source**: `dot_config/yabai/executable_yabairc`, `dot_config/skhd/skhdrc`
**Ignored on Linux**: Yes (via `.chezmoiignore.tmpl`)
**Linux equivalent**: Partially — Hyprland/HyDE keybindings exist at `dot_config/hypr/keybindings.conf` but don't mirror the skhd mappings

### Yabai Features That Need Parity

| Feature | macOS (Yabai) | Current Linux (Hyprland) | Gap? |
|---------|--------------|-------------------------|------|
| BSP tiling | Yes | Yes (default) | No |
| Stack layout | Yes | Group mode available | Partial |
| Named spaces (term, browser, code, dev, misc, comms, ref, debug) | Yes (8-10 spaces) | 10 numbered workspaces | **Yes** — no named workspaces |
| App-to-space rules | Yes (40+ rules) | Not configured | **Yes** |
| Auto-detect display count | Yes | Monitors in `monitors.conf` | Partial |
| Unmanaged apps | Yes (System Settings, Calculator, etc.) | `windowrules.conf` exists | Check needed |
| Window opacity | 0.95 normal / 1.0 active | Not configured | **Yes** |
| Padding/gaps | 6px all sides | HyDE default | Check needed |

### skhd Hotkeys vs Hyprland Keybindings

**Critical mapping differences**:

| Action | skhd (macOS) | Hyprland (Linux) | Match? |
|--------|-------------|-----------------|--------|
| Close window | — | Super+Q | Different |
| Focus hjkl | Ctrl+Alt+hjkl | Super+Arrow | **Different** — not vim-style |
| Move window | Shift+Alt+hjkl | Super+Shift+Ctrl+Arrow | **Different** |
| Switch workspace 1-10 | Alt+1-0 | Super+1-0 | **Different modifier** |
| Move to workspace 1-10 | Shift+Alt+1-0 | Super+Shift+1-0 | **Different modifier** |
| Focus display | Alt+w/e | Not configured | **Missing** |
| Move to display | Shift+Alt+w/e | Not configured | **Missing** |
| Toggle float | Shift+Alt+t | Super+W | Different |
| Toggle fullscreen | Shift+Alt+m | Shift+F11 | **Different** |
| BSP/Stack/Float layout | Alt+b/s/f | Not configured | **Missing** |
| Open terminal | Ctrl+Return | Super+T | **Different** |
| Rotate/flip layout | Shift+Alt+r/y/x | Not configured | **Missing** |
| Toggle split | — | Super+J | — |
| Show desktop | Alt+d | — | **Missing** |
| App launcher | — | Super+A (rofi) | — |
| Clipboard | — | Super+V (cliphist) | — |

### Key Decision Needed

The entire modifier philosophy differs:
- **macOS**: Alt/Option as primary modifier, Ctrl+Alt for focus, Shift+Alt for move
- **HyDE default**: Super as primary modifier

**Do you want to remap Hyprland to match your macOS muscle memory (Alt-based) or adapt to the HyDE/Hyprland convention (Super-based)?**

---

## 3. System Automation (Hammerspoon)

**Source**: `dot_hammerspoon/init.lua`
**Ignored on Linux**: Yes (via `.chezmoiignore.tmpl`)
**Linux equivalent needed**: Partial

### Configured Features

| Feature | macOS (Hammerspoon) | Linux Equivalent |
|---------|-------------------|-----------------|
| VimMode Spoon — Vim keybindings in all apps | Ctrl+[ enters vim normal mode | No direct equivalent; possible: `xremap`, `keyd` layers |
| Screen dimming in vim normal mode | Yes | Not available system-wide |
| Disabled for terminal apps | Ghostty, Kitty, iTerm, Terminal | N/A — only needed for GUI apps |

The VimMode Spoon provides vim-style navigation in **non-terminal** GUI apps (browsers, text editors, etc.). This is hard to replicate on Linux — possible approaches:
- `keyd` with layer switching
- `kanata` with modal layers
- Tridactyl/Vimium for browsers specifically

---

## 4. Application Launcher (Raycast)

**Source**: `cm-util/ctrld-configs/raycast/`
**Linux equivalent needed**: Yes

### Raycast Features

| Feature | Raycast (macOS) | Linux Equivalent |
|---------|----------------|-----------------|
| App launcher | Spotlight replacement | `rofi` (already in HyDE: Super+A) |
| Clipboard history | Built-in | `cliphist` (already in HyDE: Super+V) |
| Custom script commands | `kitty-btop.sh`, `kitty-cliamp.sh` | Rofi scripts or Hyprland keybinds |
| Window management | Raycast window snapping | Hyprland native |
| Calculator/conversions | Built-in | Rofi plugins |
| File search | Built-in | `rofi -show filebrowser` (Super+Shift+E in HyDE) |

### Custom Script Commands to Port

1. **kitty-btop.sh** — Opens kitty terminal running btop (system monitor)
   - Linux: Add Hyprland keybind → `exec, ghostty -e btop`
2. **kitty-cliamp.sh** — Opens kitty terminal running ytm (YouTube Music TUI)
   - Linux: Add Hyprland keybind → `exec, ghostty -e ytm`

### Raycast Config Export

Two `.rayconfig` exports exist but are binary/encrypted — cannot extract specific keybindings without Raycast app.

---

## 5. Background Services (LaunchAgents)

**Source**: `Library/LaunchAgents/`
**Linux equivalent needed**: Yes — systemd user units

| LaunchAgent | Purpose | Linux Equivalent |
|-------------|---------|-----------------|
| `com.gitwatch.obsidian.plist` | Auto-commit Obsidian vault every 5s | `systemd --user` unit running `gitwatch` |
| `com.obsidian-vault.pull.plist` | Pull Obsidian vault every 5min | `systemd --user` timer (5min interval) |
| `com.ollama.server.plist` | Keep Ollama LLM server running | `systemd --user` unit for `ollama serve` |
| `com.yabaiindicator.keepalive.plist` | Keep YabaiIndicator alive | N/A — no yabai on Linux |

### Existing Linux Setup

The chezmoi script `.chezmoiscripts/run_once_after_5-setup-gitwatch.sh.tmpl` already has a Linux code path using systemd for the gitwatch/obsidian services. The systemd units are symlinked via `dot_config/symlink_systemd.tmpl`.

**Status**: Gitwatch/Obsidian — likely already handled. Ollama — needs a systemd unit.

---

## 6. Terminal Keybindings (Ghostty)

**Source**: `dot_config/ghostty/ghostty.conf.tmpl`
**Problem**: Keybindings (lines 119-161) use `super` key and are **NOT** inside a darwin-only template block — they render on both platforms.

On macOS, `super` = Command key. On Linux, `super` = the Windows/Meta key. This means:
- The keybindings technically work on Linux but use the Super key
- This conflicts with Hyprland, which uses Super as its primary modifier

### Ghostty Keybindings That Conflict with Hyprland

| Ghostty Binding | Action | Hyprland Binding | Conflict? |
|----------------|--------|-----------------|-----------|
| `super+j` | Next tab | `super+j` = Toggle split | **YES** |
| `super+k` | Prev tab | `super+k` = Toggle keyboard layout | **YES** |
| `super+d` | Split down | — | No |
| `super+r` | Split right | — | No |
| `super+shift+l` | Goto split right | `super+shift+*` = Move to workspace | Possible |
| `super+shift+h` | Goto split left | — | No |
| `super+shift+f` | Scroll page down | `super+shift+f` = Toggle pin | **YES** |
| `super+shift+s` | Write scrollback | `super+shift+s` = Move to scratchpad | **YES** |
| `super+shift+p` | Jump to prompt | `super+shift+p` = Color picker | **YES** |
| `super+shift+g` | Scroll to bottom | `super+shift+g` = Game launcher | **YES** |
| `super+shift+t` | Scroll to top | `super+shift+t` = Theme select | **YES** |

### macOS-Only Settings Not Gated

These settings are outside any template conditional (lines 165, 166, 224-240):
- `macos-auto-secure-input`
- `macos-secure-input-indication`
- `macos-icon`, `macos-icon-ghost-color`, `macos-icon-screen-color`, `macos-icon-frame`
- `macos-window-shadow`
- `macos-option-as-alt`
- `macos-titlebar-proxy-icon`
- `macos-titlebar-style`
- `macos-dock-drop-behavior`

Ghostty likely ignores these on Linux, but they should be wrapped in a darwin template block for cleanliness.

### Decision Needed

**Option A**: Wrap Ghostty keybindings in darwin-only block and create separate Linux keybindings using `ctrl+alt` or another prefix that doesn't conflict with Hyprland.

**Option B**: Change Hyprland keybindings to avoid conflicts and keep Ghostty using Super.

---

## 7. Key Repeat / Input Speed

**Source**: `.chezmoiscripts/run_once_after_4-macos-settings.sh`

| Setting | macOS Value | Linux Equivalent |
|---------|------------|-----------------|
| `ApplePressAndHoldEnabled = false` | Disable char picker, enable repeat | Default on Linux (no char picker) |
| `InitialKeyRepeat = 25` | ~375ms delay before repeat | `xset r rate 375` or Hyprland `input { repeat_delay = 375 }` |
| `KeyRepeat = 1` | ~15ms between repeats (very fast) | `xset r rate 375 15` or Hyprland `input { repeat_rate = 65 }` |

### Current Hyprland Config

`dot_config/hypr/userprefs.conf` has input settings but **no repeat_delay or repeat_rate configured**. Only:
- `sensitivity = .3`
- `natural_scroll = yes`
- `tap-to-click = yes`

**Action needed**: Add `repeat_delay` and `repeat_rate` to `userprefs.conf` input block to match macOS speed.

Note: macOS `KeyRepeat = 1` is extremely fast (~65 keys/sec). Hyprland equivalent: `repeat_rate = 65` (or higher) and `repeat_delay = 375` (or lower).

---

## 8. macOS System Defaults

**Source**: `.chezmoiscripts/run_once_after_4-macos-settings.sh`

| Setting | macOS | Linux Equivalent | Status |
|---------|-------|-----------------|--------|
| App switcher on all displays | `com.apple.dock appswitcher-all-displays` | Hyprland shows on focused monitor | N/A |
| Press-and-hold disabled | `ApplePressAndHoldEnabled = false` | Default on Linux | Done |
| Font smoothing off | `AppleFontSmoothing = 0` | `fontconfig` settings | Check needed |
| Services submenu threshold | `NSServicesMinimumItemCountForContextSubmenu` | N/A | N/A |
| Font installation | Copies to `~/Library/Fonts/` | `.chezmoiscripts/run_once_after_4-linux-settings.sh` copies to `~/.local/share/fonts` | Done |

---

## 9. Homebrew macOS-Only Packages

**Source**: `cm-util/ctrld-configs/homebrew/Brewfile`

### macOS-Only Tools Needing Linux Alternatives

| macOS Tool | Purpose | Linux Alternative |
|-----------|---------|------------------|
| `karabiner-elements` | Keyboard remapping | `keyd` or `kanata` |
| `hammerspoon` | Automation | Custom scripts + `keyd` layers |
| `yabai` | Tiling WM | Hyprland (already set up) |
| `skhd` | Hotkey daemon | Hyprland keybindings |
| `raycast` | App launcher | `rofi` (already in HyDE) |
| `shottr` | Screenshots | `hyprshot` / HyDE screenshot (Super+P) |
| `switchaudio-osx` | Audio switching | `pavucontrol` / `wpctl` |
| `terminal-notifier` | Notifications | `notify-send` |
| `nowplaying-cli` | Media info | `playerctl` |
| `betterdisplay` | Monitor control | `wlr-randr` / `hyprctl monitors` |
| `macfuse` | Filesystem | FUSE (kernel module) |
| `1password` | Password manager | `1password` (Linux version exists) |

### Already Available on Linux

These exist as Linux packages (pacman/AUR): `ghostty`, `obsidian`, `1password`, `firefox`, `mongodb-compass`, `postman`

---

## 10. Shell Config Issues

### Tmux — Hardcoded macOS Path

**File**: `dot_tmux.conf`, line 2
```
if-shell 'command -v fish' 'set -g default-shell /opt/homebrew/bin/fish'
```
**Problem**: Hardcodes `/opt/homebrew/bin/fish`. On Linux, fish is at `/usr/bin/fish` or `/home/linuxbrew/.linuxbrew/bin/fish`.
**Fix**: Use `command -v fish` result dynamically or template it.

### Zsh — pbcopy Alias Without Guard

**File**: `dot_zshrc`, line 178
```zsh
alias ywd="pwd | pbcopy"  # macOS-only, no platform check
```
**Fix**: Guard with `if [[ "$(uname)" == "Darwin" ]]` or use a cross-platform clipboard function.

### Zsh — Unconditional macOS PATH Exports

**File**: `dot_zshrc`, lines 16-23
```zsh
export PATH="/opt/homebrew/bin:$PATH"    # Apple silicon only
export PATH="/opt/homebrew:$PATH"         # Apple silicon only
export PATH="/opt/homebrew/sbin:$PATH"    # Apple silicon only
```
**Problem**: These are harmless on Linux (paths just don't exist) but add noise to PATH.

### Fish — Already Cross-Platform

**File**: `dot_config/fish/exact_conf.d/_fish_1_path_config.fish`
Uses `switch (uname)` properly — no issue.

### Fish Clipboard — Already Cross-Platform

**File**: `dot_config/fish/exact_functions/__clipboard_copy.fish`
Chains through `pbcopy` → `xclip` → `xsel` → `wl-copy` — works on all platforms.

---

## 11. chezmoi Ignore Gaps

**Current `.chezmoiignore.tmpl`**:
```
{{ if ne .chezmoi.os "darwin" }}
.config/karabiner
.config/skhd
.config/yabai
.hammerspoon
{{ end }}

{{ if ne .chezmoi.os "linux" }}
.config/hypr
{{ end }}
```

### Missing from Ignore

These macOS-only paths are **not** ignored on Linux:

| Path | Content | Should Ignore on Linux? |
|------|---------|------------------------|
| `Library/` | LaunchAgents (plist files) | **Yes** |
| `Applications/` | macOS .app symlinks | **Yes** |
| `.config/waybar` | Linux-only | Should be ignored on **macOS** |
| `.config/systemd` (via symlink) | Linux-only | Should be ignored on **macOS** |

---

## 12. Summary

### Already Working on Linux
- Fish shell PATH detection
- Fish clipboard functions (wl-copy fallback)
- Ghostty font-size templating
- Ghostty quick-terminal settings templating
- Hyprland basic keybindings (HyDE defaults)
- Font installation (linux-settings.sh)
- Gitwatch systemd units

### Needs Linux Configuration (Priority Order)

| Priority | Item | Effort | Notes |
|----------|------|--------|-------|
| **P0** | Key repeat speed in Hyprland | Small | Add `repeat_rate`/`repeat_delay` to `userprefs.conf` |
| **P0** | Ghostty keybind conflicts with Hyprland | Medium | Template-gate or remap one side |
| **P0** | Karabiner → `keyd`/`kanata` (Caps Lock→Ctrl/Esc, hjkl nav) | Large | Core muscle memory |
| **P1** | Hyprland keybinds to match skhd muscle memory | Medium | Remap focus/move/workspace keys |
| **P1** | macOS settings in Ghostty config not template-gated | Small | Wrap in `{{ if eq .chezmoi.os "darwin" }}` |
| **P1** | App-to-workspace rules | Medium | Port yabai rules to Hyprland `windowrulev2` |
| **P1** | Tmux fish path fix | Small | Template or dynamic detection |
| **P2** | Ollama systemd unit | Small | Create user service |
| **P2** | Raycast script commands → Hyprland keybinds | Small | 2 keybinds for btop and ytm |
| **P2** | Hammerspoon VimMode → keyd/kanata layers | Large | May not be worth it |
| **P2** | chezmoi ignore gaps (Library/, Applications/, waybar) | Small | Add to `.chezmoiignore.tmpl` |
| **P3** | zshrc pbcopy alias guard | Trivial | Platform check |
| **P3** | Window opacity rules | Small | Hyprland `windowrulev2` opacity |
| **P3** | Named workspaces | Small | Hyprland workspace names |

### Key Decisions Before Implementation

1. **Keyboard remapping tool**: `keyd` (simpler, C, runs as daemon) vs `kanata` (Rust, more Karabiner-like, supports layers and dual-function keys natively). Recommendation: **`kanata`** — closer to Karabiner's feature set, especially for dual-function keys and per-device configs.

2. **Modifier key philosophy**: Adapt macOS muscle memory (Alt-based) to Linux, or adopt HyDE convention (Super-based)?

3. **Ghostty keybinding strategy**: Remap Ghostty to avoid Super conflicts, or remap Hyprland to free up Super+j/k/etc. for Ghostty?
