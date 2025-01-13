return {
	"echasnovski/mini.tabline",
	version = false,
	dependencies = { "echasnovski/mini.icons" },
	config = function()
		-- #f4dbd6 #f0c6c6 #c6a0f6 #ed8796 #8087a2 #939ab7 #a5adcb #f5a97f #b7bdf8 #363a4f #494d64
		vim.api.nvim_set_hl(
			0,
			"MiniTablineCurrent",
			{ fg = "#f4dbd6", bg = "#363a4f", italic = true, underline = false }
		)
		vim.api.nvim_set_hl(0, "MiniTablineVisible", { fg = "#939ab7", bg = "NONE", italic = false, underline = false })
		vim.api.nvim_set_hl(0, "MiniTablineHidden", { fg = "#939ab7", bg = "NONE", italic = false, underline = false })
		vim.api.nvim_set_hl(0, "MiniTablineModifiedCurrent", { fg = "#ed8796", bg = "#363a4f", italic = true })
		vim.api.nvim_set_hl(0, "MiniTablineModifiedVisible", { fg = "#ed8796", bg = "NONE" })
		vim.api.nvim_set_hl(0, "MiniTablineModifiedHidden", { fg = "#ed8796", bg = "NONE" })
		vim.api.nvim_set_hl(0, "MiniTablineFill", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "MiniTablineTabpagesection", { fg = "#f5a97f", bg = "#363a4f" })
		local MiniTabline = require("mini.tabline")
		require("mini.tabline").setup({
			-- Whether to show file icons (requires 'mini.icons')
			show_icons = true,

			-- Function which formats the tab label
			-- By default surrounds with space and possibly prepends with icon
			-- format = nil,

			format = function(buf_id, label)
				if vim.bo.filetype == "snacks_dashboard" then
					return "" -- Hide tabline label
				end
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
