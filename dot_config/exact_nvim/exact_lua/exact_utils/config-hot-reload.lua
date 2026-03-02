-- Hot-reload Neovim configuration files on change
-- Watches lua/ directory and reloads changed modules for instant feedback

local M = {}

-- State tracking
local watchers = {}
local reload_debounce_timer = nil
local pending_reloads = {}

---@class HotReloadConfig
---@field enabled boolean
---@field debounce_ms number
---@field watch_dirs string[]
---@field exclude_patterns string[]
---@field notify_on_reload boolean

-- Default configuration
M.config = {
  enabled = false, -- Disabled by default - enable in plugins/_utils.lua
  debounce_ms = 200, -- Wait 200ms after last change before reloading
  watch_dirs = {
    vim.fn.stdpath("config") .. "/lua/config",
    vim.fn.stdpath("config") .. "/lua/utils",
    -- NOTE: Reloading plugins/ is EXPERIMENTAL and has limitations:
    -- - Plugin setup() functions may not be idempotent (safe to run multiple times)
    -- - Lazy.nvim specs are declarative - just reloading module won't re-run lazy processing
    -- - Autocmds without augroups will duplicate
    -- - Keymaps might duplicate
    -- - LSP/Treesitter configs shouldn't be reloaded
    -- RECOMMENDATION: Only enable if editing simple plugin extension files (extend-*.lua)
    -- vim.fn.stdpath("config") .. "/lua/plugins",
  },
  exclude_patterns = {
    "%.git/",
    "%.DS_Store",
    "/%..*$", -- Hidden files
    "%.swp$",
    "%.swo$",
    "%.tmp$",
    -- Recommended exclusions if watching plugins/:
    -- "lspconfig", -- LSP clients shouldn't be reloaded
    -- "treesitter", -- Parsers are already loaded
    -- "mason", -- Tool installations can't be reloaded
  },
  notify_on_reload = true,
}

-- Convert file path to Lua module name
local function filepath_to_module(filepath, config_root)
  -- Remove config root prefix
  local relative = filepath:gsub("^" .. vim.pesc(config_root) .. "/lua/", "")
  -- Remove .lua extension
  relative = relative:gsub("%.lua$", "")
  -- Convert path separators to dots
  local module = relative:gsub("/", ".")
  return module
end

-- Check if file should be excluded
local function should_exclude(filepath)
  for _, pattern in ipairs(M.config.exclude_patterns) do
    if filepath:match(pattern) then
      return true
    end
  end
  return false
end

-- Reload a Lua module
local function reload_module(module_name)
  -- Unload module from package.loaded
  package.loaded[module_name] = nil

  -- Attempt to reload
  local success, err = pcall(require, module_name)

  if success then
    if M.config.notify_on_reload then
      vim.notify(string.format("✓ Reloaded: %s", module_name), vim.log.levels.INFO)
    end
    return true
  else
    vim.notify(string.format("✗ Failed to reload %s:\n%s", module_name, err), vim.log.levels.ERROR)
    return false
  end
end

-- Process pending reloads (debounced)
local function process_reloads()
  if #pending_reloads == 0 then
    return
  end

  -- Get unique modules to reload
  local modules_to_reload = {}
  for _, module in ipairs(pending_reloads) do
    modules_to_reload[module] = true
  end

  -- Clear pending list
  pending_reloads = {}

  -- Reload each module
  local success_count = 0
  local total_count = 0

  for module, _ in pairs(modules_to_reload) do
    total_count = total_count + 1
    if reload_module(module) then
      success_count = success_count + 1
    end
  end

  if M.config.notify_on_reload and total_count > 0 then
    vim.notify(
      string.format("Config reload: %d/%d modules successful", success_count, total_count),
      success_count == total_count and vim.log.levels.INFO or vim.log.levels.WARN
    )
  end
end

-- Schedule a module for reload (with debouncing)
local function schedule_reload(module_name)
  -- Add to pending reloads
  table.insert(pending_reloads, module_name)

  -- Cancel existing timer
  if reload_debounce_timer then
    reload_debounce_timer:stop()
    reload_debounce_timer:close()
  end

  -- Create new debounce timer
  reload_debounce_timer = vim.loop.new_timer()
  reload_debounce_timer:start(M.config.debounce_ms, 0, vim.schedule_wrap(function()
    process_reloads()
    if reload_debounce_timer then
      reload_debounce_timer:close()
      reload_debounce_timer = nil
    end
  end))
end

-- Start watching a directory
local function watch_directory(dir_path)
  if watchers[dir_path] then
    return -- Already watching
  end

  local watcher = vim.loop.new_fs_event()
  local config_root = vim.fn.stdpath("config")

  local success = watcher:start(
    dir_path,
    { recursive = true },
    vim.schedule_wrap(function(err, filename, events)
      if err then
        vim.notify(string.format("Config watcher error in %s: %s", dir_path, err), vim.log.levels.ERROR)
        return
      end

      -- Build full path
      local full_path = dir_path .. "/" .. filename

      -- Skip if file should be excluded
      if should_exclude(full_path) then
        return
      end

      -- Only handle .lua files
      if not full_path:match("%.lua$") then
        return
      end

      -- Only reload on file changes (not renames/deletes)
      if events.change then
        -- Convert to module name
        local module_name = filepath_to_module(full_path, config_root)

        -- Schedule reload
        schedule_reload(module_name)
      end
    end)
  )

  if success then
    watchers[dir_path] = watcher
    vim.notify(string.format("👁  Watching: %s", dir_path), vim.log.levels.INFO)
  else
    vim.notify(string.format("Failed to watch: %s", dir_path), vim.log.levels.ERROR)
  end
end

-- Stop watching a directory
local function stop_watching(dir_path)
  local watcher = watchers[dir_path]
  if watcher then
    watcher:stop()
    watchers[dir_path] = nil
  end
end

-- Start hot-reload system
function M.start()
  if not M.config.enabled then
    vim.notify("Hot-reload is disabled. Enable in config first.", vim.log.levels.WARN)
    return
  end

  -- Stop any existing watchers
  M.stop()

  -- Start watching configured directories
  for _, dir in ipairs(M.config.watch_dirs) do
    if vim.fn.isdirectory(dir) == 1 then
      watch_directory(dir)
    else
      vim.notify(string.format("Directory not found: %s", dir), vim.log.levels.WARN)
    end
  end

  vim.notify("🔥 Hot-reload enabled", vim.log.levels.INFO)
end

-- Stop hot-reload system
function M.stop()
  -- Stop all watchers
  for dir_path, _ in pairs(watchers) do
    stop_watching(dir_path)
  end

  -- Cancel pending reloads
  if reload_debounce_timer then
    reload_debounce_timer:stop()
    reload_debounce_timer:close()
    reload_debounce_timer = nil
  end

  pending_reloads = {}

  vim.notify("Hot-reload stopped", vim.log.levels.INFO)
end

-- Toggle hot-reload
function M.toggle()
  if next(watchers) ~= nil then
    M.stop()
  else
    M.start()
  end
end

-- Setup with custom config
function M.setup(user_config)
  M.config = vim.tbl_deep_extend("force", M.config, user_config or {})

  -- Auto-start if enabled
  if M.config.enabled then
    M.start()
  end

  -- Cleanup on exit
  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = M.stop,
  })
end

return M
