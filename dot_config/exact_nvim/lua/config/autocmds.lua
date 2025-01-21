-- Autocmds are automatically loaded on the VeryLazy event

-- ================================================================
-- CUSTOM AUTO COMMANDS
-- ================================================================

-- ================================================================
-- Firenvim autocmds
-- ================================================================
-- Firenvim cache file and restore command
if vim.g.started_by_firenvim then
	local firenvimAuGroup = vim.api.nvim_create_augroup("firenvim", { clear = true })
	local firenvimBackup = vim.fn.stdpath("cache") .. "/firenvim_cache.txt"
	vim.api.nvim_create_autocmd(
		"BufWritePre",
		{ pattern = "*", command = "w! " .. firenvimBackup, group = firenvimAuGroup }
	)

	local function readFile()
		local lines = {}
		for l in io.lines(firenvimBackup) do
			table.insert(lines, l)
		end
		return lines
	end
	vim.api.nvim_create_user_command("FirenvimRecover", function(opts)
		vim.api.nvim_buf_set_lines(0, 0, vim.api.nvim_buf_line_count(0) - 1, false, readFile())
	end, {})

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
end

-- ================================================================
-- Filetype specific autocmds
-- ================================================================
-- Use 2 spaces for markdown files
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.bo.tabstop = 2
		vim.bo.shiftwidth = 2
	end,
})
-- Fix any jittering caused by high `scrolloff` value when near EOF or elsewhere
vim.api.nvim_create_autocmd("InsertEnter", {
	callback = function()
		vim.o.scrolloff = 1
	end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
	callback = function()
		vim.o.scrolloff = 999
	end,
})

-- -- Disable diagnostics on markdown files
-- FIXME: Currently disables diagnostics globally and doesn't turn them back on. May need to be BufEnter. Probably best to actually config by filetype in plugin.
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "markdown",
-- 	callback = function()
-- 		vim.diagnostic.enable(false) -- `0` applies to the current buffer
-- 	end,
-- })

-- Auto comment options
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		vim.opt.formatoptions:remove("c") -- Do not auto-wrap comments using textwidth
		vim.opt.formatoptions:remove("r") -- Do not continue comment when pressing enter
		vim.opt.formatoptions:remove("o") -- Do not continue comment when inserting a new line
	end,
})

-- Enable removing items from Quickfix list with `dd`
function Remove_qf_item()
	local curqfidx = vim.fn.line(".")
	local qfall = vim.fn.getqflist()
	-- Return if there are no items to remove
	if #qfall == 0 then
		return
	end
	-- Remove the item from the quickfix list
	table.remove(qfall, curqfidx)
	vim.fn.setqflist(qfall, "r")
	-- Reopen quickfix window to refresh the list
	vim.cmd("copen")
	-- If not at the end of the list, stay at the same index, otherwise, go one up.
	local new_idx = curqfidx < #qfall and curqfidx or math.max(curqfidx - 1, 1)
	-- Set the cursor position directly in the quickfix window
	local winid = vim.fn.win_getid() -- Get the window ID of the quickfix window
	vim.api.nvim_win_set_cursor(winid, { new_idx, 0 })
end
vim.cmd("command! RemoveQFItem lua Remove_qf_item()")
vim.api.nvim_command("autocmd FileType qf nnoremap <buffer> dd :RemoveQFItem<cr>")

-- Open help docs in a new tab
vim.api.nvim_create_autocmd("BufEnter", {
	-- pattern = "*.txt",
	callback = function()
		if vim.bo.buftype == "help" then
			-- vim.cmd("wincmd T") -- open in new tab
			-- vim.cmd("wincmd |") -- maximize width
			-- vim.cmd("wincmd _") -- maximize height
			vim.cmd("wincmd L")
			vim.cmd("vertical resize 90")
		end
	end,
})
