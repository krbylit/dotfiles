# Lazygit Configuration

## Overview

Lazygit is a terminal UI for Git commands, providing an intuitive, keyboard-driven interface for common Git workflows. This configuration integrates Lazygit with Neovim (via `nvr`), Delta (for diffs), and the Fish shell, while using the Catppuccin Macchiato theme with custom color accents.

## Configuration Files

| File | Purpose |
|------|---------|
| `symlink_config.yml.tmpl` | Symlinks to the main config in `cm-util/ctrld-configs/lazygit/config.yml` |
| `cm-util/ctrld-configs/lazygit/config.yml` | Main configuration file for UI, git behavior, and keybindings |
| `themes/catppuccin/` | Collection of Catppuccin theme variants (frappe, latte, macchiato, mocha) |

## Key Features

### Custom Neovim Integration

Lazygit is configured to open files directly in the current Neovim instance using `nvr` (Neovim Remote):

- **File editing**: Opens files in Neovim and automatically closes the Lazygit window
- **Line-specific editing**: Jumps to specific line numbers when viewing file history
- **Seamless workflow**: No separate editor windows, maintains focus in Neovim

**Configuration**:

```yaml
os:
  edit: 'nvr -s {{filename}} && nvr -s --remote-send "<C-w><C-p>q<Esc><C-w>o"'
  editAtLine: 'nvr -s +{{line}} {{filename}} && nvr -s --remote-send "<C-w><C-p>q<Esc><C-w>o"'
  editPreset: "nvim"
```

### Delta Integration

Uses Delta as the pager for enhanced diff viewing with syntax highlighting and side-by-side diffs:

```yaml
git:
  paging:
    pager: delta --dark --paging=never
    colorArg: always
```

This integrates with the global `.gitconfig` Delta configuration for consistent diff viewing across all Git tools.

### Catppuccin Theme

Currently using **Catppuccin Macchiato Rosewater** theme with custom color scheme:

- **Active border**: Rosewater (`#f4dbd6`) with bold styling
- **Selected line**: Dark surface background (`#363a4f`)
- **Unstaged changes**: Red (`#ed8796`)
- **Options text**: Blue (`#8aadf4`)
- **Author colors**: Lavender (`#b7bdf8`)

Alternative theme (Catppuccin Macchiato Mauve) is commented out in the config for easy switching.

### Enhanced UI Features

- **Nerd Fonts v3**: File and status icons using modern icon set
- **Commit length indicator**: Visual feedback for commit message length
- **Tree view**: File changes displayed as a tree structure (toggle with `~`)
- **Divergence indicators**: Shows branch divergence with arrows and numbers
- **Custom spinner**: Dot-based loading animation
- **Auto-refresh**: Automatically fetches from remote every 60 seconds and refreshes files every 10 seconds

## Key Keybindings

### Navigation (Universal)

| Key | Action |
|-----|--------|
| `j` / `k` | Move down/up |
| `h` / `l` | Move to previous/next panel |
| `<C-u>` / `<C-d>` | Page up/down (replaces `,` / `.`) |
| `H` / `L` | Scroll left/right in main view |
| `<` / `>` | Jump to top/bottom |
| `1` - `5` | Jump to specific panel |
| `<Tab>` | Toggle between panels |
| `<Esc>` | Return/cancel |
| `q` | Quit |
| `Q` | Quit without changing directory |

### Search and Selection

| Key | Action |
|-----|--------|
| `/` | Start search |
| `n` / `N` | Next/previous match |
| `v` | Toggle range select |
| `<S-Down>` / `<S-Up>` | Extend range selection |
| `<Space>` | Select/toggle item |

### Files Panel

| Key | Action |
|-----|--------|
| `c` | Commit changes |
| `C` | Commit with editor |
| `w` | Commit without pre-commit hooks |
| `A` | Amend last commit |
| `a` | Stage/unstage all |
| `s` | Stash all changes |
| `S` | View stash options |
| `D` | View reset options |
| `x` | Confirm discard |
| `i` | Ignore file |
| `f` | Fetch |
| `r` | Refresh files |
| `o` | Edit file (opens in Neovim) |
| `e` | Open with system default app |
| `` ` `` | Toggle tree view |
| `M` | Open merge tool |
| `y` | Copy file info to clipboard |

### Branches Panel

| Key | Action |
|-----|--------|
| `c` | Checkout branch by name |
| `F` | Force checkout branch |
| `r` | Rebase branch |
| `R` | Rename branch |
| `M` | Merge into current branch |
| `f` | Fast-forward branch |
| `u` | Set upstream |
| `T` | Create tag |
| `P` | Push tag |
| `o` | Create pull request |
| `O` | View pull request options |
| `s` | Change sort order |

### Commits Panel

| Key | Action |
|-----|--------|
| `s` | Squash down |
| `S` | Squash above commits |
| `r` | Rename commit |
| `R` | Rename with editor |
| `f` | Mark commit as fixup |
| `F` | Create fixup commit |
| `A` | Amend to commit |
| `a` | Reset commit author |
| `p` | Pick commit (during rebase) |
| `t` | Revert commit |
| `C` | Cherry-pick copy |
| `V` | Paste commits |
| `B` | Mark as base for rebase |
| `T` | Tag commit |
| `i` | Start interactive rebase |
| `b` | View bisect options |
| `g` | View reset options |
| `o` | Open commit in browser |
| `y` | Copy commit attribute |
| `<C-j>` / `<C-k>` | Move commit down/up |
| `<C-l>` | Open log menu |

### Main Panel (Staging/Diff View)

| Key | Action |
|-----|--------|
| `a` | Toggle select hunk |
| `b` | Pick both hunks (merge conflicts) |
| `E` | Edit selected hunk |
| `<Enter>` | Stage/unstage selected line/hunk |
| `<C-b>` / `<C-f>` | Page up/down |
| `<C-w>` | Toggle whitespace in diff |
| `{` / `}` | Decrease/increase diff context |
| `(` / `)` | Decrease/increase rename similarity threshold |

### Special Commands

| Key | Action |
|-----|--------|
| `:` | Execute shell command |
| `?` | Open keybindings menu |
| `@` | Open extras menu |
| `m` | Create rebase options menu |
| `R` | Refresh (force update) |
| `P` | Push files |
| `p` | Pull files |
| `W` or `<C-e>` | Open diffing menu |
| `<C-s>` | Open filtering menu |
| `<C-p>` | Create patch options menu |
| `<C-r>` | Open recent repos |
| `<C-t>` | Open external diff tool |
| `<C-o>` | Copy to clipboard |
| `z` / `<C-z>` | Undo/redo |
| `[` / `]` | Previous/next tab |
| `+` / `_` | Increase/decrease window size |

## Common Workflows

### Basic Commit Workflow

1. Review changes in files panel (`j`/`k` to navigate)
2. Stage changes (`<Space>` on individual files or `a` for all)
3. View staged diff in main panel
4. Commit with `c`, write message, save and close editor
5. Push with `P`

### Interactive Staging

1. Select a file with changes
2. Navigate hunks in main panel (`j`/`k`)
3. Stage individual hunks with `<Enter>`
4. Toggle line selection with `a` for partial hunk staging
5. Commit staged changes with `c`

### Interactive Rebase

1. Navigate to commits panel
2. Select the base commit with `B`
3. Press `i` to start interactive rebase
4. Use `s` to squash, `f` to fixup, `r` to reword
5. Use `<C-j>`/`<C-k>` to reorder commits
6. Confirm the rebase

### Stashing Workflow

1. Press `s` in files panel to stash all changes
2. Navigate to stash panel (use `3` to jump)
3. Press `g` to pop stash
4. Press `r` to rename stash for better organization

### Branch Management

1. Switch to branches panel (use `2` to jump)
2. Press `c` to checkout by name (with fuzzy search)
3. Press `M` to merge a branch into current
4. Press `r` to rebase current branch onto selected
5. Press `R` to rename current branch
6. Press `u` to set/update upstream

### Cherry-Picking

1. Navigate to commits panel
2. Press `C` on commit(s) to copy
3. Switch to target branch
4. Press `V` to paste/cherry-pick commits

### Fixing Up Commits

1. Make changes and stage them
2. Press `<C-a>` in files panel to find base commit for fixup
3. Or manually select commit in commits panel and press `F`
4. Lazygit creates a fixup commit automatically

## Fish Shell Integration

### `lg` Function

Simple wrapper to launch Lazygit in current directory:

```fish
function lg --wraps=lazygit --description 'alias lg lazygit'
  lazygit $argv
end
```

**Usage**: `lg` from any Git repository

### `cmg` Function

Specialized function for managing the dotfiles repository with chezmoi:

```fish
function cmg --wraps='lazygit -p (chezmoi source-path)' --description 'alias cmg lazygit -p (chezmoi source-path)'
  lazygit -p (chezmoi source-path) $argv
end
```

**Usage**: `cmg` from anywhere to manage chezmoi dotfiles repository

## Customization Guide

### Changing the Theme

**Switch to Catppuccin Macchiato Mauve**:

1. Edit `cm-util/ctrld-configs/lazygit/config.yml`
2. Comment out the current theme section (lines 51-72)
3. Uncomment the Mauve theme section (lines 73-95)
4. Apply with `chezmoi apply`

**Use a different Catppuccin variant**:

1. Browse themes in `dot_config/lazygit/themes/catppuccin/`
2. Pick a flavor (frappe, latte, macchiato, mocha) and accent color
3. Update the theme section in config to reference the chosen colors
4. Apply with `chezmoi apply`

### Modifying Keybindings

**Example: Change commit key from `c` to `C`**:

1. Edit `cm-util/ctrld-configs/lazygit/config.yml`
2. Find `keybinding.files.commitChanges`
3. Change value from `c` to `C`
4. Apply with `chezmoi apply`

**Disable a keybinding**:

Set the value to `<disabled>`:

```yaml
keybinding:
  universal:
    optionMenu: <disabled>
```

### Adjusting UI Layout

**Key settings to modify**:

- **Side panel width**: Adjust `gui.sidePanelWidth` (default: `0.3333`, range: `0.0` to `1.0`)
- **Commit hash length**: Change `gui.commitHashLength` (default: `8`)
- **Author name length**: Modify `gui.commitAuthorShortLength` (default: `2` for initials)
- **Time format**: Update `gui.timeFormat` (default: `02 Jan 06`)
- **Window border style**: Change `gui.border` (`rounded` | `single` | `double` | `hidden`)
- **Split diff mode**: Adjust `gui.splitDiff` (`auto` | `always`)

### Configuring Auto-Refresh

**Disable auto-fetch**:

```yaml
git:
  autoFetch: false
```

**Adjust refresh intervals**:

```yaml
refresher:
  refreshInterval: 30  # File refresh in seconds (default: 10)
  fetchInterval: 300   # Remote fetch in seconds (default: 60)
```

### Customizing Commit Behavior

**Auto-wrap commit messages**:

```yaml
git:
  commit:
    autoWrapCommitMessage: true
    autoWrapWidth: 72  # or 50 for subject line limit
```

**Skip hooks with prefix**:

Configure commits starting with a specific prefix to skip pre-commit hooks:

```yaml
git:
  skipHookPrefix: WIP  # "WIP: message" skips hooks
```

**Sign commits by default**:

```yaml
git:
  commit:
    signOff: true  # Adds Signed-off-by line
```

### Changing the Pager

**Use a different pager**:

```yaml
git:
  paging:
    pager: "diff-so-fancy"  # or "bat", or any other
```

**Use Git's configured pager**:

```yaml
git:
  paging:
    useConfig: true  # Use $GIT_PAGER or git config pager
```

## Integration Points

### Neovim Integration

Lazygit integrates tightly with Neovim through `nvr` (Neovim Remote):

- **Editing files**: Opens files in the active Neovim instance rather than launching a new editor
- **Terminal integration**: Can be launched from within Neovim terminal with seamless window management
- **Snacks.nvim integration**: Can be launched via the Snacks.nvim plugin for improved UX
- **Auto-close behavior**: Automatically closes Lazygit window when opening a file, returning focus to Neovim

The configuration assumes `NVIM` environment variable is set (automatically done by Neovim terminals), and Fish shell has configured `$EDITOR` to use `nvr`.

### Delta Integration

Lazygit uses Delta for enhanced diff viewing:

- **Syntax highlighting**: Delta provides language-aware syntax highlighting in diffs
- **Side-by-side view**: Configured for side-by-side diff display
- **Consistent styling**: Shares theme configuration with Git's global Delta config
- **Line-number display**: Uses unobtrusive line numbers for reference

Delta configuration in `.gitconfig` is automatically picked up by Lazygit's pager settings.

### Git Configuration

Lazygit respects and enhances global Git configuration:

- **Merge strategy**: Uses `zdiff3` conflict style from `.gitconfig`
- **Diff algorithm**: Applies histogram diff algorithm
- **Color settings**: Respects moved line coloring configuration
- **Main branches**: Recognizes `main` and `master` as primary branches
- **GPG signing**: Respects Git's GPG configuration for signed commits

### Yazi Integration

Yazi file manager includes a Lazygit plugin:

- **Quick launch**: Open Lazygit from within Yazi on the current directory
- **Repository detection**: Plugin detects Git repositories automatically
- **Seamless workflow**: Switch between file management and Git operations

Plugin located at `cm-util/ctrld-configs/yazi/plugins/lazygit.yazi/`

## Troubleshooting

### Lazygit Won't Open Files in Neovim

**Symptoms**: Pressing `o` on a file opens a new Neovim instance or shows an error

**Solution**:

1. Ensure `nvr` is installed: `brew install neovim-remote`
2. Verify `NVIM` environment variable is set (check with `env | grep NVIM`)
3. Launch Lazygit from within a Neovim terminal, not a standalone terminal
4. Check Fish shell has `nvr` in the `$PATH`

### Delta Not Showing in Diffs

**Symptoms**: Diffs appear without syntax highlighting or side-by-side view

**Solution**:

1. Verify Delta is installed: `which delta`
2. Check `git.paging.pager` setting in Lazygit config
3. Ensure Delta is configured in `.gitconfig` with `core.pager = delta`
4. Try setting `git.paging.colorArg: always` in Lazygit config

### Theme Colors Not Appearing

**Symptoms**: Lazygit displays with default colors instead of Catppuccin

**Solution**:

1. Verify terminal supports true color: `echo $COLORTERM` should show `truecolor`
2. Check theme section is properly formatted YAML (indentation matters)
3. Ensure no syntax errors in config: `lazygit --use-config-file ~/.config/lazygit/config.yml`
4. Try applying changes with `chezmoi apply -v` for verbose output

### Auto-Fetch Causing Slowdowns

**Symptoms**: Lazygit freezes or slows down periodically

**Solution**:

1. Increase `refresher.fetchInterval` to a longer duration (e.g., 300 seconds)
2. Disable auto-fetch with `git.autoFetch: false`
3. Manually fetch with `f` when needed
4. Check network connectivity to remote repositories

### Keybindings Not Working

**Symptoms**: Pressing a key doesn't perform expected action

**Solution**:

1. Press `?` to view all active keybindings
2. Check for conflicting keybindings in the config
3. Verify YAML syntax in `keybinding` section (proper indentation)
4. Reset to defaults by commenting out custom keybindings
5. Check if key is mapped in terminal/multiplexer (tmux, terminal emulator)

### Commit Message Editor Won't Open

**Symptoms**: Pressing `c` or `C` doesn't open editor

**Solution**:

1. Check `$EDITOR` environment variable: `echo $EDITOR`
2. Verify editor path is correct and executable exists
3. For Neovim integration, ensure `nvr` is properly configured
4. Try setting `os.editPreset: "vim"` temporarily to test
5. Check for errors with `lazygit --debug`

## External Resources

- [Official Documentation](https://github.com/jesseduffield/lazygit)
- [Configuration Reference](https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md)
- [Keybindings Documentation](https://github.com/jesseduffield/lazygit/blob/master/docs/keybindings/Keybindings_en.md)
- [Custom Pagers Guide](https://github.com/jesseduffield/lazygit/blob/master/docs/Custom_Pagers.md)
- [Catppuccin Theme Repository](https://github.com/catppuccin/lazygit)
- [Delta Documentation](https://dandavison.github.io/delta/)
- [Neovim Remote (nvr)](https://github.com/mhinz/neovim-remote)
