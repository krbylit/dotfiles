-- LazyDocker via Snacks terminal toggle.
-- Run the Fish helper explicitly so first-open startup still goes through the
-- custom zellij session naming and compose-root detection logic in `ldz`.
vim.keymap.set({ "n", "t" }, "<leader>dd", function()
  Snacks.terminal.toggle({ "fish", "-ic", "ldz" }, {
    win = {
      position = "float",
      height = 0,
      width = 0,
      border = "rounded",
      keys = {
        hide = {
          "<c-/>",
          function(self)
            self:hide()
          end,
          mode = "t",
          desc = "Toggle lazydocker closed",
        },
      },
    },
    interactive = true,
    auto_close = true,
  })
end, { desc = "LazyDocker (zellij)" })

return {}
