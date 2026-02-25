if vim.env.IS_SSH == "1" then
  return {}
end

return {
  "HiPhish/rainbow-delimiters.nvim",
  config = function()
    ---@type rainbow_delimiters.config
    require("rainbow-delimiters.setup").setup({
      -- strategy = {
      --   [""] = "rainbow-delimiters.strategy.global",
      --   commonlisp = "rainbow-delimiters.strategy.local",
      -- },
      -- query = {
      --   [""] = "rainbow-delimiters",
      --   latex = "rainbow-blocks",
      -- },
      highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterYellow",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
      },
      -- blacklist = { "c", "cpp" },
    })
  end,
}
