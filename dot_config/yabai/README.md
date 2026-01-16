# Yabai Configuration

## Overview

Yabai is a tiling window manager for macOS that provides powerful window management capabilities through Binary Space Partitioning (BSP), stacking, and floating layouts. This configuration creates an organized workspace with nine labeled spaces distributed across displays, comprehensive window rules for automatic application placement, and seamless integration with skhd for keyboard-driven window management.

## Table of Contents

- [Overview](#overview)
- [Configuration Files](#configuration-files)
- [Key Features](#key-features)
  - [Tiling Layouts and Modes](#tiling-layouts-and-modes)
  - [Space Organization](#space-organization)
  - [Window Rules](#window-rules)
  - [Display Management](#display-management)
  - [Visual Configuration](#visual-configuration)
  - [Mouse Integration](#mouse-integration)
  - [Signal Handlers](#signal-handlers)
- [Customization Guide](#customization-guide)
  - [Common Modifications](#common-modifications)
  - [Configuration Options](#configuration-options)
  - [Querying Window and Space Information](#querying-window-and-space-information)
- [Integration Points](#integration-points)
  - [Skhd Hotkey Integration](#skhd-hotkey-integration)
  - [YabaiIndicator Integration](#yabaiindicator-integration)
- [Troubleshooting](#troubleshooting)
  - [Accessibility Permissions Required](#accessibility-permissions-required)
  - [SIP (System Integrity Protection) Considerations](#sip-system-integrity-protection-considerations)
  - [How to Check if Yabai is Running](#how-to-check-if-yabai-is-running)
  - [Common Issues After macOS Updates](#common-issues-after-macos-updates)
  - [Viewing Yabai Logs](#viewing-yabai-logs)
  - [Window Rules Not Applying](#window-rules-not-applying)
  - [Scripting Addition Won't Load](#scripting-addition-wont-load)
  - [How to Revert to an Older Version of Yabai](#how-to-revert-to-an-older-version-of-yabai)
- [External Resources](#external-resources)

## Configuration Files

| File                          | Purpose                                                                                                  |
| ----------------------------- | -------------------------------------------------------------------------------------------------------- |
| `executable_yabairc`          | Main yabai configuration file that defines layouts, window rules, space assignments, and signal handlers |
| `ext-config/scripted-yabairc` | Alternative/backup scripted configuration                                                                |

## Key Features

### Tiling Layouts and Modes

Yabai supports three primary layout modes:

- **BSP (Binary Space Partitioning)**: Automatically tiles windows by recursively splitting spaces in half. Default layout when multiple displays are connected.
- **Stack**: All windows occupy the same space with only one visible at a time, similar to macOS fullscreen. Default layout for single display mode and specific spaces (term, browser, code).
- **Float**: Windows float freely and can be positioned manually, useful for utility apps and system preferences.

Current configuration uses BSP as the global default but applies stack layout to term, browser, and code spaces for focused single-window workflows.

### Space Organization

Nine labeled spaces are configured for different workflows:

**Main Display Spaces:**

1. **term** - Terminal applications (Ghostty)
2. **browser** - Web browsers (Microsoft Edge, Firefox, Safari)
3. **code** - Code editors (VS Code, Cursor, Sublime Text)
4. **dev** - Development tools (Proxyman, Postman, Docker, MongoDB Compass)
5. **misc** - General utilities (Finder)

**Secondary Display Spaces** (or main display if single monitor): 6. **comms** - Communication apps (Slack, Zoom, Mail, Outlook) 7. **ref** - Reference materials (Notion Calendar, LM Studio, Ollama) 8. **debug** - Debugging and AI tools (Chrome, Claude, ChatGPT, kitty) 9. **util** - System utilities (Calendar, Figma, 1Password, Activity Monitor)

### Window Rules

**Automatic Space Assignment:**
Applications are automatically sent to their designated spaces on launch. For example:

- Terminal apps → term space
- Browsers → browser space
- Code editors → code space
- Communication apps → comms space

**Unmanaged Applications:**
These apps ignore tiling and float freely:

- System apps: System Settings, System Preferences, System Information
- Utilities: Calculator, Dictionary, FaceTime, App Store
- Alfred, Stats, Mountain Duck, Screen Sharing

**Sticky Applications:**
System Settings and System Preferences remain visible across all spaces for quick access.

**Special Rules:**

- **YabaiIndicator**: Completely transparent (opacity=0) to hide restart notifications
- **1Password Quick Access**: Follows mouse cursor (`space=mouse`)
- **ChatGPT popups**: Follow mouse cursor for non-main windows
- **Notion Tab Preview**: Unmanaged to prevent tiling interference
- **Finder dialogs**: Copy, Connect, Move, Info, and Preferences windows float

### Display Management

The configuration automatically detects the number of connected displays:

- **Single display**: Uses stack layout by default, all spaces on main display
- **Multiple displays**: Uses BSP layout by default, distributes spaces across displays
- **Dynamic adjustment**: Signals trigger full yabai restart when displays are added/removed/moved

### Visual Configuration

- **Window gaps**: 6px uniform spacing between windows and screen edges
- **Padding**: 6px on all sides (customized to 0px for term space)
- **Split ratio**: 0.5 (windows split evenly)
- **Auto-balance**: Disabled (manual control preferred)
- **Window shadows**: Disabled for cleaner appearance
- **Insert feedback**: Blue highlight (0xff7793d1) when inserting windows
- **Window opacity**: Disabled globally, active window at 100%, normal at 95%

### Mouse Integration

- **Modifier key**: `alt` enables mouse-driven window management
- **Left click + alt**: Move windows
- **Right click + alt**: Resize windows
- **Drop action**: Swap windows by dragging
- **Focus follows mouse**: Disabled (keyboard-driven focus only)
- **Mouse follows focus**: Disabled

### Signal Handlers

Yabai monitors system events and automatically responds:

**Display Events:**

- Dock restart → Reload scripting addition
- Display added/removed/moved → Full restart sequence with rule reapplication

**YabaiIndicator Integration:**

- Mission Control exit → Refresh indicator
- Window created/destroyed/focused/moved/resized → Update indicator
- Window minimized/deminimized → Update indicator

These signals communicate with YabaiIndicator via Unix socket at `/tmp/yabai-indicator.socket`.

## Customization Guide

### Common Modifications

**Change window gaps and padding**

1. Edit `executable_yabairc`
2. Modify the padding variables:

   ```bash
   yabai -m config top_padding 12
   yabai -m config bottom_padding 12
   yabai -m config left_padding 12
   yabai -m config right_padding 12
   yabai -m config window_gap 12
   ```

3. Apply with `chezmoi apply`
4. Reload yabai with `alt + r` (or `yabai --restart-service`)

**Add a new application rule**

1. Edit `executable_yabairc`
2. Add the app to the appropriate array:

   ```bash
   CODE_APPS=(
       Code
       "Visual Studio"
       Cursor
       "Sublime Text"
       "Your New Editor"  # Add here
   )
   ```

3. The `assign_to_space` function automatically creates the rule
4. Apply with `chezmoi apply` and run `yabai -m rule --apply` (or `alt + a`)

**Make an application unmanaged**

1. Edit `executable_yabairc`
2. Add to the `UNMANAGED_APPS` string:

   ```bash
   UNMANAGED_APPS="Alfred 'App Store' ... 'Your App Name'"
   ```

3. Apply with `chezmoi apply` and reload yabai

**Change space layout**

You can change layouts per-space or globally:

```bash
# Per-space (edit yabairc)
yabai -m config --space dev layout bsp

# Runtime change (via skhd hotkeys)
alt + b  # BSP layout
alt + s  # Stack layout
alt + f  # Float layout
alt + t  # Toggle between stack and BSP
```

**Modify space names or display assignments**

1. Edit `executable_yabairc`
2. Modify the space lists:

   ```bash
   SPACES="term browser code dev misc comms ref debug util"
   MAIN_SPACES="term browser code dev misc"
   SEC_SPACES="comms ref debug util"
   ```

3. Apply with `chezmoi apply` and reload yabai

### Configuration Options

Key settings you can modify in `executable_yabairc`:

- **layout**: Window tiling mode (Current: `bsp`)
- **split_ratio**: How evenly windows split (Current: `0.5`)
- **auto_balance**: Automatically balance window sizes (Current: `off`)
- **split_type**: Direction for new splits (Current: `auto`)
- **window_placement**: Where new windows appear (Current: `second_child`)
- **window_shadow**: macOS window shadows (Current: `off`)
- **window_animation_duration**: Window animation speed (Current: `0.0` - instant)
- **mouse_modifier**: Key for mouse window management (Current: `alt`)
- **focus_follows_mouse**: Auto-focus on hover (Current: `off`)

### Querying Window and Space Information

Yabai provides powerful query capabilities using JSON output:

```bash
# Query current window info
yabai -m query --windows --window

# Query all spaces
yabai -m query --spaces

# Query current space
yabai -m query --spaces --space

# Query all displays
yabai -m query --displays

# Query all windows
yabai -m query --windows

# Example: Get current space type
yabai -m query --spaces --space | jq -r '.type'

# Example: Get current window ID
yabai -m query --windows --window | jq -r '.id'
```

These queries are used in skhd scripts for advanced window management operations.

## Integration Points

### Skhd Hotkey Integration

Yabai is controlled primarily through skhd keyboard shortcuts. All window management operations are triggered via skhd hotkeys:

**Space Switching:**

- `alt + 1-9, 0` - Focus spaces 1-10
- `alt + [` - Focus previous space
- `alt + ]` - Focus next space
- `alt + d` - Show desktop (focus first empty space)

**Window Focus:**

- `ctrl + alt + h/j/k/l` - Focus window west/south/north/east (vim-style navigation)
- `ctrl + alt + p` - Focus most recently used window

**Display Focus:**

- `alt + w` - Focus west (left) display
- `alt + e` - Focus east (right) display

**Layout Manipulation:**

- `shift + alt + r` - Rotate layout 270° (90° clockwise)
- `shift + alt + y` - Mirror layout on y-axis (vertical flip)
- `shift + alt + x` - Mirror layout on x-axis (horizontal flip)
- `shift + alt + e` - Balance window tree (equal area)

**Window State:**

- `shift + alt + t` - Toggle float (with centered 4x4 grid positioning)
- `shift + alt + m` - Toggle zoom-fullscreen (maximize in space)
- `shift + alt + f` - Toggle native macOS fullscreen

**Window Movement:**

- `shift + alt + h/j/k/l` - Warp window west/south/north/east
- `shift + alt + w/e` - Move window to west/east display (and follow)
- `shift + alt + p/n` - Move window to previous/next space
- `shift + alt + 1-9, 0` - Move window to space 1-10 (maintains focus)

**Layout Mode:**

- `alt + b` - Set BSP layout
- `alt + f` - Set float layout
- `alt + s` - Set stack layout
- `alt + t` - Toggle between stack and BSP

**Space Management:**

- `shift + alt + q` - Delete current space

**Yabai Service Control:**

- `ctrl + alt + q` - Stop yabai service
- `ctrl + alt + s` - Start yabai service
- `ctrl + alt + r` - Restart yabai service
- `alt + r` - Full system refresh (restart skhd + yabai + reload scripting addition)
- `alt + a` - Reapply all window rules

**Advanced Operations:**

The `alt + r` hotkey performs a comprehensive restart:

1. Makes all hidden processes visible
2. Restarts skhd service
3. Loads scripting addition with sudo
4. Stops yabai
5. Starts yabai
6. Reapplies all window rules

The window-to-space movement shortcuts (`shift + alt + 1-9, 0`) use an advanced pattern that maintains focus:

```bash
wid=$(yabai -m query --windows --window | jq -r ".id")
yabai -m window --space 2
yabai -m window --focus $wid
```

### YabaiIndicator Integration

The menu bar indicator (YabaiIndicator) displays current space and window status. Yabai sends refresh signals via Unix socket:

```bash
echo "refresh" | nc -U /tmp/yabai-indicator.socket
echo "refresh windows" | nc -U /tmp/yabai-indicator.socket
```

The YabaiIndicator app itself is hidden using `opacity=0` to prevent restart notification popups.

## Troubleshooting

### Accessibility Permissions Required

**Symptoms**: Yabai cannot control windows, hotkeys don't work, or windows don't tile properly.

**Solution**:

1. Open System Settings → Privacy & Security → Accessibility
2. Ensure yabai has accessibility permissions enabled
3. You may need to remove and re-add yabai to refresh permissions
4. Restart yabai: `yabai --restart-service`

### SIP (System Integrity Protection) Considerations

**Why disable SIP**: Yabai's scripting addition (SA) provides advanced features like window opacity, focus follows mouse, window borders, and menubar transparency. These features require SIP to be partially disabled.

**What to disable**: Only specific SIP features need to be disabled, not all of SIP:

1. Reboot into Recovery Mode (hold `Cmd + R` at startup)
2. Open Terminal and run:

   ```bash
   csrutil enable --without fs --without debug --without nvram
   ```

3. Reboot normally

**Loading the scripting addition**:

```bash
sudo yabai --load-sa
```

This is automatically executed in the yabairc configuration and after display changes.

**Before macOS updates**:

- Restore SIP to default settings to prevent system corruption
- After update, reconfigure SIP and reload scripting addition
- See "Preparing for / recovering from macOS update" section below

### How to Check if Yabai is Running

**Check service status**:

```bash
brew services list | grep yabai
```

**Check process**:

```bash
ps aux | grep yabai
```

**Query yabai directly**:

```bash
yabai -m query --spaces
```

If the query returns JSON data, yabai is running correctly.

### Common Issues After macOS Updates

**Symptoms**: Yabai stops working after a macOS update, windows don't tile, or scripting addition fails to load.

**Solution**:

1. Check if SIP settings were reset by the update:

   ```bash
   csrutil status
   ```

2. If SIP is enabled, follow the SIP configuration steps above
3. Reload the scripting addition:

   ```bash
   sudo yabai --load-sa
   ```

4. Quit all applications and reopen them
5. If issues persist, run the full refresh: `alt + r`

**Best practice for macOS updates**:

1. Before update: Restore SIP to normal settings

   ```bash
   # In Recovery Mode
   csrutil enable
   ```

2. Complete the macOS update
3. After update: Reconfigure SIP as documented above
4. Reload scripting addition and restart applications

### Viewing Yabai Logs

**Check yabai error logs**:

```bash
tail -f /tmp/yabai_$USER.err.log
```

**Check yabai output logs**:

```bash
tail -f /tmp/yabai_$USER.out.log
```

These logs are invaluable for diagnosing configuration errors, rule issues, or scripting addition problems.

### Window Rules Not Applying

**Symptoms**: Applications don't move to their assigned spaces or float when they should be tiled.

**Solution**:

1. Verify the application name matches exactly:

   ```bash
   yabai -m query --windows | jq '.[] | {app, title}'
   ```

2. Check for typos in `executable_yabairc` application arrays
3. Manually reapply rules: `yabai -m rule --apply` (or `alt + a`)
4. If the app is already open, close and reopen it
5. For persistent issues, add a debug rule:

   ```bash
   yabai -m rule --add app="^YourApp$" manage=on
   ```

### Scripting Addition Won't Load

**Symptoms**: Error message "could not load scripting addition" or advanced features don't work.

**Solution**:

1. Verify SIP is properly configured: `csrutil status`
2. Check sudoers configuration for passwordless yabai execution:

   ```bash
   sudo visudo -f /private/etc/sudoers.d/yabai
   ```

   Should contain:

   ```
   <user> ALL=(root) NOPASSWD: sha256:<hash> <yabai-path> --load-sa
   ```

3. Regenerate the sudoers entry:

   ```bash
   echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai
   ```

4. Reload scripting addition: `sudo yabai --load-sa`

### How to Revert to an Older Version of Yabai

If a new yabai version causes issues:

1. Download the desired `.tar.gz` from [yabai releases](https://github.com/koekeishiya/yabai/releases)
2. Edit the Homebrew formula:

   ```bash
   brew edit koekeishiya/formulae/yabai
   ```

3. Update the URL and checksum:

   ```ruby
   url "https://github.com/koekeishiya/yabai/releases/download/v7.1.6/yabai-v7.1.6.tar.gz"
   sha256 "1d2b99f53c24056814cb4912ceba89ea54d095a32dabb1096771650c59f6df5c"
   ```

4. Calculate the checksum:

   ```bash
   shasum -a 256 yabai-v7.1.6.tar.gz
   ```

5. Reinstall:

   ```bash
   brew reinstall yabai
   ```

6. Update sudoers hash (scripting addition won't load with mismatched hash)

---

**For additional troubleshooting help**, see the [Troubleshooting Guide](/docs/TROUBLESHOOTING.md#system-permissions) for comprehensive coverage of:

- macOS accessibility permissions (symptoms, step-by-step resolution, verification commands)
- System-wide diagnostic procedures
- Permission issues after macOS updates
- Scripting addition setup and SIP configuration
- Integration with skhd and other window management tools

## External Resources

- [Official Yabai Documentation](https://github.com/koekeishiya/yabai)
- [Yabai Wiki](https://github.com/koekeishiya/yabai/wiki)
- [Configuration Reference](https://github.com/koekeishiya/yabai/blob/master/doc/yabai.asciidoc)
- [Skhd Documentation](https://github.com/koekeishiya/skhd) - Companion hotkey daemon
- [YabaiIndicator](https://github.com/xiamaz/YabaiIndicator) - Menu bar status indicator
