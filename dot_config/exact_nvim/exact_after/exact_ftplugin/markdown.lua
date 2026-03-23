-- Disable auto-comment behaviors
vim.opt_local.formatoptions:remove("c")
vim.opt_local.formatoptions:remove("r")
vim.opt_local.formatoptions:remove("o")
-- -- Auto-insert a real newline when typing past 120 chars
-- vim.opt_local.textwidth = 120
-- vim.opt_local.formatoptions:append("t")
-- Don't wrap so we get nice code blocks from markview.nvim
vim.opt_local.wrap = false
-- Folding suggested for obsidian.nvim: https://github.com/obsidian-nvim/obsidian.nvim/wiki/Folding
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.wo.foldmethod = "expr"

-- Markdown heading insertion using Treesitter
-- Provides smart heading insertion that respects section boundaries
-- Based on algorithm:
--   1. Find source heading (current line or first heading above cursor)
--   2. Calculate target level (sibling = same, subheading = +1)
--   3. Find target line (first heading at/above target level OR separator)
--   4. Insert above target line

local function get_heading_level(node)
  local type = node:type()

  if type == "atx_heading" then
    for child in node:iter_children() do
      local child_type = child:type()
      if child_type:match("^atx_h%d_marker$") then
        local marker_text = vim.treesitter.get_node_text(child, 0)
        return #marker_text
      end
    end
  elseif type == "setext_heading" then
    for child in node:iter_children() do
      if child:type() == "setext_h1_underline" then
        return 1
      elseif child:type() == "setext_h2_underline" then
        return 2
      end
    end
  end

  return nil
end

local function find_source_heading()
  local cursor_line = vim.fn.line(".")
  local bufnr = vim.api.nvim_get_current_buf()

  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "markdown")
  if not ok then
    return nil, nil
  end

  local tree = parser:parse()[1]
  local root = tree:root()

  local node = vim.treesitter.get_node({ bufnr = bufnr, pos = { cursor_line - 1, 0 } })
  while node do
    local node_type = node:type()
    if node_type == "atx_heading" or node_type == "setext_heading" then
      local level = get_heading_level(node)
      if level then
        return level, node:start() + 1
      end
    end
    node = node:parent()
  end

  local query = vim.treesitter.query.parse(
    "markdown",
    [[
    (atx_heading) @heading
    (setext_heading) @heading
  ]]
  )

  local best_heading = nil
  local best_line = 0

  for _, heading_node in query:iter_captures(root, bufnr) do
    local start_line = heading_node:start() + 1
    if start_line < cursor_line and start_line > best_line then
      best_line = start_line
      best_heading = heading_node
    end
  end

  if best_heading then
    return get_heading_level(best_heading), best_line
  end

  return nil, nil
end

local function is_separator_line(line_content)
  return line_content:match("^%-%-%-+%s*$") or line_content:match("^%*%*%*+%s*$")
end

local function find_target_line(cursor_line, target_level)
  local bufnr = vim.api.nvim_get_current_buf()
  local total_lines = vim.fn.line("$")

  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "markdown")
  if not ok then
    return total_lines + 1
  end

  local tree = parser:parse()[1]
  local root = tree:root()

  local lines = vim.api.nvim_buf_get_lines(bufnr, cursor_line, total_lines, false)

  local query = vim.treesitter.query.parse(
    "markdown",
    [[
    (atx_heading) @heading
    (setext_heading) @heading
  ]]
  )

  local headings = {}
  for _, node in query:iter_captures(root, bufnr) do
    local start_line = node:start() + 1
    if start_line > cursor_line then
      local level = get_heading_level(node)
      if level then
        headings[start_line] = level
      end
    end
  end

  for i, line in ipairs(lines) do
    local actual_line = cursor_line + i

    if is_separator_line(line) then
      return actual_line
    end

    if headings[actual_line] and headings[actual_line] <= target_level then
      return actual_line
    end
  end

  return total_lines + 1
end

local function insert_heading(mode)
  local cursor_line = vim.fn.line(".")
  local source_level = find_source_heading() or 1
  local target_level = mode == "subheading" and math.min(source_level + 1, 6) or source_level
  local target_line = find_target_line(cursor_line, target_level)
  local heading_text = string.rep("#", target_level) .. " "
  local insert_line = target_line - 1
  local insert_line_content = insert_line > 0 and vim.fn.getline(insert_line) or ""
  if insert_line_content:match("^%s*$") then
    vim.fn.append(insert_line, heading_text)
    vim.fn.cursor(insert_line + 1, #heading_text + 1)
  else
    vim.fn.append(insert_line, { "", heading_text })
    vim.fn.cursor(insert_line + 2, #heading_text + 1)
  end
  vim.cmd("startinsert!")
end

local function jump_heading(flags)
  local views = vim.fn.winsaveview()
  local found = vim.fn.search("^#\\+\\s", flags)
  if found == 0 then
    vim.fn.winrestview(views)
  end
end

-- List continuation on Enter in insert mode.
-- Supports: bullet (- / * / +), todo (- [ ] ), numbered (1.)
-- On an empty list item, pressing Enter removes the marker and inserts a newline.
local function markdown_enter()
  local line = vim.api.nvim_get_current_line()
  local col = vim.fn.col(".")
  local before_cursor = line:sub(1, col - 1)
  local after_cursor = line:sub(col)

  -- Capture optional leading indent
  local indent = line:match("^(%s*)") or ""

  -- Helper to send keys
  local function send(keys)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", true)
  end

  -- 1. TODO list item: - [ ] or * [ ] or + [ ] etc.
  -- Matches any checkbox state like [ ], [x], [?], [!], etc.
  -- NOTE: No capture groups here — match() returns the full match (including
  -- indent) so that #todo_full gives the correct offset into before_cursor.
  local todo_full = before_cursor:match("^%s*[%-%*%+]%s%[[^%]]*%]%s?")

  if todo_full then
    local content_after_marker = before_cursor:sub(#todo_full + 1)
    if content_after_marker:match("^%s*$") and after_cursor:match("^%s*$") then
      -- Empty item: clear the marker and leave a blank line at current indent
      send("<C-u>" .. indent .. "<CR>")
      return
    end
    -- Continue todo: insert newline + indent + same bullet type + empty checkbox
    local marker_type = before_cursor:match("^%s*([%-%*%+])")
    send("<CR><C-u>" .. indent .. marker_type .. " [ ] ")
    return
  end

  -- 2. Bullet list item: - / * / +
  -- NOTE: No capture groups — same reason as above.
  local bullet_full = before_cursor:match("^%s*[%-%*%+]%s")
  if bullet_full then
    local marker = bullet_full:match("[%-%*%+]")
    local content_after_marker = before_cursor:sub(#bullet_full + 1)
    if content_after_marker:match("^%s*$") and after_cursor:match("^%s*$") then
      send("<C-u>" .. indent .. "<CR>")
      return
    end
    send("<CR><C-u>" .. indent .. marker .. " ")
    return
  end

  -- 3. Numbered list item: 1. or 1)
  local num, sep = before_cursor:match("^%s*(%d+)([%.%)]%s)")
  if num and sep then
    local full_marker = before_cursor:match("^%s*%d+[%.%)]%s")
    local content_after_marker = before_cursor:sub(#full_marker + 1)
    if content_after_marker:match("^%s*$") and after_cursor:match("^%s*$") then
      send("<C-u>" .. indent .. "<CR>")
      return
    end
    local next_num = tostring(tonumber(num) + 1)
    send("<CR><C-u>" .. indent .. next_num .. sep)
    return
  end

  -- Not a list line — default Enter
  send("<CR>")
end

vim.keymap.set("i", "<CR>", markdown_enter, {
  buffer = true,
  desc = "Continue list on Enter",
})

vim.keymap.set("n", "<localleader>h", function()
  insert_heading("sibling")
end, { desc = "Insert sibling heading (TS)", buffer = true })

vim.keymap.set("n", "<localleader>s", function()
  insert_heading("subheading")
end, { desc = "Insert subheading (TS)", buffer = true })

vim.keymap.set("n", "]]", function()
  jump_heading("W")
end, { desc = "Next markdown heading", buffer = true, nowait = true, silent = true })

vim.keymap.set("n", "[[", function()
  jump_heading("bW")
end, { desc = "Previous markdown heading", buffer = true, nowait = true, silent = true })

-- Markdown editing helpers — available in all .md files
vim.keymap.set("n", "<localleader>t", "o- [ ] ", { desc = "Add todo item", buffer = true })
vim.keymap.set("n", "<localleader>b", "o- ", { desc = "Add bullet point", buffer = true })
vim.keymap.set("n", "<localleader>1", "o# ", { desc = "Heading level 1", buffer = true })
vim.keymap.set("n", "<localleader>2", "o## ", { desc = "Heading level 2", buffer = true })
vim.keymap.set("n", "<localleader>3", "o### ", { desc = "Heading level 3", buffer = true })
vim.keymap.set("n", "<localleader>4", "o#### ", { desc = "Heading level 4", buffer = true })
vim.keymap.set("n", "<localleader>c", "o```<CR>```<Esc>O", { desc = "Add code block", buffer = true })

vim.keymap.set("n", "<localleader>l", function()
  local clipboard = vim.fn.getreg("+")
  local url = clipboard:match("^https?://") and clipboard or ""
  if url ~= "" then
    -- Clipboard has a URL: insert [](url) and position cursor inside []
    vim.api.nvim_feedkeys("a[](" .. url .. ")<Esc>F[a", "n", false)
  else
    -- No URL: insert []() and position cursor inside []
    vim.api.nvim_feedkeys("a[]()<Esc>F[a", "n", false)
  end
end, { desc = "Insert link", buffer = true })

vim.keymap.set("v", "<localleader>l", function()
  -- Exit visual mode first so '< and '> marks are set to the current selection
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)

  local start_pos = vim.api.nvim_buf_get_mark(0, "<")
  local end_pos = vim.api.nvim_buf_get_mark(0, ">")
  local start_row = start_pos[1] - 1
  local start_col = start_pos[2]
  local end_row = end_pos[1] - 1
  -- end_col from get_mark is 0-indexed and inclusive; buf_get_text needs exclusive end
  local end_line = vim.api.nvim_buf_get_lines(0, end_row, end_row + 1, true)[1] or ""
  local end_col = math.min(end_pos[2] + 1, #end_line)

  local lines = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {})
  local selected_text = table.concat(lines, "\n")

  local clipboard = vim.fn.getreg("+")
  local url
  if clipboard:match("^https?://") then
    url = clipboard
  else
    url = vim.fn.input("URL: ")
  end

  if not url or url == "" then
    return
  end

  local link = "[" .. selected_text .. "](" .. url .. ")"
  vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col, { link })
end, { desc = "Insert link (wrap selection)", buffer = true })

-- Interactive checkbox: delegates to obsidian.nvim when available, no-ops otherwise.
-- Outside the vault obsidian.nvim is loaded but the current buffer is not an obsidian
-- note, so the Checkbox command may not exist — we guard with pcall.
vim.keymap.set("n", "<localleader>i", function()
  local ok, err = pcall(vim.cmd, "Checkbox interactive")
  if not ok then
    vim.notify("Checkbox interactive requires obsidian.nvim (not available here)", vim.log.levels.WARN)
  end
end, { desc = "Change checkbox interactively", buffer = true })
