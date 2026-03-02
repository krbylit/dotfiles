# Television Custom Channels

This directory contains channel configuration files for television.

## Channel Structure

Each channel is a TOML file with the following sections:

```toml
[metadata]
name = "channel-name"
description = "What this channel does"
requirements = ["required", "commands"]  # optional

[source]
command = "command that generates list items"
# or for multiple commands (toggle with ctrl-h by default):
# command = ["cmd1", "cmd2"]

[preview]
command = "command to preview selected item"
# Use {} as placeholder for selected item

[keybindings]
shortcut = "f1"  # Quick access key
ctrl-e = "actions:custom_action"  # Custom action binding

[actions.custom_action]
description = "What this action does"
command = "command to run on selection"
mode = "execute"  # or "fork" to return to tv
```

## Fish Shell Compatibility

Television executes commands through your system shell. For Fish-specific syntax:

### Option 1: Use POSIX-compatible syntax
```toml
[actions.edit]
command = "$EDITOR '{}'"  # Works in both bash and fish
```

### Option 2: Explicit fish shell invocation
```toml
[actions.edit]
command = "fish -c \"$EDITOR '{}'\""
```

### Option 3: Use fish conditionals
```toml
[source]
# Fish uses 'set -q' for checking variables
command = "if set -q MY_VAR; echo $MY_VAR; else echo default; end"
```

## Common Patterns

### File Operations
- `fd` for file search (faster than find)
- `bat` for file preview
- `eza` for directory listing

### Templates
- `{}` - Full selected entry
- `{0}`, `{1}` - Split by delimiter (space by default)
- `{split:/:0}` - Split by `:` and take first part

## Examples

See the existing channels:
- `files.toml` - File/directory selector
- `env.toml` - Environment variables browser
- `fish-history.toml` - Fish shell command history

Run `tv list-channels` to see all available channels.
