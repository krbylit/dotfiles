return {
  "sindrets/diffview.nvim",
  enabled = vim.env.IS_SSH ~= "1",
  opts = { enhanced_diff_hl = true },
  keys = { { "<leader>gv", "<cmd>DiffviewFileHistory<cr>", desc = "Open Diffview file history" } },
}
