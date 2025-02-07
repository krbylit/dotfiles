local M = {}

M.setup = function()
	vim.g.firenvim_config = {
		globalSettings = {
			alt = "all",
			-- workaround to not show cmdline error
			cmdlineTimeout = 3000,
		},
		localSettings = {
			[".*"] = {
				cmdline = "neovim",
				-- The content localSetting controls how Firenvim should read the content of an element. Setting it to html will make Firenvim fetch the content of elements as HTML, text will make it use plaintext. The default value is text
				content = "text",
				priority = 0,
				-- The selector attribute of a localSetting controls what elements Firenvim automatically takes over.
				selector = "*",
				takeover = "never",
				-- takeover = "once",
			},
		},
	}

	local opt = vim.opt
	-- Options specifically for firenvim
	opt.laststatus = 0
	opt.statuscolumn = ""
	opt.number = false
	opt.relativenumber = false
	opt.cursorline = false
	-- Don't show cmdline at all unless in use
	opt.cmdheight = 0
	-- Suppress cmdline messages
	opt.shortmess = ""
	-- vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
end

return M
