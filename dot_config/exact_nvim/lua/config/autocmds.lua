-- Autocmds are automatically loaded on the VeryLazy event

-- ================================================================
-- CUSTOM AUTO COMMANDS
-- ================================================================
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

-- Fallback Buffer Detection (this will tell us if the input buffer is the "[No Name]" buffer that opens when all others close)
local function is_fallback_buffer(buf)
	-- No associated file and not backed by a real file on disk
	local has_no_file = buf.name == "" or vim.fn.filereadable(vim.fn.fnamemodify(buf.name, ":p")) == 0

	return has_no_file -- No associated file
		and buf.linecount <= 1 -- Empty or nearly empty
		and buf.listed == 1 -- It's a listed buffer
end
vim.api.nvim_create_autocmd("BufWinLeave", {
	pattern = "*",
	callback = function()
		if vim.bo.filetype == "snacks_dashboard" then
			-- Get the list of listed and loaded buffers
			local listed_buffers = vim.fn.getbufinfo({ buflisted = 1, bufloaded = 1 })

			-- Detect if the fallback buffer exists
			local fallback_bufnr = nil
			for _, buf in ipairs(listed_buffers) do
				if is_fallback_buffer(buf) then
					fallback_bufnr = buf.bufnr
					break
				end
			end

			if fallback_bufnr then
				vim.api.nvim_buf_delete(fallback_bufnr, { force = true }) -- Close fallback buffer
			end
		end
	end,
})
-- Delete fallback buffer when closing MiniFilesExplorer
vim.api.nvim_create_autocmd("User", {
	pattern = "MiniFilesExplorerClose",
	callback = function()
		-- Get the list of listed and loaded buffers
		local listed_buffers = vim.fn.getbufinfo({ buflisted = 1, bufloaded = 1 })

		-- Detect if the fallback buffer exists
		local fallback_bufnr = nil
		for _, buf in ipairs(listed_buffers) do
			if is_fallback_buffer(buf) then
				fallback_bufnr = buf.bufnr
				break
			end
		end

		if fallback_bufnr then
			vim.api.nvim_buf_delete(fallback_bufnr, { force = true }) -- Close fallback buffer
		end
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
