-- Plugin to help editing chezmoi managed config files
-- https://github.com/xvzc/chezmoi.nvim

return {
    "xvzc/chezmoi.nvim",
    enabled = vim.env.IS_SSH ~= "1",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "alker0/chezmoi.vim",
            enabled = vim.env.IS_SSH ~= "1",
        },
    },
    opts = {
        edit = {
            watch = false,
            force = false,
        },
        notification = {
            on_open = false,
            on_apply = true,
            on_watch = false,
        },
        telescope = {
            select = { "<CR>" },
        },
    },
}
