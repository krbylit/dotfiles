# Claude Code Keybindings Reference

> [!NOTE]
> This file documents the verified keybindings for Claude Code based on official documentation.
> All information is sourced from [code.claude.com/docs/en/keybindings](https://code.claude.com/docs/en/keybindings)

## Quick Reference

- **Run** `/keybindings` to edit your configuration
- **Run** `/doctor` to validate your keybindings
- **Location**: `~/.claude/keybindings.json`
- **Auto-reload**: Changes apply immediately without restart

## Valid Contexts

Claude Code recognizes exactly 18 contexts.

| Context           | Description                                      |
| :---------------- | :----------------------------------------------- |
| `Global`          | Applies everywhere in the app                    |
| `Chat`            | Main chat input area                             |
| `Autocomplete`    | Autocomplete menu is open                        |
| `Settings`        | Settings menu (escape-only dismiss)              |
| `Confirmation`    | Permission and confirmation dialogs              |
| `Tabs`            | Tab navigation components                        |
| `Help`            | Help menu is visible                             |
| `Transcript`      | Transcript viewer                                |
| `HistorySearch`   | History search mode (Ctrl+R)                     |
| `Task`            | Background task is running                       |
| `ThemePicker`     | Theme picker dialog                              |
| `Attachments`     | Image/attachment bar navigation                  |
| `Footer`          | Footer indicator navigation (tasks, teams, diff) |
| `MessageSelector` | Rewind and summarize dialog message selection    |
| `DiffDialog`      | Diff viewer navigation                           |
| `ModelPicker`     | Model picker effort level                        |
| `Select`          | Generic select/list components                   |
| `Plugin`          | Plugin dialog (browse, discover, manage)         |

## Valid Actions by Namespace

### App Actions (Global context)

| Action                 | Default | Description                 |
| :--------------------- | :------ | :-------------------------- |
| `app:interrupt`        | Ctrl+C  | Cancel current operation    |
| `app:exit`             | Ctrl+D  | Exit Claude Code            |
| `app:toggleTodos`      | Ctrl+T  | Toggle task list visibility |
| `app:toggleTranscript` | Ctrl+O  | Toggle verbose transcript   |

### History Actions (Global context)

History actions belong in the `Global` context.

| Action             | Default | Description           |
| :----------------- | :------ | :-------------------- |
| `history:search`   | Ctrl+R  | Open history search   |
| `history:previous` | Up      | Previous history item |
| `history:next`     | Down    | Next history item     |

### Chat Actions

The following are the valid chat actions. Text editing (cursor movement, deletion, etc.) is handled by the terminal layer and cannot be customized via keybindings.

| Action                | Default                   | Description              |
| :-------------------- | :------------------------ | :----------------------- |
| `chat:cancel`         | Escape                    | Cancel current input     |
| `chat:cycleMode`      | Shift+Tab                 | Cycle permission modes   |
| `chat:modelPicker`    | Cmd+P / Meta+P            | Open model picker        |
| `chat:thinkingToggle` | Cmd+T / Meta+T            | Toggle extended thinking |
| `chat:submit`         | Enter                     | Submit message           |
| `chat:undo`           | Ctrl+\_                   | Undo last action         |
| `chat:externalEditor` | Ctrl+G                    | Open in external editor  |
| `chat:stash`          | Ctrl+S                    | Stash current prompt     |
| `chat:imagePaste`     | Ctrl+V (Alt+V on Windows) | Paste image              |

### Autocomplete Actions

| Action                  | Default | Description         |
| :---------------------- | :------ | :------------------ |
| `autocomplete:accept`   | Tab     | Accept suggestion   |
| `autocomplete:dismiss`  | Escape  | Dismiss menu        |
| `autocomplete:previous` | Up      | Previous suggestion |
| `autocomplete:next`     | Down    | Next suggestion     |

### Confirmation Actions

| Action                      | Default   | Description                   |
| :-------------------------- | :-------- | :---------------------------- |
| `confirm:yes`               | Y, Enter  | Confirm action                |
| `confirm:no`                | N, Escape | Decline action                |
| `confirm:previous`          | Up        | Previous option               |
| `confirm:next`              | Down      | Next option                   |
| `confirm:nextField`         | Tab       | Next field                    |
| `confirm:previousField`     | (unbound) | Previous field                |
| `confirm:cycleMode`         | Shift+Tab | Cycle permission modes        |
| `confirm:toggleExplanation` | Ctrl+E    | Toggle permission explanation |

### Permission Actions

| Action                   | Default | Description                  |
| :----------------------- | :------ | :--------------------------- |
| `permission:toggleDebug` | Ctrl+D  | Toggle permission debug info |

### Transcript Actions

| Action                     | Default        | Description             |
| :------------------------- | :------------- | :---------------------- |
| `transcript:toggleShowAll` | Ctrl+E         | Toggle show all content |
| `transcript:exit`          | Ctrl+C, Escape | Exit transcript view    |

### History Search Actions

| Action                  | Default     | Description              |
| :---------------------- | :---------- | :----------------------- |
| `historySearch:next`    | Ctrl+R      | Next match               |
| `historySearch:accept`  | Escape, Tab | Accept selection         |
| `historySearch:cancel`  | Ctrl+C      | Cancel search            |
| `historySearch:execute` | Enter       | Execute selected command |

### Task Actions

| Action            | Default | Description             |
| :---------------- | :------ | :---------------------- |
| `task:background` | Ctrl+B  | Background current task |

### Theme Actions

| Action                           | Default | Description                |
| :------------------------------- | :------ | :------------------------- |
| `theme:toggleSyntaxHighlighting` | Ctrl+T  | Toggle syntax highlighting |

### Help Actions

| Action         | Default | Description     |
| :------------- | :------ | :-------------- |
| `help:dismiss` | Escape  | Close help menu |

### Tabs Actions

| Action          | Default         | Description  |
| :-------------- | :-------------- | :----------- |
| `tabs:next`     | Tab, Right      | Next tab     |
| `tabs:previous` | Shift+Tab, Left | Previous tab |

### Attachments Actions

| Action                 | Default           | Description                |
| :--------------------- | :---------------- | :------------------------- |
| `attachments:next`     | Right             | Next attachment            |
| `attachments:previous` | Left              | Previous attachment        |
| `attachments:remove`   | Backspace, Delete | Remove selected attachment |
| `attachments:exit`     | Down, Escape      | Exit attachment bar        |

### Footer Actions

| Action                  | Default | Description               |
| :---------------------- | :------ | :------------------------ |
| `footer:next`           | Right   | Next footer item          |
| `footer:previous`       | Left    | Previous footer item      |
| `footer:openSelected`   | Enter   | Open selected footer item |
| `footer:clearSelection` | Escape  | Clear footer selection    |

### Message Selector Actions

| Action                   | Default                                   | Description       |
| :----------------------- | :---------------------------------------- | :---------------- |
| `messageSelector:up`     | Up, K                                     | Move up in list   |
| `messageSelector:down`   | Down, J                                   | Move down in list |
| `messageSelector:top`    | Ctrl+Up, Shift+Up, Meta+Up, Shift+K       | Jump to top       |
| `messageSelector:bottom` | Ctrl+Down, Shift+Down, Meta+Down, Shift+J | Jump to bottom    |
| `messageSelector:select` | Enter                                     | Select message    |

### Diff Actions

| Action                | Default            | Description            |
| :-------------------- | :----------------- | :--------------------- |
| `diff:dismiss`        | Escape             | Close diff viewer      |
| `diff:previousSource` | Left               | Previous diff source   |
| `diff:nextSource`     | Right              | Next diff source       |
| `diff:previousFile`   | Up                 | Previous file in diff  |
| `diff:nextFile`       | Down               | Next file in diff      |
| `diff:viewDetails`    | Enter              | View diff details      |
| `diff:back`           | (context-specific) | Go back in diff viewer |

### Model Picker Actions

| Action                       | Default | Description           |
| :--------------------------- | :------ | :-------------------- |
| `modelPicker:decreaseEffort` | Left    | Decrease effort level |
| `modelPicker:increaseEffort` | Right   | Increase effort level |

### Select Actions

| Action            | Default         | Description      |
| :---------------- | :-------------- | :--------------- |
| `select:next`     | Down, J, Ctrl+N | Next option      |
| `select:previous` | Up, K, Ctrl+P   | Previous option  |
| `select:accept`   | Enter           | Accept selection |
| `select:cancel`   | Escape          | Cancel selection |

### Plugin Actions

| Action           | Default | Description              |
| :--------------- | :------ | :----------------------- |
| `plugin:toggle`  | Space   | Toggle plugin selection  |
| `plugin:install` | I       | Install selected plugins |

### Settings Actions

| Action            | Default | Description                         |
| :---------------- | :------ | :---------------------------------- |
| `settings:search` | /       | Enter search mode                   |
| `settings:retry`  | R       | Retry loading usage data (on error) |

## Reserved Shortcuts

> [!WARNING]
> These shortcuts are hardcoded and CANNOT be rebound. Including them in your keybindings.json will cause validation errors.

| Shortcut | Reason                     |
| :------- | :------------------------- |
| Ctrl+C   | Hardcoded interrupt/cancel |
| Ctrl+D   | Hardcoded exit             |

## Terminal Conflicts

Some shortcuts may conflict with terminal multiplexers:

| Shortcut | Conflict                          |
| :------- | :-------------------------------- |
| Ctrl+B   | tmux prefix (press twice to send) |
| Ctrl+A   | GNU screen prefix                 |
| Ctrl+Z   | Unix process suspend (SIGTSTP)    |

## Keystroke Syntax

### Modifiers

Use modifier keys with the `+` separator:

- `ctrl` or `control` - Control key
- `alt`, `opt`, or `option` - Alt/Option key
- `shift` - Shift key
- `meta`, `cmd`, or `command` - Meta/Command key

Examples:

```text
ctrl+k          Single key with modifier
shift+tab       Shift + Tab
meta+p          Command/Meta + P
ctrl+shift+c    Multiple modifiers
```

### Uppercase Letters

A standalone uppercase letter implies Shift. For example, `K` is equivalent to `shift+k`.

Uppercase letters with modifiers (e.g., `ctrl+K`) are treated as stylistic and do NOT imply Shift — `ctrl+K` is the same as `ctrl+k`.

### Chords

Chords are sequences of keystrokes separated by spaces:

```text
ctrl+k ctrl+s   Press Ctrl+K, release, then Ctrl+S
```

### Special Keys

- `escape` or `esc` - Escape key
- `enter` or `return` - Enter key
- `tab` - Tab key
- `space` - Space bar
- `up`, `down`, `left`, `right` - Arrow keys
- `backspace`, `delete` - Delete keys

## Unbinding Default Shortcuts

Set an action to `null` to unbind a default shortcut:

```json
{
  "bindings": [
    {
      "context": "Chat",
      "bindings": {
        "ctrl+s": null
      }
    }
  ]
}
```

## Vim Mode Interaction

When vim mode is enabled (`/vim`), keybindings and vim mode operate independently:

- **Vim mode** handles input at the text input level (cursor movement, modes, motions)
- **Keybindings** handle actions at the component level (toggle todos, submit, etc.)
- The Escape key in vim mode switches INSERT to NORMAL mode; it does not trigger `chat:cancel`
- Most Ctrl+key shortcuts pass through vim mode to the keybinding system
- In vim NORMAL mode, `?` shows the help menu (vim behavior)

## Sources

All information in this document is verified from:

- [Official Claude Code Keybindings Documentation](https://code.claude.com/docs/en/keybindings)
- [JSON Schema](https://www.schemastore.org/claude-code-keybindings.json)

Last verified: 2026-02-10
