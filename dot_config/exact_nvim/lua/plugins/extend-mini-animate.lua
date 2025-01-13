-- Provides UI animations
-- https://github.com/echasnovski/mini.animate
-- Scroll and resize animations actually change Neovim state to achieve their effects and are asynchronous. This can cause following issues:
-- If you have remapped any movement operation to center after it is done (like with nzvzz or <C-d>zz), you need to change those mappings. Either remove them or update to use MiniAnimate.execute_after() (see :h MiniAnimate.config.scroll)
-- Using mouse wheel to scroll can appear slower or can have visual jitter. This usually happens due to high number of wheel turns per second: each turn is taking over previous one to start new animation. To mitigate this, you can either modify 'mousescroll' option (set vertical scroll to 1 and use high turn speed or set to high value and use one turn at a time) or config.scroll to fine tune when/how scroll animation is done.

return {
	"echasnovski/mini.animate",
	version = false,
	-- cond = function()
	-- 	-- return vim.bo.filetype ~= "snacks_dashboard"
	-- 	return false
	-- end,
	opts = {
		-- Cursor path
		cursor = {
			-- Whether to enable this animation
			-- enable = true,
			enable = false,

			-- Timing of animation (how steps will progress in time)
			-- timing = --<function: implements linear total 250ms animation duration>,

			-- Path generator for visualized cursor movement
			-- path = --<function: implements shortest line path>,
		},

		-- Vertical scroll
		scroll = {
			-- Whether to enable this animation
			enable = false,

			-- Timing of animation (how steps will progress in time)
			-- timing = --<function: implements linear total 250ms animation duration>,

			-- Subscroll generator based on total scroll
			-- subscroll = --<function: implements equal scroll with at most 60 steps>,
		},

		-- Window resize
		resize = {
			-- Whether to enable this animation
			enable = true,

			-- Timing of animation (how steps will progress in time)
			-- timing = --<function: implements linear total 250ms animation duration>,

			-- Subresize generator for all steps of resize animations
			-- subresize = --<function: implements equal linear steps>,
		},

		-- Window open
		open = {
			-- Whether to enable this animation
			enable = true,

			-- Timing of animation (how steps will progress in time)
			-- timing = --<function: implements linear total 250ms animation duration>,

			-- Floating window config generator visualizing specific window
			-- winconfig = --<function: implements static window for 25 steps>,

			-- 'winblend' (window transparency) generator for floating window
			-- winblend = --<function: implements equal linear steps from 80 to 100>,
		},

		-- Window close
		close = {
			-- Whether to enable this animation
			enable = true,

			-- Timing of animation (how steps will progress in time)
			-- timing = --<function: implements linear total 250ms animation duration>,

			-- Floating window config generator visualizing specific window
			-- winconfig = --<function: implements static window for 25 steps>,

			-- 'winblend' (window transparency) generator for floating window
			-- winblend = --<function: implements equal linear steps from 80 to 100>,
		},
	},
}
