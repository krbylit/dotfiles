return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "helix",
		delay = function(ctx)
			return ctx.plugin and 0 or 200
		end,
		win = {
			no_overlap = true,
			padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
			title = true,
			title_pos = "center",
			zindex = 1000,
		},
	},
}
