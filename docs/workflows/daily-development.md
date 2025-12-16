# Daily Development Workflow

## Purpose

This workflow documents how all the tools in this dotfiles configuration work together during a typical development day. It demonstrates real-world integration patterns, common task flows, and how each tool enhances productivity through seamless interaction with others.

Use this guide to:

- Understand how tools integrate in daily use
- Learn typical workflow patterns for common tasks
- Discover keyboard-driven navigation across the entire system
- Optimize your development environment for maximum efficiency

## Architecture Overview

The development environment operates as a layered system where each tool feeds into the next:

```
Hardware Layer:        Keyboard input
                            ↓
Remapping Layer:       Karabiner-Elements (Vim navigation, dual-function keys)
                            ↓
Hotkey Layer:          skhd (Window management, app launching)
                            ↓
Window Manager Layer:  Yabai (Tiling, spaces, displays)
                            ↓
Application Layer:     Ghostty → Fish Shell → Neovim/Tools
                            ↓
Tool Integration:      FZF, Delta, Lazygit, Zellij, Yazi
```

**Key principle**: Each layer transforms input before passing it to the next, creating a cohesive keyboard-driven workflow.

---

## Morning Startup Routine

### System Boot and Initialization

**What happens automatically:**

1. **macOS boots** → Login screen appears
2. **User logs in** → Launch agents and services start automatically
3. **Homebrew services start** (managed by `brew services`):
   - `yabai` - Window manager service starts
   - `skhd` - Hotkey daemon initializes and waits for input
   - `karabiner-elements` - Keyboard remapper activates
4. **Yabai initializes** (via `~/.config/yabai/yabairc`):
   - Creates 9 labeled spaces across displays
   - Applies window rules for automatic app placement
   - Configures BSP/stack layouts for each space
   - Loads scripting addition for advanced features

**Expected state after boot:**

- 9 virtual spaces ready (term, browser, code, dev, misc, comms, ref, debug, util)
- Keyboard remapping active (Vim navigation with hjkl, Caps Lock → Ctrl/Esc)
- Hotkeys ready (alt + 1-9 for space switching, shift + alt for window movement)

### Opening Your Workspace

**Step 1: Launch Terminal**

Press `ctrl + return` (skhd hotkey) → Ghostty terminal opens on **space 1 (term)**

**Why this works:**

- skhd receives `ctrl + return` keypress
- Executes: `open -a "Ghostty"`
- Yabai window rule auto-assigns Ghostty to space 1
- You're automatically focused on the term space

**Step 2: Open Typical Applications**

Applications automatically go to their designated spaces when launched:

```bash
# From terminal or Spotlight
open -a "Microsoft Edge"      # → Space 2 (browser)
open -a "Cursor"              # → Space 3 (code)
open -a "Docker Desktop"      # → Space 4 (dev)
open -a "Slack"               # → Space 6 (comms)
```

**Yabai window rules in action** (from `yabairc`):

- Browser apps → browser space (stack layout for focused browsing)
- Code editors → code space (stack layout for single-editor focus)
- Dev tools → dev space (BSP layout for multi-tool workflows)
- Communication → comms space (BSP layout for chat + calendar)

**Step 3: Navigate to Your Project**

In the Ghostty terminal, use Fish shell functions:

```fish
# Smart directory navigation with zoxide
z myproject              # Jump to frequently-used project directory
# Or use interactive picker
zi                       # FZF picker shows recent directories

# Launch file manager to browse project
y                        # Opens Yazi, auto-cd to selected directory on exit
```

**Tool integration in action:**

1. Fish shell provides the `z` and `y` wrapper functions
2. Zoxide tracks directory frequency and recency
3. FZF provides interactive selection (via `zi`)
4. Yazi file manager integrates with Fish for seamless directory switching

### Typical Initial Window Layout

After opening common apps, your Yabai spaces look like this:

**Primary Display:**

- Space 1 (term): Ghostty terminal with Fish shell
- Space 2 (browser): Microsoft Edge in stack layout
- Space 3 (code): Cursor editor in stack layout
- Space 4 (dev): Docker, Postman in BSP layout (side-by-side)
- Space 5 (misc): Finder windows

**Secondary Display** (if connected):

- Space 6 (comms): Slack + Outlook in BSP layout
- Space 7 (ref): Notion Calendar, LM Studio
- Space 8 (debug): Chrome DevTools, Claude chat
- Space 9 (util): 1Password, Activity Monitor

**Navigation:**

- `alt + 1-9` to switch spaces
- `alt + w/e` to focus west/east display
- `ctrl + alt + hjkl` to focus windows within a space

---

## Code Development Flow

### Opening and Editing Files

**Scenario**: You need to edit a file in your project

**Method 1: Direct Neovim (from terminal)**

```fish
# Navigate to project
z myproject

# Open file directly
v src/main.ts            # 'v' is Fish function wrapping nvim
```

**Method 2: FZF File Finder (from Fish shell)**

Press `ctrl + f` (FZF keybinding) → File picker opens

**What happens:**

1. Fish shell receives `ctrl + f` input
2. fzf.fish plugin activates file search
3. `fd` finds all files (respecting .gitignore)
4. FZF displays interactive picker with `bat` preview
5. Select file → path inserted at cursor
6. Run `v <selected-file>` to open in Neovim

**Method 3: Ripgrep Live Search (from Fish shell)**

Press `ctrl + s` (custom Fish keybinding) → Launches `ripgrep_live`

**What happens:**

1. FZF opens in full-screen mode
2. Type search query → ripgrep searches in real-time
3. FZF updates results as you type
4. Preview pane shows `bat` syntax-highlighted context
5. Press `enter` → Opens file in Neovim at matching line
6. Or press `tab` to select multiple → `enter` builds Neovim quickfix list

**Method 4: File Manager (Yazi)**

```fish
y                        # Launch Yazi file manager
# Navigate with hjkl, preview files, press 'enter' to select
# Yazi closes, Fish auto-cd to selected directory
```

**From within Yazi:**

- `g` → Opens Lazygit on current directory (if it's a Git repo)
- `/` → Ripgrep search integration (calls `yazi_ripgrep` Fish function)
- `e` → Opens file in `$EDITOR` (Neovim)

### Neovim Editing with LSP and Copilot

**Opening Neovim automatically activates:**

1. **Language Server Protocol (LSP)** - Real-time code intelligence:
   - Diagnostic messages for errors/warnings
   - Auto-completion suggestions
   - Hover documentation
   - Go-to-definition, find references

2. **GitHub Copilot** - AI code suggestions:
   - Context-aware completions
   - Multi-line suggestions
   - Accept with `Tab`, dismiss with `Esc`

3. **Syntax highlighting** via Tree-sitter:
   - Faster, more accurate than regex-based highlighting
   - Semantic understanding of code structure

4. **File tree** via neo-tree:
   - `<leader>e` to toggle file explorer
   - Integrates with Git status indicators

**Typical editing workflow:**

```
1. Open file with 'v filename' or via FZF
2. Navigate with Vim motions (hjkl, w, b, e, etc.)
3. LSP shows diagnostics as you type
4. Copilot suggests completions (Tab to accept)
5. Use 'gd' to go to definition (LSP)
6. Use '<leader>ca' for code actions (LSP)
7. Save with ':w'
```

**Integration with system clipboard:**

- Neovim is configured to use system clipboard automatically
- `yy` in normal mode → Copies line to macOS clipboard
- Works across Neovim, Fish shell, and all other apps

### Terminal Workflow with Fish

**Running commands with enhanced output:**

```fish
# List files with eza (enhanced ls)
l                        # Icons, colors, grouped by type
la                       # Includes hidden files
lrt                      # Sorted by modification time

# View file contents with syntax highlighting
cat config.yaml          # 'cat' aliased to 'bat --paging=never'

# Search with ripgrep + FZF preview
frg "function"           # Interactive search with bat preview
brg "TODO"               # Batgrep with smart case search

# Help with syntax highlighting
help git                 # Uses bat for colorized --help output
vman git                 # Opens man page in Neovim
```

**Command history with FZF:**

Press `ctrl + e` (FZF history keybinding) → Fuzzy search command history

**What happens:**

1. FZF opens with full command history
2. Type to filter (fuzzy matching)
3. Select command → Inserted at prompt
4. Press `enter` to execute, or edit first

**Auto-suggestions:**

Fish provides real-time command suggestions based on history:

- Type partial command → Ghost text appears
- Press `ctrl + y` to accept suggestion (Karabiner + Fish keybinding)

### Git Operations with Lazygit

**Opening Lazygit:**

```fish
lg                       # Opens Lazygit in current directory
cmg                      # Opens Lazygit in chezmoi source directory
```

**From within Yazi:**

- Press `g` → Launches Lazygit on current directory

**Typical Git workflow:**

1. **Review changes** (Files panel):
   - `j`/`k` to navigate files
   - `space` to stage/unstage individual files
   - `a` to stage all changes
   - Main panel shows Delta-enhanced diff with syntax highlighting

2. **Commit changes**:
   - Press `c` → Commit dialog opens
   - Write commit message in Neovim (via `nvr` integration)
   - Save and close → Returns to Lazygit, commit created

3. **Push to remote**:
   - Press `P` → Pushes to remote
   - Or use `shift + p` to pull first

4. **Interactive rebase** (Commits panel):
   - Navigate to base commit
   - Press `i` to start interactive rebase
   - Press `s` to squash, `r` to reword, `f` to fixup
   - Use `ctrl + j`/`ctrl + k` to reorder commits

5. **Branch management** (Branches panel):
   - Press `c` to checkout branch (with fuzzy search)
   - Press `M` to merge branch into current
   - Press `r` to rebase current onto selected

**Integration benefits:**

- **Neovim integration**: Opens files in existing Neovim instance (via `nvr`)
- **Delta integration**: Syntax-highlighted diffs in preview
- **Fish shell integration**: Launched via `lg` or `cmg` wrapper functions
- **Yazi integration**: Quick launch from file manager

### Debugging with Logs and Docker

**Viewing logs with syntax highlighting:**

```fish
# Tail log files with bat
logtail /var/log/app.log # Syntax-highlighted tailing

# Docker logs
dtail                    # Tails journald logs for all running containers
dlog                     # Shows most recent Docker build log

# Export Docker logs
exportlogs myapp 20231215 json  # Export specific date in JSON format
```

**Docker development workflow:**

```fish
# Build and deploy
dbuild                   # Builds Docker compose in detached tmux session
ddeploy                  # Full cycle: build, stop, start with logging

# Monitor with Lazydocker
ld                       # Opens Lazydocker TUI for interactive management
```

**Lazydocker features:**

- Manage containers, images, volumes
- View logs with syntax highlighting
- Execute commands in containers
- Monitor resource usage
- All navigable with Vim keybindings (hjkl)

---

## Window Management Flow

### Space Navigation

**Switching between spaces:**

```
alt + 1-9                Focus space 1-9
alt + [                  Focus previous space
alt + ]                  Focus next space
alt + d                  Show desktop (focus first empty space)
```

**Real-world navigation pattern:**

```
Working on code:
  alt + 1    → Terminal (run commands)
  alt + 3    → Code editor (write code)
  alt + 4    → Browser DevTools (debug)
  alt + 6    → Slack (respond to messages)
  alt + 1    → Back to terminal
```

**How it flows:**

1. Press `alt + 1` → skhd receives input
2. skhd executes: `yabai -m space --focus 1`
3. Yabai switches to space 1 (term)
4. Cursor focus moves to Ghostty window automatically

### Window Focus Within Space

**Focus windows using directional navigation:**

```
ctrl + alt + h           Focus window to the left
ctrl + alt + j           Focus window below
ctrl + alt + k           Focus window above
ctrl + alt + l           Focus window to the right
ctrl + alt + p           Focus most recently used window
```

**Why ctrl + alt instead of plain hjkl?**

- Karabiner remaps these to arrow keys in non-terminal apps
- In terminals, uses `right option + hjkl` to avoid conflicts
- This provides universal Vim navigation across the entire system

**Example workflow:**

```
Space 4 (dev) has Docker and Postman side-by-side (BSP layout):
  ctrl + alt + h    → Focus Docker window (left)
  ctrl + alt + l    → Focus Postman window (right)
  ctrl + alt + p    → Toggle between the two
```

### Moving Windows Between Spaces

**Send window to specific space (and maintain focus):**

```
shift + alt + 1-9        Move window to space 1-9 (keeps focus)
shift + alt + p          Move to previous space
shift + alt + n          Move to next space
```

**Advanced window move pattern** (from skhdrc):

```bash
# When you press shift + alt + 3:
wid=$(yabai -m query --windows --window | jq -r ".id")  # Get window ID
yabai -m window --space 3                                # Move to space 3
yabai -m window --focus $wid                             # Refocus the window
```

**Why this pattern?**

- Maintains keyboard control of the moved window
- No need to switch spaces manually after moving
- Allows immediate interaction with the moved window

**Real-world scenario:**

```
You're on space 1 with a terminal window:
  shift + alt + 3   → Window moves to code space AND you stay focused on it
                      (now on space 3, ready to continue working)
```

### Layout Manipulation

**Change window layouts:**

```
alt + b                  BSP layout (tiling)
alt + s                  Stack layout (one window visible, rest stacked)
alt + f                  Float layout (windows float freely)
alt + t                  Toggle between stack and BSP
```

**Rotate and mirror:**

```
shift + alt + r          Rotate layout 90° clockwise
shift + alt + y          Mirror layout vertically (y-axis)
shift + alt + x          Mirror layout horizontally (x-axis)
shift + alt + e          Balance window sizes (equal area)
```

**Real-world use case:**

```
Space 4 (dev) in BSP layout with 3 windows:
  Too many small windows?
  → shift + alt + e    → All windows balanced to equal size

  Want vertical split to be horizontal?
  → shift + alt + r    → Rotate entire layout

  Need to focus on one window temporarily?
  → alt + s            → Switch to stack layout (one window fullscreen)
  → alt + t            → Toggle back to BSP when done
```

### Window State Changes

**Toggle window states:**

```
shift + alt + t          Toggle float (centers in 4x4 grid)
shift + alt + m          Toggle zoom-fullscreen (maximize in space)
shift + alt + f          Toggle native macOS fullscreen
```

**Float vs. Zoom vs. Native Fullscreen:**

- **Float**: Window floats above tiling, manually positioned
- **Zoom**: Window fills entire space (BSP/stack still active, other windows hidden)
- **Native fullscreen**: macOS fullscreen mode (creates new space, hides menu bar)

**When to use each:**

- **Float**: Temporary windows (dialogs, calculators, small utilities)
- **Zoom**: Focus mode without leaving current space layout
- **Native fullscreen**: Presentations, watching videos, distraction-free editing

### Multi-Monitor Workflows

**Display focus:**

```
alt + w                  Focus west (left) display
alt + e                  Focus east (right) display
```

**Move windows between displays:**

```
shift + alt + w          Move window to west display (and follow)
shift + alt + e          Move window to east display (and follow)
```

**Typical dual-monitor setup:**

```
Primary display (laptop screen):
  Spaces 1-5: term, browser, code, dev, misc

Secondary display (external monitor):
  Spaces 6-9: comms, ref, debug, util

Navigation:
  alt + 1    → Terminal on primary display
  alt + 6    → Comms on secondary display
  alt + w    → Focus back to primary display
  alt + e    → Focus back to secondary display
```

**Dynamic display adjustment:**

When you connect/disconnect a display:

1. Yabai detects display change (signal handler)
2. Automatically restarts Yabai service
3. Reapplies all window rules
4. Redistributes spaces across available displays

**Signal from yabairc:**

```bash
yabai -m signal --add event=display_added action="yabai --restart-service"
yabai -m signal --add event=display_removed action="yabai --restart-service"
```

---

## Configuration Changes Flow

### Editing Configuration with Chezmoi

**Step 1: Identify what to change**

```fish
# Find managed files
chezmoi managed | grep fish

# Search for content
cd ~/.local/share/chezmoi
ripgrep_live              # FZF live search across all dotfiles
```

**Step 2: Edit the source file**

```fish
# Use custom Fish function
c                         # Opens Neovim in chezmoi source directory

# Or use chezmoi edit command
chezmoi edit ~/.config/fish/config.fish

# Or use dedicated config editor shortcuts
fc                        # Edit Fish config
vc                        # Edit Neovim config
gc                        # Edit Ghostty config
```

**How the 'c' function works** (from Fish functions):

```fish
function c
    set -l prev_dir (pwd)
    cd (chezmoi source-path)
    nvim $argv
    cd $prev_dir
end
```

**Benefits:**

- Opens Neovim in chezmoi source directory
- Returns to previous directory on exit
- Can pass filenames as arguments

**Step 3: Preview changes**

```fish
# See what would change
chezmoi diff

# Apply and preview side-by-side
chezmoi apply --dry-run --verbose
```

**Chezmoi diff uses Delta integration:**

- Syntax-highlighted diff output
- Side-by-side view of changes
- Shows exactly what will be applied

**Step 4: Apply changes**

```fish
# Apply to home directory
chezmoi apply

# Apply and reload Fish config
cmf                       # Custom Fish function: force apply + reload shell
```

**The 'cmf' function** (from Fish functions):

```fish
function cmf
    chezmoi apply --force $argv
    exec fish               # Restart Fish shell to reload config
end
```

### Testing Configuration Changes

**For shell configurations:**

```fish
# Test Fish syntax before applying
fish -n ~/.config/fish/config.fish

# Profile Fish startup time
profile_fish              # Opens sorted profile in Neovim
```

**For Neovim configuration:**

```fish
# Test in isolated environment
vtest                     # Launches Neovim with isolated data/state/cache
```

**For window manager configuration:**

```
# After editing yabai/skhd configs:
alt + r                   # Full system refresh (skhd + yabai + rules)
alt + a                   # Reapply window rules only
```

### Committing Configuration Changes

**Step 1: Review changes in Lazygit**

```fish
cmg                       # Opens Lazygit in chezmoi source directory
```

**Step 2: Stage and commit**

In Lazygit:

1. Navigate files panel with `j`/`k`
2. Review Delta-enhanced diffs in main panel
3. Stage files with `space` or `a` (all)
4. Press `c` to commit
5. Write commit message in Neovim
6. Save and close

**Step 3: Push to remote**

```
Press 'P' in Lazygit → Push to origin
```

**Alternative Git workflow (command line):**

```fish
# Navigate to chezmoi source
cd (chezmoi source-path)

# Use enhanced git diff
gdiff                     # Fish function: git diff with Delta

# Commit interactively
git add -p               # Stage hunks interactively
git commit -m "feat(fish): add new function"
git push
```

---

## Tool Integration Examples

### FZF Integration with Ripgrep, fd, and bat

**How FZF enhances multiple tools:**

1. **File search** (ctrl + f in Fish):
   - `fd` finds files (respects .gitignore)
   - FZF provides interactive selection
   - `bat` shows syntax-highlighted preview
   - `eza` shows directory contents in preview

2. **Live ripgrep** (ctrl + s in Fish):
   - `ripgrep` searches file contents in real-time
   - FZF displays results and updates as you type
   - `bat` shows context with syntax highlighting
   - Opens in Neovim at exact matching line

3. **Command history** (ctrl + e in Fish):
   - Fish history provides all past commands
   - FZF fuzzy-searches across entire history
   - Select command → Inserted at prompt

4. **Directory navigation** (`zi` in Fish):
   - Zoxide provides frequently-used directories
   - FZF shows interactive picker
   - Select → Auto-cd to directory

**Configuration flow** (from Fish config):

```fish
# FZF uses fd for file search
set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'

# Preview uses bat for syntax highlighting
set -gx fzf_preview_dir_cmd "eza --all --color=always"

# Git diff preview uses Delta
set -gx fzf_diff_highlighter 'delta --no-gitconfig --paging=never'
```

**Real-world example:**

```
You need to find a function definition:

1. Press ctrl + s          → ripgrep_live launches
2. Type "fish_prompt"      → Ripgrep searches all files
3. FZF shows matches        → bat shows preview with context
4. Press enter              → Opens in Neovim at matching line
5. Edit and save            → Back to terminal
6. Press ctrl + e           → Search command history
7. Type "chezmoi apply"     → Find and re-run command
8. Changes applied          → New prompt visible
```

### Delta Integration with Git and Lazygit

**How Delta enhances Git across multiple tools:**

**1. Command-line Git** (automatic via .gitconfig):

```fish
git diff                  # → Piped through Delta
git show HEAD             # → Syntax-highlighted commit diff
git log -p                # → Delta-enhanced commit history
```

**Git configuration** (from .gitconfig):

```gitconfig
[core]
    pager = delta

[interactive]
    diffFilter = delta --color-only

[delta]
    side-by-side = true
    navigate = true
```

**2. Lazygit** (configured via config.yml):

```yaml
git:
  paging:
    pager: delta --dark --paging=never
    colorArg: always
```

**Benefits in Lazygit:**

- Files panel shows syntax-highlighted diffs
- Side-by-side view for easier comparison
- Consistent theme with Catppuccin colors
- Line numbers for precise navigation

**3. FZF previews** (Fish shell integration):

```fish
# Git log FZF picker uses Delta for preview
set -gx fzf_diff_highlighter 'delta --no-gitconfig --paging=never ...'
```

**Real-world example:**

```
Reviewing a feature branch:

1. Open Lazygit (lg)
2. Navigate to Commits panel
3. View Delta-highlighted diffs in main panel
4. Press 'enter' on commit → Full diff with side-by-side view
5. Navigate with 'n' and 'N' (Delta navigation keys)
6. Close Lazygit
7. Run: git log -p          → Same Delta styling in terminal
8. Press ctrl + alt + a     → FZF git log picker (via fzf.fish)
9. Select commit            → Delta preview in FZF window
```

**Consistency across all tools:**

- Same syntax highlighting
- Same side-by-side layout
- Same Catppuccin color scheme
- Same navigation patterns (n/N for next/previous)

### Neovim Integration with System Clipboard

**How clipboard integration works:**

1. **Neovim configuration** (from init.lua):

   ```lua
   vim.opt.clipboard = "unnamedplus"  -- Use system clipboard
   ```

2. **Yank in Neovim** → Copies to macOS clipboard

   ```vim
   yy                    " Copy line to clipboard
   "+y                   " Explicit clipboard register
   ```

3. **Paste from macOS** → Available in Neovim

   ```vim
   p                     " Paste from clipboard
   "+p                   " Explicit clipboard register
   ```

4. **Works across applications:**
   - Copy in Neovim → Paste in browser
   - Copy in browser → Paste in Neovim
   - Copy in Fish → Paste in Neovim

**Fish shell clipboard integration:**

```fish
# Copy command line to clipboard
# (Custom Fish function bound to keybinding)
function vi_copy_to_clipboard
    commandline -b | pbcopy
end
```

**Real-world workflow:**

```
1. In Neovim: yy         → Copy line
2. alt + 2               → Switch to browser space
3. Cmd + v               → Paste into browser
4. Copy text in browser  → Cmd + c
5. alt + 3               → Switch back to Neovim
6. p                     → Paste browser text into code
```

### Fish Functions Calling Other Tools

**Fish functions orchestrate multiple tools seamlessly:**

**Example 1: The 's' function** (SSH with dotfiles sync)

```fish
function s
    # 1. Rsync dotfiles to remote host
    _rsync_dotfiles $argv

    # 2. SSH with custom config
    ssh -F ~/.ssh-dotfiles/config $argv

    # 3. On remote: auto-attach to Zellij session
    # (Handled by SSH config and remote shell init)
end
```

**Tools involved:**

- `rsync` → Syncs dotfiles to remote
- `ssh` → Connects with custom config
- `zellij` → Remote session management

**Example 2: The 'ripgrep_live' function**

```fish
function ripgrep_live
    # 1. FZF opens in fullscreen
    # 2. Ripgrep searches on every keystroke
    # 3. Bat provides syntax-highlighted preview
    # 4. Neovim opens selected file at matching line

    nvim (rg --line-number --with-filename $pattern | \
          fzf --preview 'bat --color=always {1}' | \
          awk -F: '{print "+" $2 " " $1}')
end
```

**Tools involved:**

- `ripgrep` → Searches file contents
- `fzf` → Interactive selection
- `bat` → Preview with syntax highlighting
- `nvim` → Opens file at specific line
- `awk` → Parses ripgrep output

**Example 3: The 'dbuild' function** (Docker build with logging)

```fish
function dbuild
    # 1. Create log file with timestamp
    set logfile "docker-build-$(date +%Y%m%d-%H%M%S).log"

    # 2. Run docker compose in tmux session
    # 3. Capture output to log file
    # 4. Return to terminal immediately (detached)
end
```

**Tools involved:**

- `docker-compose` → Builds containers
- `tmux` → Detached session for background execution
- File redirection → Captures logs
- `dlog` function → Tails log file later

**Example 4: The 'y' function** (Yazi with auto-cd)

```fish
function y
    # 1. Launch Yazi file manager
    # 2. Navigate with hjkl, preview files
    # 3. On exit: auto-cd to selected directory

    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if test -f "$tmp"
        set dir (cat $tmp)
        cd $dir
    end
    rm -f $tmp
end
```

**Tools involved:**

- `yazi` → File manager with preview
- `mktemp` → Temporary file for directory path
- `cd` → Changes directory on exit
- Fish shell → Auto-cd integration

---

## Common Task Workflows

### Starting a New Project

**Step 1: Create project directory**

```fish
# Create and navigate to project
mkdir -p ~/Projects/myproject
cd ~/Projects/myproject

# Or use zoxide after first visit
z myproject              # Jump to project from anywhere
```

**Step 2: Initialize Git repository**

```fish
git init
git branch -M main

# Open Lazygit to create .gitignore
lg
# Press 'a' to add files, 'c' to commit
```

**Step 3: Open project in editor**

```fish
# Open Cursor (or your preferred editor)
cursor .                 # Yabai auto-assigns to space 3 (code)

# Or open Neovim
v .                      # Opens Neovim in project root
```

**Step 4: Set up development tools**

```fish
# Python project
venv --python 3.13       # Create virtual environment with uv

# Node.js project
nvm use 20               # Switch to Node 20 (Fish nvm plugin)
npm init -y              # Initialize package.json

# Docker project
touch docker-compose.yml
v docker-compose.yml     # Edit in Neovim
```

**Step 5: Organize workspace**

```
alt + 1                  # Terminal (running commands)
alt + 3                  # Code editor (Cursor/Neovim)
alt + 4                  # Dev tools (Docker, Postman)
alt + 2                  # Browser (documentation, testing)

# Move windows if needed
shift + alt + 4          # Move current window to dev space
```

**Step 6: Start development server**

```fish
# In terminal (space 1)
npm run dev              # Start dev server

# Or with Docker
dup                      # Start Docker Compose services
dlog                     # Tail logs

# Or in background with Zellij
zel myproject            # Create/attach to Zellij session
# Run dev server in Zellij pane
```

### Code Review Workflow

**Scenario**: Review a pull request from a colleague

**Step 1: Fetch and checkout branch**

```fish
# Navigate to repository
z projectname

# Open Lazygit
lg
```

**In Lazygit:**

```
1. Press 'f'                  → Fetch from remote
2. Navigate to Branches panel → Press '2' to jump
3. Press 'c'                  → Checkout branch (type PR branch name)
4. Navigate to Commits panel  → Press '3' to jump
5. Select commits to review   → View Delta-highlighted diffs
```

**Step 2: Review changes in detail**

**Method A: Lazygit (for quick review)**

```
1. Files panel              → See changed files
2. Main panel               → Delta side-by-side diff
3. Press 'enter' on file    → Full diff view
4. Navigate with 'n'/'N'    → Next/previous hunk
```

**Method B: FZF + Ripgrep (for deep code search)**

```fish
# Back in terminal (close Lazygit)
ripgrep_live               # Search for specific patterns
# Type search query, see results with context
# Open files in Neovim for detailed review
```

**Method C: Neovim split windows**

```fish
v src/main.ts              # Open changed file

# Inside Neovim:
:Gdiffsplit main           # Git diff in split window
# Or
:DiffviewOpen main...feature-branch  # Diffview plugin
```

**Step 3: Add review comments**

```fish
# Take notes in scratch pad
ns                         # Opens scratch.md in nb

# Or create review notes
nq "Code review for PR #123: ..."
```

**Step 4: Test changes locally**

```fish
# Run tests
npm test                   # Or your test command

# Start dev server
npm run dev

# Switch to browser
alt + 2                    # Test in browser

# Check Docker services
ld                         # Lazydocker to monitor containers
```

**Step 5: Approve or request changes**

```fish
# Add review comment to Git
git commit --allow-empty -m "Code review: approved"

# Or use GitHub CLI
gh pr review 123 --approve
gh pr review 123 --comment "Looks good!"
```

### Deployment Workflow

**Scenario**: Deploy code to production

**Step 1: Verify changes**

```fish
# Open Lazygit
lg

# Review commits since last deployment
# Navigate to Commits panel
# Find last deployment tag (e.g., v1.2.3)
# Review all commits since then with Delta diffs
```

**Step 2: Run pre-deployment checks**

```fish
# Run tests
npm test

# Build production bundle
npm run build

# Lint code
npm run lint

# Check Docker build
dbuild                     # Build Docker Compose
dlog                       # Monitor build logs
```

**Step 3: Create release tag**

**In Lazygit:**

```
1. Navigate to Commits panel
2. Select commit to tag
3. Press 'T'               → Create tag
4. Enter version (e.g., v1.3.0)
5. Press 'P' on tag        → Push tag to remote
```

**Step 4: Deploy**

```fish
# Trigger deployment (method depends on your setup)

# Example: Deploy to remote server
s production-server       # SSH with dotfiles sync
ssh production            # Connect to server

# On remote server:
git pull origin main      # Pull latest code
docker-compose up -d      # Restart services
```

**Step 5: Monitor deployment**

```fish
# Tail logs on remote server
dtail                      # Docker journald logs
logtail /var/log/app.log   # Application logs with bat

# Monitor locally
alt + 4                    # Switch to dev space
# Open monitoring tools (DataDog, Grafana, etc.)
```

**Step 6: Verify deployment**

```fish
alt + 2                    # Switch to browser
# Test production URL
# Verify features working

alt + 8                    # Switch to debug space
# Check browser DevTools
# Monitor for errors
```

**Step 7: Notify team**

```fish
alt + 6                    # Switch to comms space (Slack)
# Post deployment notification
# Update deployment tracking
```

### Troubleshooting Issues

**Scenario**: Production issue reported, need to investigate quickly

**Step 1: Gather information**

```fish
# Check error reports in Slack
alt + 6                    # Comms space

# Check monitoring dashboards
alt + 4                    # Dev space (monitoring tools)
```

**Step 2: Access logs**

```fish
# SSH to production server
s production-server

# On remote:
exportlogs appname 20231215 json  # Export today's logs
logtail /var/log/error.log         # Tail error log with bat

# Download logs for local analysis
exit                       # Return to local machine
scp production:/path/to/logs.json ~/Downloads/
```

**Step 3: Search for errors**

```fish
# Local log analysis
cd ~/Downloads
ripgrep_live               # Search log files for error patterns
# Type error message, see context
# Open in Neovim for detailed view
```

**Step 4: Reproduce locally**

```fish
# Start local environment
dup                        # Docker Compose up
dlog                       # Monitor logs

# Open Lazydocker
ld                         # Interactive Docker management
# Check container status, logs, resource usage
```

**Step 5: Search codebase**

```fish
# Navigate to project
z project

# Search for error-related code
ripgrep_live               # Live search with FZF
# Or
frg "error message"        # Fast ripgrep with bat preview
```

**Step 6: Review recent changes**

```fish
# Open Lazygit
lg

# Navigate to Commits panel
# Review recent commits with Delta diffs
# Identify potential cause

# Check specific file history
# Navigate to file in Files panel
# Press 'g' → View file history
```

**Step 7: Create fix**

```fish
# Open Neovim
v src/buggy-file.ts

# Make changes with LSP assistance
# Save and test locally

# Run tests
npm test
```

**Step 8: Deploy fix**

```fish
# Commit fix in Lazygit
lg
# Stage changes, commit with descriptive message
# Push to remote

# Create hotfix branch if needed
# Deploy using standard deployment workflow
```

**Step 9: Verify fix**

```fish
# Monitor production logs
s production-server
logtail /var/log/app.log

# Verify in browser
alt + 2                    # Browser space
# Test affected functionality
```

**Step 10: Document resolution**

```fish
# Create note with resolution
nq "Issue #456: Resolved by fixing ..."
# Includes: error description, root cause, fix applied

# Update team in Slack
alt + 6                    # Comms space
# Post resolution update
```

---

## Advanced Integration Patterns

### Keyboard Navigation Consistency

**The entire system uses Vim-style hjkl navigation:**

1. **Karabiner-Elements** (hardware layer):
   - Terminals: `right option + hjkl` → Arrow keys
   - Other apps: `left control + hjkl` → Arrow keys

2. **Yabai window focus** (via skhd):
   - `ctrl + alt + hjkl` → Focus windows in directions

3. **Neovim** (built-in):
   - `hjkl` → Character navigation
   - `ctrl + w + hjkl` → Window navigation

4. **Lazygit** (built-in):
   - `hjkl` → Navigate panels and items

5. **Yazi** (built-in):
   - `hjkl` → Navigate files and directories

6. **Lazydocker** (built-in):
   - `hjkl` → Navigate containers and panels

**Result**: Muscle memory transfers across all tools without cognitive overhead

### FZF as Universal Selection Interface

**FZF provides consistent selection UI across:**

1. **Fish shell**:
   - `ctrl + e` → Command history
   - `ctrl + f` → File search
   - `ctrl + p` → Process search
   - `alt + a` → Git log search

2. **Zoxide**:
   - `zi` → Interactive directory picker

3. **Zellij**:
   - `zellij_picker` → Session management (bound to `ctrl + z`)

4. **Custom functions**:
   - `frg` → Ripgrep with FZF
   - `ripgrep_live` → Real-time search with FZF
   - `yazi_ripgrep` → File search for Yazi

**Pattern**: Anytime you need to select from a list, FZF provides the interface

### Workspace Persistence

**Yabai maintains workspace state across reboots:**

1. **Spaces persist**: 9 labeled spaces recreated on boot
2. **Window rules auto-apply**: Apps automatically go to designated spaces
3. **Layout configurations**: Stack/BSP layouts restored per space
4. **Multiple displays**: Adapts to connected displays automatically

**Result**: Same workspace layout every morning, zero manual setup

### Tool Chain for Text Processing

**The text processing pipeline integrates seamlessly:**

```
Input → Ripgrep → FZF → Bat → Neovim → Git → Delta → Lazygit
```

**Example flow:**

1. Search with `ripgrep` → Finds matches
2. Select with `fzf` → Interactive picker
3. Preview with `bat` → Syntax highlighting
4. Edit in `nvim` → Make changes
5. Stage in `git` → Track changes
6. View diff with `delta` → Enhanced diffs
7. Manage in `lazygit` → Interactive Git TUI

**Every tool enhances the next**, creating a seamless workflow

---

## Performance Optimizations

### Fast Shell Startup

**Fish shell optimization techniques:**

1. **Lazy-load plugins**: Fisher plugins load on first use
2. **Minimal PATH modifications**: Only essential paths
3. **Deferred initialization**: Non-critical tools initialized after prompt
4. **Disabled heavy tools**: Atuin disabled in favor of FZF history

**Check startup time:**

```fish
profile_fish               # Opens sorted profile in Neovim
# Look for slow operations (> 10ms)
```

### Efficient Window Management

**Yabai optimizations:**

1. **Signal handlers**: Automatic refresh on display changes
2. **Window rules**: Auto-placement eliminates manual organization
3. **Stack layouts**: Reduced visual complexity in focused spaces
4. **BSP balance disabled**: Manual control for performance

### FZF Preview Optimization

**Preview configurations balance speed and utility:**

```fish
# File preview: bat (fast syntax highlighting)
--preview 'bat --color=always {}'

# Directory preview: eza (faster than tree)
--preview 'eza --all --color=always {}'

# Git diff preview: delta with no paging
--preview 'git show {1} | delta --paging=never'
```

---

## Summary: Tool Integration Matrix

| Tool | Integrates With | Integration Method | Benefit |
|------|----------------|-------------------|---------|
| **Karabiner** | skhd, all apps | Hardware keyboard remapping | Vim navigation everywhere |
| **skhd** | Yabai, apps | Hotkey → command mapping | Keyboard-driven window management |
| **Yabai** | skhd, all windows | Window manager API | Automatic tiling and organization |
| **Fish** | All CLI tools | Shell functions, keybindings | Enhanced command execution |
| **FZF** | Fish, ripgrep, fd, bat, zoxide | Stdin/stdout pipes | Universal selection interface |
| **Neovim** | LSP, Copilot, system clipboard | Plugins, config | Intelligent code editing |
| **Lazygit** | Git, Delta, Neovim | Pager, editor integration | Interactive Git management |
| **Delta** | Git, Lazygit, FZF | Pager configuration | Enhanced diff viewing |
| **Bat** | FZF, Fish functions, cat | Pager, preview command | Syntax-highlighted file viewing |
| **Ripgrep** | FZF, Fish functions | Search command | Fast code search |
| **Zoxide** | Fish, FZF | Directory tracking | Smart navigation |
| **Yazi** | Fish, Lazygit, ripgrep | Shell integration, plugins | Visual file management |
| **Ghostty** | Fish, tmux, Neovim | Terminal emulator | Fast, native terminal |

**Key insight**: Every tool is designed to enhance another, creating a cohesive ecosystem where the whole is greater than the sum of its parts.

---

## Related Documentation

- [ARCHITECTURE.md](/docs/ARCHITECTURE.md) - System architecture diagrams
- [KEYMAPS.md](/docs/KEYMAPS.md) - Complete keyboard shortcut reference
- [Configuration Changes Workflow](/docs/workflows/configuration-changes.md) - Chezmoi editing workflow
- [New Machine Setup](/docs/workflows/new-machine-setup.md) - Initial setup process
- [Fish Shell README](/dot_config/fish/README.md) - Fish configuration and functions
- [Neovim README](../../dot_config/exact_nvim/README.md) - Neovim plugins and setup
- [Yabai README](/dot_config/yabai/README.md) - Window manager configuration
- [skhd README](/dot_config/skhd/README.md) - Hotkey daemon reference
- [Lazygit README](/dot_config/lazygit/README.md) - Git TUI workflows

---

**This workflow guide demonstrates the daily integration of 20+ tools into a seamless, keyboard-driven development environment. The key principle: each layer enhances the next, creating efficiency through consistent patterns and thoughtful integration.**
