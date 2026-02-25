return {
  "bajor/nvim-raccoon",
  enabled = vim.env.IS_SSH ~= "1",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("raccoon").setup()
  end,
}
