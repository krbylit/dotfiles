-- LazyDocker via Snacks terminal toggle
-- Toggles a fullscreen float running lazydocker inside zellij via the ldz
-- fish function. Session named lazydocker-<dir>-<pathHash> so reattaching
-- from the same directory reuses the existing session.
vim.keymap.set({ "n", "t" }, "<leader>ld", function()
  Snacks.terminal.toggle("ldz", {
    win = {
      position = "float",
      height = 0,
      width = 0,
      border = "rounded",
    },
    interactive = true,
    auto_close = true,
  })
end, { desc = "LazyDocker (zellij)" })

return {}
