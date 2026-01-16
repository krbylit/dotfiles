-- TODO: implement truncation method for when window not big enough for file path
local colors = require("tokyonight.colors").setup({ style = "night" })
-- local colors = require("tokyonight").load({ style = "night" })

-- Cache for git information to avoid repeated shell calls
local git_cache = {
  current_repo_name = "",
  current_branch = "",
  git_root = "",
  last_dir = "",
  is_exiting = false,
}

-- Function to update the repository name and branch based on the current buffer
local function update_git_info()
  -- Don't update during neovim exit
  if git_cache.is_exiting then
    return
  end

  local current_dir_display = vim.fn.expand("%:p:h")
  local current_dir = vim.loop.fs_realpath(current_dir_display) or current_dir_display

  -- Only update if directory has changed
  if current_dir == git_cache.last_dir then
    return
  end

  -- Get repo root (only call once)
  -- NOTE: Use shellescape for shell command, not pattern escape
  local git_dir =
    vim.fn.system("git -C " .. vim.fn.shellescape(current_dir) .. " rev-parse --show-toplevel 2>/dev/null")
  if vim.v.shell_error == 0 then
    git_cache.git_root = git_dir:gsub("\n", "")
    git_cache.current_repo_name = vim.fn.fnamemodify(git_cache.git_root, ":t")

    -- Get branch name
    local branch = vim.fn.system("git -C " .. vim.fn.shellescape(current_dir) .. " branch --show-current 2>/dev/null")
    if vim.v.shell_error == 0 then
      git_cache.current_branch = branch:gsub("\n", "")
    else
      git_cache.current_branch = ""
    end
  else
    -- Reset cache if not in a git repo
    git_cache.current_repo_name = ""
    git_cache.current_branch = ""
    git_cache.git_root = ""
  end

  git_cache.last_dir = current_dir
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

-- Autocmd to update the git info whenever a buffer is entered or switched
local autocmd_id = vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  callback = function()
    -- Use vim.schedule to avoid blocking UI, but check if we're exiting
    if not git_cache.is_exiting then
      vim.schedule(function()
        if not git_cache.is_exiting then
          update_git_info()
        end
      end)
    end
  end,
})

-- Add autocmd to handle neovim exit
-- Intended to mitigate hanging on nvim exit
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    git_cache.is_exiting = true
    -- Clean up the buffer autocmd to prevent any scheduled callbacks
    if autocmd_id then
      pcall(vim.api.nvim_del_autocmd, autocmd_id)
    end
  end,
})

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

    -- Format repo and branch with icons
    --    󰘬  󰳏    󰘬  󰊢      󰊤        
    -- Branch
    result = string.format(
      "%%#MiniStatuslineBranchIcon#%s%%*",
      "" -- Branch icon
    )
    result = result .. string.format("%%#MiniStatuslineBoldBranchName#%s%%*", git_cache.current_branch)
    -- Repo
    result = result .. string.format(
      "%%#MiniStatuslineRepoIcon#%s%%*",
      "" -- Repo icon
    )
    result = result .. string.format("%%#MiniStatuslineBoldRepoName#%s%%*", git_cache.current_repo_name)

    -- Add the rest of the path if it exists
    if #parts > 0 then
      for i, part in ipairs(parts) do
        if i == #parts then
          -- Last part (filename) gets special highlighting
          result = result
            .. string.format(
              "%%#MiniStatuslinePathName#/%s",
              string.format("%%#MiniStatuslineBoldFileName#%s%%*", part)
            )
        else
          -- Middle parts of the path
          result = result .. string.format("%%#MiniStatuslinePathName#/%s%%*", part)
        end
      end
    end
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
  version = false,
  -- cond = function()
  -- 	return vim.bo.filetype ~= "snacks_dashboard"
  -- end,
  config = function()
    vim.api.nvim_set_hl(
      0,
      "MiniStatuslineBoldFileName",
      { italic = true, bold = true, fg = colors.teal, bg = colors.bg }
    )
    vim.api.nvim_set_hl(
      0,
      "MiniStatuslineBoldRepoName",
      { italic = false, bold = true, fg = colors.orange, bg = colors.bg }
    )
    vim.api.nvim_set_hl(
      0,
      "MiniStatuslineRepoIcon",
      { italic = false, bold = false, fg = colors.orange, bg = colors.bg }
    )
    vim.api.nvim_set_hl(
      0,
      "MiniStatuslineBoldBranchName",
      { italic = false, bold = true, fg = colors.cyan, bg = colors.bg }
    )
    vim.api.nvim_set_hl(
      0,
      "MiniStatuslineBranchIcon",
      { italic = false, bold = false, fg = colors.cyan, bg = colors.bg }
    )
    vim.api.nvim_set_hl(0, "MiniStatuslinePathName", { fg = colors.fg_dark, bg = colors.bg })
    vim.api.nvim_set_hl(0, "MiniStatuslineRecording", { fg = colors.bg_dark1, bg = colors.red })
    -- Mode indicator hl groups
    vim.api.nvim_set_hl(0, "MiniStatuslineModeNormal", { fg = colors.bg_dark1, bg = colors.blue })
    vim.api.nvim_set_hl(0, "MiniStatuslineModeInsert", { fg = colors.bg_dark1, bg = colors.green })
    vim.api.nvim_set_hl(0, "MiniStatuslineModeVisual", { fg = colors.bg_dark1, bg = colors.purple })
    vim.api.nvim_set_hl(0, "MiniStatuslineModeReplace", { fg = colors.bg_dark1, bg = colors.magenta2 })
    vim.api.nvim_set_hl(0, "MiniStatuslineModeCommand", { fg = colors.bg_dark1, bg = colors.orange })
    vim.api.nvim_set_hl(0, "MiniStatuslineModeOther", { fg = colors.bg_dark1, bg = colors.teal })
    -- General hl groups
    vim.api.nvim_set_hl(0, "MiniStatuslineDevinfo", { fg = colors.fg, bg = colors.blue7 })
    vim.api.nvim_set_hl(0, "MiniStatuslineFileinfo", { fg = colors.fg, bg = colors.blue7 })
    -- vim.api.nvim_set_hl(0, "MiniStatuslineInactive", { fg = colors.bg_dark1, bg = colors.teal })
    -- Nvim statusline hl groups
    vim.api.nvim_set_hl(0, "StatusLine", { bg = colors.bg })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = colors.bg }) -- For inactive windows
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

          return MiniStatusline.combine_groups({
            { hl = mode_hl, strings = { mode } },
            "%<", -- Mark general truncate point
            { hl = "MiniStatuslinePathName", strings = { filename } },
            "%=", -- End left alignment
            { hl = "MiniStatuslineRecording", strings = { mode_status } },
            { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
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

          return MiniStatusline.combine_groups({
            { hl = mode_hl, strings = { mode } },
            { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
            "%<", -- Mark general truncate point
            { hl = "MiniStatuslinePathName", strings = { filename } },
            "%=", -- End left alignment
            { hl = "MiniStatuslineRecording", strings = { mode_status } },
            { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
            { hl = mode_hl, strings = { search, location } },
          })
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
