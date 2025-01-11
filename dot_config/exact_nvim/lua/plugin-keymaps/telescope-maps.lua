local M = {}

M.setup = function()
	local which_key = require("which-key")
	local map = vim.keymap.set

	which_key.add({
		{
			"<leader>t",
			-- keymap rhs can also be string
			function()
				require("telescope.builtin").resume()
			end,
			desc = "Open last Telescope",
			remap = false,
			silent = false,
			mode = { "n" },
			cond = function()
				return true
			end,
			hidden = false,
			icon = "",
		},
	})
end

return M
