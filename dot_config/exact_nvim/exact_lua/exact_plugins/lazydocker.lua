-- LazyDocker via Snacks terminal toggle
-- Toggles a fullscreen float running lazydocker inside zellij via the ldz
-- fish function. Session named lazydocker-<dir>-<pathHash> so reattaching
-- from the same directory reuses the existing session.
vim.keymap.set({ "n", "t" }, "<leader>dd", function()
  Snacks.terminal.toggle("ldz", {
    win = {
      position = "float",
      height = 0,
      width = 0,
      border = "rounded",
      keys = {
        hide = { "<c-/>", function(self) self:hide() end, mode = "t", desc = "Toggle lazydocker closed" },
      },
    },
    interactive = true,
    auto_close = true,
  })
end, { desc = "LazyDocker (zellij)" })

return {}
