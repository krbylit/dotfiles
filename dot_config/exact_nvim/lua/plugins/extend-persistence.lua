local wk = require("which-key")
return {
	"folke/persistence.nvim",
	event = "BufReadPre", -- this will only start session saving when an actual file was opened
	keys = {
		-- load the session for the current directory
		{
			mode = "n",
			"<leader>qs",
			function()
				require("persistence").load()
			end,
			desc = "Load session for current directory",
		},

		-- select a session to load
		{
			mode = "n",
			"<leader>qS",
			function()
				require("persistence").select()
			end,
			desc = "Select session to load",
		},

		-- load the last session
		{
			mode = "n",
			"<leader>ql",
			function()
				require("persistence").load({ last = true })
			end,
			desc = "Load last session",
		},

		-- stop Persistence => session won't be saved on exit
		{
			mode = "n",
			"<leader>qd",
			function()
				require("persistence").stop()
			end,
			desc = "Don't save session on exit",
		},
	},
	opts = {
		dir = vim.fn.stdpath("state") .. "/sessions/", -- directory where session files are saved
		-- minimum number of file buffers that need to be open to save
		-- Set to 0 to always save
		need = 1,
		branch = true, -- use git branch to save session
	},
}
