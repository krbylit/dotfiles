# skhd Configuration

## Overview

skhd (Simple Hotkey Daemon) is a powerful system-wide hotkey daemon for macOS that enables custom keyboard shortcuts. This configuration integrates skhd as the primary input layer for the Yabai window manager, providing 76 carefully organized hotkeys for window management, space navigation, layout control, and system operations.

skhd translates keyboard input into Yabai window manager commands, creating a seamless tiling window management experience. The hotkey scheme is designed around modifier key patterns: `alt` for navigation, `shift + alt` for manipulation, and `ctrl + alt` for window focus and service control.

## Table of Contents

- [Overview](#overview)
- [Configuration Files](#configuration-files)
- [Key Features](#key-features)
  - [Hotkey Organization](#hotkey-organization)
  - [Modifier Key Patterns](#modifier-key-patterns)
  - [Complete Hotkey Reference](#complete-hotkey-reference)
- [Customization Guide](#customization-guide)
  - [Adding New Hotkeys](#adding-new-hotkeys)
  - [Modifying Existing Hotkeys](#modifying-existing-hotkeys)
  - [Reloading Configuration](#reloading-configuration)
  - [Hotkey Definition Syntax](#hotkey-definition-syntax)
- [Integration Points](#integration-points)
  - [Yabai Window Manager Integration](#yabai-window-manager-integration)
  - [Karabiner Hardware Remapping](#karabiner-hardware-remapping)
  - [Application vs Window Control Distinction](#application-vs-window-control-distinction)
- [Troubleshooting](#troubleshooting)
  - [skhd Not Responding to Hotkeys](#skhd-not-responding-to-hotkeys)
  - [Accessibility Permissions Required](#accessibility-permissions-required)
  - [Secure Keyboard Input Blocking Hotkeys](#secure-keyboard-input-blocking-hotkeys)
  - [Hotkey Conflicts with Applications](#hotkey-conflicts-with-applications)
  - [Alt + R System Refresh Failing](#alt--r-system-refresh-failing)
  - [Issues After macOS Updates](#issues-after-macos-updates)
  - [Debugging Hotkey Execution](#debugging-hotkey-execution)
- [External Resources](#external-resources)

## Configuration Files

| File | Purpose |
|------|---------|
| `skhdrc` | Main hotkey configuration file defining all 76 keyboard shortcuts |
| `util/focus_empty_space.sh` | Helper script for "show desktop" functionality - finds and focuses first empty space on each display |
| `README.md` | This documentation file |

## Key Features

### Hotkey Organization

All 76 hotkeys are organized into 11 functional categories:

1. **MacOS Override** (1 hotkey) - Disables conflicting default macOS shortcuts
2. **Application Launch** (1 hotkey) - Quick application launching
3. **Space Switching** (13 hotkeys) - Navigate between virtual spaces
4. **Window Focus** (5 hotkeys) - Change focus between windows using directional navigation
5. **Display Focus** (2 hotkeys) - Switch focus between multiple monitors
6. **Layout Manipulation** (4 hotkeys) - Rotate, mirror, and balance window layouts
7. **Window State** (3 hotkeys) - Toggle float, fullscreen, and zoom states
8. **Window Movement** (21 hotkeys) - Move windows between spaces, displays, and positions
9. **Layout Mode** (4 hotkeys) - Switch between BSP, float, and stack layout modes
10. **Space Management** (1 hotkey) - Create and destroy spaces
11. **Yabai Service Control** (5 hotkeys) - Start, stop, restart, and reload Yabai

### Modifier Key Patterns

The configuration follows a consistent modifier key scheme:

- **`alt + [key]`** - Navigation and switching (spaces, displays, layout modes)
- **`shift + alt + [key]`** - Manipulation and movement (moving windows, warping, state changes)
- **`ctrl + alt + [key]`** - Window focus within space and Yabai service control
- **`ctrl + return`** - Application launcher
- **`cmd + h`** - Disabled (macOS override to prevent conflicts)

### Complete Hotkey Reference

#### MacOS Override

| Hotkey | Action | Description |
|--------|--------|-------------|
| `cmd + h` | No-op | Disables macOS default hide window behavior to prevent conflicts |

#### Application Launch

| Hotkey | Action | Description |
|--------|--------|-------------|
| `ctrl + return` | Launch Ghostty | Opens or focuses the Ghostty terminal application |

#### Space Switching (13 hotkeys)

| Hotkey | Action | Description |
|--------|--------|-------------|
| `alt + d` | Show desktop | Changes all displays to first empty space (via helper script) |
| `alt + 1` | Focus space 1 | Switch to virtual space 1 |
| `alt + 2` | Focus space 2 | Switch to virtual space 2 |
| `alt + 3` | Focus space 3 | Switch to virtual space 3 |
| `alt + 4` | Focus space 4 | Switch to virtual space 4 |
| `alt + 5` | Focus space 5 | Switch to virtual space 5 |
| `alt + 6` | Focus space 6 | Switch to virtual space 6 |
| `alt + 7` | Focus space 7 | Switch to virtual space 7 |
| `alt + 8` | Focus space 8 | Switch to virtual space 8 |
| `alt + 9` | Focus space 9 | Switch to virtual space 9 |
| `alt + 0` | Focus space 10 | Switch to virtual space 10 |
| `alt + ]` | Next space | Focus next space in sequence (keycode 0x1E) |
| `alt + [` | Previous space | Focus previous space in sequence (keycode 0x21) |

#### Window Focus (5 hotkeys)

| Hotkey | Action | Description |
|--------|--------|-------------|
| `ctrl + alt + j` | Focus south | Change focus to window below current window |
| `ctrl + alt + k` | Focus north | Change focus to window above current window |
| `ctrl + alt + h` | Focus west | Change focus to window left of current window |
| `ctrl + alt + l` | Focus east | Change focus to window right of current window |
| `ctrl + alt + p` | Focus recent | Change focus to most recently focused window |

#### Display Focus (2 hotkeys)

| Hotkey | Action | Description |
|--------|--------|-------------|
| `alt + w` | Focus west display | Switch focus to external monitor on the left |
| `alt + e` | Focus east display | Switch focus to external monitor on the right |

#### Layout Manipulation (4 hotkeys)

| Hotkey | Action | Description |
|--------|--------|-------------|
| `shift + alt + r` | Rotate clockwise | Rotate current space layout 270° (90° clockwise) |
| `shift + alt + y` | Mirror Y-axis | Flip layout vertically along Y-axis |
| `shift + alt + x` | Mirror X-axis | Flip layout horizontally along X-axis |
| `shift + alt + e` | Balance layout | Resize all windows to occupy equal area |

#### Window State (3 hotkeys)

| Hotkey | Action | Description |
|--------|--------|-------------|
| `shift + alt + t` | Toggle float | Toggle between floating and tiled, positions float window in center 2×2 grid |
| `shift + alt + m` | Toggle zoom | Maximize window (toggle zoom-fullscreen) |
| `shift + alt + f` | Toggle fullscreen | Toggle native macOS fullscreen mode |

#### Window Movement (21 hotkeys)

**Directional Warping (4 hotkeys)**

| Hotkey | Action | Description |
|--------|--------|-------------|
| `shift + alt + j` | Warp south | Move window south and reposition in tree |
| `shift + alt + k` | Warp north | Move window north and reposition in tree |
| `shift + alt + h` | Warp west | Move window west and reposition in tree |
| `shift + alt + l` | Warp east | Move window east and reposition in tree |

**Display Movement (2 hotkeys)**

| Hotkey | Action | Description |
|--------|--------|-------------|
| `shift + alt + w` | Move to west display | Move window to left monitor and follow focus |
| `shift + alt + e` | Move to east display | Move window to right monitor and follow focus |

**Space Movement (12 hotkeys)**

| Hotkey | Action | Description |
|--------|--------|-------------|
| `shift + alt + p` | Move to previous space | Move window to previous space |
| `shift + alt + n` | Move to next space | Move window to next space |
| `shift + alt + 1` | Move to space 1 | Move window to space 1 and maintain focus |
| `shift + alt + 2` | Move to space 2 | Move window to space 2 and maintain focus |
| `shift + alt + 3` | Move to space 3 | Move window to space 3 and maintain focus |
| `shift + alt + 4` | Move to space 4 | Move window to space 4 and maintain focus |
| `shift + alt + 5` | Move to space 5 | Move window to space 5 and maintain focus |
| `shift + alt + 6` | Move to space 6 | Move window to space 6 and maintain focus |
| `shift + alt + 7` | Move to space 7 | Move window to space 7 and maintain focus |
| `shift + alt + 8` | Move to space 8 | Move window to space 8 and maintain focus |
| `shift + alt + 9` | Move to space 9 | Move window to space 9 and maintain focus |
| `shift + alt + 0` | Move to space 10 | Move window to space 10 and maintain focus |

**Note**: Moving to numbered spaces uses a sophisticated approach - it queries the window ID, moves the window, then refocuses it to maintain keyboard control.

#### Layout Mode (4 hotkeys)

| Hotkey | Action | Description |
|--------|--------|-------------|
| `alt + b` | BSP layout | Change current space to Binary Space Partitioning layout |
| `alt + f` | Float layout | Change current space to floating layout mode |
| `alt + s` | Stack layout | Change current space to stack layout mode |
| `alt + t` | Toggle stack/BSP | Toggle between stack and BSP layouts |

#### Space Management (1 hotkey)

| Hotkey | Action | Description |
|--------|--------|-------------|
| `shift + alt + q` | Destroy space | Delete the currently focused space |

#### Yabai Service Control (5 hotkeys)

| Hotkey | Action | Description |
|--------|--------|-------------|
| `ctrl + alt + q` | Stop Yabai | Stop the Yabai window manager service |
| `ctrl + alt + s` | Start Yabai | Start the Yabai window manager service |
| `ctrl + alt + r` | Restart Yabai | Restart the Yabai window manager service |
| `alt + r` | Full system refresh | Comprehensive restart: unhide processes, restart skhd, reload scripting addition, restart Yabai, reapply rules |
| `alt + a` | Reapply rules | Apply/reapply all Yabai window rules to current windows |

## Customization Guide

### Adding New Hotkeys

1. Edit the configuration file:

   ```bash
   chezmoi edit ~/.config/skhd/skhdrc
   ```

2. Add your hotkey using the syntax:

   ```
   <modifier> - <key> : <command>
   ```

3. Example - add a hotkey to open Safari:

   ```
   ctrl + alt - b : open -a "Safari"
   ```

4. Apply changes:

   ```bash
   chezmoi apply
   skhd --restart-service
   ```

### Modifying Existing Hotkeys

**Change a key binding**:

1. Edit `skhdrc` using `chezmoi edit ~/.config/skhd/skhdrc`
2. Find the hotkey you want to modify
3. Change either the key combination or the command
4. Apply with `chezmoi apply` and reload with `skhd --restart-service`

**Example - Change terminal launcher from `ctrl + return` to `cmd + return`**:

```diff
- ctrl - return : open -a "Ghostty"
+ cmd - return : open -a "Ghostty"
```

### Reloading Configuration

After making changes to `skhdrc`, reload skhd:

```bash
# Quick restart
skhd --restart-service

# Full system refresh (includes Yabai)
# Triggered by alt + r hotkey or manual command:
osascript -e 'tell application "System Events" to set visible of (every process whose visible is false and background only is false) to true'
skhd --restart-service
env -u TERMINFO sudo -n /opt/homebrew/bin/yabai --load-sa
yabai --stop-service
sleep .25
yabai --start-service
sleep 1.5
yabai -m rule --apply
```

### Hotkey Definition Syntax

skhd uses a simple syntax for defining hotkeys:

```
<modifier> [+ <modifier>] - <key> : <command>
```

**Modifiers**:

- `cmd` - Command key
- `alt` - Option/Alt key
- `shift` - Shift key
- `ctrl` - Control key
- Combine multiple: `shift + alt - key`

**Keys**:

- Letter keys: `a-z`
- Number keys: `0-9`
- Special keys: `return`, `space`, `tab`, `escape`
- Keycodes: `0x1E` (for special keys like brackets)

**Commands**:

- Single command: `yabai -m window --focus south`
- Shell script: `sh -c 'complex command here'`
- Multiple commands: `command1; command2; command3`
- External script: `sh -c '"$XDG_CONFIG_HOME"/skhd/util/script.sh'`

**Examples**:

```bash
# Simple application launch
ctrl - return : open -a "Terminal"

# Yabai window command
alt - j : yabai -m window --focus south

# Complex shell command with query
shift + alt - 1 : sh -c 'wid=$(yabai -m query --windows --window | jq -r ".id"); yabai -m window --space 1; yabai -m window --focus $wid'

# Multiple sequential commands
alt - r : skhd --restart-service; yabai --restart-service
```

## Integration Points

### Yabai Window Manager Integration

**Critical Integration**: skhd serves as the primary input layer for Yabai window management. Every window management action is triggered through skhd hotkeys.

**How skhd Controls Yabai**:

1. **Direct Yabai Commands**: Most hotkeys execute `yabai -m <command>` directly

   ```bash
   # Example: Focus window to the south
   ctrl + alt - j : yabai -m window --focus south

   # Example: Move window to space 5
   shift + alt - 5 : yabai -m window --space 5
   ```

2. **Query and Action Pattern**: Some hotkeys query Yabai state before taking action

   ```bash
   # Toggle between stack and BSP based on current layout
   alt - t : sh -c '[ "$(yabai -m query --spaces --space | jq -r ".type")" = "stack" ] && yabai -m space --layout bsp || yabai -m space --layout stack'
   ```

3. **Window ID Tracking**: Moving windows to specific spaces requires tracking window ID

   ```bash
   # Query window ID, move to space, then refocus the window
   shift + alt - 1 : sh -c 'wid=$(yabai -m query --windows --window | jq -r ".id"); yabai -m window --space 1; yabai -m window --focus $wid'
   ```

4. **Service Control**: skhd hotkeys manage Yabai's lifecycle

   ```bash
   ctrl + alt - q : yabai --stop-service
   ctrl + alt - s : yabai --start-service
   ctrl + alt - r : yabai --restart-service
   ```

5. **Scripting Addition Management**: The `alt + r` hotkey reloads Yabai's scripting addition with sudo privileges (requires sudoers configuration)

**Yabai Command Categories Used**:

- `yabai -m window` - Window operations (focus, warp, toggle, display, space)
- `yabai -m space` - Space operations (focus, layout, rotate, mirror, balance, destroy)
- `yabai -m display` - Display operations (focus)
- `yabai -m query` - Query current state (windows, spaces, displays)
- `yabai -m rule` - Window rule management (apply)

### Karabiner Hardware Remapping

Karabiner-Elements provides hardware-level key remapping that feeds into skhd:

- **Caps Lock → Hyper Key**: Karabiner remaps Caps Lock to a "hyper" modifier or escape
- **Complex Modifications**: Hardware-level key transformations happen before skhd receives input
- **Layer Independence**: Karabiner handles physical key remapping; skhd handles the resulting key events

This separation allows:

1. Karabiner to provide ergonomic key positions
2. skhd to handle logical key combinations
3. Clean separation between hardware and software layers

### Application vs Window Control Distinction

**Application Launchers** (skhd opens apps directly):

- `ctrl + return` → Ghostty terminal

**Window Control** (skhd commands Yabai):

- All focus, movement, layout, and space operations
- These don't launch apps - they manage existing windows through Yabai

## Troubleshooting

### skhd Not Responding to Hotkeys

**Symptoms**: Hotkeys don't work, no response when pressing configured key combinations

**Solution**:

1. Check if skhd is running:

   ```bash
   pgrep skhd
   ```

2. Restart skhd:

   ```bash
   skhd --restart-service
   ```

3. If process isn't running, start manually to see error messages:

   ```bash
   skhd
   ```

4. Check for configuration syntax errors in `skhdrc`

### Accessibility Permissions Required

**Symptoms**: skhd service won't start, or permission denied errors

**Solution**:

1. Open **System Settings → Privacy & Security → Accessibility**
2. Grant accessibility permissions to:
   - `skhd` binary
   - Terminal emulator you're using (Ghostty, iTerm2, etc.)
3. Restart skhd after granting permissions:

   ```bash
   skhd --restart-service
   ```

### Secure Keyboard Input Blocking Hotkeys

**Symptoms**: Hotkeys stop working, especially when certain applications are focused

**Solution**:

1. This commonly occurs with Firefox when password input fields are focused
2. Quit the application causing secure keyboard input (typically Firefox)
3. Restart skhd:

   ```bash
   skhd --restart-service
   ```

4. Reopen the application

### Hotkey Conflicts with Applications

**Symptoms**: Some hotkeys work in certain apps but not others

**Solution**:

1. Check if the application has its own hotkey for the same combination
2. Either disable the app's hotkey or change your skhd binding
3. Use the `cmd - h` override pattern to disable conflicting macOS defaults:

   ```bash
   cmd - h : :
   ```

### Alt + R System Refresh Failing

**Symptoms**: `alt + r` doesn't fully restart Yabai, or asks for password

**Solution**:

1. Configure passwordless sudo for Yabai scripting addition:

   ```bash
   # Get Yabai binary checksum
   shasum -a 256 /opt/homebrew/bin/yabai

   # Edit sudoers
   sudo visudo -f /etc/sudoers.d/yabai

   # Add this line (replace {username} and {checksum}):
   {username} ALL=(root) NOPASSWD: sha256:{checksum} /opt/homebrew/bin/yabai --load-sa
   ```

2. Ensure the skhd hotkey doesn't pass `TERMINFO` environment variable:

   ```bash
   alt - r : env -u TERMINFO sudo -n /opt/homebrew/bin/yabai --load-sa && skhd --restart-service && yabai --stop-service && yabai --start-service && sleep 1 && yabai -m rule --apply
   ```

### Issues After macOS Updates

**Symptoms**: Hotkeys stop working after macOS system update

**Solution**:

1. Re-grant accessibility permissions in **System Settings → Privacy & Security → Accessibility**
2. Reinstall skhd if necessary:

   ```bash
   brew reinstall koekeishiya/formulae/skhd
   ```

3. Restart the service:

   ```bash
   skhd --start-service
   ```

4. Reconfigure sudoers for Yabai (checksum may have changed):

   ```bash
   shasum -a 256 /opt/homebrew/bin/yabai
   sudo visudo -f /etc/sudoers.d/yabai
   ```

### Debugging Hotkey Execution

**Symptoms**: Need to verify if hotkeys are triggering commands

**Solution**:

1. Run skhd in foreground to see debug output:

   ```bash
   # Stop service first
   skhd --stop-service

   # Run in foreground
   skhd --verbose
   ```

2. Test your hotkey - you'll see console output when it triggers

3. Restart as service when done:

   ```bash
   # Press Ctrl+C to stop foreground process
   skhd --start-service
   ```

---

**For additional troubleshooting help**, see the [Troubleshooting Guide](/docs/TROUBLESHOOTING.md#system-permissions) for comprehensive coverage of:

- macOS accessibility permissions (symptoms, step-by-step resolution, verification commands)
- Permission issues after macOS updates
- Debugging hotkey conflicts and secure keyboard input
- Terminal emulator permissions
- Integration with Yabai and window management troubleshooting

## External Resources

- [Official skhd Documentation](https://github.com/koekeishiya/skhd)
- [skhd Example Configuration](https://github.com/koekeishiya/skhd/blob/master/examples/skhdrc)
- [Yabai Documentation](https://github.com/koekeishiya/yabai/wiki) - Understanding the window manager skhd controls
- [Yabai + skhd Setup Guide](https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release))
