# Configuration Changes Workflow

## Purpose

This workflow guides you through making safe configuration changes to any file managed by chezmoi. Use this workflow when you need to:

- Modify existing configuration files (shell configs, editor settings, tool configurations)
- Add new configurations to chezmoi management
- Update tool-specific settings across multiple machines
- Test configuration changes before committing them to git

Following this workflow ensures your changes are previewed, tested, version-controlled, and easily reversible if something goes wrong.

## Prerequisites

- [ ] Chezmoi installed and initialized (`chezmoi --version` works)
- [ ] Git configured with your credentials (`git config user.name` and `git config user.email` set)
- [ ] Text editor configured (EDITOR environment variable set, e.g., `export EDITOR=nvim`)
- [ ] Basic understanding of chezmoi concepts (source vs destination directories)
- [ ] Your dotfiles repository cloned to `~/.local/share/chezmoi`

## Step-by-Step Procedure

### Step 1: Identify What to Change

Before editing, you need to locate the exact file in chezmoi's source directory.

**Option A: Find a specific file by name**

```bash
# List all managed files and search for your file
chezmoi managed | grep config.fish

# Example output:
# ~/.config/fish/config.fish
```

**Option B: Search for content across all managed files**

```bash
# Navigate to chezmoi source directory
cd ~/.local/share/chezmoi

# Search for a pattern (e.g., finding where an alias is defined)
rg "alias gst" --type fish

# Example output:
# dot_config/fish/config.fish
# 42:alias gst='git status'
```

**Option C: Check if a file is managed**

```bash
# Check if a specific file is managed by chezmoi
chezmoi managed | grep -F ~/.config/nvim/init.lua
```

**Expected result**: You know the exact path to the file you want to edit (e.g., `~/.config/fish/config.fish`)

### Step 2: Edit the Configuration

Use `chezmoi edit` to open the source file in your editor. This ensures you're editing the source, not the destination file in your home directory.

```bash
# Edit with your default editor
chezmoi edit ~/.config/fish/config.fish

# Or specify an editor for this session
EDITOR=nvim chezmoi edit ~/.config/nvim/init.lua

# Edit multiple files at once
chezmoi edit ~/.config/fish/config.fish ~/.config/fish/functions/fish_prompt.fish
```

**Important**: Always use `chezmoi edit`, not direct editing of files in `~/.local/share/chezmoi`. The `edit` command handles special files (templates, encrypted files) correctly.

**Expected result**: Your text editor opens with the chezmoi source file ready to edit

### Step 3: Make Your Changes

When making changes, follow these best practices:

- **Make focused changes**: One logical change per editing session (easier to test and revert)
- **Validate syntax**: Use tool-specific syntax checkers if available
  - Fish: `fish -n ~/.config/fish/config.fish` (dry run)
  - Lua: `luacheck ~/.config/nvim/init.lua`
  - Shell: `shellcheck script.sh`
- **Add comments**: Explain why you made the change, not just what changed
- **Follow existing patterns**: Match the style and structure already in the file
- **Preserve templates**: If the file uses chezmoi templates (`{{ .variable }}`), keep the syntax correct

**Example change to Fish config:**

```fish
# Before
set -gx EDITOR vim

# After
set -gx EDITOR nvim  # Switched to Neovim for better plugin support
```

**Expected result**: Changes are made, saved, and your editor closed

### Step 4: Preview Changes

Before applying changes to your home directory, preview exactly what will change. This is the most important safety step.

```bash
# See all pending changes in unified diff format
chezmoi diff

# See changes for a specific file
chezmoi diff ~/.config/fish/config.fish

# Perform a dry run showing what would be applied
chezmoi apply --dry-run --verbose

# See changes with more context (10 lines before/after)
chezmoi diff --unified=10
```

**Example output:**

```diff
diff --git a/~/.config/fish/config.fish b/~/.config/fish/config.fish
--- a/~/.config/fish/config.fish
+++ b/~/.config/fish/config.fish
@@ -15,7 +15,7 @@
 # Editor configuration
-set -gx EDITOR vim
+set -gx EDITOR nvim  # Switched to Neovim for better plugin support
```

**Review the diff carefully**:

- Ensure only intended lines changed
- Check for accidental deletions (lines with `-`)
- Verify template syntax if applicable

**Expected result**: You understand exactly what will change in your home directory and confirm it matches your intent

### Step 5: Apply Changes

Once you've confirmed the changes are correct, apply them to your home directory.

```bash
# Apply all pending changes
chezmoi apply

# Apply only a specific file (safer for first-time changes)
chezmoi apply ~/.config/fish/config.fish

# Apply with verbose output to see what's happening
chezmoi apply --verbose

# Apply and show what was changed
chezmoi apply --verbose --diff
```

**What happens during apply**:

1. Chezmoi processes templates (if applicable)
2. Decrypts encrypted files (if applicable)
3. Copies/updates files from source to destination
4. Sets correct permissions
5. Creates directories if needed

**Expected result**: Changes are now live in your home directory (e.g., `~/.config/fish/config.fish` has your edits)

### Step 6: Test the Configuration

Verify that your configuration works as expected. Testing varies by tool:

**Shell configurations (Fish, Bash, Zsh)**:

```bash
# Fish: Open a new shell session
fish

# Check for errors in the config
fish -n ~/.config/fish/config.fish

# Verify your change works (e.g., test an alias)
gst  # If you added an alias
```

**Neovim configuration**:

```bash
# Open Neovim
nvim

# Run health checks
:checkhealth

# Test specific functionality you changed
```

**Window manager (Yabai, Skhd)**:

```bash
# Reload Yabai configuration
yabai --restart-service

# Test hotkeys you modified
# (Try the actual key combinations)

# Check window rules
yabai -m query --spaces
```

**Git configuration**:

```bash
# Verify config was applied
git config --list | grep alias

# Test the change
git st  # If you added an alias
```

**Generic tool testing**:

```bash
# Restart the application
# Try the specific feature you modified
# Check for error messages in logs
```

**Expected result**: The tool works correctly with your new configuration, no errors occur

### Step 7: Commit Changes to Git

Once tested, commit your changes to version control for backup and synchronization.

```bash
# Navigate to chezmoi source directory
chezmoi cd

# Check the status
git status

# Review your changes one more time
git diff

# Stage the specific files you modified
git add dot_config/fish/config.fish

# Commit with a descriptive message
git commit -m "feat: switch default editor to neovim

- Changed EDITOR environment variable from vim to nvim
- Added comment explaining the reason for the change
- Tested by opening git commit editor, works as expected"

# Push to remote repository
git push

# Return to your previous directory
exit
```

**Commit message best practices**:

- Use conventional commit format: `type: brief description`
- Types: `feat` (new feature), `fix` (bug fix), `chore` (maintenance), `docs` (documentation)
- Keep subject line under 50 characters
- Add a body explaining why (not what) you made the change
- Reference any related issues or tickets

**Expected result**: Changes are committed and pushed to your git repository

### Step 8: (Optional) Apply to Other Machines

If you manage multiple machines with the same dotfiles repository, synchronize your changes.

**On the other machine:**

```bash
# Update chezmoi (pulls git changes and applies them)
chezmoi update

# Or do it manually for more control:
# Pull the latest changes
chezmoi git pull

# Preview what would change
chezmoi diff

# Apply the changes
chezmoi apply

# Test the configuration on this machine
```

**Be cautious with machine-specific configurations**: If your change is specific to one machine, use chezmoi templates to conditionally apply it:

```fish
# Example: Only set this on your work machine
{{ if eq .chezmoi.hostname "work-laptop" }}
set -gx WORK_VAR "value"
{{ end }}
```

**Expected result**: Your other machines now have the same configuration changes

## Verification

To verify the workflow completed successfully, check all of the following:

1. **Source file updated**: `chezmoi cat ~/.config/fish/config.fish` shows your changes
2. **Destination file updated**: `cat ~/.config/fish/config.fish` shows your changes
3. **Tool reflects changes**: The application using the config behaves as expected
4. **Git committed**: `chezmoi cd && git log -1` shows your commit message
5. **Remote updated**: Check your dotfiles repository on GitHub/GitLab for the commit
6. **No errors**: `chezmoi verify` runs without errors (checks all files match source)

Quick verification command:

```bash
# Verify all chezmoi-managed files are in correct state
chezmoi verify
```

## Troubleshooting

### Problem: Changes don't appear after `chezmoi apply`

**Symptoms**:

- `chezmoi diff` shows changes
- `chezmoi apply` runs without error messages
- File in home directory hasn't changed (verified with `cat ~/.config/file`)

**Solution**:

1. Verify the file is managed:

   ```bash
   chezmoi managed | grep -F ~/.config/fish/config.fish
   ```

2. Check that you edited the source, not the destination:

   ```bash
   # This should show your changes
   chezmoi cat ~/.config/fish/config.fish

   # Compare with destination
   cat ~/.config/fish/config.fish
   ```

3. Look for template errors:

   ```bash
   chezmoi apply --verbose 2>&1 | grep -i error
   ```

4. Force apply the specific file:

   ```bash
   chezmoi apply --force ~/.config/fish/config.fish
   ```

5. Check file permissions:

   ```bash
   ls -la ~/.config/fish/config.fish
   chezmoi managed --include=all | grep -F ~/.config/fish/config.fish
   ```

### Problem: Syntax errors after applying

**Symptoms**:

- Tool fails to start after configuration change
- Error messages about configuration syntax (e.g., "unexpected token")
- Shell won't load, application crashes

**Solution**:

1. **Immediate fix**: Revert to the previous version:

   ```bash
   # Navigate to chezmoi source
   chezmoi cd

   # Undo the last commit
   git reset HEAD~1

   # Reapply the old configuration
   chezmoi apply

   exit
   ```

2. **Identify the error**: Check tool-specific syntax:

   ```bash
   # Fish shell
   fish -n ~/.config/fish/config.fish

   # Lua (Neovim)
   luacheck ~/.config/nvim/init.lua

   # YAML
   yamllint ~/.config/tool/config.yml
   ```

3. **Fix and retest**: Edit the source file again, fix the syntax, test before applying:

   ```bash
   chezmoi edit ~/.config/fish/config.fish
   # Fix the syntax error

   # Test before applying
   chezmoi cat ~/.config/fish/config.fish | fish -n

   # If no errors, apply
   chezmoi apply
   ```

### Problem: Can't find the file to edit

**Symptoms**:

- Don't know where configuration file is in chezmoi source directory
- `chezmoi edit` says file not found
- Uncertain if file is managed by chezmoi

**Solution**:

1. List all managed files:

   ```bash
   chezmoi managed
   ```

2. Search by filename pattern:

   ```bash
   chezmoi managed | grep fish
   ```

3. Check if the file exists in your home directory but isn't managed:

   ```bash
   ls -la ~/.config/fish/config.fish
   ```

4. If the file exists but isn't managed, add it to chezmoi:

   ```bash
   chezmoi add ~/.config/fish/config.fish
   ```

5. If you're not sure where a configuration should be:

   ```bash
   # Search for tool configs in your home directory
   fd config.fish ~/.config

   # Or use find
   find ~/.config -name "config.fish"
   ```

### Problem: Chezmoi edit opens wrong editor

**Symptoms**:

- Wrong text editor opens (e.g., nano instead of nvim)
- Editor you want to use doesn't start

**Solution**:

1. Check current EDITOR setting:

   ```bash
   echo $EDITOR
   ```

2. Set EDITOR for current session:

   ```bash
   export EDITOR=nvim
   chezmoi edit ~/.config/fish/config.fish
   ```

3. Set EDITOR permanently in your shell config:

   ```fish
   # For Fish: Add to ~/.config/fish/config.fish
   set -gx EDITOR nvim
   ```

4. Override for a single command:

   ```bash
   EDITOR=code chezmoi edit ~/.config/fish/config.fish
   ```

### Problem: Template syntax errors

**Symptoms**:

- `chezmoi apply` shows template errors
- Messages like "template: error calling function"
- Variables not expanding correctly

**Solution**:

1. Test template execution:

   ```bash
   chezmoi execute-template < ~/.local/share/chezmoi/dot_config/file
   ```

2. Check template syntax:

   ```bash
   # View the processed template without applying
   chezmoi cat ~/.config/fish/config.fish
   ```

3. Common template fixes:
   - Use `{{` and `}}` with proper spacing: `{{ .variable }}` not `{{.variable}}`
   - Escape literal braces: `\{` and `\}` if you need actual braces in output
   - Check variable names: `{{ .chezmoi.hostname }}` not `{{ .hostname }}`

4. Debug template variables:

   ```bash
   chezmoi data
   ```

### Problem: Permission denied errors

**Symptoms**:

- `chezmoi apply` shows "permission denied"
- Can't write to destination file

**Solution**:

1. Check file permissions in source:

   ```bash
   chezmoi cd
   ls -la dot_config/fish/config.fish
   exit
   ```

2. Check if file is readonly in destination:

   ```bash
   ls -la ~/.config/fish/config.fish
   ```

3. Fix permissions on destination (if safe):

   ```bash
   chmod u+w ~/.config/fish/config.fish
   chezmoi apply
   ```

4. Update source file permissions:

   ```bash
   chezmoi cd
   chmod 644 dot_config/fish/config.fish
   git add dot_config/fish/config.fish
   git commit -m "fix: correct config.fish permissions"
   exit
   chezmoi apply
   ```

## Related Documentation

- [secrets-management.md](./secrets-management.md) - Managing encrypted configuration files and secrets
- [Chezmoi User Guide](https://www.chezmoi.io/user-guide/command-overview/) - Official chezmoi command reference
- Tool-specific READMEs in `~/.config/<tool>/README.md` - Configuration details for individual tools

## Notes

- **Always preview with `chezmoi diff` before applying**: This single step prevents most configuration breakages. Make it a habit.
- **Commit frequently with descriptive messages**: Small, focused commits are easier to understand and revert if needed. Think of commits as save points.
- **Test on non-critical machine first**: If you have multiple machines, apply risky changes to your least critical machine first, verify they work, then sync to others.
- **Template syntax is strict**: Even minor template errors will prevent `chezmoi apply` from working. Use `chezmoi cat` to preview template output.
- **Some tools require restart**: Changes to shell configurations require a new shell session. Window managers (yabai, skhd) need restart. Background services need reload.
- **Use `chezmoi verify` regularly**: Occasionally run this to ensure your home directory matches the chezmoi source state.
- **Keep backups**: Your git repository is a backup, but for critical configs, keep an additional backup before major changes.
- **Read tool documentation**: Each tool has its own configuration syntax and reload requirements. When in doubt, check the tool's official docs.
- **Templates are powerful but optional**: Start with simple file management, add templates only when you need machine-specific configurations.

## Common Configuration Change Patterns

**Adding an alias**:

```bash
chezmoi edit ~/.config/fish/config.fish
# Add: alias gco='git checkout'
chezmoi diff
chezmoi apply
# Test: gco main
chezmoi cd && git add . && git commit -m "feat: add git checkout alias"
```

**Updating a plugin list**:

```bash
chezmoi edit ~/.config/nvim/init.lua
# Add plugin to list
chezmoi diff
chezmoi apply
nvim +PlugInstall +qall
# Test plugin works
chezmoi cd && git add . && git commit -m "feat: add telescope.nvim plugin"
```

**Changing environment variables**:

```bash
chezmoi edit ~/.config/fish/config.fish
# Modify: set -gx PATH /new/path $PATH
chezmoi diff
chezmoi apply
fish  # Start new shell
echo $PATH  # Verify
chezmoi cd && git add . && git commit -m "feat: update PATH with custom bin directory"
```

These patterns cover 90% of configuration changes you'll make. Adapt them to your specific needs.
