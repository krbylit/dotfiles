-- Fancy formatting for :help files
-- https://github.com/OXY2DEV/helpview.nvim

-- disabling for now b/c there's odd behavior with conceals and often have to toggle `conceallevel` to read full docs
return {
	"OXY2DEV/helpview.nvim",
	lazy = false, -- Recommended

	-- In case you still want to lazy load
	-- ft = "help",

	dependencies = {
		-- "neovim/tree-sitter-vimdoc",
		{
			"nvim-treesitter/nvim-treesitter",
		},
	},
}
