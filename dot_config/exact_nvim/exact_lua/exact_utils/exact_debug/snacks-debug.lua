-- Snacks.nvim debug utilities
-- Provides _G.dd, _G.bt, and vim.print override
-- These reference Snacks lazily to avoid nil errors during install_missing

_G.dd = function(...)
  if Snacks then
    Snacks.debug.inspect(...)
  else
    vim.print(...)
  end
end

_G.bt = function()
  if Snacks then
    Snacks.debug.backtrace()
  else
    vim.notify("Snacks not loaded yet", vim.log.levels.WARN)
  end
end

vim.print = _G.dd
