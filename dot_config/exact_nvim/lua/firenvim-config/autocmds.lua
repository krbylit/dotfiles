local M = {}

M.setup = function()
	-- ================================================================
	-- Firenvim autocmds
	-- ================================================================
	-- FIXME: Cache and autosave autocmds aren't playing nicely w/ certain fields (probably non-textarea fields, this can be experienced in the ChatGPT input field)
	-- -- Incrementally autosave the firenvim buffer, syncing changes to the website
	-- vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
	-- 	callback = function(e)
	-- 		if vim.g.timer_started == true then
	-- 			return
	-- 		end
	-- 		vim.g.timer_started = true
	-- 		vim.fn.timer_start(10000, function()
	-- 			vim.g.timer_started = false
	-- 			vim.cmd("silent write")
	-- 		end)
	-- 	end,
	-- })
	-- -- Firenvim cache file and restore command
	-- local firenvimAuGroup = vim.api.nvim_create_augroup("firenvim", { clear = true })
	-- local firenvimBackup = vim.fn.stdpath("cache") .. "/firenvim_cache.txt"
	-- vim.api.nvim_create_autocmd(
	-- 	"BufWritePre",
	-- 	{ pattern = "*", command = "w! " .. firenvimBackup, group = firenvimAuGroup }
	-- )
	--
	-- local function readFile()
	-- 	local lines = {}
	-- 	for l in io.lines(firenvimBackup) do
	-- 		table.insert(lines, l)
	-- 	end
	-- 	return lines
	-- end
	-- vim.api.nvim_create_user_command("FirenvimRecover", function(opts)
	-- 	vim.api.nvim_buf_set_lines(0, 0, vim.api.nvim_buf_line_count(0) - 1, false, readFile())
	-- end, {})

	-- Set github textareas to markdown
	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		pattern = "github.com_*.txt",
		command = "set filetype=markdown",
	})

	-- Function to apply transparency settings globally
	local function set_transparency()
		vim.cmd([[
			hi Normal guibg=NONE ctermbg=NONE
			hi NormalNC guibg=NONE ctermbg=NONE
			hi SignColumn guibg=NONE ctermbg=NONE
			hi StatusLine guibg=NONE ctermbg=NONE
			hi StatusLineNC guibg=NONE ctermbg=NONE
			hi VertSplit guibg=NONE ctermbg=NONE
			hi TabLine guibg=NONE ctermbg=NONE
			hi TabLineFill guibg=NONE ctermbg=NONE
			hi TabLineSel guibg=NONE ctermbg=NONE
			hi Pmenu guibg=NONE ctermbg=NONE
			hi PmenuSel guibg=NONE ctermbg=NONE
			hi NeoTreeNormal guibg=NONE ctermbg=NONE
			hi NeoTreeNormalNC guibg=NONE ctermbg=NONE
			hi NeoTreeWinSeparator guibg=NONE ctermbg=NONE
			hi NeoTreeEndOfBuffer guibg=NONE ctermbg=NONE
			hi EndOfBuffer guibg=NONE ctermbg=NONE
			]])
	end

	-- Apply transparency settings initially
	set_transparency()

	-- Reapply transparency on buffer enter
	vim.api.nvim_create_autocmd("BufEnter", {
		pattern = "*",
		callback = set_transparency,
	})
	-- Enter zen mode if in firenvim
	-- NOTE: not the best way to achieve this
	-- vim.api.nvim_create_autocmd("BufEnter", {
	-- 	callback = function()
	-- 		if vim.g.started_by_firenvim then
	-- 			vim.cmd("lua Snacks.zen()")
	-- 		end
	-- 	end,
	-- 	desc = "Run Snacks.zen() if started by Firenvim",
	-- })
	-- end
end

return M
