-- Import and optionally enable config hot-reload utility
-- Enable this during active config development for instant feedback
-- local hot_reload = require("utils.config-hot-reload")

return {
  -- hot_reload.setup({
  --   enabled = false, -- Set to true to enable hot-reload during config development
  --   debounce_ms = 200,
  --   watch_dirs = {
  --     vim.fn.stdpath("config") .. "/lua/config",
  --     vim.fn.stdpath("config") .. "/lua/utils",
  --     -- Reloading plugins/ has limitations - see config-hot-reload.lua for details
  --     -- Uncomment if editing simple plugin extensions and understand the risks:
  --     -- vim.fn.stdpath("config") .. "/lua/plugins",
  --   },
  --   notify_on_reload = true,
  -- }),

  -- Manual toggle command: :lua require("utils.config-hot-reload").toggle()

  -- Register palette viewer commands (:TokyonightColors, :CatppuccinColors, :TeideColors)
  require("utils.colors.color-utils").setup(),
}
