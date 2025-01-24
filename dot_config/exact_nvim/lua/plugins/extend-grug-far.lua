return {
	"MagicDuck/grug-far.nvim",
	keys = function(_, keys)
		local which_key = require("which-key")
		local ext_keys = {
			which_key.add({
				{
					"<leader>sf",
					function()
						require("grug-far").grug_far({ prefills = { paths = vim.fn.expand("%:p") } })
					end,
					desc = "Search and replace in buffer",
					mode = { "n" },
					silent = true,
					remap = false,
				},
			}),
		}
		keys = vim.tbl_deep_extend("force", keys or {}, ext_keys)
		return keys
	end,
}
