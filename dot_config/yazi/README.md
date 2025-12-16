# Yazi File Manager Configuration

## Overview

[Yazi](https://yazi-rs.github.io/) is a blazing fast terminal file manager written in Rust, featuring async I/O, rich previews, and extensive plugin support. This configuration includes custom keybindings, themes, plugins, and shell integration for a vim-like file navigation experience.

## Table of Contents

- [Overview](#overview)
- [Configuration Files](#configuration-files)
- [Key Features](#key-features)
  - [Shell Integration](#shell-integration)
  - [Rich Previews](#rich-previews)
  - [Plugin Ecosystem](#plugin-ecosystem)
- [Essential Keybindings](#essential-keybindings)
  - [Navigation & Movement](#navigation--movement)
  - [Quick Jump Shortcuts](#quick-jump-shortcuts)
  - [File Operations](#file-operations)
  - [Search & Filter](#search--filter)
  - [Linemode Display](#linemode-display)
  - [Sorting](#sorting)
  - [Preference Management](#preference-management)
  - [Copy to Clipboard](#copy-to-clipboard)
  - [Projects & Sessions](#projects--sessions)
  - [Bookmarks](#bookmarks)
  - [Shell Commands](#shell-commands)
  - [macOS-Specific](#macos-specific)
  - [Git Integration](#git-integration)
  - [Preview & Tasks](#preview--tasks)
  - [Help & Exit](#help--exit)
- [Manager Configuration](#manager-configuration)
  - [Display Settings](#display-settings)
  - [File Openers](#file-openers)
  - [Preview Configuration](#preview-configuration)
- [Plugin Management](#plugin-management)
  - [Installing Plugins](#installing-plugins)
  - [Updating Plugins](#updating-plugins)
  - [Enabling Plugins](#enabling-plugins)
  - [Currently Installed Plugins](#currently-installed-plugins)
- [Theme Configuration](#theme-configuration)
  - [Available Flavors](#available-flavors)
  - [Switching Themes](#switching-themes)
- [Customization Guide](#customization-guide)
  - [Common Modifications](#common-modifications)
  - [Configuration Options](#configuration-options)
  - [Disabling Plugins](#disabling-plugins)
- [Integration Points](#integration-points)
  - [Fish Shell](#fish-shell)
  - [Zoxide](#zoxide)
  - [FZF](#fzf)
  - [Starship Prompt](#starship-prompt)
  - [Git (Lazygit)](#git-lazygit)
  - [Rich-CLI](#rich-cli)
- [Troubleshooting](#troubleshooting)
  - [Plugin Installation Fails](#plugin-installation-fails)
  - [Directory Not Changing After Exit](#directory-not-changing-after-exit)
  - [Preview Not Working for File Type](#preview-not-working-for-file-type)
  - [Keybinding Not Working](#keybinding-not-working)
  - [Theme Not Applying](#theme-not-applying)
  - [Searchjump Plugin Not Found](#searchjump-plugin-not-found)
- [External Resources](#external-resources)

## Configuration Files

| File | Purpose |
|------|---------|
| `keymap.toml` | Custom keybindings and plugin shortcuts |
| `yazi.toml` | Manager settings, file openers, previewers, and plugin configuration |
| `theme.toml` | Theme/flavor selection (currently Nord) |
| `yazi-starship.toml` | Starship prompt configuration for Yazi status line |
| `flavors/` | Collection of color themes (Catppuccin, Nord, Tokyo Night, etc.) |
| `plugins/` | Symlinked to `~/.local/share/chezmoi/cm-util/ctrld-configs/yazi/plugins/` |

## Key Features

### Shell Integration

The Fish function `y` wraps Yazi to automatically change the shell's working directory when exiting:

```fish
function y --wraps='yazi' --description 'yazi with cwd'
    # Creates temporary file to track directory changes
    # Sets YAZI_ID for multi-instance support
    # Changes shell directory on exit
```

**Usage**: Type `y` instead of `yazi` to launch with directory tracking.

### Rich Previews

Configured previewers for enhanced file viewing:

- **Markdown/CSV/JSON**: Rich-cli (Textual) formatting with syntax highlighting
- **Images**: Automatic image preview with multiple format support (AVIF, HEIC, JXL, SVG)
- **Video**: Video thumbnail generation
- **Archives**: Content listing for zip, tar, 7z, etc.
- **PDF**: PDF preview rendering
- **Jupyter Notebooks**: `.ipynb` file preview

### Plugin Ecosystem

27+ installed plugins including:

- **searchjump**: Fast fuzzy file search
- **ripgrep-live**: Interactive text search across files
- **projects**: Save and restore directory sessions
- **bookmarks**: Vim-like bookmarks for quick navigation
- **smart-filter**: Advanced file filtering
- **lazygit**: Git integration
- **popup-shell**: Fish shell in floating window
- **relative-motions**: Vim-style relative line numbers
- **pref-by-location**: Save preferences per directory

## Essential Keybindings

### Navigation & Movement

| Key | Action | Description |
|-----|--------|-------------|
| `j` / `k` | Move down/up | Single line movement |
| `h` / `l` | Leave/Enter | Parent directory / Child directory |
| `H` / `L` | Back/Forward | Directory history navigation |
| `gg` / `G` | Jump to top/bottom | First/last item |
| `Ctrl-u` / `Ctrl-d` | Page up/down | Full page scroll |
| `Ctrl-k` / `Ctrl-j` | Half page up/down | 10% scroll |
| `1`-`9` | Relative motion | Jump N lines with vim motions |
| `[` / `]` | Previous/Next tab | Switch between tabs |
| `{` / `}` | Swap tabs | Reorder tabs |

### Quick Jump Shortcuts

| Key | Action | Description |
|-----|--------|-------------|
| `gh` | Go home | Jump to `~` |
| `gc` | Go config | Jump to `~/.config` |
| `gd` | Go downloads | Jump to `~/Downloads` |
| `gm` | Go chezmoi | Jump to `~/.local/share/chezmoi/` |
| `g<Space>` | Go interactive | Select directory with picker |
| `z` | Zoxide jump | Jump using zoxide |
| `Z` | FZF jump | Jump or reveal file with fzf |

### File Operations

| Key | Action | Description |
|-----|--------|-------------|
| `<Space>` | Toggle selection | Select/deselect current file |
| `v` / `V` | Visual mode | Enter selection mode |
| `Ctrl-a` | Select all | Select all files |
| `y` / `x` | Yank/Cut | Copy/cut selected files |
| `p` / `P` | Paste | Paste / paste with overwrite |
| `d` / `D` | Remove | Trash / permanently delete |
| `a` | Create | Create file (end with `/` for directory) |
| `r` | Rename | Rename with cursor before extension |
| `oo` / `O` | Open | Open selected files / interactive open |
| `-` / `_` | Symlink | Create absolute/relative symlink |
| `Ctrl--` | Hardlink | Create hardlink |

### Search & Filter

| Key | Action | Description |
|-----|--------|-------------|
| `s` | Searchjump | Fast fuzzy file search (plugin) |
| `Ctrl-s` | Ripgrep Live | Interactive text search in files |
| `f` / `F` | Filter | Smart filter / plugin smart-filter |
| `/` | Find | Find files by name |
| `n` / `N` | Find next/previous | Navigate search results |
| `S` | Search content | Search using ripgrep |
| `.` | Toggle hidden | Show/hide hidden files |

### Linemode Display

Change what information is displayed in file listings:

| Key | Mode | Shows |
|-----|------|-------|
| `ms` | Size | File sizes |
| `mp` | Permissions | File permissions |
| `mm` | Mtime | Modified time |
| `mb` | Btime | Birth/creation time |
| `mo` | Owner | File owner |
| `mn` | None | Minimal display |

### Sorting

All sort commands support reverse with uppercase:

| Key | Sort By | Reverse |
|-----|---------|---------|
| `,a` / `,A` | Alphabetical | `,A` |
| `,n` / `,N` | Natural | `,N` |
| `,m` / `,M` | Modified time | `,M` |
| `,b` / `,B` | Birth time | `,B` |
| `,s` / `,S` | Size | `,S` |
| `,e` / `,E` | Extension | `,E` |
| `,r` | Random | N/A |

Sorting preferences are saved per-directory with `pref-by-location` plugin.

### Preference Management

| Key | Action | Description |
|-----|--------|-------------|
| `,t` | Toggle auto-save | Enable/disable preference saving |
| `,d` | Disable auto-save | Turn off preference saving |
| `,R` | Reset preferences | Clear saved preferences for current directory |

### Copy to Clipboard

| Key | Copies | Description |
|-----|--------|-------------|
| `cc` | Full path | `/full/path/to/file.txt` |
| `cd` | Directory path | `/full/path/to/` |
| `cf` | Filename | `file.txt` |
| `cn` | Name without ext | `file` |

### Projects & Sessions

| Key | Action | Description |
|-----|--------|-------------|
| `q` | Save & quit | Save current project and exit |
| `Ps` | Save project | Save current session |
| `Pl` | Load project | Pick and load a project |
| `PP` | Load last | Load most recent project |
| `Pd` | Delete project | Remove saved project |
| `PD` | Delete all | Clear all projects |
| `Pm` / `PM` | Merge | Merge current tab/project to another |

### Bookmarks

| Key | Action | Description |
|-----|--------|-------------|
| `m` | Save bookmark | Mark current location |
| `'` | Jump to bookmark | Select and jump to bookmark |
| `bd` | Delete bookmark | Remove a bookmark |
| `bD` | Delete all bookmarks | Clear all bookmarks |

### Shell Commands

| Key | Action | Description |
|-----|--------|-------------|
| `;` | Shell interactive | Run shell command in background |
| `:` | Shell block | Run shell command (blocks until done) |
| `':` | Custom shell block | Plugin custom-shell (interactive, blocking) |
| `';` | Custom shell async | Plugin custom-shell (interactive, async) |
| `Ctrl-/` | Popup shell | Open Fish shell in popup window |

### macOS-Specific

| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl-p` | Quick Look | Open macOS Quick Look preview |
| `of` | Open in Finder | Open current directory in Finder |

### Git Integration

| Key | Action | Description |
|-----|--------|-------------|
| `gl` | Lazygit | Launch lazygit in current directory |

### Preview & Tasks

| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl-b` / `Ctrl-f` | Seek preview | Scroll preview up/down |
| `<Tab>` | Spot file | Focus on file spot view |
| `w` | Tasks manager | Show background tasks |

### Help & Exit

| Key | Action | Description |
|-----|--------|-------------|
| `?` / `~` / `F1` | Help | Open help menu |
| `q` | Quit | Save project and exit |
| `Q` | Quit no-cwd | Exit without saving cwd |
| `Ctrl-c` | Close tab | Close current tab |
| `Ctrl-z` | Suspend | Suspend Yazi process |

## Manager Configuration

### Display Settings

- **Ratio**: `[1, 4, 3]` - Column width distribution (parent, current, preview)
- **Linemode**: `size_and_mtime` - Default display mode
- **Scrolloff**: `5` - Keep 5 lines visible above/below cursor
- **Sort**: Natural, case-insensitive, directories first

### File Openers

Configured actions by file type:

- **Text files**: Open in `$EDITOR` (default: vi)
- **Images**: System default (macOS `open`)
- **Videos**: MPV player with media info fallback
- **Archives**: Extract with `ya pub extract`
- **JSON/JavaScript**: Edit in `$EDITOR`

### Preview Configuration

- **Max dimensions**: 600x900 pixels
- **Image delay**: 30ms
- **Image quality**: 75%
- **Tab size**: 2 spaces
- **Wrap**: Disabled

## Plugin Management

### Installing Plugins

Most plugins can be installed via Yazi package manager:

```bash
ya pack -a <author/plugin-name>
```

**Note**: Due to symlinked plugin directory, some plugins may need manual cloning:

```bash
# Clone to the correct location
git clone https://github.com/author/plugin.yazi \
  ~/.local/share/chezmoi/cm-util/ctrld-configs/yazi/plugins/plugin.yazi
```

### Updating Plugins

```bash
ya pkg upgrade
```

### Enabling Plugins

After installation, add plugin configuration to `yazi.toml`:

```toml
[plugin]
prepend_previewers = [
    { name = "*.md", run = "plugin-name" },
]
```

Refer to individual plugin READMEs for specific configuration requirements.

### Currently Installed Plugins

<details>
<summary>View full plugin list (27 plugins)</summary>

- bookmarks.yazi
- chmod.yazi
- copy-file-contents.yazi
- custom-shell.yazi
- diff.yazi
- file-extra-metadata.yazi
- folder-rules.yazi
- full-border.yazi
- glow.yazi
- lazygit.yazi
- miller.yazi
- popup-shell.yazi
- pref-by-location.yazi
- projects.yazi
- relative-motions.yazi
- restore.yazi
- rich-preview.yazi
- ripgrep-live.yazi
- searchjump.yazi
- smart-filter.yazi
- starship.yazi
- what-size.yazi
- yatline-gruvbox-material.yazi
- yatline-tokyo-night.yazi
- yatline.yazi
- yaziline.yazi
- zless-preview.yazi

</details>

## Theme Configuration

### Available Flavors

Located in `flavors/` directory:

- **Nord** (current) - Arctic, north-bluish color palette
- Catppuccin (Frappe, Latte, Macchiato, Mocha)
- Tokyo Night
- Kanagawa
- Rose Pine
- Gruvbox Dark
- Flexoki
- OneDark
- VSCode Dark (Modern, Plus)
- Crystal

### Switching Themes

Edit `theme.toml`:

```toml
[flavor]
dark = "nord"  # Change to your preferred theme
```

Then apply changes:

```bash
chezmoi edit ~/.config/yazi/theme.toml
chezmoi apply
```

## Customization Guide

### Common Modifications

**Change Default Sort Method**

1. Edit `yazi.toml`
2. Modify `[manager]` section:

   ```toml
   sort_by = "modified"  # Options: natural, alphabetical, modified, created, size, extension, random
   sort_reverse = true   # Reverse sort order
   ```

3. Apply with `chezmoi apply`

**Add Custom Keybinding**

1. Edit `keymap.toml`
2. Add to `[[mgr.prepend_keymap]]` section:

   ```toml
   [[mgr.prepend_keymap]]
   on = ["g", "p"]
   run = "cd ~/Projects"
   desc = "Go to Projects directory"
   ```

3. Apply with `chezmoi apply`

**Change Preview Size**

1. Edit `yazi.toml`
2. Modify `[preview]` section:

   ```toml
   max_width = 800
   max_height = 1200
   ```

3. Apply with `chezmoi apply`

**Customize File Opener**

1. Edit `yazi.toml`
2. Add or modify `[opener]` section:

   ```toml
   [opener]
   myeditor = [
       { run = 'code "$@"', desc = "VS Code", block = false }
   ]
   ```

3. Add to `[open]` rules:

   ```toml
   { mime = "text/*", use = ["myeditor", "edit"] }
   ```

### Configuration Options

Key settings you can modify:

- **show_hidden**: Toggle hidden files visibility (Current: `false`)
- **show_symlink**: Show symlink indicators (Current: `true`)
- **linemode**: Default information display (Current: `size_and_mtime`)
- **scrolloff**: Lines to keep visible around cursor (Current: `5`)
- **ratio**: Column width distribution (Current: `[1, 4, 3]`)
- **cursor_blink**: Blink cursor in input mode (Current: `true`)

### Disabling Plugins

Comment out plugin keybindings in `keymap.toml`:

```toml
# [[mgr.prepend_keymap]]
# on = "s"
# run = "plugin searchjump"
# desc = "searchjump mode"
```

Or remove from `yazi.toml` plugin configuration.

## Integration Points

### Fish Shell

The `y` wrapper function provides:

- Automatic directory tracking with temporary file
- Client ID management for multi-instance support
- Working directory persistence on exit

Located: `~/.config/fish/functions/y.fish`

### Zoxide

Quick directory jumping with `z` keybinding:

- Integrates with zoxide frecency database
- Access recent/frequent directories instantly

### FZF

Fuzzy file and directory finding with `Z` keybinding:

- Jump to directories
- Reveal specific files
- Interactive fuzzy matching

### Starship Prompt

Custom Yazi status line configured via `yazi-starship.toml`:

- Git branch and status display
- Current directory with special repository handling
- Python/Node.js/Terraform version indicators
- Catppuccin color palette

### Git (Lazygit)

Press `gl` to launch lazygit in current directory:

- Full git workflow within file manager
- Stage, commit, push, pull operations
- Branch management and history viewing

### Rich-CLI

Enhanced previews for structured files:

- Markdown rendering with formatting
- CSV table display
- JSON syntax highlighting
- Jupyter notebook cell preview

## Troubleshooting

### Plugin Installation Fails

**Symptoms**: `ya pack -a` fails to copy files to correct location

**Solution**:

1. Clone plugin manually:

   ```bash
   git clone https://github.com/author/plugin.yazi \
     ~/.local/share/chezmoi/cm-util/ctrld-configs/yazi/plugins/plugin.yazi
   ```

2. Add configuration to `yazi.toml`
3. Add keybindings to `keymap.toml` if needed

### Directory Not Changing After Exit

**Symptoms**: Shell stays in same directory after exiting Yazi

**Solution**:

1. Ensure you're using the `y` wrapper function, not `yazi` directly
2. Verify Fish function exists: `functions y`
3. Reload Fish configuration: `source ~/.config/fish/config.fish`

### Preview Not Working for File Type

**Symptoms**: File preview shows as plain text or doesn't render

**Solution**:

1. Check if required dependency is installed:
   - Markdown/CSV/JSON: `python -m pip install rich`
   - Images: ImageMagick
   - PDF: Poppler
2. Verify plugin is configured in `yazi.toml` `prepend_previewers`
3. Check file MIME type: `file --mime-type filename`

### Keybinding Not Working

**Symptoms**: Custom keybinding doesn't trigger action

**Solution**:

1. Check for conflicts with existing bindings
2. Verify TOML syntax in `keymap.toml`
3. Ensure plugin is installed if using `plugin` command
4. Test with `:` shell command to verify action works
5. Check Yazi help (`?`) to see current keybinding state

### Theme Not Applying

**Symptoms**: Theme doesn't change after editing `theme.toml`

**Solution**:

1. Verify flavor name matches directory in `flavors/`
2. Apply changes: `chezmoi apply`
3. Restart Yazi
4. Check theme file exists: `ls ~/.config/yazi/flavors/`

### Searchjump Plugin Not Found

**Symptoms**: Error when pressing `s` key

**Solution**:

1. Clone searchjump manually (doesn't work with `ya pack`):

   ```bash
   git clone https://github.com/DreamMaoMao/searchjump.yazi.git \
     ~/.local/share/chezmoi/cm-util/ctrld-configs/yazi/plugins/searchjump.yazi
   ```

2. Restart Yazi

## External Resources

- [Official Documentation](https://yazi-rs.github.io/)
- [Configuration Reference](https://yazi-rs.github.io/docs/configuration/overview)
- [Plugin Directory](https://yazi-rs.github.io/docs/resources/)
- [Awesome Yazi](https://github.com/AstroNvim/awesome-yazi) - Community plugins and resources
- [GitHub Repository](https://github.com/sxyazi/yazi)
- [Discord Community](https://discord.gg/yazi)
