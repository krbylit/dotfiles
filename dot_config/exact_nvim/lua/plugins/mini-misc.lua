-- Misc functions from mini.vim
-- https://github.com/echasnovski/mini.nvim/blob/74e6b722c91113bc70d4bf67249ed8de0642b20e/readmes/mini-misc.md

return {
	"echasnovski/mini.misc",
	-- version = false,
	config = function()
		require("mini.misc").setup()
		-- Mini.misc func to get rid of border around nvim
		require("mini.misc").setup_termbg_sync()
		-- NOTE: setup_auto_root() seems to only work if called here
		require("mini.misc").setup_auto_root()
	end,
}
