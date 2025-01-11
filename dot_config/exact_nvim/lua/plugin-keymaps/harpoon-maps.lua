-- Keymaps for harpoon.nvim

local M = {}

M.setup = function()
	local map = vim.keymap.set
	local harpoon = require("harpoon")
	local which_key = require("which-key")

	-- basic telescope configuration
	harpoon:setup({})
	local conf = require("telescope.config").values
	local function toggle_telescope(harpoon_files)
		local file_paths = {}
		for _, item in ipairs(harpoon_files.items) do
			table.insert(file_paths, item.value)
		end

		require("telescope.pickers")
			.new({}, {
				prompt_title = "Harpoon",
				finder = require("telescope.finders").new_table({
					results = file_paths,
				}),
				previewer = conf.file_previewer({}),
				sorter = conf.generic_sorter({}),
			})
			:find()
	end

	which_key.add({
		{ "<leader>h", group = "Harpoon" },
		{
			"<leader>he",
			function()
				toggle_telescope(harpoon:list())
			end,
			desc = "Open Harpoon Telescope",
		},
		{
			"<leader>ha",
			function()
				harpoon:list():add()
			end,
			desc = "Add Current File to Harpoon",
		},
		{
			"<C-e>",
			function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end,
			desc = "Toggle Harpoon Quick Menu",
		},
		{
			"<C-1>",
			function()
				harpoon:list():select(1)
			end,
			desc = "Quick Select Harpoon Buffer 1",
		},
		{
			"<C-2>",
			function()
				harpoon:list():select(2)
			end,
			desc = "Quick Select Harpoon Buffer 2",
		},
		{
			"<C-3>",
			function()
				harpoon:list():select(3)
			end,
			desc = "Quick Select Harpoon Buffer 3",
		},
		{
			"<C-4>",
			function()
				harpoon:list():select(4)
			end,
			desc = "Quick Select Harpoon Buffer 4",
		},
		-- {
		-- 	"<C-S-K>",
		-- 	function()
		-- 		harpoon:list():prev()
		-- 	end,
		-- 	desc = "Harpoon Previous Buffer",
		-- },
		-- {
		-- 	"<C-S-J>",
		-- 	function()
		-- 		harpoon:list():next()
		-- 	end,
		-- 	desc = "Harpoon Next Buffer",
		-- },
	})
end

return M
