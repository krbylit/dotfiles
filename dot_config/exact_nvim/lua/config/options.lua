-- Options are automatically loaded before lazy.nvim startup

local opt = vim.opt

-- Global options for VS Code and console use
vim.g.mapleader = "," -- Set leader key to comma
vim.g.maplocalleader = " " -- Set local leader key to space
-- Set global for `$(chezmoi source-path)`
local cm_path = vim.fn.system("chezmoi source-path")
vim.g.chezmoi_source_path = cm_path
vim.g.root_spec = { { ".git", "lua" }, "lsp", "cwd" }

-- Ensure the 'list' option is enabled
vim.opt.list = true
-- Set 'listchars' to only display trailing spaces
vim.opt.listchars = {
	trail = "-", -- Show trailing spaces as `-`
	tab = "  ", -- A tab will appear as spaces (effectively hidden)
	nbsp = " ", -- Hide non-breaking spaces
	space = " ", -- Hide space indicators
}
-- Remove 'blank' from sessionoptions to avoid opening empty unnamed buffers
vim.opt.sessionoptions:remove("blank")
-- use bash for shell, fish is very slow in nvim
opt.shell = "/bin/zsh"
opt.undofile = true -- Save undo history between sessions
opt.tabstop = 4 -- A tab is equal to 4 spaces
opt.shiftwidth = 4 -- Number of spaces to use for each step of (auto)indent
opt.expandtab = true -- Convert tabs to spaces
opt.cursorline = true -- Enable highlighting of the current line
opt.scrolloff = 999 -- Lines of context
opt.relativenumber = true
opt.smartindent = true -- Insert indents automatically
-- opt.colorcolumn = "88" -- Shows a column line at 80 characters
opt.wrap = true -- Set text display to wrap. Doesn't change text in buffer
opt.linebreak = true -- wrap long lines at a blank
opt.breakindent = true -- Enable break indent
opt.breakindentopt = "shift:2,sbr,min:20"
opt.showbreak = "↳" -- Show a symbol for a line break
opt.wrapmargin = 0
opt.textwidth = 0
-- opt.showbreak = "	" -- Show a symbol for a line break
-- opt.textwidth = 80 -- Maximum width of text. Actually changes text in the buffer NOTE: disabling because it causes messes
opt.mousehide = true -- Hide mouse cursor while typing
opt.winheight = 1 -- Minimum window height
opt.winminheight = 1 -- Minimum window height
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
-- Disable diagnostics by default
vim.diagnostic.disable()
opt.autochdir = true
-- FORMATTING
-- default "tcqj"
opt.formatoptions = "qnlj"
vim.g.autoformat = true
vim.g.lazyvim_prettier_needs_config = false
if vim.fn.has("nvim-0.10") == 1 then
	opt.smoothscroll = true
	opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
	opt.foldmethod = "expr"
	opt.foldtext = ""
else
	opt.foldmethod = "indent"
	opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"
end

-- ================================================================
-- FILETYPES
-- ================================================================

-- Add chezmoi template files as filetypes to nvim so that yaml and toml LSPs can parse them
-- TODO: move these to a separate options module and import here
vim.filetype.add({
	extension = {
		tmpl = function(path, bufnr)
			if path:find(".toml.tmpl") then
				return "toml"
			end
			if path:find(".json.tmpl") then
				return "json"
			end
			if path:find(".yaml.tmpl") then
				return "yaml"
			end
			if path:find(".sh.tmpl") then
				return "sh"
			end
			if path:find(".conf.tmpl") then
				return "conf"
			end
		end,
		chezmoiignore = "gitignore",
		watchmanconfig = "json",
		gitconfig = "gitconfig",
		json = function(path, bufnr)
			if path:find("neoconf") then
				return "jsonc"
			end
			return "json"
		end,
	},
	filename = {
		-- ["dot_zshrc"] = "zsh",
		-- ["dot_gitconfig"] = "gitconfig",
		-- ["dot_neoconf"] = "jsonc", -- NOTE: this one isn't working for some reason, hence above json func
		-- ["neoconf"] = "jsonc",
	},
	pattern = {
		[".*dot_zshrc"] = "zsh",
		[".*dot_gitconfig"] = "gitconfig",
		[".*dot_bash.*"] = "bash",
		[".*ssh/.*config"] = "sshconfig",
	},
	-- pattern = {
	-- 	[".*gitconfig$"] = "gitconfig",
	-- 	[".*zshrc$"] = "zsh",
	-- 	-- 	[".*%.toml%.tmpl$"] = "toml",
	-- 	-- 	[".*%.yaml%.tmpl$"] = "yaml",
	-- },
})
