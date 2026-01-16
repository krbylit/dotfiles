# Neovim Configuration

## Overview

This Neovim configuration is built on [LazyVim](https://www.lazyvim.org/), providing a modern, extensible IDE experience. It includes separate configurations for terminal use and Firenvim (browser integration), with a comprehensive plugin system managed by Lazy.nvim.

## Table of Contents

- [Overview](#overview)
- [Configuration Structure](#configuration-structure)
- [Plugin Architecture](#plugin-architecture)
  - [Plugin Manager: Lazy.nvim](#plugin-manager-lazynvim)
  - [Plugin Organization](#plugin-organization)
  - [Plugin Categories](#plugin-categories)
- [LSP Setup via Mason](#lsp-setup-via-mason)
  - [Installing Language Servers](#installing-language-servers)
  - [Managing LSP Servers](#managing-lsp-servers)
  - [LSP Keybindings](#lsp-keybindings)
- [Keybindings Reference](#keybindings-reference)
  - [Key Custom Bindings](#key-custom-bindings)
- [Customization Guide](#customization-guide)
  - [Adding a New Plugin](#adding-a-new-plugin)
  - [Extending LazyVim Plugin Configurations](#extending-lazyvim-plugin-configurations)
  - [Customizing Keybindings](#customizing-keybindings)
  - [Customizing LSP Behavior](#customizing-lsp-behavior)
- [Troubleshooting](#troubleshooting)
  - [LSP Server Not Starting](#lsp-server-not-starting)
  - [Plugin Not Loading](#plugin-not-loading)
  - [Mason Installation Fails](#mason-installation-fails)
  - [Slow Startup](#slow-startup)
  - [Session Not Restoring](#session-not-restoring)
  - [Keybinding Conflicts](#keybinding-conflicts)
- [Special Configurations](#special-configurations)
  - [Note on Python](#note-on-python)
  - [Firenvim Setup](#firenvim-setup)
  - [Octo and `gh` Setup](#octo-and-gh-setup)
- [Extending vs Overriding Plugin Configurations in LazyVim](#extending-vs-overriding-plugin-configurations-in-lazyvim)
  - [Extending Configurations](#extending-configurations)
  - [Overriding Configurations](#overriding-configurations)
  - [Important Notes](#important-notes)
- [Adding keymaps for plugins](#adding-keymaps-for-plugins)
  - [Notes](#notes)
  - [Adding keymaps to which-key](#adding-keymaps-to-which-key)
- [External Resources](#external-resources)
- [Known Issues & TODOs](#known-issues--todos)

## Configuration Structure

The configuration follows LazyVim's modular structure:

| Directory/File            | Purpose                                                |
| ------------------------- | ------------------------------------------------------ |
| `init.lua`                | Entry point that loads all configurations              |
| `lua/config/`             | Core Neovim configuration (options, keymaps, autocmds) |
| `lua/config/lazy.lua`     | Lazy.nvim plugin manager setup                         |
| `lua/config/options.lua`  | Global Vim options and settings                        |
| `lua/config/keymaps.lua`  | Core keybindings not tied to specific plugins          |
| `lua/config/autocmds.lua` | Autocommands for file type detection and behaviors     |
| `lua/plugins/`            | Plugin specifications and configurations               |
| `lua/firenvim-config/`    | Firenvim-specific configuration                        |
| `lua/utils/`              | Helper functions and utilities                         |

## Plugin Architecture

### Plugin Manager: Lazy.nvim

This configuration uses [folke/lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management. Lazy.nvim provides:

- **Lazy loading**: Plugins load on-demand based on events, commands, or file types
- **Lock file**: `lazy-lock.json` ensures reproducible plugin versions
- **Update checking**: Automatic notifications for plugin updates
- **Performance**: Fast startup times through strategic lazy-loading

### Plugin Organization

Plugins are organized in the `lua/plugins/` directory (~54 plugin files) with a clear naming convention:

- `extend-*.lua`: Extends or overrides LazyVim's default plugin configurations (e.g., `extend-lspconfig.lua`, `extend-snacks.lua`)
- `<plugin-name>.lua`: Adds new plugins not included in LazyVim (e.g., `yazi.lua`, `harpoon.lua`)
- Plugin configurations can be disabled by moving them to `_disabled.lua`

### Plugin Categories

#### Core Functionality

- **File Explorer**: `mini.files`, `yazi.nvim`, `snacks.nvim` (explorer)
- **Fuzzy Finding**: `snacks.nvim` (picker), `fzf-lua`
- **Navigation**: `flash.nvim` (jump to any location), `harpoon` (file bookmarks)
- **Search & Replace**: `grug-far.nvim` (project-wide search/replace)
- **Session Management**: `persistence.nvim` (save/restore sessions)

#### LSP and Completion

- **LSP Configuration**: `nvim-lspconfig` with Mason integration
- **LSP Package Manager**: `mason.nvim`, `mason-lspconfig.nvim`
- **Completion Engine**: `blink.cmp` (with Copilot integration)
- **Type-aware Tools**: `typescript-tools.nvim` for enhanced TypeScript support

#### Syntax and Treesitter

- **Treesitter**: `nvim-treesitter` with custom text objects
- **Markdown Rendering**: `render-markdown.nvim`, `markview.lua`
- **CSV Support**: `csvview.nvim`

#### UI Enhancements

- **Status Line**: `mini.statusline`
- **Tab Line**: `mini.tabline`
- **Notifications**: `snacks.nvim` (notifier)
- **Dashboard**: `snacks.nvim` (dashboard)
- **Color Scheme**: Custom configuration in `colorscheme.lua`
- **Cursor Effects**: `smear-cursor.nvim`, `beacon.nvim`
- **Window Management**: `edgy.nvim`
- **Minimap**: `mini.map`

#### Git Integration

- **Diff Viewing**: `diffview.nvim`
- **Git Graph**: `gitgraph.nvim`
- **Git Operations**: LazyVim's built-in Lazygit integration
- **PR Reviews**: `octo.nvim` (currently disabled), `snacks.nvim` (gh module)

#### AI & Copilot

- **Code Completion**: `copilot.lua` with `blink.cmp` integration
- **Chat Interface**: `copilotchat.nvim`, `avante.lua`

#### Debugging (DAP)

- **Debug Adapter**: `nvim-dap`, `nvim-dap-virtual-text`
- **Debug UI**: LazyVim's DAP UI integration

#### Other Utilities

- **Keymaps Display**: `which-key.nvim`
- **Yank History**: `yanky.nvim`
- **Code Actions**: `mini.operators`
- **Formatting**: `conform.nvim`
- **Comments**: Built-in commenting with LazyVim

## LSP Setup via Mason

### Installing Language Servers

This configuration uses Mason to manage LSP servers, formatters, and linters. The following tools are automatically installed (see `lua/plugins/extend-lspconfig.lua`):

**Language Servers:**

- `bash-language-server` - Bash
- `lua-language-server` - Lua
- `typescript-language-server` - JavaScript/TypeScript
- `pyright` - Python
- `jedi-language-server` - Python (alternative, currently disabled)
- `rust-analyzer` - Rust
- `json-lsp` - JSON
- `dockerfile-language-server` - Docker
- `docker-compose-language-service` - Docker Compose
- `vim-language-server` - Vimscript
- `marksman` - Markdown

**Formatters & Linters:**

- `prettierd` - JavaScript/TypeScript/JSON/YAML/Markdown
- `eslint_d` - JavaScript/TypeScript
- `stylua` - Lua
- `yapf` - Python
- `shfmt` - Shell scripts
- `shellcheck` - Shell script linting
- `hadolint` - Dockerfile linting
- `markdownlint-cli2` - Markdown linting

**Debug Adapters:**

- `js-debug-adapter` - JavaScript/TypeScript
- `codelldb` - Rust/C/C++

### Managing LSP Servers

**View installed servers:**

```vim
:Mason
```

**Install a new LSP server:**

1. Open Mason: `:Mason`
2. Search for the server using `/`
3. Press `i` to install
4. (Optional) Add to `ensure_installed` in `lua/plugins/extend-lspconfig.lua`

**Update servers:**

```vim
:Mason
" Press 'U' to update all
" Or 'u' on individual servers
```

**Configure a server:**

Add configuration to the `servers` table in `lua/plugins/extend-lspconfig.lua`:

```lua
servers = {
    -- Add new server configuration
    your_language_server = {
        enabled = true,
        settings = {
            -- Server-specific settings
        },
        on_attach = function(client, bufnr)
            -- Custom on_attach logic
        end,
    },
}
```

### LSP Keybindings

Key LSP keybindings (provided by LazyVim):

- `gd` - Go to definition
- `gr` - Go to references
- `gI` - Go to implementation
- `gy` - Go to type definition
- `K` - Hover documentation
- `gK` - Signature help
- `<leader>ca` - Code actions
- `<leader>cr` - Rename symbol
- `]d` / `[d` - Next/previous diagnostic
- `<leader>cd` - Line diagnostics

## Keybindings Reference

This configuration includes extensive custom keybindings. For a complete reference, see the keymaps data in `/Users/kirbylittle/.local/share/chezmoi/specs/001-comprehensive-docs/neovim-keymaps-data.md`.

### Key Custom Bindings

**Leader Keys:**

- `<leader>` = `,` (comma)
- `<localleader>` = `<space>` (space)

**File Navigation:**

- `<leader><space>` - Smart file finder (Snacks picker)
- `<leader>m` - Toggle MiniFiles explorer (at file location)
- `<leader>M` - Toggle MiniFiles explorer (at cwd)
- `<leader>e` - Open Yazi file manager
- `<leader>fe` - Open Snacks Explorer
- `<leader>fc` - Find config file (in chezmoi directory)

**Fuzzy Finding:**

- `<leader>z` - Zoxide directory picker
- `<leader>/` - Live grep in current directory
- `<leader>ff` - Find files
- `<leader>fb` - Find buffers

**Harpoon (File Bookmarks):**

- `<leader>H` - Add file to Harpoon
- `<C-n>` - Toggle Harpoon quick menu
- `<C-1>` through `<C-5>` - Jump to Harpoon files 1-5

**Search & Replace:**

- `<leader>sr` - Search and replace (global)
- `<leader>sf` - Search and replace in current buffer
- `<leader>sv` - Search and replace in visual selection

**Git:**

- `<leader>gv` - Open Diffview file history
- `<leader>gl` - Draw GitGraph
- `<leader>gg` - Open Lazygit

**Movement:**

- `s` - Flash jump to any visible text
- `S` - Flash treesitter selection
- `]f` / `[f` - Jump to next/previous function
- `<C-g>` - Toggle scrolloff (center cursor)

**Sessions:**

- `<leader>qs` - Load session for current directory
- `<leader>qS` - Select session to load
- `<leader>ql` - Load last session
- `<leader>qd` - Don't save session on exit

**Debugging (DAP):**

- `<F5>` - Start/Continue
- `<F9>` - Toggle breakpoint
- `<F10>` - Step over
- `<F11>` - Step into
- `<F12>` - Step out
- `<F8>` - Terminate
- `<F6>` - Pause

**Utilities:**

- `<leader>p` - Yank history picker
- `<leader>uk` - Toggle ShowKeys (display keystrokes)
- `<leader>cp` - Toggle MiniMap

## Customization Guide

### Adding a New Plugin

1. Create a new file in `lua/plugins/` (e.g., `lua/plugins/my-plugin.lua`)
2. Define the plugin spec:

```lua
return {
    "username/plugin-name",
    event = "VeryLazy",  -- or specify lazy-loading triggers
    dependencies = {
        -- List any dependencies
    },
    opts = {
        -- Plugin options (will be passed to setup())
    },
    config = function()
        -- Or use config for custom setup logic
        require("plugin-name").setup({
            -- configuration
        })
    end,
}
```

1. Restart Neovim or run `:Lazy sync`

### Extending LazyVim Plugin Configurations

To extend (not override) LazyVim's default plugin config:

**Using `opts` table (merges with defaults):**

```lua
return {
    "plugin-name",
    opts = {
        -- Your options merge with LazyVim defaults
    },
}
```

**Using `opts` function (for more control):**

```lua
return {
    "plugin-name",
    opts = function(_, opts)
        -- Modify opts table
        opts.new_setting = "value"
        return opts
    end,
}
```

**Overriding configuration completely:**

```lua
return {
    "plugin-name",
    config = function()
        -- This replaces LazyVim's configuration entirely
        require("plugin-name").setup({
            -- your complete config
        })
    end,
}
```

See the section "Extending vs Overriding Plugin Configurations in LazyVim" below for more details.

### Customizing Keybindings

**In plugin files:**

Use the `keys` property for plugin-specific keybindings:

```lua
return {
    "username/plugin-name",
    keys = {
        { "<leader>xx", "<cmd>SomeCommand<cr>", desc = "Description" },
        { "<leader>xy", function()
            -- custom function
        end, desc = "Custom action" },
    },
}
```

**For which-key integration:**

Add mappings using `which-key.add()`:

```lua
require("which-key").add({
    { "<leader>x", group = "Group Name" },
    { "<leader>xx", "<cmd>Command<cr>", desc = "Description" },
})
```

**In `lua/config/keymaps.lua`:**

For core keymaps not tied to plugins:

```lua
vim.keymap.set("n", "<leader>xx", function()
    -- your logic
end, { desc = "Description" })
```

### Customizing LSP Behavior

Edit `lua/plugins/extend-lspconfig.lua`:

**Add/modify server settings:**

```lua
servers = {
    your_lsp = {
        enabled = true,
        settings = {
            -- LSP-specific settings
        },
    },
}
```

**Customize on_attach for a specific server:**

```lua
servers = {
    your_lsp = {
        on_attach = function(client, bufnr)
            -- Custom logic when LSP attaches to buffer
            client.server_capabilities.documentFormattingProvider = false
        end,
    },
}
```

**Global LSP options:**

Modify the `opts` table in `extend-lspconfig.lua`:

- `diagnostics` - Configure virtual text, signs, severity
- `inlay_hints` - Enable/disable inlay hints
- `codelens` - Enable/disable code lenses

## Troubleshooting

### LSP Server Not Starting

**Symptoms**: No LSP features (hover, completion, diagnostics) in a file

**Solution**:

1. Check if the server is installed: `:Mason`
2. Check active LSP clients: `:LspInfo`
3. Check LSP logs: `:LspLog`
4. Verify filetype detection: `:set filetype?`
5. Restart LSP: `:LspRestart`

### Plugin Not Loading

**Symptoms**: Plugin commands/features not available

**Solution**:

1. Check plugin status: `:Lazy`
2. Look for errors in Lazy UI (press `x` to see errors)
3. Check if plugin is in `_disabled.lua`
4. Verify lazy-loading conditions (event, cmd, ft, keys)
5. Try `:Lazy sync` to reinstall

### Mason Installation Fails

**Symptoms**: Error installing LSP server or tool via Mason

**Solution**:

1. Check Mason log: `:MasonLog`
2. Ensure proper Python setup (this config requires `/opt/homebrew/bin/python3`)
3. Check network connectivity
4. Try manual installation: `:MasonInstall <package>`
5. For Python tools, ensure not using uv-managed Python (see "Note on Python" section)

### Slow Startup

**Symptoms**: Neovim takes a long time to start

**Solution**:

1. Check startup time: `nvim --startuptime startup.log`
2. Review loaded plugins: `:Lazy profile`
3. Ensure plugins are properly lazy-loaded
4. Check for autocmd overhead in `lua/config/autocmds.lua`
5. Disable problematic plugins temporarily to isolate issue

### Session Not Restoring

**Symptoms**: `persistence.nvim` not loading previous session

**Solution**:

1. Verify session was saved (check `~/.local/state/nvim/sessions/`)
2. Ensure you're in a directory with a `.git` folder (current limitation)
3. Check `sessionoptions`: `:set sessionoptions?`
4. Try manually loading: `<leader>qs`

### Keybinding Conflicts

**Symptoms**: Keymap doesn't work as expected or triggers wrong action

**Solution**:

1. Check all mappings for a key: `:map <key>`
2. Use which-key to see conflicts: Press your leader key and wait
3. Check plugin keymap definitions in `lua/plugins/`
4. Use `:verbose map <key>` to see where mapping was defined

---

**For additional troubleshooting help**, see the [Troubleshooting Guide](/docs/TROUBLESHOOTING.md#neovim-lsp-issues) for comprehensive coverage of:

- LSP server installation and configuration via Mason
- Python LSP issues after Python upgrades
- Plugin errors and debugging procedures
- Copilot authentication and Node.js requirements
- Health check procedures and common LSP diagnostics

## Special Configurations

### Note on Python

Some plugins require Python for functionality. This config explicitly sets the Python interpreter to avoid issues with uv-managed Python installations:

```lua
vim.g.python3_host_prog = "/opt/homebrew/bin/python3"
vim.env.PATH = "/opt/homebrew/bin:" .. (vim.env.PATH or "")
```

If you encounter Python-related issues (especially with Mason installing `debugpy`), verify your Python installation points to a system Python, not a uv-managed one.

### Firenvim Setup

Firenvim allows using Neovim in browser text areas.

**Browser keymaps:**

- `<C-e>` - Turn focused element into Firenvim iframe
- `<C-,>` - Toggle Firenvim for current tab

**Enable `<C-w>` in Firenvim (Firefox):**

1. Go to `about:addons`
2. Click Extensions → Firenvim cog icon → Manage Extension Shortcuts
3. Set "Send `<C-w>` to firenvim" shortcut

### Octo and `gh` Setup

For PR reviews with Octo, authenticate with these permissions:

```
admin:public_key, codespace, gist, notifications, project,
read:repo_hook, repo, user, workflow, write:discussion,
write:org, write:packages
```

## Extending vs Overriding Plugin Configurations in LazyVim

LazyVim makes it easy to extend or override default plugin configurations. Here's how it works:

### Extending Configurations

You can extend LazyVim's default configurations in two ways:

- **Using `opts` with a Table**
  Passing a table to `opts` will automatically merge your custom options with LazyVim's defaults.

  **Example: Extending Options with a Table**

  ```lua
  return {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        mappings = {
          i = { ["<C-j>"] = "move_selection_next", ["<C-k>"] = "move_selection_previous" },
        },
      },
    },
  }
  ```

- **Using `opts` as a Function**
  If you need more control, you can use a function to modify or replace the existing `opts`. This gives you access to the defaults for dynamic changes.

  **Example: Extending Options with a Function**

  ```lua
  return {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      opts.defaults.mappings = vim.tbl_deep_extend("force", opts.defaults.mappings or {}, {
        i = { ["<C-j>"] = "move_selection_next", ["<C-k>"] = "move_selection_previous" },
      })
      opts.pickers = opts.pickers or {}
      opts.pickers.find_files = { hidden = true }
    end,
  }
  ```

### Overriding Configurations

If you use the `config` key, it will completely replace LazyVim's default configuration for that plugin.

**Example: Overriding Configurations**

```lua
return {
  "nvim-telescope/telescope.nvim",
  config = function()
    require("telescope").setup({
      defaults = {
        mappings = {
          i = { ["<C-j>"] = "move_selection_next", ["<C-k>"] = "move_selection_previous" },
        },
      },
    })
  end,
}
```

### Important Notes

- `opts` will merge configurations by default.
- Properties like `cmd`, `event`, `ft`, `keys`, and `dependencies` are extended automatically.
- Any property not explicitly mentioned above (e.g., `config`) will override the default configuration entirely.

## Adding keymaps for plugins

### Notes

- `which-key` did not play nice with 'rhs' being a string like this: `":lua require('grug-far').grug_far({ prefills = { paths = vim.fn.expand(" % ") } })<CR>"`
  - Instead used a function call to the command (see the module).

### Adding keymaps to which-key

- To add maps to `which-key`, we can `require("which-key").add(<keymap-spec>)` in the plugin keymap files.
- We can also add 'groups' to `which-key` to categorize the mappings (see e.g. below).
- Keymap spec is a table with the following attributes:

  > A mapping has the following attributes:
  > [1]: (string) lhs (required)
  > [2]: (string|fun()) rhs (optional): when present, it will create the mapping
  > desc: (string|fun():string) description (required for non-groups)
  > group: (string|fun():string) group name (optional)
  > mode: (string|string[]) mode (optional, defaults to "n")
  > cond: (boolean|fun():boolean) condition to enable the mapping (optional)
  > hidden: (boolean) hide the mapping (optional)
  > icon: (string|wk.Icon|fun():(wk.Icon|string)) icon spec (optional)
  > proxy: (string) proxy to another mapping (optional)
  > expand: (fun():wk.Spec) nested mappings (optional)
  > any other option valid for vim.keymap.set. These are only used for creating mappings.

e.g. from `harpooon-maps.lua`, this creates the 'h' group in the main `<leader>` menu and maps `<leader>he`:

```lua

  { "<leader>h", group = "Harpoon" },
  {
   "<leader>he",
   function()
    toggle_telescope(harpoon:list())
   end,
   desc = "Open Harpoon Telescope",
  },
```

## External Resources

- [LazyVim Documentation](https://www.lazyvim.org/)
- [LazyVim Keymaps Reference](https://www.lazyvim.org/keymaps)
- [Lazy.nvim Plugin Manager](https://github.com/folke/lazy.nvim)
- [Mason.nvim Documentation](https://github.com/williamboman/mason.nvim)
- [Neovim LSP Configuration Guide](https://github.com/neovim/nvim-lspconfig)
- [LazyVim Book for Ambitious Devs](https://lazyvim-ambitious-devs.phillips.codes/course/chapter-1/)
- [Basic Neovim Config Tutorial](https://martinlwx.github.io/en/config-neovim-from-scratch/)
- [Lua Quick Primer](https://learnxinyminutes.com/docs/lua/)

---

## Markdown callouts

Special rendering exists for the following callouts formatted with `> [!CALLOUTNAME] Optional title`

Callout rendering is provided by [markview.nvim](lua/plugins/markview.lua:2), which implements the same callout system as render-markdown.nvim. The complete callout configuration can be seen in the commented section of [extend-render-markdown.lua](lua/plugins/extend-render-markdown.lua:321-350).

> [!TIP] GitHub supported callouts
> GitHub supports rendering `NOTE`, `TIP`, `IMPORTANT`, `WARNING`, `CAUTION` callouts, but _cannot_ use optional title following `[!CALLOUT]`.

Titles can be supplied as such:

> [!NOTE] Title of note
> Note content

> [!NOTE] Callout aliases
> Some callouts are aliases that render identically:
>
> - `ABSTRACT` = `SUMMARY` = `TLDR`
> - `SUCCESS` = `CHECK` = `DONE`
> - `QUESTION` = `HELP` = `FAQ`
> - `FAILURE` = `FAIL` = `MISSING`
> - `DANGER` = `ERROR`
> - `QUOTE` = `CITE`

### List of callouts with rendering

> [!WARNING]
> Content text

> [!ATTENTION]
> Content text

> [!CAUTION]
> Content text

> [!NOTE]
> Content text

> [!INFO]
> Content text

> [!TIP]
> Content text

> [!HINT]
> Content text

> [!IMPORTANT]
> Content text

> [!ERROR]
> Content text

> [!DANGER]
> Content text

> [!SUCCESS]
> Content text

> [!CHECK]
> Content text

> [!DONE]
> Content text

> [!QUESTION]
> Content text

> [!HELP]
> Content text

> [!FAQ]
> Content text

> [!FAILURE]
> Content text

> [!FAIL]
> Content text

> [!MISSING]
> Content text

> [!BUG]
> Content text

> [!EXAMPLE]
> Content text

> [!QUOTE]
> Content text

> [!CITE]
> Content text

> [!ABSTRACT]
> Content text

> [!SUMMARY]
> Content text

> [!TLDR]
> Content text

> [!TODO]
> Content text

---

## Known Issues & TODOs

> [!TODO]
>
> - FIXME: `persistence.nvim` only opening session if in root dir with .git folder
>   - e.g. this is bad for when we `vc` and want to restore session of just our vim config buffers. we can only restore a session saved inside `chezmoi/` dir if our cwd is root `chezmoi/`
> - FIXME: dashboard recent files needs to truncate long filenames (see
>   snacks.scratch e.g.)
> - FIXME: when opening file from snacks dash w/ harpoon, we get no line numbers. seems that we're probably inheriting the buff opts set by snacks dash in that buffer
>   - this actually seems to be happening other times as well. inconsistent behavior: e.g. not happening in work proj dirs. may have to do w/ `vc` alias?
> - FIXME: see why harpoon saved list is resetting w/ chezmoi dir. seems related to not having harpoon list in `vc` vim config but having it in `c` config. perhaps based on project root
> - TODO: get nvim-dap and debugging python/js working again
> - TODO: config new plugin features:
>
>   ```
>     ○ chezmoi.nvim  <leader>sz
>         3f70149 Update README.md with Fzf-lua integration (6 months ago)
>   ```
>
>   - config this fzf popup to be the same as `<leader>/|space`
>
> - TODO: "plugin" to disable all LazyVim default configs for plugins.
>   - Iterate through LazyVim's lazy-lock and lazyextras and call `config` with empty fn
>   - May want to also add `enabled = false` to all, then iterate through our lazy-lock/lazyextras and turn back on `enabled = true`
> - FIXME: figure out what all is providing alt+j/k in visual to move text. I think multiple things are providing this and conflicting. moving multiple line chunks does not always work well
>   - w/ multi lines, after first alt+ move our visual selection resets to just the first line, causing subsequent moves to move only that line
>   - seems to only be effecting downward movements. when we move chunks up the selection stays the same
>   - one is coming from abstract-autocmds (this is <J|K> though). behavior with this is the same.
>   - alt+j/k/h/l is coming from `mini.move`, look into if this options is the cause:
>
>     ```
>       -- Options which control moving behavior
>     options = {
>     -- Automatically reindent selection during linewise vertical move
>     reindent_linewise = true,
>     },
>     ```
>
>   - REPRODUCTION: happens when we move a chunk into a multiline chunk of fn args
>
> - TODO: see if we can get rid of `abstract-autocmds`
