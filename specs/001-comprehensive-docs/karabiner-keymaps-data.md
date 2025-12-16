# Karabiner Complex Modifications Data

This file contains structured data extracted from the Karabiner configuration for use in creating comprehensive keymaps documentation.

---

## Rule: Use alt + l for right arrow

- **From**: Right Option + l
- **To**: Right Arrow
- **Conditions**: Only when Kitty (net.kovidgoyal.kitty) or Ghostty (com.mitchellh.ghostty) is frontmost application
- **Purpose**: Vim-style navigation in terminal emulators using right alt/option modifier instead of ctrl to avoid conflicts with terminal control sequences

---

## Rule: Use alt + k for up arrow

- **From**: Right Option + k
- **To**: Up Arrow
- **Conditions**: Only when Kitty (net.kovidgoyal.kitty) or Ghostty (com.mitchellh.ghostty) is frontmost application
- **Purpose**: Vim-style navigation in terminal emulators using right alt/option modifier instead of ctrl to avoid conflicts with terminal control sequences

---

## Rule: Use alt + j for down arrow

- **From**: Right Option + j
- **To**: Down Arrow
- **Conditions**: Only when Kitty (net.kovidgoyal.kitty) or Ghostty (com.mitchellh.ghostty) is frontmost application
- **Purpose**: Vim-style navigation in terminal emulators using right alt/option modifier instead of ctrl to avoid conflicts with terminal control sequences

---

## Rule: Use alt + h for left arrow

- **From**: Right Option + h
- **To**: Left Arrow
- **Conditions**: Only when Kitty (net.kovidgoyal.kitty) or Ghostty (com.mitchellh.ghostty) is frontmost application
- **Purpose**: Vim-style navigation in terminal emulators using right alt/option modifier instead of ctrl to avoid conflicts with terminal control sequences

---

## Rule: Use ctrl + l for right arrow

- **From**: Left Control + l
- **To**: Right Arrow
- **Conditions**: Only when Kitty or Ghostty is NOT the frontmost application
- **Purpose**: Vim-style navigation for non-terminal applications using ctrl modifier (complementary to the terminal-specific right option mappings)

---

## Rule: Use ctrl + k for up arrow

- **From**: Left Control + k
- **To**: Up Arrow
- **Conditions**: Only when Kitty or Ghostty is NOT the frontmost application
- **Purpose**: Vim-style navigation for non-terminal applications using ctrl modifier (complementary to the terminal-specific right option mappings)

---

## Rule: Use ctrl + j for down arrow

- **From**: Left Control + j
- **To**: Down Arrow
- **Conditions**: Only when Kitty or Ghostty is NOT the frontmost application
- **Purpose**: Vim-style navigation for non-terminal applications using ctrl modifier (complementary to the terminal-specific right option mappings)

---

## Rule: Use ctrl + h for left arrow

- **From**: Left Control + h
- **To**: Left Arrow
- **Conditions**: Only when Kitty or Ghostty is NOT the frontmost application
- **Purpose**: Vim-style navigation for non-terminal applications using ctrl modifier (complementary to the terminal-specific right option mappings)

---

## Rule: Use Alt + c to move right in Application Switcher

- **From**: Option + c (with any other optional modifiers)
- **To**: Command + Tab
- **Conditions**: None
- **Purpose**: Vim-style forward navigation through macOS application switcher

---

## Rule: Use Alt + x to move left in Application Switcher

- **From**: Option + x (with any other optional modifiers)
- **To**: Command + Shift + Tab
- **Conditions**: None
- **Purpose**: Vim-style backward navigation through macOS application switcher

---

## Rule: Ctrl to Esc and Ctrl (HHKB)

- **From**: Left Control (with any optional modifiers)
- **To**: Left Control when held, Escape when tapped alone
- **Conditions**: Only when HHKB keyboard is connected (vendor_id: 1278, product_id: 33)
- **Purpose**: Dual-function key for HHKB keyboard - provides easy Escape access (common in Vim workflows) while maintaining Control functionality for key combinations

---

## Rule: Ctrl to Alt/Option (Mac KB)

- **From**: Left Control (with any optional modifiers)
- **To**: Left Option
- **Conditions**: Only when HHKB keyboard is NOT connected (vendor_id: 1278, product_id: 33)
- **Purpose**: Remaps Control to Option/Alt on non-HHKB keyboards to match HHKB layout expectations

---

## Rule: Caps Lock to Esc and Ctrl (Mac KB)

- **From**: Caps Lock (with any optional modifiers)
- **To**: Left Control when held, Escape when tapped alone
- **Conditions**: Only when HHKB keyboard is NOT connected (vendor_id: 1278, product_id: 33)
- **Purpose**: Dual-function key for Mac keyboard - provides easy Escape access (common in Vim workflows) while maintaining Control functionality for key combinations, making non-HHKB keyboards behave more like HHKB

---

## Rule: Change caps_lock to command+control+option+shift (DISABLED)

- **From**: Caps Lock (with any optional modifiers)
- **To**: Left Shift + Left Command + Left Control + Left Option (Hyper key)
- **Conditions**: None
- **Status**: Currently disabled
- **Purpose**: Creates a "Hyper" modifier key for triggering custom application shortcuts without conflicts

---

## Rule: Change right_command+hjkl to arrow keys (DISABLED)

- **From**: Right Command + h/j/k/l (with any other optional modifiers)
- **To**: Left/Down/Up/Right arrows respectively
- **Conditions**: None
- **Status**: Currently disabled
- **Purpose**: Alternative Vim-style navigation using right Command modifier (disabled in favor of the ctrl/alt-based navigation)

---

## Rule: Change spacebar to left_shift (DISABLED)

- **From**: Spacebar (with any optional modifiers)
- **To**: Left Shift when held, Spacebar when tapped alone
- **Conditions**: None
- **Status**: Currently disabled
- **Purpose**: Dual-function spacebar for ergonomic shift access

---

## Rule: Hyper Key: Right Option → left shift + left option + left command (DISABLED)

- **From**: Right Option (with any optional modifiers)
- **To**: Left Control + Left Shift + Left Option + Left Command (with variable tracking)
- **Conditions**: None
- **Status**: Currently disabled
- **Purpose**: Creates a "Hyper" modifier key using right option for triggering custom application shortcuts without conflicts

---

## Rule: Hyper Key: Caps Lock → left control + left shift + right command (DISABLED)

- **From**: Caps Lock (with any optional modifiers)
- **To**: Left Control + Left Shift + Right Command (with variable tracking)
- **Conditions**: None
- **Status**: Currently disabled
- **Purpose**: Creates a "Hyper" modifier key using caps lock for triggering custom application shortcuts without conflicts

---

## Rule: Hyper Key: Tab (held down) → left control + left command (DISABLED)

- **From**: Tab
- **To**: Left Control + Left Command when held down, Tab when tapped alone (with variable tracking)
- **Conditions**: None
- **Status**: Currently disabled
- **Purpose**: Creates a "Hyper" modifier key using held-down tab for triggering custom application shortcuts without conflicts

---

## Rule: Mac OSX: double-tap right shift key → caps lock toggle

- **From**: Right Shift (double-tapped within timeout period)
- **To**: Caps Lock toggle
- **Conditions**: Uses variable "right_shift pressed" to detect double-tap
- **Purpose**: Accidental prevention for Caps Lock - requires deliberate double-tap of right shift to activate, reducing accidental Caps Lock activation

---

## Rule: Mac OSX: left cmd + double-tap q → close application

- **From**: Command + q (double-tapped within timeout period)
- **To**: Command + q (application quit)
- **Conditions**: Uses variable "command-q" to detect double-tap
- **Purpose**: Accidental prevention for quitting applications - requires deliberate double-tap of Command+q to quit, reducing accidental application closure

---

## Rule: Mac OSX: disable cmd + h to prevent minimising an application window

- **From**: Command + h
- **To**: (no action)
- **Conditions**: None
- **Purpose**: Disables the hide window shortcut to prevent accidental window hiding

---

## Rule: Mac OSX: disable cmd + option + h + m to prevent minimising all windows

- **From**: Command + Option + h OR Command + Option + m
- **To**: (no action)
- **Conditions**: None
- **Purpose**: Disables the hide all windows and minimize shortcuts to prevent accidental mass window management actions

---

## Summary Statistics

- **Total Rules**: 23
- **Active Rules**: 15
- **Disabled Rules**: 8
- **Keyboard-Specific Rules**: 3 (HHKB vs Mac keyboard)
- **Application-Specific Rules**: 8 (terminal vs non-terminal navigation)
- **Safety Features**: 4 (double-tap requirements, disabled shortcuts)

## Key Themes

1. **Vim-Style Navigation**: Comprehensive hjkl navigation mappings for both terminal and non-terminal contexts
2. **Keyboard Adaptability**: Different behavior for HHKB vs Mac keyboards to maintain consistent user experience
3. **Dual-Function Keys**: Multiple keys serve different purposes when tapped vs held
4. **Safety Mechanisms**: Double-tap requirements prevent accidental commands
5. **Application Context Awareness**: Different key behaviors in terminal emulators vs other applications
