return {
    "vhyrro/luarocks.nvim",
    enabled = vim.env.IS_SSH ~= "1",
    priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
    config = true,
}
