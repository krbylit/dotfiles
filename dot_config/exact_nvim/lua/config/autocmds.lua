-- Autocmds are automatically loaded on the VeryLazy event

-- ================================================================
-- DEBUG: Track indentation changes
-- ================================================================
-- This autocmd helps debug when and what is changing indentation settings
local function track_indent_changes()
  local augroup = vim.api.nvim_create_augroup("DebugIndentChanges", { clear = true })

  -- Store initial indent settings per buffer
  local buffer_indent_settings = {}

  local function get_indent_settings(bufnr)
    return {
      tabstop = vim.bo[bufnr].tabstop,
      shiftwidth = vim.bo[bufnr].shiftwidth,
      softtabstop = vim.bo[bufnr].softtabstop,
      expandtab = vim.bo[bufnr].expandtab,
    }
  end

  local function settings_changed(old, new)
    return old.tabstop ~= new.tabstop
      or old.shiftwidth ~= new.shiftwidth
      or old.softtabstop ~= new.softtabstop
      or old.expandtab ~= new.expandtab
  end

  local function format_settings(settings)
    return string.format(
      "ts=%d sw=%d sts=%d et=%s",
      settings.tabstop,
      settings.shiftwidth,
      settings.softtabstop,
      settings.expandtab
    )
  end

  -- Track changes on various events
  vim.api.nvim_create_autocmd({
    "BufEnter",
    "BufWritePost",
    "FileType",
    "OptionSet",
    "LspAttach",
    "InsertLeave",
  }, {
    group = augroup,
    callback = function(ev)
      local bufnr = ev.buf
      local current = get_indent_settings(bufnr)

      -- Filter out UI plugin buffers (empty names, special buftypes)
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      local buftype = vim.bo[bufnr].buftype
      local is_ui_buffer = bufname == ""
        or buftype == "nofile"
        or buftype == "prompt"
        or buftype == "terminal"
        or buftype == "help"
        or bufname:match("^term://")

      if is_ui_buffer then
        return -- Skip UI buffers silently
      end

      -- Initialize tracking for new buffers
      if not buffer_indent_settings[bufnr] then
        buffer_indent_settings[bufnr] = current
        vim.notify(
          string.format("[INDENT DEBUG] %s - Initial: %s (file: %s)", ev.event, format_settings(current), bufname),
          vim.log.levels.INFO
        )
        return
      end

      -- Check if settings changed
      local old = buffer_indent_settings[bufnr]
      if settings_changed(old, current) then
        vim.notify(
          string.format(
            "[INDENT DEBUG] %s - Changed from %s to %s\n  File: %s\n  Stack: %s",
            ev.event,
            format_settings(old),
            format_settings(current),
            bufname,
            debug.traceback("", 2):gsub("\n", "\n  ")
          ),
          vim.log.levels.WARN
        )
        buffer_indent_settings[bufnr] = current
      end
    end,
  })
end

-- Enable debugging - comment this line to disable
-- TODO: Disable once we can confirm indentation is not being set back to incorrect value while buffers are open
-- track_indent_changes()

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
-- Plugin specific autocmds
-- ================================================================
-- The below configuration wll allow you to automatically apply changes on files under chezmoi source path.
--  e.g. ~/.local/share/chezmoi/*
if vim.env.IS_SSH ~= "1" then
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
end

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
  if #qfall == 0 then
    return
  end
  table.remove(qfall, curqfidx)
  vim.fn.setqflist(qfall, "r")
  -- After removing, check if the list is empty
  if #qfall == 0 then
    -- Optionally close quickfix window
    vim.cmd("cclose")
    return
  end
  -- Reselect the appropriate line
  local new_idx = math.min(curqfidx, #qfall)
  vim.api.nvim_win_set_cursor(0, { new_idx, 0 })
end
function Remove_qf_range()
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end
  local qfall = vim.fn.getqflist()
  if #qfall == 0 then
    return
  end
  -- Remove from end to start to avoid shifting indices
  for i = end_line, start_line, -1 do
    table.remove(qfall, i)
  end
  vim.fn.setqflist(qfall, "r")
  -- After removing, check if the list is empty
  if #qfall == 0 then
    -- Optionally close quickfix window
    vim.cmd("cclose")
    return
  end
  local new_idx = math.min(start_line, #qfall)
  vim.api.nvim_win_set_cursor(0, { new_idx, 0 })
  -- Exit visual mode after deleting
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "dd", Remove_qf_item, { buffer = true })
    vim.keymap.set("v", "d", Remove_qf_range, { buffer = true })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "sidekick_terminal",
  callback = function()
    vim.keymap.set({ "n", "i" }, "<C-v>", vim.cmd("PasteImage"), { buffer = true })
  end,
})

-- Increase terminal scrollback buffer
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.scrollback = 100000
  end,
})

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
