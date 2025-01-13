-- Keymaps for search and replace with grug-far.nvim

local M = {}

M.setup = function()
	local which_key = require("which-key")
	local map = vim.keymap.set

	which_key.add({
		{
			"<leader>sf",
			function()
				require("grug-far").grug_far({ prefills = { paths = vim.fn.expand("%:p") } })
			end,
			desc = "Search and replace in buffer",
			mode = { "n" },
			silent = true,
			remap = false,
		},
	})
end

return M
