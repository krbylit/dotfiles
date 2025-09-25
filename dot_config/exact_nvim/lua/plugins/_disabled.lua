-- Plugins disabled in normal and remote SSH Neovim
-- _disabled.lua
local disabled = {
    { "nvim-mini/mini.pairs", enabled = false },
    { "nvim-neo-tree/neo-tree.nvim", enabled = false },
    { "akinsho/bufferline.nvim", enabled = false },
    { "nvim-lualine/lualine.nvim", enabled = false },
    { "lukas-reineke/indent-blankline.nvim", enabled = false },
    { "ggandor/flit.nvim", enabled = false },
    { "nvimdev/dashboard-nvim", enabled = false },
    -- FIXME: Disabling SchemaStore for now as it loads a massive amount of schemas on LSP attach and slows things down, particularly slowing quitting nvim.
    -- Disabling in `extend-lspconfig.lua` did not seem to stop it either.
    -- { "b0o/SchemaStore.nvim", enabled = false },
}

-- NOTE: Alternative to disable based on SSH env. Can also set in plugin Lua file with
-- `enabled = vim.env.IS_SSH ~= "1"`
-- if vim.env.IS_SSH == "1" then
--     -- table.insert(disabled, { "nvim-treesitter/nvim-treesitter", enabled = false })
--     -- table.insert(disabled, { "folke/noice.nvim", enabled = false })
-- end

return disabled
