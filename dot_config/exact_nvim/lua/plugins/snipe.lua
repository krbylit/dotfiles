-- Simple buffer picker
-- https://github.com/leath-dub/snipe.nvim

return {
	"leath-dub/snipe.nvim",
	keys = {
		{
			"gb",
			function()
				require("snipe").open_buffer_menu()
				-- require("snipe").create_buffer_menu_toggler({
				-- Limit the width of path buffer names
				-- /my/long/path/is/really/annoying will be is/really/annoying (max of 3)
				-- max_path_width = 1,
				-- })()
			end,
			desc = "Open Snipe buffer menu",
		},
	},
	opts = {
		ui = {
			max_width = -1, -- -1 means dynamic width
			-- Where to place the ui window
			-- Can be any of "topleft", "bottomleft", "topright", "bottomright", "center", "cursor" (sets under the current cursor pos)
			position = "topright",
		},
		hints = {
			-- Charaters to use for hints (NOTE: make sure they don't collide with the navigation keymaps)
			dictionary = "sadflewcmpghio",
		},
		navigate = {
			-- When the list is too long it is split into pages
			-- `[next|prev]_page` options allow you to navigate
			-- this list
			next_page = "J",
			prev_page = "K",

			-- You can also just use normal navigation to go to the item you want
			-- this option just sets the keybind for selecting the item under the
			-- cursor
			under_cursor = "<cr>",

			-- In case you changed your mind, provide a keybind that lets you
			-- cancel the snipe and close the window.
			cancel_snipe = "q",
		},
	},
}
