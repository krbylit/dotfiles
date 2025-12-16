# Skhd Hotkeys Data

This file contains a comprehensive categorization of all skhd hotkeys configured in the system.

## Category: MacOS Override

### Hotkey: cmd - h

- **Command**: `:` (no-op)
- **Effect**: Disables the macOS default cmd+h hide window behavior
- **Yabai Integration**: None - this prevents conflicts with yabai mappings

---

## Category: Application Launch

### Hotkey: ctrl - return

- **Command**: `open -a "Ghostty"`
- **Effect**: Launches or focuses the Ghostty terminal application
- **Yabai Integration**: None

---

## Category: Space Switching

### Hotkey: alt - d

- **Command**: `sh -c '"$XDG_CONFIG_HOME"/skhd/util/focus_empty_space.sh'`
- **Effect**: "Show desktop" - changes all displays to first empty space
- **Yabai Integration**: Uses external script that likely calls yabai to focus empty spaces

### Hotkey: alt - 1

- **Command**: `yabai -m space --focus 1`
- **Effect**: Switch focus to space 1
- **Yabai Integration**: Focuses space 1

### Hotkey: alt - 2

- **Command**: `yabai -m space --focus 2`
- **Effect**: Switch focus to space 2
- **Yabai Integration**: Focuses space 2

### Hotkey: alt - 3

- **Command**: `yabai -m space --focus 3`
- **Effect**: Switch focus to space 3
- **Yabai Integration**: Focuses space 3

### Hotkey: alt - 4

- **Command**: `yabai -m space --focus 4`
- **Effect**: Switch focus to space 4
- **Yabai Integration**: Focuses space 4

### Hotkey: alt - 5

- **Command**: `yabai -m space --focus 5`
- **Effect**: Switch focus to space 5
- **Yabai Integration**: Focuses space 5

### Hotkey: alt - 6

- **Command**: `yabai -m space --focus 6`
- **Effect**: Switch focus to space 6
- **Yabai Integration**: Focuses space 6

### Hotkey: alt - 7

- **Command**: `yabai -m space --focus 7`
- **Effect**: Switch focus to space 7
- **Yabai Integration**: Focuses space 7

### Hotkey: alt - 8

- **Command**: `yabai -m space --focus 8`
- **Effect**: Switch focus to space 8
- **Yabai Integration**: Focuses space 8

### Hotkey: alt - 9

- **Command**: `yabai -m space --focus 9`
- **Effect**: Switch focus to space 9
- **Yabai Integration**: Focuses space 9

### Hotkey: alt - 0

- **Command**: `yabai -m space --focus 10`
- **Effect**: Switch focus to space 10
- **Yabai Integration**: Focuses space 10

### Hotkey: alt - 0x1E

- **Command**: `yabai -m space --focus next`
- **Effect**: Switch focus to next space (keycode 0x1E is ']')
- **Yabai Integration**: Focuses next space in sequence

### Hotkey: alt - 0x21

- **Command**: `yabai -m space --focus prev`
- **Effect**: Switch focus to previous space (keycode 0x21 is '[')
- **Yabai Integration**: Focuses previous space in sequence

---

## Category: Window Focus

### Hotkey: ctrl + alt - j

- **Command**: `yabai -m window --focus south`
- **Effect**: Change window focus to the window below (south)
- **Yabai Integration**: Focuses window in south direction

### Hotkey: ctrl + alt - k

- **Command**: `yabai -m window --focus north`
- **Effect**: Change window focus to the window above (north)
- **Yabai Integration**: Focuses window in north direction

### Hotkey: ctrl + alt - h

- **Command**: `yabai -m window --focus west`
- **Effect**: Change window focus to the window on the left (west)
- **Yabai Integration**: Focuses window in west direction

### Hotkey: ctrl + alt - l

- **Command**: `yabai -m window --focus east`
- **Effect**: Change window focus to the window on the right (east)
- **Yabai Integration**: Focuses window in east direction

### Hotkey: ctrl + alt - p

- **Command**: `yabai -m window --focus recent`
- **Effect**: Change window focus to the most recently focused window
- **Yabai Integration**: Focuses most recent window

---

## Category: Display Focus

### Hotkey: alt - w

- **Command**: `yabai -m display --focus west`
- **Effect**: Change focus to external display on the left (west)
- **Yabai Integration**: Focuses west display

### Hotkey: alt - e

- **Command**: `yabai -m display --focus east`
- **Effect**: Change focus to external display on the right (east)
- **Yabai Integration**: Focuses east display

---

## Category: Layout Manipulation

### Hotkey: shift + alt - r

- **Command**: `yabai -m space --rotate 270`
- **Effect**: Rotate layout clockwise (270 degrees counterclockwise = 90 clockwise)
- **Yabai Integration**: Rotates current space layout 270 degrees

### Hotkey: shift + alt - y

- **Command**: `yabai -m space --mirror y-axis`
- **Effect**: Flip the layout along the y-axis (vertical flip)
- **Yabai Integration**: Mirrors current space along y-axis

### Hotkey: shift + alt - x

- **Command**: `yabai -m space --mirror x-axis`
- **Effect**: Flip the layout along the x-axis (horizontal flip)
- **Yabai Integration**: Mirrors current space along x-axis

### Hotkey: shift + alt - e

- **Command**: `yabai -m space --balance`
- **Effect**: Balance out tree of windows to occupy equal area
- **Yabai Integration**: Balances all windows in current space

---

## Category: Window State

### Hotkey: shift + alt - t

- **Command**: `yabai -m window --toggle float --grid 4:4:1:1:2:2`
- **Effect**: Toggle window between floating and tiled, positions floating window in center 2x2 grid
- **Yabai Integration**: Toggles float state with 4x4 grid positioning (center 2x2 area)

### Hotkey: shift + alt - m

- **Command**: `yabai -m window --toggle zoom-fullscreen`
- **Effect**: Maximize a window (toggle zoom-fullscreen)
- **Yabai Integration**: Toggles zoom-fullscreen state

### Hotkey: shift + alt - f

- **Command**: `yabai -m window --toggle native-fullscreen`
- **Effect**: Toggle window native macOS fullscreen
- **Yabai Integration**: Toggles native-fullscreen state

---

## Category: Window Movement

### Hotkey: shift + alt - j

- **Command**: `yabai -m window --warp south`
- **Effect**: Move window south and split (warp repositions window in tree)
- **Yabai Integration**: Warps window to south position

### Hotkey: shift + alt - k

- **Command**: `yabai -m window --warp north`
- **Effect**: Move window north and split (warp repositions window in tree)
- **Yabai Integration**: Warps window to north position

### Hotkey: shift + alt - h

- **Command**: `yabai -m window --warp west`
- **Effect**: Move window west and split (warp repositions window in tree)
- **Yabai Integration**: Warps window to west position

### Hotkey: shift + alt - l

- **Command**: `yabai -m window --warp east`
- **Effect**: Move window east and split (warp repositions window in tree)
- **Yabai Integration**: Warps window to east position

### Hotkey: shift + alt - w

- **Command**: `yabai -m window --display west; yabai -m display --focus west;`
- **Effect**: Move window to left display and follow focus
- **Yabai Integration**: Moves window to west display, then focuses that display

### Hotkey: shift + alt - e

- **Command**: `yabai -m window --display east; yabai -m display --focus east;`
- **Effect**: Move window to right display and follow focus
- **Yabai Integration**: Moves window to east display, then focuses that display

### Hotkey: shift + alt - p

- **Command**: `yabai -m window --space prev;`
- **Effect**: Move window to previous space
- **Yabai Integration**: Moves window to previous space

### Hotkey: shift + alt - n

- **Command**: `yabai -m window --space next;`
- **Effect**: Move window to next space
- **Yabai Integration**: Moves window to next space

### Hotkey: shift + alt - 1

- **Command**: `sh -c 'wid=$(yabai -m query --windows --window | jq -r ".id"); yabai -m window --space 1; yabai -m window --focus $wid'`
- **Effect**: Move window to space 1 and maintain focus on the window
- **Yabai Integration**: Queries window ID, moves to space 1, refocuses window

### Hotkey: shift + alt - 2

- **Command**: `sh -c 'wid=$(yabai -m query --windows --window | jq -r ".id"); yabai -m window --space 2; yabai -m window --focus $wid'`
- **Effect**: Move window to space 2 and maintain focus on the window
- **Yabai Integration**: Queries window ID, moves to space 2, refocuses window

### Hotkey: shift + alt - 3

- **Command**: `sh -c 'wid=$(yabai -m query --windows --window | jq -r ".id"); yabai -m window --space 3; yabai -m window --focus $wid'`
- **Effect**: Move window to space 3 and maintain focus on the window
- **Yabai Integration**: Queries window ID, moves to space 3, refocuses window

### Hotkey: shift + alt - 4

- **Command**: `sh -c 'wid=$(yabai -m query --windows --window | jq -r ".id"); yabai -m window --space 4; yabai -m window --focus $wid'`
- **Effect**: Move window to space 4 and maintain focus on the window
- **Yabai Integration**: Queries window ID, moves to space 4, refocuses window

### Hotkey: shift + alt - 5

- **Command**: `sh -c 'wid=$(yabai -m query --windows --window | jq -r ".id"); yabai -m window --space 5; yabai -m window --focus $wid'`
- **Effect**: Move window to space 5 and maintain focus on the window
- **Yabai Integration**: Queries window ID, moves to space 5, refocuses window

### Hotkey: shift + alt - 6

- **Command**: `sh -c 'wid=$(yabai -m query --windows --window | jq -r ".id"); yabai -m window --space 6; yabai -m window --focus $wid'`
- **Effect**: Move window to space 6 and maintain focus on the window
- **Yabai Integration**: Queries window ID, moves to space 6, refocuses window

### Hotkey: shift + alt - 7

- **Command**: `sh -c 'wid=$(yabai -m query --windows --window | jq -r ".id"); yabai -m window --space 7; yabai -m window --focus $wid'`
- **Effect**: Move window to space 7 and maintain focus on the window
- **Yabai Integration**: Queries window ID, moves to space 7, refocuses window

### Hotkey: shift + alt - 8

- **Command**: `sh -c 'wid=$(yabai -m query --windows --window | jq -r ".id"); yabai -m window --space 8; yabai -m window --focus $wid'`
- **Effect**: Move window to space 8 and maintain focus on the window
- **Yabai Integration**: Queries window ID, moves to space 8, refocuses window

### Hotkey: shift + alt - 9

- **Command**: `sh -c 'wid=$(yabai -m query --windows --window | jq -r ".id"); yabai -m window --space 9; yabai -m window --focus $wid'`
- **Effect**: Move window to space 9 and maintain focus on the window
- **Yabai Integration**: Queries window ID, moves to space 9, refocuses window

### Hotkey: shift + alt - 0

- **Command**: `sh -c 'wid=$(yabai -m query --windows --window | jq -r ".id"); yabai -m window --space 10; yabai -m window --focus $wid'`
- **Effect**: Move window to space 10 and maintain focus on the window
- **Yabai Integration**: Queries window ID, moves to space 10, refocuses window

---

## Category: Layout Mode

### Hotkey: alt - b

- **Command**: `yabai -m space --layout bsp`
- **Effect**: Change current space layout to BSP (Binary Space Partitioning)
- **Yabai Integration**: Sets space layout to bsp

### Hotkey: alt - f

- **Command**: `yabai -m space --layout float`
- **Effect**: Change current space layout to float mode
- **Yabai Integration**: Sets space layout to float

### Hotkey: alt - s

- **Command**: `yabai -m space --layout stack`
- **Effect**: Change current space layout to stack mode
- **Yabai Integration**: Sets space layout to stack

### Hotkey: alt - t

- **Command**: `sh -c '[ "$(yabai -m query --spaces --space | jq -r ".type")" = "stack" ] && yabai -m space --layout bsp || yabai -m space --layout stack'`
- **Effect**: Toggle current space layout between stack and bsp
- **Yabai Integration**: Queries current space type, switches between stack and bsp

---

## Category: Space Management

### Hotkey: shift + alt - q

- **Command**: `yabai -m space --destroy`
- **Effect**: Delete the currently focused space
- **Yabai Integration**: Destroys current space

---

## Category: Yabai Service Control

### Hotkey: ctrl + alt - q

- **Command**: `yabai --stop-service`
- **Effect**: Stop the yabai window manager service
- **Yabai Integration**: Stops yabai service

### Hotkey: ctrl + alt - s

- **Command**: `yabai --start-service`
- **Effect**: Start the yabai window manager service
- **Yabai Integration**: Starts yabai service

### Hotkey: ctrl + alt - r

- **Command**: `yabai --restart-service`
- **Effect**: Restart the yabai window manager service
- **Yabai Integration**: Restarts yabai service

### Hotkey: alt - r

- **Command**: `osascript -e 'tell application "System Events" to set visible of (every process whose visible is false and background only is false) to true'; skhd --restart-service; env -u TERMINFO sudo -n /opt/homebrew/bin/yabai --load-sa; yabai --stop-service; sleep .25; yabai --start-service; sleep 1.5; yabai -m rule --apply`
- **Effect**: Full system refresh - makes all processes visible, restarts skhd, loads scripting addition, restarts yabai, and reapplies rules
- **Yabai Integration**: Comprehensive restart sequence including scripting addition reload and rule reapplication

### Hotkey: alt - a

- **Command**: `yabai -m rule --apply`
- **Effect**: Apply/reapply all yabai window rules
- **Yabai Integration**: Reapplies all configured window rules
