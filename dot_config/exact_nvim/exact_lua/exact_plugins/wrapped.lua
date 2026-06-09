if vim.env.IS_SSH == "1" then
  return { "aikhe/wrapped.nvim", enabled = false }
end

return {
  "aikhe/wrapped.nvim",
  dependencies = { "nvzone/volt" },
  cmd = { "WrappedNvim" },
  opts = {
    path = (vim.g.chezmoi_source_path or (vim.env.HOME .. "/.local/share/chezmoi")) .. "/dot_config/exact_nvim",
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
