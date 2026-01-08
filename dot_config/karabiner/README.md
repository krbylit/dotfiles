# Karabiner-Elements Configuration

## Overview

Karabiner-Elements is a powerful keyboard customizer for macOS that serves as the **hardware remapping layer** in this dotfiles configuration. It intercepts keyboard input at the lowest level and transforms it before it reaches applications, enabling sophisticated key remapping, dual-function keys, and application-aware behaviors.

This configuration implements a comprehensive Vim-centric navigation philosophy with adaptive keyboard support (HHKB vs Mac keyboards), application-specific behaviors, and safety mechanisms to prevent accidental commands.

## Table of Contents

- [Overview](#overview)
- [Configuration Files](#configuration-files)
- [Key Features](#key-features)
  - [Vim-Style Navigation (hjkl)](#vim-style-navigation-hjkl)
  - [Application Switcher Navigation](#application-switcher-navigation)
  - [Keyboard-Adaptive Behavior](#keyboard-adaptive-behavior)
  - [Dual-Function Keys](#dual-function-keys)
  - [Safety Mechanisms](#safety-mechanisms)
- [Complex Modifications Reference](#complex-modifications-reference)
  - [Active Rules (15)](#active-rules-15)
  - [Disabled Rules (8)](#disabled-rules-8)
- [Customization Guide](#customization-guide)
  - [Adding New Complex Modifications](#adding-new-complex-modifications)
  - [Enabling/Disabling Existing Rules](#enablingdisabling-existing-rules)
  - [Adding Application-Specific Rules](#adding-application-specific-rules)
  - [Creating Dual-Function Keys](#creating-dual-function-keys)
  - [Testing Modifications](#testing-modifications)
  - [Backing Up Configuration](#backing-up-configuration)
- [Integration Points](#integration-points)
  - [skhd Integration](#skhd-integration)
  - [Terminal Emulator Integration](#terminal-emulator-integration)
  - [Keyboard Hardware Integration](#keyboard-hardware-integration)
- [Troubleshooting](#troubleshooting)
  - [Input Monitoring Permissions Required](#input-monitoring-permissions-required)
  - [Common Issues After macOS Updates](#common-issues-after-macos-updates)
  - [How to Verify Karabiner is Active](#how-to-verify-karabiner-is-active)
  - [Configuration Not Loading](#configuration-not-loading)
  - [Dual-Function Keys Not Working](#dual-function-keys-not-working)
  - [Conflicts with Other Keyboard Tools](#conflicts-with-other-keyboard-tools)
- [External Resources](#external-resources)

## Configuration Files

| File | Purpose |
|------|---------|
| `karabiner.json` | Main configuration file containing all complex modifications, profiles, and device-specific rules |

**Note**: The actual configuration file is managed through chezmoi and located at `/Users/kirbylittle/.local/share/chezmoi/cm-util/ctrld-configs/karabiner/karabiner.json`. Edit using `chezmoi edit` and apply with `chezmoi apply`.

## Key Features

### Vim-Style Navigation (hjkl)

The configuration provides comprehensive Vim-style navigation across the entire system using `hjkl` keys, with intelligent context-awareness:

**Terminal Emulators (Ghostty, Kitty)**

- `Right Option + h/j/k/l` → Left/Down/Up/Right arrows
- Uses Right Option to avoid conflicts with terminal control sequences (Ctrl+h, Ctrl+j, etc.)
- Only active when Ghostty or Kitty is the frontmost application

**Non-Terminal Applications**

- `Left Control + h/j/k/l` → Left/Down/Up/Right arrows
- Uses Left Control for Vim-style navigation everywhere else
- Only active when Ghostty or Kitty is NOT the frontmost application

This dual approach ensures navigation works consistently while avoiding conflicts with terminal-specific shortcuts.

### Application Switcher Navigation

Vim-style navigation for macOS Command+Tab application switcher:

- `Option + c` → Move right (Command+Tab)
- `Option + x` → Move left (Command+Shift+Tab)

### Keyboard-Adaptive Behavior

The configuration automatically adapts based on whether an HHKB keyboard (vendor_id: 1278, product_id: 33) is connected:

**HHKB Keyboard Connected**

- `Left Control` → Dual-function: Control when held, Escape when tapped alone
- Maintains HHKB's native Ctrl key position and functionality

**Mac Keyboard (Non-HHKB)**

- `Left Control` → Remapped to Left Option/Alt
- `Caps Lock` → Dual-function: Control when held, Escape when tapped alone
- Makes Mac keyboards behave similarly to HHKB layout

This ensures a consistent typing experience regardless of which keyboard is connected.

### Dual-Function Keys

Several keys perform different actions when tapped versus held:

- **Control/Caps Lock** (keyboard-dependent): Control when held, Escape when tapped
- This provides easy Escape access for Vim workflows while maintaining Control modifier functionality

### Safety Mechanisms

The configuration includes several features to prevent accidental commands:

**Double-Tap to Quit Applications**

- `Command + q` requires double-tap to quit applications
- First tap sets a variable, second tap within timeout actually quits
- Prevents accidental application closure

**Double-Tap for Caps Lock**

- `Right Shift` double-tapped → Toggles Caps Lock
- Requires deliberate action to activate Caps Lock
- Reduces accidental Caps Lock activation

**Disabled Shortcuts**

- `Command + h` → Disabled (prevents accidental window hiding)
- `Command + Option + h` → Disabled (prevents hide all windows)
- `Command + Option + m` → Disabled (prevents minimize all windows)

## Complex Modifications Reference

### Active Rules (15)

#### Vim Navigation in Terminal Emulators (4 rules)

1. **Use alt + h for left arrow** - Right Option + h → Left Arrow (Ghostty/Kitty only)
2. **Use alt + j for down arrow** - Right Option + j → Down Arrow (Ghostty/Kitty only)
3. **Use alt + k for up arrow** - Right Option + k → Up Arrow (Ghostty/Kitty only)
4. **Use alt + l for right arrow** - Right Option + l → Right Arrow (Ghostty/Kitty only)

#### Vim Navigation in Non-Terminal Apps (4 rules)

5. **Use ctrl + h for left arrow** - Left Control + h → Left Arrow (except Ghostty/Kitty)
2. **Use ctrl + j for down arrow** - Left Control + j → Down Arrow (except Ghostty/Kitty)
3. **Use ctrl + k for up arrow** - Left Control + k → Up Arrow (except Ghostty/Kitty)
4. **Use ctrl + l for right arrow** - Left Control + l → Right Arrow (except Ghostty/Kitty)

#### Application Switcher (2 rules)

9. **Use Alt + c to move right in Application Switcher** - Option + c → Command + Tab
2. **Use Alt + x to move left in Application Switcher** - Option + x → Command + Shift + Tab

#### Keyboard-Adaptive Keys (3 rules)

11. **Ctrl to Esc and Ctrl (HHKB)** - Control → Dual-function (HHKB only)
2. **Ctrl to Alt/Option (Mac KB)** - Control → Option (Mac keyboard only)
3. **Caps Lock to Esc and Ctrl (Mac KB)** - Caps Lock → Dual-function (Mac keyboard only)

#### Safety Features (2 rules)

14. **Mac OSX: double-tap right shift key → caps lock toggle** - Right Shift double-tap → Caps Lock
2. **Mac OSX: left cmd + double-tap q → close application** - Command + q double-tap → Quit app

#### Disabled Shortcuts (4 rules combined)

- **Mac OSX: disable cmd + h to prevent minimising an application window**
- **Mac OSX: disable cmd + option + h + m to prevent minimising all windows**

### Disabled Rules (8)

These rules are present in the configuration but currently disabled. You can enable them if desired:

1. **Change caps_lock to command+control+option+shift** - Creates a "Hyper" modifier key
2. **Change right_command+hjkl to arrow keys** - Alternative Vim navigation using right Command
3. **Change spacebar to left_shift** - Dual-function spacebar (Shift when held, Space when tapped)
4. **Hyper Key: Right Option → left shift + left option + left command** - Hyper modifier variant
5. **Hyper Key: Caps Lock → left control + left shift + right command** - Hyper modifier variant
6. **Hyper Key: Tab (held down) → left control + left command** - Hyper modifier variant

## Customization Guide

### Adding New Complex Modifications

1. **Edit the configuration**:

   ```bash
   chezmoi edit ~/.config/karabiner/karabiner.json
   ```

2. **Add your rule to the `rules` array**:

   ```json
   {
     "description": "Your modification description",
     "manipulators": [
       {
         "type": "basic",
         "from": {
           "key_code": "your_key",
           "modifiers": {
             "mandatory": ["modifier_key"]
           }
         },
         "to": [
           {
             "key_code": "target_key"
           }
         ]
       }
     ]
   }
   ```

3. **Apply the changes**:

   ```bash
   chezmoi apply
   ```

4. **Verify in Karabiner-Elements**: The new rule should appear immediately in the Complex Modifications tab

### Enabling/Disabling Existing Rules

**Method 1: Via Karabiner-Elements UI**

1. Open Karabiner-Elements application
2. Navigate to "Complex Modifications" tab
3. Click "Enable" or "Disable" next to any rule

**Method 2: Via Configuration File**

1. Edit the configuration: `chezmoi edit ~/.config/karabiner/karabiner.json`
2. Add or modify the `"enabled": false` property on any rule
3. Apply changes: `chezmoi apply`

Example:

```json
{
  "description": "Your rule",
  "enabled": false,  // Add this line to disable
  "manipulators": [...]
}
```

### Adding Application-Specific Rules

To make a rule work only in specific applications, add a `conditions` array with `frontmost_application_if` or `frontmost_application_unless`:

```json
{
  "conditions": [
    {
      "type": "frontmost_application_if",
      "bundle_identifiers": [
        "^com\\.example\\.app$"
      ]
    }
  ]
}
```

**Finding Bundle Identifiers**:

1. Open Karabiner-EventViewer
2. Select "Frontmost Application" tab
3. Switch to your target application
4. Note the bundle identifier displayed

### Creating Dual-Function Keys

For keys that behave differently when tapped vs. held:

```json
{
  "from": {
    "key_code": "your_key"
  },
  "to": [
    { "key_code": "held_behavior" }
  ],
  "to_if_alone": [
    { "key_code": "tapped_behavior" }
  ]
}
```

### Testing Modifications

1. **Karabiner-EventViewer**: Monitor key events in real-time
   - Open Karabiner-EventViewer from the menu bar
   - View "Main" tab to see all key events
   - Verify your mappings are triggering correctly

2. **Test incrementally**: Add one rule at a time and test before adding more

3. **Check Karabiner-Elements log**: View logs at `/var/log/karabiner/` for errors

### Backing Up Configuration

Your configuration is already backed up through chezmoi! Additional backup options:

1. **Export via Karabiner-Elements**:
   - Misc tab → Export configuration

2. **Manual backup**:

   ```bash
   cp ~/.config/karabiner/karabiner.json ~/karabiner-backup-$(date +%Y%m%d).json
   ```

3. **Version control**: The configuration is tracked in your dotfiles repository

## Integration Points

### skhd Integration

Karabiner-Elements operates at the hardware layer, transforming keys before they reach any application. This feeds into the skhd layer, which handles:

- Window management shortcuts
- Application launching shortcuts
- Yabai window manager integration

**Layer Hierarchy**:

1. **Karabiner-Elements** (Hardware layer) → Remaps physical keys, dual-function keys, app-specific behaviors
2. **skhd** (Application layer) → Receives transformed input, triggers window management and app shortcuts
3. **Yabai** (Window manager) → Receives commands from skhd for window tiling and management

Example flow: `Caps Lock (tap)` → Karabiner transforms to `Escape` → skhd may handle additional Escape shortcuts → Application receives final input

### Terminal Emulator Integration

**Ghostty and Kitty** receive special treatment:

- Right Option + hjkl for Vim navigation (instead of Control)
- Prevents conflicts with terminal control sequences (Ctrl+C, Ctrl+Z, etc.)
- Allows normal terminal shortcuts to work while providing navigation

**Why this matters**: Terminal emulators need Ctrl key combinations for their native functions (interrupt, suspend, etc.). Using Right Option for navigation avoids these conflicts.

### Keyboard Hardware Integration

The configuration automatically detects connected keyboards:

- **HHKB detection**: vendor_id: 1278, product_id: 33
- Different key mappings activate based on detected hardware
- Seamless switching when connecting/disconnecting keyboards

## Troubleshooting

### Input Monitoring Permissions Required

**Symptoms**: Karabiner-Elements installed but key remapping not working

**Solution**:

1. Open System Settings → Privacy & Security → Input Monitoring
2. Enable karabiner_grabber and karabiner_observer
3. Restart Karabiner-Elements: `brew services restart karabiner-elements`

### Common Issues After macOS Updates

**Symptoms**: Karabiner stops working after macOS update

**Solution**:

1. Open Karabiner-Elements
2. If prompted, allow all system permission requests
3. Re-enable Input Monitoring permissions in System Settings
4. Restart: `brew services restart karabiner-elements`

### How to Verify Karabiner is Active

**Check 1: Menu Bar Icon**

- Karabiner-Elements icon should appear in menu bar
- Click it and verify version number

**Check 2: EventViewer**

- Open Karabiner-EventViewer
- Type some keys and verify they appear in the log

**Check 3: Test a Simple Mapping**

- Try one of the Vim navigation shortcuts (Ctrl+h/j/k/l)
- If arrow keys move, Karabiner is working

**Check 4: System Services**

```bash
brew services list | grep karabiner
```

Should show karabiner-elements as "started"

### Configuration Not Loading

**Symptoms**: Changes to karabiner.json not taking effect

**Solution**:

1. Verify JSON syntax is valid (use a JSON validator)
2. Check Karabiner-Elements log: `tail -f /var/log/karabiner/console_user_server.log`
3. Restart Karabiner-Elements
4. Verify file is in correct location: `~/.config/karabiner/karabiner.json`

### Dual-Function Keys Not Working

**Symptoms**: Tap/hold behavior not working as expected

**Solution**:

1. Adjust timing in Karabiner-Elements → Parameters tab
2. Increase "to_if_alone_timeout_milliseconds" (default: 1000ms)
3. Adjust "to_delayed_action_delay_milliseconds" for double-tap features

### Conflicts with Other Keyboard Tools

**Symptoms**: Unexpected behavior when using other keyboard customization tools

**Solution**:

- Disable other keyboard tools (BetterTouchTool keyboard features, Hammerspoon key remapping, etc.)
- Karabiner should be the only tool modifying keyboard input at the hardware level
- Use skhd for application-level shortcuts instead

---

**For additional troubleshooting help**, see the [Troubleshooting Guide](/docs/TROUBLESHOOTING.md#system-permissions) for comprehensive coverage of:

- macOS Input Monitoring permissions (symptoms, step-by-step resolution, verification)
- Permission issues after macOS updates
- Using Karabiner-EventViewer for debugging
- Configuration validation and JSON syntax checking
- Dual-function key timing adjustments
- Integration with skhd and application-level shortcuts

## External Resources

- [Official Karabiner-Elements Documentation](https://karabiner-elements.pqrs.org/docs/)
- [Complex Modifications Reference](https://karabiner-elements.pqrs.org/docs/json/typical-complex-modifications-examples/)
- [Configuration Reference Manual](https://karabiner-elements.pqrs.org/docs/json/)
- [Community Complex Modifications](https://ke-complex-modifications.pqrs.org/) - Pre-made rules you can import
- [EventViewer Guide](https://karabiner-elements.pqrs.org/docs/manual/operation/eventviewer/) - Learn to monitor key events
- [Karabiner-Elements GitHub](https://github.com/pqrs-org/Karabiner-Elements) - Source code and issue tracker
