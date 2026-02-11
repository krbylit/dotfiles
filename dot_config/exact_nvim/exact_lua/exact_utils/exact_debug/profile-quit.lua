-- Temporary: Profile what's taking time during quit
-- This will log timing information to help identify slow operations

local log_file = "/tmp/nvim-quit-profile.log"

-- Clear log on startup
vim.fn.writefile({ "=== QUIT PROFILE SESSION " .. os.date("%Y-%m-%d %H:%M:%S") .. " ===" }, log_file)

local function log_msg(msg)
  vim.fn.writefile(vim.split(msg, "\n"), log_file, "a")
end

local start_time = vim.loop.hrtime()

local function log_timing(event_name)
  local elapsed_ms = (vim.loop.hrtime() - start_time) / 1000000
  log_msg(string.format("[+%.1fms] %s", elapsed_ms, event_name))
end

-- Profile key exit events
-- Run FIRST to log when VimLeavePre starts
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("profile_quit_first", { clear = true }),
  callback = function()
    log_timing("VimLeavePre started (first handler)")

    -- Log active LSP clients
    local clients = vim.lsp.get_clients()
    log_msg(string.format("  Active LSP clients: %d", #clients))
    for _, client in ipairs(clients) do
      log_msg(string.format("    - %s (id: %d)", client.name, client.id))
    end

    -- Log loaded plugins (this might be slow)
    local lazy_ok, lazy = pcall(require, "lazy")
    if lazy_ok then
      local loaded = vim.tbl_filter(function(plugin)
        return plugin._.loaded
      end, lazy.plugins())
      log_msg(string.format("  Loaded plugins: %d", #loaded))
    end

    -- Log all VimLeavePre autocmds to see what's registered
    local leave_aus = vim.api.nvim_get_autocmds({ event = "VimLeavePre" })
    log_msg(string.format("  VimLeavePre handlers: %d", #leave_aus))
    for i, au in ipairs(leave_aus) do
      if i <= 10 then -- Only log first 10 to avoid spam
        log_msg(string.format("    - Group: %s, Desc: %s", au.group_name or "nil", au.desc or "nil"))
      end
    end
  end,
})

-- Profile BEFORE VimLeavePre handlers complete
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    log_timing("VimLeavePre finishing (this handler runs last)")
  end,
})

vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    log_timing("VimLeave triggered")

    -- Check if LSP clients are still running
    local clients = vim.lsp.get_clients()
    if #clients > 0 then
      log_msg(string.format("  WARNING: %d LSP clients still active!", #clients))
      for _, client in ipairs(clients) do
        log_msg(string.format("    - %s (id: %d)", client.name, client.id))
      end
    else
      log_msg("  All LSP clients stopped cleanly")
    end
  end,
})

-- Track when the quit command is issued (approximate)
vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    log_timing("QuitPre - user issued quit command")
  end,
})

-- Track buffer deletion during exit
local buf_delete_count = 0
vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
  callback = function(ev)
    buf_delete_count = buf_delete_count + 1
    if buf_delete_count == 1 then
      log_timing("First buffer being deleted")
    end
  end,
})

-- Log when specific slow plugins trigger their exit handlers
local slow_plugins = { "persistence", "copilot", "null-ls", "noice" }
for _, plugin_name in ipairs(slow_plugins) do
  vim.api.nvim_create_autocmd("User", {
    pattern = plugin_name .. "*",
    callback = function(ev)
      log_timing(string.format("User event: %s", ev.match))
    end,
  })
end

return {}
