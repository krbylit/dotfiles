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

-- HACK: snacks.nvim bug — picker/config/highlights.lua calls
-- `Snacks.util.set_hl()` at module scope (not inside a function). When
-- lazy.nvim's install_missing phase loads the picker, this module gets
-- required before snacks' own init.lua has run `_G.Snacks = M`, so the
-- global is nil and Neovim errors with "attempt to index global 'Snacks'".
--
-- Fix: manually add snacks.nvim to rtp and require it before lazy.setup().
-- lazy.nvim hasn't added plugin paths to rtp yet at this point, so a bare
-- pcall(require, "snacks") would silently fail. By prepending the path
-- ourselves, require("snacks") succeeds and sets _G.Snacks, so the picker
-- highlights module finds the global when install_missing loads it later.
-- The fs_stat guard handles the first-ever launch when snacks isn't cloned.
local snacks_path = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
if vim.uv.fs_stat(snacks_path) then
  vim.opt.rtp:prepend(snacks_path)
  pcall(require, "snacks")
end

require("config.lazy")
