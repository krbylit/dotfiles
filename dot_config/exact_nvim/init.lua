-- Utility debugging functions (https://github.com/folke/snacks.nvim/blob/main/docs/debug.md)
-- Pretty print an object

-- NOTE: Debugging utils
-- -- NOTE: Enable to log profiling info after exit.
-- vim.cmd([[
--     profile start ~/.local/state/nvim/profile.log
--   profile func *
--   profile file *
-- ]])

local function snapshot()
    local n_maps = #vim.api.nvim_get_keymap("n")
    local n_autocmds = #vim.api.nvim_get_autocmds({})
    local mem_kb = collectgarbage("count")
    local active_lsp = vim.lsp.get_active_clients()
    local diagnostics_count = 0
    -- Diagnostics count for all listed buffers
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        diagnostics_count = diagnostics_count + #vim.diagnostic.get(buf)
    end
    vim.notify(
        (
            "Neovim State:\n"
            .. "Keymaps: %d\n"
            .. "Autocmds: %d\n"
            .. "Lua memory: %.1f KB\n"
            .. "Active LSP clients: %d\n"
            .. "Diagnostics: %d"
        ):format(n_maps, n_autocmds, mem_kb, #active_lsp, diagnostics_count)
    )
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
require("config.lazy")
