-- TODO: config tabby or get rid of it
-- Tab display line and management
-- https://github.com/nanozuki/tabby.nvim

-- FIXME: doesn't seem to be working currently
return {
	-- "nanozuki/tabby.nvim",
	-- event = 'VimEnter', -- if you want lazy load, see below
	-- dependencies = "nvim-tree/nvim-web-devicons",
	-- opts = {
	-- 	preset = "active_wins_at_tail",
	-- 	option = {
	-- 		theme = {
	-- 			fill = "TabLineFill", -- tabline background
	-- 			head = "TabLine", -- head element highlight
	-- 			current_tab = "TabLineSel", -- current tab label highlight
	-- 			tab = "TabLine", -- other tab label highlight
	-- 			win = "TabLine", -- window highlight
	-- 			tail = "TabLine", -- tail element highlight
	-- 		},
	-- 		nerdfont = true, -- whether use nerdfont
	-- 		-- lualine_theme = nil, -- lualine theme name
	-- 		tab_name = {
	-- 			name_fallback = function(tabid)
	-- 				return tabid
	-- 			end,
	-- 		},
	-- 		buf_name = {
	-- 			mode = "'unique'|'relative'|'tail'|'shorten'",
	-- 		},
	-- 	},
	-- },
	-- opts = {
	-- 	preset = "active_wins_at_tail",
	-- 	option = {
	-- 		theme = {
	-- 			fill = "TabLineFill", -- tabline background
	-- 			head = "TabLine", -- head element highlight
	-- 			current_tab = "TabLineSel", -- current tab label highlight
	-- 			tab = "TabLine", -- other tab label highlight
	-- 			win = "TabLine", -- window highlight
	-- 			tail = "TabLine", -- tail element highlight
	-- 		},
	-- 		nerdfont = true, -- whether use nerdfont
	-- 		lualine_theme = nil, -- lualine theme name
	-- 		tab_name = {
	-- 			name_fallback = function(tabid)
	-- 				return tabid
	-- 			end,
	-- 		},
	-- 		buf_name = {
	-- 			mode = "'unique'|'relative'|'tail'|'shorten'",
	-- 		},
	-- 	},
	-- },
	-- config = function()
	-- 	local palette = require("features.ui.colors").palette
	-- 	local filename = require("tabby.filename")
	-- 	local cwd = function()
	-- 		return " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. " "
	-- 	end
	-- 	local tabname = function(tabid)
	-- 		return vim.api.nvim_tabpage_get_number(tabid)
	-- 	end
	-- 	local line = {
	-- 		hl = { fg = palette.fg, bg = palette.bg },
	-- 		layout = "active_wins_at_tail",
	-- 		head = {
	-- 			{ cwd, hl = { fg = palette.bg, bg = palette.accent } },
	-- 			{ "", hl = { fg = palette.accent, bg = palette.bg } },
	-- 		},
	-- 		active_tab = {
	-- 			label = function(tabid)
	-- 				return {
	-- 					"  " .. tabname(tabid) .. " ",
	-- 					hl = { fg = palette.bg, bg = palette.accent_sec, style = "bold" },
	-- 				}
	-- 			end,
	-- 			left_sep = { "", hl = { fg = palette.accent_sec, bg = palette.bg } },
	-- 			right_sep = { "", hl = { fg = palette.accent_sec, bg = palette.bg } },
	-- 		},
	-- 		inactive_tab = {
	-- 			label = function(tabid)
	-- 				return {
	-- 					"  " .. tabname(tabid) .. " ",
	-- 					hl = { fg = palette.fg, bg = palette.bg_sec, style = "bold" },
	-- 				}
	-- 			end,
	-- 			left_sep = { "", hl = { fg = palette.bg_sec, bg = palette.bg } },
	-- 			right_sep = { "", hl = { fg = palette.bg_sec, bg = palette.bg } },
	-- 		},
	-- 		top_win = {
	-- 			label = function(winid)
	-- 				return {
	-- 					"  " .. filename.unique(winid) .. " ",
	-- 					hl = { fg = palette.fg, bg = palette.bg_sec },
	-- 				}
	-- 			end,
	-- 			left_sep = { "", hl = { fg = palette.bg_sec, bg = palette.bg } },
	-- 			right_sep = { "", hl = { fg = palette.bg_sec, bg = palette.bg } },
	-- 		},
	-- 		win = {
	-- 			label = function(winid)
	-- 				return {
	-- 					"  " .. filename.unique(winid) .. " ",
	-- 					hl = { fg = palette.fg, bg = palette.bg_sec },
	-- 				}
	-- 			end,
	-- 			left_sep = { "", hl = { fg = palette.bg_sec, bg = palette.bg } },
	-- 			right_sep = { "", hl = { fg = palette.bg_sec, bg = palette.bg } },
	-- 		},
	-- 		tail = {
	-- 			{ "", hl = { fg = palette.accent_sec, bg = palette.bg } },
	-- 			{ "  ", hl = { fg = palette.bg, bg = palette.accent_sec } },
	-- 		},
	-- 	}
	-- 	require("tabby").setup({ tabline = line })
	-- end,
}
