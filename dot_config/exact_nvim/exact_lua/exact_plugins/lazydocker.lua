return {
  "crnvl96/lazydocker.nvim",
  opts = function(_, opts)
    vim.keymap.set(
      { "n", "t" },
      "<leader>ld",
      "<Cmd>lua require('lazydocker').toggle({ engine = 'docker' })<CR>",
      { desc = "LazyDocker (docker)" }
    )
    opts = vim.tbl_deep_extend("force", opts or {}, {
      window = {
        settings = {
          width = 1, -- Percentage of screen width (0 to 1)
          height = 1, -- Percentage of screen height (0 to 1)
          border = "rounded", -- See ':h nvim_open_win' border options
          relative = "editor", -- See ':h nvim_open_win' relative options
        },
      },
    })
    return opts
  end,
}
