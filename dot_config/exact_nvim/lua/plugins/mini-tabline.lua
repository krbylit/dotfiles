local colors = require("tokyonight.colors").setup({ style = "night" } )
-- local colors = require("tokyonight").load({ style = "night" })

return {
	"echasnovski/mini.tabline",
	version = false,
	dependencies = { "echasnovski/mini.icons" },
	-- cond = function()
	-- 	return vim.bo.filetype ~= "snacks_dashboard"
	-- end,
	config = function()
		vim.api.nvim_set_hl(
			0,
			"MiniTablineCurrent",
			{ fg = colors.teal, bg = colors.bg_highlight, italic = true, underline = false }
		)
		vim.api.nvim_set_hl(
			0,
			"MiniTablineVisible",
			{ fg = colors.fg_dark, bg = colors.bg_dark, italic = false, underline = false }
		)
		vim.api.nvim_set_hl(
			0,
			"MiniTablineHidden",
			{ fg = colors.fg_dark, bg = colors.bg_dark, italic = false, underline = false }
		)
		vim.api.nvim_set_hl(
			0,
			"MiniTablineModifiedCurrent",
			{ fg = colors.red, bg = colors.bg_highlight, italic = true }
		)
		vim.api.nvim_set_hl(0, "MiniTablineModifiedVisible", { fg = colors.red, bg = colors.bg_dark })
		vim.api.nvim_set_hl(0, "MiniTablineModifiedHidden", { fg = colors.red, bg = colors.bg_dark })
		vim.api.nvim_set_hl(0, "MiniTablineFill", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "MiniTablineTabpagesection", { fg = colors.orange, bg = colors.bg_highlight })
		local MiniTabline = require("mini.tabline")
		require("mini.tabline").setup({
			-- Whether to show file icons (requires 'mini.icons')
			show_icons = true,

			-- Function which formats the tab label
			-- By default surrounds with space and possibly prepends with icon
			-- format = nil,

			format = function(buf_id, label)
				-- if vim.bo.filetype == "snacks_dashboard" then
				-- 	return "" -- Hide tabline label
				-- end
				-- Add a `+` to the end of the tab label if the buffer is modified
				local suffix = vim.bo[buf_id].modified and "+ " or ""
				return MiniTabline.default_format(buf_id, label) .. suffix
			end,
			-- Whether to set Vim's settings for tabline (make it always shown and
			-- allow hidden buffers)
			set_vim_settings = true,

			-- Where to show tabpage section in case of multiple vim tabpages.
			-- One of 'left', 'right', 'none'.
			tabpage_section = "left",
		})
	end,
}
