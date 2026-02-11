-- Utility debugging functions (https://github.com/folke/snacks.nvim/blob/main/docs/debug.md)
-- Pretty print an object

-- NOTE: Debugging utils
-- -- NOTE: Enable to log profiling info after exit.
-- vim.cmd([[
--     profile start ~/.local/state/nvim/profile.log
--   profile func *
--   profile file *
-- ]])

-- Hot reload function for individual modules
-- Use: `:lua R("plugins.statuscol"`
function R(name)
  package.loaded[name] = nil
  return require(name)
end

local function snapshot()
  -- Core metrics
  local n_maps = #vim.api.nvim_get_keymap("n")
  local n_autocmds = #vim.api.nvim_get_autocmds({})
  local mem_kb = collectgarbage("count")
  local active_lsp = #vim.lsp.get_clients()
  local diagnostics = 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    diagnostics = diagnostics + #vim.diagnostic.get(buf)
  end

  -- Buffer/window/tab counts
  local open_bufs = vim.api.nvim_list_bufs()
  local win_count = #vim.api.nvim_list_wins()
  local tab_count = #vim.api.nvim_list_tabpages()

  -- Build buffer table
  local buf_lines = { "buf # │ name                               │ listed │ loaded │ filetype" }
  for _, buf in ipairs(open_bufs) do
    local name = vim.api.nvim_buf_get_name(buf)
    local short = vim.fn.fnamemodify(name, ":~:.") -- shorter path
    local listed = vim.api.nvim_get_option_value("buflisted", { buf = buf })
    local loaded = vim.api.nvim_buf_is_loaded(buf)
    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
    table.insert(
      buf_lines,
      string.format(
        "%5d │ %-34s │ %-6s │ %-6s │ %s",
        buf,
        short:sub(1, 34),
        tostring(listed),
        tostring(loaded),
        ft
      )
    )
  end

  -- Collate and notify
  local header = (
    "Neovim State:\n"
    .. ("Keymaps: %d | Autocmds: %d | Mem: %.1f KB\n"):format(n_maps, n_autocmds, mem_kb)
    .. ("LSP clients: %d | Diags: %d | Buftotal: %d | Wins: %d | Tabs: %d\n\n"):format(
      active_lsp,
      diagnostics,
      #open_bufs,
      win_count,
      tab_count
    )
  )

  vim.notify(header .. table.concat(buf_lines, "\n"), vim.log.levels.INFO, { title = "Snapshot" })
end

vim.api.nvim_create_user_command("NvimSnapshot", snapshot, {})
-- Uncomment to print snapshot on startup, can be compared later if issues appear for diagnosis.
-- vim.schedule(snapshot)

_G.dd = function(...)
  Snacks.debug.inspect(...)
end
_G.bt = function()
  Snacks.debug.backtrace()
end
vim.print = _G.dd
require("utils.globals")

-- TODO: Unsure whether this is actually a reasonable solution
-- ================================================================
-- LSP EXIT FIX - Must run BEFORE Lazy.nvim loads
-- ================================================================
-- Fix: Clean up LspNotify autocmds and force stop LSP clients before exit
-- This prevents "Error in LspNotify Autocommands" and reduces quit delay
-- Combine with LspAttach autocmd in `extend-lspconfig.lua`
-- vim.api.nvim_create_autocmd("VimLeavePre", {
--   -- NOTE: Must be registered WITHOUT an augroup (global) to fire correctly
--   nested = true,
--   desc = "Force kill LSP processes before exit",
--   callback = function()
--     -- 1. Forcefully stop all LSP clients
--     local clients = vim.lsp.get_clients()
--     for _, client in ipairs(clients) do
--       -- Try to kill by PID if available (faster than graceful shutdown)
--       local pid = client.rpc and client.rpc.pid
--       if pid then
--         pcall(vim.uv.kill, pid, 9) -- SIGKILL
--       else
--         -- Fallback: force stop the client
--         pcall(vim.lsp.stop_client, client.id, true)
--       end
--     end
--
--     -- 2. Clean up LspNotify autocmds to prevent errors
--     local lsp_aus = vim.api.nvim_get_autocmds({ event = "LspNotify" })
--     for _, au in ipairs(lsp_aus) do
--       pcall(vim.api.nvim_del_autocmd, au.id)
--     end
--   end,
-- })

require("config.lazy")
