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
track_indent_changes()
