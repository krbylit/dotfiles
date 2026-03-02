# Hot-Reload Configuration Guide

## What Makes Code Safe to Hot-Reload?

### ✅ SAFE to reload

**1. Pure configuration modules (options, settings)**
```lua
-- config/options.lua
vim.opt.number = true
vim.opt.relativenumber = true
```
- No side effects beyond setting options
- Idempotent (safe to run multiple times)

**2. Utility functions**
```lua
-- utils/helpers.lua
local M = {}
function M.greet() return "hello" end
return M
```
- Pure functions with no state
- No autocmds, keymaps, or global side effects

**3. Autocmds WITH augroups + clear = true**
```lua
local group = vim.api.nvim_create_augroup("MyGroup", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  group = group,  -- ✅ Using group
  callback = function() ... end
})
```
- `clear = true` deletes old autocmds before creating new ones
- Always exactly 1 copy of each autocmd

**4. Simple plugin extension files (opts-only)**
```lua
-- plugins/extend-telescope.lua
return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      layout_strategy = "vertical",
    },
  },
}
```
- Only modifies `opts` table
- No `config` function that calls `setup()`

### ⚠️ RISKY to reload

**1. Autocmds WITHOUT augroups**
```lua
-- ❌ NO augroup - duplicates on reload
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function() print("test") end
})
```
- First reload: 1 autocmd
- Second reload: 2 autocmds (both fire!)
- Third reload: 3 autocmds...

**FIX:** Always use augroups with `clear = true`

**2. Keymaps without deduplication**
```lua
-- ❌ Creates new mapping each reload
vim.keymap.set("n", "<leader>ff", telescope.find_files)
```
- Usually last one wins, but wasteful
- Can cause confusion if callbacks differ

**FIX:** Use `{ buffer = bufnr }` for buffer-local maps that auto-clean, or manually unmap before remapping

**3. Global state**
```lua
-- ❌ Counter increments on each reload
vim.g.my_counter = (vim.g.my_counter or 0) + 1
```
- Doesn't reset between reloads
- Can cause unexpected behavior

**FIX:** Design for idempotency - set absolute values, not incremental

**4. Plugin config functions**
```lua
return {
  "plugin/name",
  config = function()
    require("plugin").setup({ ... })  -- ❌ May not be idempotent
  end,
}
```
- `setup()` might create autocmds without augroups
- Might create keymaps, highlights, global state
- Might register event handlers multiple times

**FIX:** Check if plugin's `setup()` is idempotent (most aren't designed for it)

### 🚫 UNSAFE to reload (never reload these)

**1. LSP configurations**
```lua
require("lspconfig").pyright.setup({})
```
- Creates LSP client attached to buffers
- Reloading creates duplicate clients
- Must detach old client first (complex)

**2. Treesitter configurations**
```lua
require("nvim-treesitter.configs").setup({})
```
- Parsers are already loaded and compiled
- Reloading won't re-compile parsers
- Can cause parser conflicts

**3. Package manager (lazy.nvim, packer)**
```lua
require("lazy").setup({})
```
- Plugin manager is already running
- Reloading can break plugin system
- Never reload package manager config

**4. UI components (statusline, tabline) that register globally**
```lua
require("lualine").setup({})
```
- Creates UI elements that can't be duplicated
- Might create conflicting autocmds
- Might leak resources (timers, watchers)

**FIX:** Don't reload these - restart Neovim instead

## Patterns for Writing Reload-Safe Code

### Pattern 1: Augroups for ALL autocmds

```lua
-- ✅ GOOD - Safe to reload unlimited times
local group = vim.api.nvim_create_augroup("MyFeature", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "lua",
  callback = function() ... end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  pattern = "*.lua",
  callback = function() ... end,
})
```

**Why it works:**
- First load: Creates group + 2 autocmds
- Second load: `clear = true` deletes old autocmds, creates fresh ones
- Always exactly 2 autocmds, never duplicates

### Pattern 2: Guard against duplicate timers/watchers

```lua
-- ✅ GOOD - Cleanup before creating new
local M = {}
local timer = nil

function M.start()
  -- Stop existing timer first
  if timer then
    timer:stop()
    timer:close()
  end

  -- Create new timer
  timer = vim.loop.new_timer()
  timer:start(1000, 1000, function() ... end)
end

function M.stop()
  if timer then
    timer:stop()
    timer:close()
    timer = nil
  end
end

-- Cleanup on Neovim exit
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = M.stop,
})

return M
```

### Pattern 3: Idempotent setup

```lua
-- ✅ GOOD - Can be called multiple times safely
local M = {}
local initialized = false

function M.setup(opts)
  -- Only run expensive initialization once
  if not initialized then
    -- One-time setup (register providers, etc.)
    initialized = true
  end

  -- Always safe to re-run (just updates config)
  M.config = vim.tbl_deep_extend("force", M.config or {}, opts)

  -- Safe to re-create with augroup
  local group = vim.api.nvim_create_augroup("MyPlugin", { clear = true })
  vim.api.nvim_create_autocmd("BufEnter", {
    group = group,
    callback = function() ... end,
  })
end

return M
```

## Hot-Reload Recommendations

### For config/ and utils/
**✅ Safe to hot-reload** if you follow patterns above:
- Use augroups with `clear = true`
- Clean up timers/watchers before recreating
- Write idempotent code

### For plugins/
**⚠️ Experimental** - only reload if:
1. **You're editing simple `opts` extensions** (extend-*.lua files)
2. **You understand the plugin's setup() is idempotent**
3. **You exclude problematic plugins:**
   ```lua
   exclude_patterns = {
     "lspconfig",   -- LSP clients
     "treesitter",  -- Parser configs
     "mason",       -- Tool installations
     "lazy",        -- Plugin manager
   }
   ```

**Safer alternative:** Restart Neovim when changing plugin configs

## Debugging Hot-Reload Issues

### Symptom: Feature runs multiple times
```
-- You hit <leader>ff and telescope opens twice
```
**Cause:** Duplicate autocmds or keymaps

**Debug:**
```vim
:au GroupName          " List autocmds in group
:verbose map <leader>ff " See all mappings for key
```

**Fix:** Add augroup with `clear = true`, or unmap before remapping

### Symptom: Settings don't update
**Cause:** Module isn't actually reloading (still cached)

**Debug:**
```lua
:lua print(package.loaded["config.options"])  -- Check if loaded
:lua package.loaded["config.options"] = nil   -- Force unload
:lua require("config.options")                 -- Reload
```

**Fix:** Hot-reloader should be clearing `package.loaded[module]` before requiring

### Symptom: Errors about duplicate resources
```
Error: LSP client already attached
Error: Augroup already exists
```
**Cause:** Trying to reload non-idempotent code

**Fix:** Add to `exclude_patterns` or use proper cleanup/augroups
