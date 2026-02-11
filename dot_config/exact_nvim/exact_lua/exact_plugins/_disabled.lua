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
if vim.env.IS_SSH == "1" then
  table.insert(disabled, { "zbirenbaum/copilot.lua", enabled = false })
  table.insert(disabled, { "danilamihailov/beacon.nvim", enabled = false })
  table.insert(disabled, { "folke/drop.nvim", enabled = false })
  table.insert(disabled, { "saghen/blink.cmp", enabled = false })
  table.insert(disabled, { "saghen/blink.compat", enabled = false })
  table.insert(disabled, { "mikavilpas/blink-ripgrep.nvim", enabled = false })
  table.insert(disabled, { "xvzc/chezmoi.nvim", enabled = false })
  table.insert(disabled, { "alker0/chezmoi.vim", enabled = false })
  table.insert(disabled, { "CopilotC-Nvim/CopilotChat.nvim", enabled = false })
  table.insert(disabled, { "theHamsta/nvim-dap-virtual-text", enabled = false })
  table.insert(disabled, { "mfussenegger/nvim-dap", enabled = false })
  table.insert(disabled, { "ThePrimeagen/harpoon", enabled = false })
  table.insert(disabled, { "nvim-mini/mini.animate", enabled = false })
  table.insert(disabled, { "nvim-mini/mini.files", enabled = false })
  table.insert(disabled, { "folke/neoconf.nvim", enabled = false })
  table.insert(disabled, { "pwntester/octo.nvim", enabled = false })
  -- table.insert(disabled, { "folke/persistence.nvim", enabled = false })
  table.insert(disabled, { "glacambre/firenvim", enabled = false })
  table.insert(disabled, { "isakbm/gitgraph.nvim", enabled = false })
  table.insert(disabled, { "OXY2DEV/helpview.nvim", enabled = false })
  -- table.insert(disabled, { "OXY2DEV/markview.nvim", enabled = false })
  table.insert(disabled, { "nvim-mini/mini.map", enabled = false })
  -- table.insert(disabled, { "nvim-mini/mini.misc", enabled = false })
  -- table.insert(disabled, { "nvim-mini/mini.statusline", enabled = false })
  -- table.insert(disabled, { "nvim-mini/mini.tabline", enabled = false })
  table.insert(disabled, { "epwalsh/obsidian.nvim", enabled = false })
  table.insert(disabled, { "nvchad/showkeys", enabled = false })
  table.insert(disabled, { "leath-dub/snipe.nvim", enabled = false })
  table.insert(disabled, { "luukvbaal/statuscol.nvim", enabled = false })
  table.insert(disabled, { "krbylit/agentic.nvim", enabled = false })
  table.insert(disabled, { "carlos-algms/agentic.nvim", enabled = false })
  table.insert(disabled, { "stevearc/overseer.nvim", enabled = false })
  table.insert(disabled, { "folke/sidekick.nvim", enabled = false })
  -- table.insert(disabled, { "", enabled = false })
end

return disabled
