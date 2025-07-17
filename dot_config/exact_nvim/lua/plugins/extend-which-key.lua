-- HACK: This fixes it so that which-key menu always shows up when localleader is pressed. Otherwise leader must be pressed at least once in the buffer for localleader menu to show.
-- https://github.com/folke/which-key.nvim/issues/172
vim.keymap.set(
    "n",
    "<localleader>???",
    ":lua print(string.format('localleader is %s', vim.g.maplocalleader))<CR>",
    { desc = "print localleader" }
)
return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        preset = "helix",
        delay = function(ctx)
            return ctx.plugin and 0 or 200
        end,
        win = {
            no_overlap = true,
            padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
            title = true,
            title_pos = "center",
            zindex = 1000,
        },
    },
}
