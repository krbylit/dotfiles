# Neovim Config

Based on LazyVim, with separate config options for nvim in VS Code and in the terminal.

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
>     ○ chezmoi.nvim  <leader>sz
>         3f70149 Update README.md with Fzf-lua integration (6 months ago)
>   ```
>
>   - config this fzf popup to be the same as `<leader>/|space`
>
> - TODO: "plugin" to disable all LazyVim default configs for plugins.
>   - Iterate through LazyVim's lazy-lock and lazyextras and call `config` with empty fn
>   - May want to also add `enabled = false` to all, then iterate through our lazy-lock/lazyextras and turn back on `enabled = true`
> - FIXME: figure out what all is providing alt+j/k in visual to move text. I think multiple things are providing this and conflicting. moving multiple line chunks does not always work well
>
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

## Neovim Guides

- [Basic Config Tutorial](https://martinlwx.github.io/en/config-neovim-from-scratch/)

### Lua

- [Quick primer](https://learnxinyminutes.com/docs/lua/)

### LazyVim

- [Book on using LazyVim](https://lazyvim-ambitious-devs.phillips.codes/course/chapter-1/)
- [LazyVim Install](https://www.lazyvim.org/installation)
- [LazyVim Starter Template](https://github.com/LazyVim/starter)

## Extending vs Overriding Plugin Configurations in LazyVim

LazyVim makes it easy to extend or override default plugin configurations. Here's how it works:

### **Extending Configurations**

You can extend LazyVim’s default configurations in two ways:

- **Using `opts` with a Table**
  Passing a table to `opts` will automatically merge your custom options with LazyVim’s defaults.

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

### **Overriding Configurations**

If you use the `config` key, it will completely replace LazyVim’s default configuration for that plugin.

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

### **Important Notes**

- `opts` will merge configurations by default.
- Properties like `cmd`, `event`, `ft`, `keys`, and `dependencies` are extended automatically.
- Any property not explicitly mentioned above (e.g., `config`) will override the default configuration entirely.
