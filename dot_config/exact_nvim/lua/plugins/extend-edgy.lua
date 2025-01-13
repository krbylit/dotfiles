-- Provides predifined windows for certain filetypes and other window management utils
-- https://github.com/folke/edgy.nvim
return {
	"folke/edgy.nvim",
	opts = function()
		local opts = {}
		-- Somehow this works in combination with the autocmd for "help" files to open them in a v-split
		for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
			opts[pos] = opts[pos] or {}
			table.insert(opts[pos], {
				ft = "trouble",
				filter = function(_buf, win)
					return vim.w[win].trouble
						and vim.w[win].trouble.position == pos
						and vim.w[win].trouble.type == "split"
						and vim.w[win].trouble.relative == "editor"
						and not vim.w[win].trouble_preview
				end,
			})
		end
		return opts
	end,
}
