# Delta - Git Diff Viewer

## Overview

Delta is a syntax-highlighting pager for git, diff, and grep output. It provides enhanced diff viewing with side-by-side comparisons, syntax highlighting, and intelligent line numbering. Delta serves as the primary diff viewer across all Git tools in this configuration.

## Configuration Files

- **Git configuration**: `~/.gitconfig` - Core Delta settings
- **Delta themes**: `~/.config/delta/` - Optional custom themes and features

## Core Features

### Syntax Highlighting

Delta provides language-aware syntax highlighting for diffs, making it easier to identify changes in code structure and logic.

### Side-by-Side View

Configured to show changes in side-by-side mode by default, allowing for easier comparison of before/after states:

```gitconfig
[delta]
    side-by-side = true
```

### Unobtrusive Line Numbers

Uses subtle line numbers that don't interfere with diff content readability:

```gitconfig
[delta]
    features = unobtrusive-line-numbers decorations
```

### Navigation Support

Navigate between diff sections using `n` (next) and `N` (previous):

```gitconfig
[delta]
    navigate = true
```

### Advanced Diff Algorithm

Uses the histogram diff algorithm for more accurate and readable diffs:

```gitconfig
[diff]
    algorithm = histogram
    colorMoved = default
```

**Color-moved lines**: Changed lines that were moved (not modified) are colored distinctly:

- Old moved lines: Yellow bold
- New moved lines: Cyan bold

### Merge Conflict Visualization

Uses `zdiff3` conflict style which truncates identical lines from both sides, focusing on actual conflicts:

```gitconfig
[merge]
    conflictstyle = zdiff3
```

## Integration Points

### Git Integration (Primary)

Delta is configured as Git's core pager, automatically processing all `git diff`, `git log -p`, `git show`, and other diff outputs:

```gitconfig
[core]
    pager = delta

[interactive]
    diffFilter = delta --color-only
```

**How it works:**

1. You run a Git command that produces diff output: `git diff`, `git log -p`, `git show`
2. Git pipes the output to Delta instead of the default pager
3. Delta processes the diff, adds syntax highlighting and side-by-side view
4. The enhanced output is displayed in your terminal

### Lazygit Integration

Lazygit uses Delta for all diff viewing within its TUI:

```yaml
# ~/.config/lazygit/config.yml
git:
  paging:
    pager: delta --dark --paging=never
    colorArg: always
```

**Features in Lazygit:**

- Syntax-highlighted diffs in the main panel
- Side-by-side view for file changes
- Consistent theme with the Catppuccin color scheme
- Line numbers for precise navigation

See: `~/.config/lazygit/README.md` for complete Lazygit configuration.

### Fish Shell Integration

Delta is used in Fish custom functions for enhanced diff viewing:

**`gdiff` function**: Enhanced git diff viewer with FZF integration

```fish
function gdiff
    git diff $argv | delta
end
```

**FZF Git log preview**: Uses Delta for syntax highlighting in FZF preview windows

```fish
set -gx fzf_diff_highlighter 'delta --no-gitconfig --paging=never ...'
```

**Git commit function**: The `gc` function shows diffs via Delta before committing

See: `~/.config/fish/TOOLS.md` for complete function documentation.

### FZF Integration

Delta enhances FZF preview windows when browsing Git logs and diffs:

**Preview window configuration:**

```fish
# In FZF preview for Git log
--preview 'git show {1} | delta --paging=never'
```

**Benefits:**

- Syntax-highlighted diffs in FZF selection UI
- Side-by-side view within narrow FZF preview panes
- Consistent styling across all Git exploration workflows

## Common Workflows

### Viewing Uncommitted Changes

```bash
git diff              # Working directory changes
git diff --staged     # Staged changes
git diff HEAD         # All changes since last commit
```

All automatically pipe through Delta with syntax highlighting and side-by-side view.

### Reviewing Commit History

```bash
git log -p            # Show patches with commits
git show <commit>     # Show specific commit with diff
git log --stat        # Show commit stats (file list)
```

### Comparing Branches

```bash
git diff main..feature-branch        # Changes in feature-branch
git diff main...feature-branch       # Changes since branches diverged
```

### Interactive Diff Navigation

When viewing large diffs:

- Press `n` to jump to next file/hunk
- Press `N` to jump to previous file/hunk
- Press `q` to quit the pager

### Merging with Enhanced Conflict View

```bash
git merge feature-branch   # Create merge conflict
git diff                   # View conflicts with zdiff3 format
```

The `zdiff3` style shows only the conflicting parts, making it easier to resolve.

## Customization

### Themes

Delta supports custom themes via `~/.config/delta/` directory. Available themes can be found at:

- [Official Delta Themes](https://github.com/dandavison/delta/blob/main/themes.gitconfig)

To enable a theme:

```gitconfig
[delta]
    features = my-custom-theme
```

### Feature Flags

Current enabled features:

- `unobtrusive-line-numbers`: Subtle line numbers
- `decorations`: Enhanced commit/file headers

Additional features can be enabled by adding to the features list in `.gitconfig`.

### Disable Side-by-Side for Wide Diffs

For very wide diffs, you can temporarily disable side-by-side:

```bash
git diff --no-pager | delta --side-by-side=false
```

Or set a shell alias:

```fish
alias git-diff-vertical="git diff --no-pager | delta --side-by-side=false"
```

## Troubleshooting

### Delta Not Showing Color

**Symptoms**: Diffs appear in plain text without syntax highlighting

**Solutions**:

1. Verify Delta is installed: `which delta`
2. Check `.gitconfig` has `core.pager = delta`
3. Ensure Git is sending color to Delta: `git config --get color.ui` should return "auto" or "always"
4. Test Delta directly: `git diff | delta`

### Side-by-Side View Too Narrow

**Symptoms**: Side-by-side diffs are cramped or difficult to read

**Solutions**:

1. Increase terminal width (Delta needs ~160 columns for optimal side-by-side)
2. Temporarily disable side-by-side: `git -c delta.side-by-side=false diff`
3. Set narrower width threshold in `.gitconfig`:

   ```gitconfig
   [delta]
       side-by-side = true
       max-line-length = 120
   ```

### Navigation Keys Not Working

**Symptoms**: Pressing `n` or `N` doesn't jump between diff sections

**Solutions**:

1. Check `.gitconfig` has `navigate = true` in `[delta]` section
2. Ensure you're using Delta's pager (not less or another pager)
3. Try explicit navigation: `git diff | delta --navigate`

### Lazygit Not Using Delta

**Symptoms**: Lazygit shows plain diffs without syntax highlighting

**Solutions**:

1. Check `~/.config/lazygit/config.yml` has correct pager setting
2. Verify Delta is in PATH: `which delta`
3. Test Delta pager command: `echo "test" | delta --dark --paging=never`
4. Ensure `git.paging.colorArg` is set to "always"

See: `~/.config/lazygit/README.md#delta-not-showing-in-diffs` for Lazygit-specific troubleshooting.

## Architecture

Delta fits into the Git workflow as a post-processing layer:

```
Git Command → Diff Output → Delta Pager → Syntax Highlighting → Terminal Display
```

**Integration flow:**

1. **Git**: Generates diff output with ANSI color codes
2. **Delta**: Receives diff via stdin, parses structure and content
3. **Processing**: Applies syntax highlighting, reformats to side-by-side, adds line numbers
4. **Output**: Renders enhanced diff to terminal or FZF preview

See: `~/docs/ARCHITECTURE.md` (Diagram 2: Shell Environment Flow) for visual representation.

## Related Tools

- **Lazygit** (`~/.config/lazygit/`) - Git TUI using Delta for diffs
- **Fish Shell** (`~/.config/fish/`) - Custom functions leveraging Delta
- **FZF** (configured in Fish) - Uses Delta for preview windows
- **Neovim** (`~/.config/nvim/`) - Uses `nvimdiff` for merge/diff, not Delta

## Resources

- [Delta GitHub Repository](https://github.com/dandavison/delta)
- [Delta Themes Collection](https://github.com/dandavison/delta/blob/main/themes.gitconfig)
- [Delta Configuration Guide](https://dandavison.github.io/delta/configuration.html)
- [Git diff algorithms explained](https://luppeng.wordpress.com/2020/10/10/when-to-use-each-of-the-git-diff-algorithms/)
