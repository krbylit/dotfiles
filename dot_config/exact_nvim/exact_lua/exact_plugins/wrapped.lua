return {
  "aikhe/wrapped.nvim",
  enabled = vim.env.IS_SSH ~= "1",
  dependencies = { "nvzone/volt" },
  cmd = { "WrappedNvim" },
  opts = {
    path = vim.g.chezmoi_source_path,
    border = false,
    size = {
      width = 120,
      height = 40,
    },
    exclude_filetype = {
      ".gitmodules",
    },
    cap = {
      commits = 1000,
      plugins = 100,
      plugins_ever = 200,
      lines = 10000,
    },
  },
}
