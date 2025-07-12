-- Utility debugging functions (https://github.com/folke/snacks.nvim/blob/main/docs/debug.md)
-- Pretty print an object

-- -- NOTE: Enable to log profiling info after exit.
-- vim.cmd([[
--     profile start ~/.local/state/nvim/profile.log
--   profile func *
--   profile file *
-- ]])
_G.dd = function(...)
    Snacks.debug.inspect(...)
end
_G.bt = function()
    Snacks.debug.backtrace()
end
vim.print = _G.dd
require("config.lazy")
