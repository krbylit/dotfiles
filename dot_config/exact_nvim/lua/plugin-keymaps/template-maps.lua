local M = {}

M.setup = function()
	local which_key = require("which-key")
	local map = vim.keymap.set

	which_key.add({
		-- Add keymap group
		{ "<leader>", group = "Group name" },
		-- Add keymaps
		{
			"<leader>",
			-- keymap rhs can also be string
			-- ":lua require('module').function()<CR>", -- This one doesn't work well
			-- "<cmd>command<CR>",
			function()
				return command
			end,
			desc = "Open Harpoon Telescope",
			remap = false,
			silent = true,
			mode = { "n" },
			group = "",
			cond = function()
				return true
			end,
			hidden = false,
			icon = "",
		},
	})
end

return M
