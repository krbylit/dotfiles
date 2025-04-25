-- Autocmds are automatically loaded on the VeryLazy event

-- ================================================================
-- CUSTOM AUTO COMMANDS
-- ================================================================
-- NOTE: Workaround since something is overriding this since we have it set in options. Remove once we figure out what is overriding.
-- Disabling for now as having root dir set works with persistence.nvim better
-- vim.api.nvim_create_autocmd("BufEnter", {
-- 	callback = function()
-- 		vim.opt.autochdir = true
-- 	end,
-- })
-- ================================================================
-- Filetype specific autocmds
-- ================================================================
-- Reset all options when leaving snacks dashboard by requiring options module
-- NOTE: solves issue of options.lua not being reset when opening a file with fuzzy finder from dashboard
-- Recent update from Snacks may have fixed this. No longer an issue when opened from snacks.picker, but still an issue when opened from Harpoon.
-- vim.api.nvim_create_autocmd("BufDelete", {
-- 	callback = function(ev)
-- 		-- Check if the buffer being deleted is a dashboard
-- 		if vim.bo[ev.buf].filetype == "snacks_dashboard" then
-- 			-- Check if there are any other dashboard buffers
-- 			local dashboard_buffers = vim.tbl_filter(function(buf)
-- 				return buf ~= ev.buf and vim.bo[buf].filetype == "snacks_dashboard"
-- 			end, vim.api.nvim_list_bufs())
--
-- 			-- Only reload options if no other dashboard buffers exist
-- 			if #dashboard_buffers == 0 then
-- 				package.loaded["config.options"] = nil
-- 				require("config.options")
-- 			end
-- 		end
-- 	end,
-- })

-- Trim trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*", -- Applies to all files
	command = [[%s/\s\+$//e]],
})

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
