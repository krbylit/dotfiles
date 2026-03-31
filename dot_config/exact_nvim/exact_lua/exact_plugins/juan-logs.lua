return {
  "minigian/juan-logs.nvim",
  -- TODO: try again later; currently this is putting files into edited (as though it had changes) state upon open
  enabled = false,
  build = "cargo build --release",
  config = function()
    require("juanlog").setup({
      threshold_size = 1024 * 1024 * 100, -- 100MB
      mode = "dynamic",
      lazy = true, -- background indexing. prevents neovim from freezing on 50GB files
      patterns = { "*.log", "*.txt", "*.csv", "*.json" }, -- Use the plugin for these filetypes
      enable_custom_statuscol = true, -- fakes absolute line numbers
      syntax = false, -- set to true to enable native vim syntax (can be slow on huge files)
    })
  end,
}
