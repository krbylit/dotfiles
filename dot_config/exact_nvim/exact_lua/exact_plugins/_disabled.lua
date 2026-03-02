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
  table.insert(disabled, { "folke/neoconf.nvim", enabled = false })
  table.insert(disabled, { "pwntester/octo.nvim", enabled = false })
  table.insert(disabled, { "folke/persistence.nvim", enabled = false })
  table.insert(disabled, { "glacambre/firenvim", enabled = false })
  table.insert(disabled, { "isakbm/gitgraph.nvim", enabled = false })
  table.insert(disabled, { "OXY2DEV/helpview.nvim", enabled = false })
  table.insert(disabled, { "nvim-mini/mini.map", enabled = false })
  -- table.insert(disabled, { "nvim-mini/mini.misc", enabled = false })
  -- table.insert(disabled, { "nvim-mini/mini.statusline", enabled = false })
  -- table.insert(disabled, { "nvim-mini/mini.tabline", enabled = false })
  table.insert(disabled, { "nvchad/showkeys", enabled = false })
  table.insert(disabled, { "leath-dub/snipe.nvim", enabled = false })
  table.insert(disabled, { "luukvbaal/statuscol.nvim", enabled = false })
  table.insert(disabled, { "krbylit/agentic.nvim", enabled = false })
  table.insert(disabled, { "carlos-algms/agentic.nvim", enabled = false })
  table.insert(disabled, { "stevearc/overseer.nvim", enabled = false })
  table.insert(disabled, { "folke/sidekick.nvim", enabled = false })
  table.insert(disabled, { "OXY2DEV/markview.nvim", enabled = false })
  table.insert(disabled, { "obsidian-nvim/obsidian.nvim", enabled = false })
  table.insert(disabled, { "mikavilpas/yazi.nvim", enabled = false })
  table.insert(disabled, { "HiPhish/rainbow-delimiters.nvim", enabled = false })
  table.insert(disabled, { "MeanderingProgrammer/render-markdown.nvim", enabled = false })
  table.insert(disabled, { "iamcco/markdown-preview.nvim", enabled = false })
  table.insert(disabled, { "hat0uma/csvview.nvim", enabled = false })
  table.insert(disabled, { "ahmedkhalf/project.nvim", enabled = false })
  -- table.insert(disabled, { "", enabled = false })
end

return disabled
