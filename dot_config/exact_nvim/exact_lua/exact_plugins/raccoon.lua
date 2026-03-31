if vim.env.IS_SSH == "1" then
  return { "bajor/nvim-raccoon", enabled = false }
end

return {
  "bajor/nvim-raccoon",
  enabled = false,
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("raccoon").setup()
  end,
}
