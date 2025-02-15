-- Displays keystrokes on screen
-- https://github.com/NvChad/showkeys
---@type LazySpec
return {
	"nvchad/showkeys",
	cmd = "ShowkeysToggle",
	opts = {
		timeout = 1,
		maxkeys = 5,
		show_count = false,
		-- bottom-left, bottom-right, bottom-center, top-left, top-right, top-center
		position = "bottom-right",
	},
	keys = {
		{
			"<leader>uk",
			"<cmd>ShowkeysToggle<CR>",
			desc = "Toggle ShowKeys",
		},
	},
}
