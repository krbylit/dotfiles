-- Highly configurable bookmarking plugin
-- https://github.com/ThePrimeagen/harpoon/tree/harpoon2

return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	---@type HarpoonSettings
	opts = {
		settings = {
			save_on_toggle = true,
			sync_on_ui_close = true,
			key = function()
				-- return vim.loop.cwd()
				-- NOTE: This let's us get harpoon list when in child dirs under project.
				return Snacks.git.get_root()
			end,
		},
	},
	-- Override default keys so they don't show in our main which-key menu
	keys = function()
		local harpoon = require("harpoon")
		local keys = {
			{
				"<leader>H",
				function()
					harpoon:list():add()
				end,
				desc = "Harpoon File",
			},
			{
				"<C-e>",
				function()
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end,
				desc = "Harpoon Quick Menu",
			},
		}
		for i = 1, 5 do
			table.insert(keys, {
				"<C-" .. i .. ">",
				function()
					harpoon:list():select(i)
				end,
				desc = "Harpoon to File " .. i,
			})
		end
		return keys
	end,
}
