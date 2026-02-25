if vim.env.IS_SSH == "1" then
  return { "Rtarun3606k/TakaTime", enabled = false }
end

return {
  "Rtarun3606k/TakaTime",
  lazy = false,
  config = function()
    -- Optional: Enable debug mode if you run into issues
    require("taka-time").setup({
      debug = false,
    })
  end,
}
