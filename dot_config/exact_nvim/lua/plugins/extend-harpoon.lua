-- Highly configurable bookmarking plugin
-- https://github.com/ThePrimeagen/harpoon/tree/harpoon2
local harpoon = require("harpoon")

return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		settings = {
			save_on_toggle = true,
			sync_on_ui_close = true,
		},
	},
	-- Override default keys so they don't show in our main which-key menu
	keys = function()
		return {
			{
				"<C-e>",
				function()
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end,
			},
			{
				"<C-1>",
				function()
					harpoon:list():select(1)
				end,
			},
			{
				"<C-2>",
				function()
					harpoon:list():select(2)
				end,
			},
			{
				"<C-3>",
				function()
					harpoon:list():select(3)
				end,
			},
			{
				"<C-4>",
				function()
					harpoon:list():select(4)
				end,
			},
		}
	end,
}
