-- Plugin to help editing chezmoi managed config files
-- https://github.com/xvzc/chezmoi.nvim

-- The below configuration wll allow you to automatically apply changes on files under chezmoi source path.
--  e.g. ~/.local/share/chezmoi/*
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { os.getenv("HOME") .. "/.local/share/chezmoi/*" },
	callback = function(ev)
		local bufnr = ev.buf
		local edit_watch = function()
			-- TODO: See if we can re-source nvim config after chezmoi apply
			require("chezmoi.commands.__edit").watch(bufnr)
		end
		vim.schedule(edit_watch)
	end,
})

return {
	"xvzc/chezmoi.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		edit = {
			watch = false,
			force = false,
		},
		notification = {
			on_open = false,
			on_apply = true,
			on_watch = false,
		},
		telescope = {
			select = { "<CR>" },
		},
	},
}
