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

vim.keymap.set("n", "<localleader>h", function()
  insert_heading("sibling")
end, { desc = "Insert sibling heading (TS)", buffer = true })

vim.keymap.set("n", "<localleader>s", function()
  insert_heading("subheading")
end, { desc = "Insert subheading (TS)", buffer = true })
