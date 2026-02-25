return {
  "Rtarun3606k/TakaTime",
  enabled = vim.env.IS_SSH ~= "1",
  lazy = false,
  config = function()
    -- Optional: Enable debug mode if you run into issues
    require("taka-time").setup({
      debug = false,
    })
  end,
}
