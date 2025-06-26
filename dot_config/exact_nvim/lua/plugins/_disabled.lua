-- Plugins disabled in normal and remote SSH Neovim
-- _disabled.lua
local disabled = {
    { "echasnovski/mini.pairs", enabled = false },
    { "nvim-neo-tree/neo-tree.nvim", enabled = false },
    { "akinsho/bufferline.nvim", enabled = false },
    { "nvim-lualine/lualine.nvim", enabled = false },
    { "lukas-reineke/indent-blankline.nvim", enabled = false },
    { "ggandor/flit.nvim", enabled = false },
    { "glepnir/dashboard-nvim", enabled = false },
}

-- NOTE: Alternative to disable based on SSH env. Can also set in plugin Lua file with
-- `enabled = vim.env.IS_SSH ~= "1"`
-- if vim.env.IS_SSH == "1" then
--     -- table.insert(disabled, { "nvim-treesitter/nvim-treesitter", enabled = false })
--     -- table.insert(disabled, { "folke/noice.nvim", enabled = false })
-- end

return disabled
