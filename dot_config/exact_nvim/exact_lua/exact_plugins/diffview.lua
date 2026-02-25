if vim.env.IS_SSH == "1" then
  return {}
end

return {
  "sindrets/diffview.nvim",
  opts = { enhanced_diff_hl = true },
  keys = { { "<leader>gv", "<cmd>DiffviewFileHistory<cr>", desc = "Open Diffview file history" } },
}
