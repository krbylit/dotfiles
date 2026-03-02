local colors = require("tokyonight.colors").setup({ style = "night" })
-- local colors = require("tokyonight").load({ style = "night" })

-- Cache for git information to avoid repeated shell calls
local git_cache = {
  current_repo_name = "",
  current_branch = "",
  git_root = "",
  last_dir = "",
  is_exiting = false,
  git_watcher = nil, -- fs_event watcher for .git/HEAD
  update_timer = nil, -- debounce timer for update_git_info
}

-- Stop watching git changes (cleanup)
local function stop_git_watcher()
  if git_cache.git_watcher then
    git_cache.git_watcher:stop()
    git_cache.git_watcher = nil
  end
end

-- Start watching .git/HEAD for branch changes
local function start_git_watcher(git_root)
  -- Stop any existing watcher first
  stop_git_watcher()

  local git_head = git_root .. "/.git/HEAD"

  -- Check if .git/HEAD exists (not a bare repo or worktree)
  if vim.fn.filereadable(git_head) == 0 then
    return
  end

  -- Create fs_event watcher
  local watcher = vim.loop.new_fs_event()
  local success = watcher:start(
    git_head,
    {},
    vim.schedule_wrap(function(err, filename, events)
      if err or git_cache.is_exiting then
        return
      end

      if events.change then
        -- Branch changed! Update cached branch name
        vim.system(
          { "git", "-C", git_root, "branch", "--show-current" },
          { text = true },
          vim.schedule_wrap(function(result)
            if result.code == 0 and result.stdout then
              git_cache.current_branch = result.stdout:gsub("\n", "")
              vim.cmd("redrawstatus")
            end
          end)
        )
      end
    end)
  )

  if success then
    git_cache.git_watcher = watcher
  end
end

-- Function to update git repository info when changing directories (debounced)
local function update_git_info()
  -- Don't update during neovim exit
  if git_cache.is_exiting then
    return
  end

  -- Cancel existing timer if present
  if git_cache.update_timer then
    git_cache.update_timer:stop()
    git_cache.update_timer:close()
    git_cache.update_timer = nil
  end

  -- Debounce with 50ms delay to handle rapid buffer switches
  git_cache.update_timer = vim.loop.new_timer()
  git_cache.update_timer:start(
    50,
    0,
    vim.schedule_wrap(function()
      local current_dir_display = vim.fn.expand("%:p:h")
      local current_dir = vim.loop.fs_realpath(current_dir_display) or current_dir_display

      -- Only update if directory has changed
      if current_dir == git_cache.last_dir then
        if git_cache.update_timer then
          git_cache.update_timer:close()
          git_cache.update_timer = nil
        end
        return
      end

      git_cache.last_dir = current_dir

      -- Get repo root asynchronously
      vim.system({ "git", "-C", current_dir, "rev-parse", "--show-toplevel" }, { text = true }, function(result)
        vim.schedule(function()
          if result.code == 0 and result.stdout then
            local new_git_root = result.stdout:gsub("\n", "")

            -- Check if we switched to a different repo
            if new_git_root ~= git_cache.git_root then
              -- Different repo - update cache and restart watcher
              git_cache.git_root = new_git_root
              git_cache.current_repo_name = vim.fn.fnamemodify(new_git_root, ":t")

              -- Get initial branch name
              vim.system(
                { "git", "-C", current_dir, "branch", "--show-current" },
                { text = true },
                function(branch_result)
                  vim.schedule(function()
                    if branch_result.code == 0 and branch_result.stdout then
                      git_cache.current_branch = branch_result.stdout:gsub("\n", "")
                    else
                      git_cache.current_branch = ""
                    end

                    -- Start watching new repo's .git/HEAD
                    start_git_watcher(new_git_root)

                    vim.cmd("redrawstatus")
                  end)
                end
              )
            end
          -- If same repo, watcher is already running - no action needed
          else
            -- Not in a git repo - stop watcher and clear cache
            stop_git_watcher()
            git_cache.current_repo_name = ""
            git_cache.current_branch = ""
            git_cache.git_root = ""
            vim.cmd("redrawstatus")
          end

          -- Clean up timer
          if git_cache.update_timer then
            git_cache.update_timer:close()
            git_cache.update_timer = nil
          end
        end)
      end)
    end) -- End of vim.schedule_wrap
  ) -- End of timer:start()
end

-- Function to get path relative to git root (using cached git_root)
local function get_relative_path()
  local full_path_display = vim.fn.expand("%:p")
  local full_path = vim.loop.fs_realpath(full_path_display) or full_path_display

  -- Use cached git root instead of calling git again
  if git_cache.git_root ~= "" then
    local relative_path = full_path:gsub("^" .. vim.pesc(git_cache.git_root) .. "/?", "")
    return relative_path
  end

  return full_path
end

-- Cache for word count and token estimate (bufnr -> formatted string).
-- Populated on BufEnter (cold start) and refreshed on BufWritePost.
-- get_word_count() reads from this cache so the statusline redraw path
-- never calls vim.fn.wordcount() directly.
local word_count_cache = {}

local function refresh_word_count(bufnr)
  -- wordcount() operates on the current buffer; switch context if needed
  local cur = vim.api.nvim_get_current_buf()
  local counts
  if bufnr == cur then
    counts = vim.fn.wordcount()
  else
    -- For off-screen buffers we skip the update; BufEnter will seed on switch
    return
  end
  local words = counts.chars > 0 and counts.words or 0
  local tokens = counts.chars > 0 and math.floor(counts.chars / 4) or 0
  word_count_cache[bufnr] = string.format("W:%d~T:%d", words, tokens)
end

-- Check for git repo changes on buffer enter (lightweight check)
-- fs_event watcher handles branch changes WITHIN a repo.
-- Also seeds the word count cache for buffers not yet counted.
local autocmd_id = vim.api.nvim_create_autocmd({ "BufEnter" }, {
  callback = function(ev)
    if not git_cache.is_exiting then
      update_git_info()
    end
    -- Seed cache on first visit to this buffer
    if word_count_cache[ev.buf] == nil then
      refresh_word_count(ev.buf)
    end
  end,
})

-- Refresh word count cache when the buffer is saved
vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function(ev)
    refresh_word_count(ev.buf)
  end,
})

-- Cleanup on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    git_cache.is_exiting = true
    -- Stop git watcher
    stop_git_watcher()
    -- Stop update timer
    if git_cache.update_timer then
      git_cache.update_timer:stop()
      git_cache.update_timer:close()
      git_cache.update_timer = nil
    end
    -- Clean up the buffer autocmd
    if autocmd_id then
      pcall(vim.api.nvim_del_autocmd, autocmd_id)
    end
  end,
})

-- Return the cached word/token count for the current buffer.
-- The cache is populated on BufEnter and refreshed on BufWritePost.
local function get_word_count()
  -- if vim.bo.filetype ~= "markdown" then
  --   return ""
  -- end
  return word_count_cache[vim.api.nvim_get_current_buf()] or ""
end

-- Custom section_filename to highlight the Git root directory and show branch
local function custom_section_filename(args)
  local result = ""

  -- If we're in a git repo (use cached values)
  if git_cache.current_repo_name ~= "" then
    -- Get the relative path (using cached git_root)
    local relative_path = get_relative_path()
    local parts = {}
    for part in relative_path:gmatch("[^/]+") do
      table.insert(parts, part)
    end

    -- Extract filename (last part) and intermediate path dirs
    local filename = #parts > 0 and parts[#parts] or nil
    local path_parts = {}
    for i = 1, #parts - 1 do
      table.insert(path_parts, parts[i])
    end

    -- Branch + repo prefix
    result = string.format("%%#MiniStatuslineBranchIcon#%s%%*", "")
      .. string.format("%%#MiniStatuslineBoldBranchName#%s%%*", git_cache.current_branch)
      .. string.format("%%#MiniStatuslineRepoIcon#%s%%*", "")
      .. string.format("%%#MiniStatuslineBoldRepoName#%s%%*", git_cache.current_repo_name)

    -- Build path segment: optional /... prefix + intermediate dirs + filename
    local function build_path(mid_parts, has_ellipsis)
      local r = has_ellipsis and string.format("%%#MiniStatuslinePathName#/...%%*") or ""
      for _, part in ipairs(mid_parts) do
        r = r .. string.format("%%#MiniStatuslinePathName#/%s%%*", part)
      end
      if filename then
        r = r
          .. string.format(
            "%%#MiniStatuslinePathName#/%s",
            string.format("%%#MiniStatuslineBoldFileName#%s%%*", filename)
          )
      end
      return r
    end

    -- Strip statusline highlight escapes to measure plain display width
    local function plain_width(s)
      return vim.fn.strdisplaywidth((s:gsub("%%#[^#]*#", ""):gsub("%%%*", "")))
    end

    -- Remove intermediate dirs from left (closest to repo root) until the whole
    -- section fits within the available budget, or no intermediate dirs remain
    local truncated = false
    -- local budget = math.max(30, vim.api.nvim_win_get_width(0) - 70)
    -- while #path_parts > 0 and plain_width(result .. build_path(path_parts, truncated)) > budget do
    --   table.remove(path_parts, 1)
    --   truncated = true
    -- end
    result = result .. build_path(path_parts, truncated)
  else
    -- Not in a git repo - show full path with home directory replaced
    local filepath = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":~")
    local parts = {}
    for part in filepath:gmatch("[^/]+") do
      table.insert(parts, part)
    end

    -- Format the parts
    for i, part in ipairs(parts) do
      if i == 1 then
        result = string.format("%%#MiniStatuslinePathName#%s%%*", part)
      elseif i == #parts then
        result = result
          .. string.format("%%#MiniStatuslinePathName#/%s", string.format("%%#MiniStatuslineBoldFileName#%s%%*", part))
      else
        result = result .. string.format("%%#MiniStatuslinePathName#/%s%%*", part)
      end
    end
  end

  -- Add file modification and readonly flags
  local file_flags = "%m%r"
  return result .. file_flags
end

return {
  "nvim-mini/mini.statusline",
  lazy = false,
  version = false,
  -- cond = function()
  -- 	return vim.bo.filetype ~= "snacks_dashboard"
  -- end,
  config = function()
    vim.api.nvim_set_hl(
      0,
      "MiniStatuslineBoldFileName",
      { italic = true, bold = true, fg = colors.teal, bg = colors.bg_statusline }
    )
    vim.api.nvim_set_hl(
      0,
      "MiniStatuslineBoldRepoName",
      { italic = false, bold = true, fg = colors.orange, bg = colors.bg_statusline }
    )
    vim.api.nvim_set_hl(
      0,
      "MiniStatuslineRepoIcon",
      { italic = false, bold = false, fg = colors.orange, bg = colors.bg_statusline }
    )
    vim.api.nvim_set_hl(
      0,
      "MiniStatuslineBoldBranchName",
      { italic = false, bold = true, fg = colors.cyan, bg = colors.bg_statusline }
    )
    vim.api.nvim_set_hl(
      0,
      "MiniStatuslineBranchIcon",
      { italic = false, bold = false, fg = colors.cyan, bg = colors.bg_statusline }
    )
    vim.api.nvim_set_hl(0, "MiniStatuslinePathName", { fg = colors.fg_dark, bg = colors.bg_statusline })
    vim.api.nvim_set_hl(0, "MiniStatuslineRecording", { fg = colors.bg, bg = colors.red })
    -- vim.api.nvim_set_hl(0, "MiniStatuslineWordCounts", { fg = colors.fg, bg = colors.bg_search })
    -- vim.api.nvim_set_hl(0, "MiniStatuslineWordCounts", { fg = colors.fg, bg = colors.bg_visual })
    vim.api.nvim_set_hl(0, "MiniStatuslineWordCounts", { fg = colors.blue, bg = colors.bg_visual })
    -- Mode indicator hl groups
    vim.api.nvim_set_hl(0, "MiniStatuslineModeNormal", { fg = colors.blue5, bg = colors.bg_search })
    vim.api.nvim_set_hl(0, "MiniStatuslineModeInsert", { fg = colors.bg, bg = colors.teal })
    vim.api.nvim_set_hl(0, "MiniStatuslineModeVisual", { fg = colors.bg, bg = colors.terminal.magenta })
    vim.api.nvim_set_hl(0, "MiniStatuslineModeReplace", { fg = colors.bg, bg = colors.magenta2 })
    vim.api.nvim_set_hl(0, "MiniStatuslineModeCommand", { fg = colors.bg, bg = colors.orange })
    vim.api.nvim_set_hl(0, "MiniStatuslineModeOther", { fg = colors.bg, bg = colors.teal })
    -- General hl groups
    -- vim.api.nvim_set_hl(0, "MiniStatuslineDevinfo", { fg = colors.fg, bg = colors.blue7 })
    vim.api.nvim_set_hl(0, "MiniStatuslineDevinfo", { fg = colors.blue, bg = colors.bg_visual })
    vim.api.nvim_set_hl(0, "MiniStatuslineFileinfo", { fg = colors.comment, bg = colors.bg_statusline })
    -- vim.api.nvim_set_hl(0, "MiniStatuslineInactive", { fg = colors.bg_dark1, bg = colors.teal })
    -- Nvim statusline hl groups
    vim.api.nvim_set_hl(0, "StatusLine", { bg = colors.bg_statusline }) -- For active windows
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = colors.bg_statusline }) -- For inactive windows
    local statusline_content = nil

    if vim.env.IS_SSH == "1" then
      statusline_content = {
        active = function()
          local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
          local filename = MiniStatusline.section_filename({ trunc_width = 75 })
          local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
          local location = MiniStatusline.section_location({ trunc_width = 75 })
          local search = MiniStatusline.section_searchcount({
            trunc_width = 75,
            options = { maxcount = 9999, timeout = 500 },
          })
          local mode_status = require("noice").api.status.mode.get()
          local word_count = get_word_count()

          return MiniStatusline.combine_groups({
            { hl = mode_hl, strings = { mode } },
            "%<", -- Mark general truncate point
            { hl = "MiniStatuslinePathName", strings = { filename } },
            "%=", -- End left alignment
            { hl = "MiniStatuslineRecording", strings = { mode_status } },
            { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
            { hl = "MiniStatuslineWordCounts", strings = { word_count } },
            { hl = mode_hl, strings = { search, location } },
          })
        end,
        inactive = nil,
      }
    else
      statusline_content = {
        active = function()
          -- if vim.bo.filetype == "snacks_dashboard" then
          -- 	return MiniStatusline.combine_groups({
          -- 		{ hl = "MiniStatuslineDashboard", strings = { mode } },
          -- 	})
          -- end
          local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
          local git = MiniStatusline.section_git({ trunc_width = 40 })
          local diff = MiniStatusline.section_diff({ trunc_width = 75 })
          local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
          local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
          local filename = custom_section_filename({ trunc_width = 140 })
          local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
          local location = MiniStatusline.section_location({ trunc_width = 75 })
          local search = MiniStatusline.section_searchcount({
            trunc_width = 75,
            options = { maxcount = 9999, timeout = 500 },
          })
          local mode_status = require("noice").api.status.mode.get()
          local word_count = get_word_count()

          if vim.bo.filetype == "snacks_dashboard" then
            return MiniStatusline.combine_groups({
              { hl = "MiniStatuslinePathName", strings = { filename } },
            })
          else
            return MiniStatusline.combine_groups({
              { hl = mode_hl, strings = { mode } },
              { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
              "%<", -- Mark general truncate point
              { hl = "MiniStatuslinePathName", strings = { filename } },
              "%=", -- End left alignment
              { hl = "MiniStatuslineRecording", strings = { mode_status } },
              { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
              { hl = "MiniStatuslineWordCounts", strings = { word_count } },
              { hl = mode_hl, strings = { search, location } },
            })
          end
        end,
        inactive = nil,
      }
    end
    require("mini.statusline").setup({
      content = statusline_content,
      use_icons = true,
      set_vim_settings = true,
    })
  end,
}
