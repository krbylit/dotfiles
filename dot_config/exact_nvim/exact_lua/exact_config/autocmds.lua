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

-- Trim trailing whitespace on save (excluding markdown files per .editorconfig)
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = "*",
--   callback = function()
--     -- Skip markdown files - they need to preserve trailing whitespace per .editorconfig
--     if vim.bo.filetype == "markdown" then
--       return
--     end
--     -- Trim trailing whitespace for all other files
--     vim.cmd([[%s/\s\+$//e]])
--   end,
-- })

-- Use 2 spaces for markdown files
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "markdown",
--   callback = function()
--     vim.bo.tabstop = 2
--     vim.bo.shiftwidth = 2
--   end,
-- })
-- NOTE: Disabling to try manually controlling scrolloff
-- -- Fix any jittering caused by high `scrolloff` value when near EOF or elsewhere
-- vim.api.nvim_create_autocmd("InsertEnter", {
--     callback = function()
--         vim.o.scrolloff = 1
--     end,
-- })
-- vim.api.nvim_create_autocmd("InsertLeave", {
--     callback = function()
--         vim.o.scrolloff = 999
--     end,
-- })

-- ================================================================
-- FileType Keymaps - Grouped by Purpose
-- ================================================================
local ft_keymap_group = vim.api.nvim_create_augroup("FileTypeKeymaps", { clear = true })

-- Quickfix list manipulation functions
local function remove_qf_item()
  local curqfidx = vim.fn.line(".")
  local qfall = vim.fn.getqflist()
  if #qfall == 0 then
    return
  end
  table.remove(qfall, curqfidx)
  vim.fn.setqflist(qfall, "r")
  if #qfall == 0 then
    vim.cmd("cclose")
    return
  end
  local new_idx = math.min(curqfidx, #qfall)
  vim.api.nvim_win_set_cursor(0, { new_idx, 0 })
end

local function remove_qf_range()
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end
  local qfall = vim.fn.getqflist()
  if #qfall == 0 then
    return
  end
  for i = end_line, start_line, -1 do
    table.remove(qfall, i)
  end
  vim.fn.setqflist(qfall, "r")
  if #qfall == 0 then
    vim.cmd("cclose")
    return
  end
  local new_idx = math.min(start_line, #qfall)
  vim.api.nvim_win_set_cursor(0, { new_idx, 0 })
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
end

-- Quickfix keymaps
vim.api.nvim_create_autocmd("FileType", {
  group = ft_keymap_group,
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "dd", remove_qf_item, { buffer = true })
    vim.keymap.set("v", "d", remove_qf_range, { buffer = true })
  end,
})

-- ================================================================
-- FileType UI/Display Settings - Grouped by Purpose
-- ================================================================
local ft_ui_group = vim.api.nvim_create_augroup("FileTypeUI", { clear = true })

-- Help docs: vertical split on the right.
-- BufWinEnter is used instead of FileType because FileType only fires once per
-- buffer (when the filetype is first set). When a help buffer is reused in a new
-- window (e.g. running :help on a previously-viewed topic), the filetype is
-- already set so FileType does not fire again -- only BufWinEnter does.
-- Guard against floating windows where wincmd L is not meaningful.
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = ft_ui_group,
  callback = function()
    if vim.bo.buftype == "help" and vim.api.nvim_win_get_config(0).relative == "" then
      vim.cmd("wincmd L | vertical resize 90")
    end
  end,
})

-- Markdown: disable wrap in every window showing a markdown buffer.
-- `wrap` is window-local, so FileType autocmds only cover the initial window.
-- BufWinEnter fires for every window (splits, floats, etc.) and reliably
-- overrides the global `wrap = true` set in options.lua.
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = ft_ui_group,
  pattern = "*.md",
  callback = function()
    vim.opt_local.wrap = false
    -- vim.opt_local.cursorline = false
    -- vim.cmd("IlluminatePauseBuf")
  end,
})

-- ================================================================
-- Terminal Settings - Optimized Pattern
-- ================================================================
local terminal_group = vim.api.nvim_create_augroup("TerminalSettings", { clear = true })

-- Terminal settings (only TermOpen - removed redundant BufWinEnter)
vim.api.nvim_create_autocmd("TermOpen", {
  group = terminal_group,
  pattern = "term://*",
  callback = function()
    vim.opt_local.scrollback = 100000
    -- Force terminal to use Normal highlight group background
    -- NOTE: This was necessary to make sidekick.nvim terminal window respect colorscheme, doesn't seem to be required any longer
    -- vim.opt_local.winhighlight = "Normal:Normal,NormalNC:NormalNC"

    if vim.bo.filetype == "sidekick_terminal" then
      vim.keymap.set({ "n", "i" }, "<C-v>", function()
        vim.cmd("PasteImage")
      end, { buffer = true })
    end

    -- Plain builtin `:terminal` buffers do not inherit Snacks terminal keymaps.
    -- Give them a local `<C-q>` escape hatch so they don't fall through to the
    -- global normal-mode `<C-q>` buffer-delete mapping.
    if vim.bo.filetype == "" then
      vim.keymap.set("t", "<C-q>", function()
        vim.cmd.stopinsert()
      end, { buffer = true, desc = "Terminal: enter normal mode" })

      vim.keymap.set("n", "<C-q>", function()
        vim.cmd.startinsert()
      end, { buffer = true, desc = "Terminal: return to terminal mode" })
    end
  end,
})

-- Disable cursorline highlight in inactive windows. cursorline=false should be set in options.lua
-- enable only in active window
-- vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
--   callback = function()
--     vim.opt_local.cursorline = true
--   end,
-- })
--
-- vim.api.nvim_create_autocmd("WinLeave", {
--   callback = function()
--     vim.opt_local.cursorline = false
--   end,
-- })
