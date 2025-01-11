-- Highly configurable bookmarking plugin
-- https://github.com/ThePrimeagen/harpoon/tree/harpoon2

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
}
