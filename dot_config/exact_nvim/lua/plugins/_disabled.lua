-- Plugins disabled in console Neovim use

if vim.g.started_by_firenvim then
	-- Additional plugins to disable when in Firenvim
	return {
		{ "echasnovski/mini.pairs", cond = false },
		{ "nvim-neo-tree/neo-tree.nvim", cond = false },
		{ "akinsho/bufferline.nvim", cond = false },
		{ "nvim-lualine/lualine.nvim", cond = false },
		{ "lukas-reineke/indent-blankline.nvim", cond = false },
		{ "ggandor/flit.nvim", cond = false },
		{ "glepnir/dashboard-nvim", cond = false },
		{ "leath-dub/snipe.nvim", cond = false },
		{ "echasnovski/mini.tabline", cond = false },
		{ "echasnovski/mini.statusline", cond = false },
		{ "echasnovski/mini.map", cond = false },
		{ "vhyrro/luarocks.nvim", cond = false },
		{ "OXY2DEV/helpview.nvim", cond = false },
		{ "nmac427/guess-indent.nvim", cond = false },
		{ "isakbm/gitgraph.nvim", cond = false },
		{ "folke/persistence.nvim", cond = false },
		{ "folke/neoconf.nvim", cond = false },
		{ "echasnovski/mini.files", cond = false },
		{ "ThePrimeagen/harpoon", cond = false },
		{ "ibhagwan/fzf-lua", cond = false },
		{ "xvzc/chezmoi.nvim", cond = false },
		{ "folke/drop.nvim", cond = false },
		{ "neovim/nvim-lspconfig", cond = false }, -- NOTE: may not work to disable this
		{ "folke/noice.nvim", cond = false }, -- NOTE: may not work to disable this
	}
else
	return {
		{ "echasnovski/mini.pairs", enabled = false },
		{ "nvim-neo-tree/neo-tree.nvim", enabled = false },
		{ "akinsho/bufferline.nvim", enabled = false },
		{ "nvim-lualine/lualine.nvim", enabled = false },
		{ "lukas-reineke/indent-blankline.nvim", enabled = false },
		{ "ggandor/flit.nvim", enabled = false },
		{ "glepnir/dashboard-nvim", enabled = false },
	}
end
