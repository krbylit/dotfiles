-- Markdown heading insertion using Treesitter
-- Provides smart heading insertion that respects section boundaries
-- Based on algorithm:
--   1. Find source heading (current line or first heading above cursor)
--   2. Calculate target level (sibling = same, subheading = +1)
--   3. Find target line (first heading at/above target level OR separator)
--   4. Insert above target line

return {
  "nvim-treesitter/nvim-treesitter",
  optional = true,
  ft = "markdown",
  config = function()
    local M = {}

    -- Get heading level from a treesitter heading node
    local function get_heading_level(node)
      local type = node:type()

      if type == "atx_heading" then
        -- ATX headings: # Heading, ## Heading, etc.
        for child in node:iter_children() do
          local child_type = child:type()
          if child_type:match("^atx_h%d_marker$") then
            local marker_text = vim.treesitter.get_node_text(child, 0)
            return #marker_text
          end
        end
      elseif type == "setext_heading" then
        -- Setext headings: === (level 1) or --- (level 2)
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

    -- Step 1: Find the source heading
    local function find_source_heading()
      local cursor_line = vim.fn.line(".")
      local bufnr = vim.api.nvim_get_current_buf()

      local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "markdown")
      if not ok then
        return nil, nil
      end

      local tree = parser:parse()[1]
      local root = tree:root()

      -- 1a. Check if current line is a heading
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

      -- 1b. Search backwards for first heading above cursor
      local query = vim.treesitter.query.parse(
        "markdown",
        [[
        (atx_heading) @heading
        (setext_heading) @heading
      ]]
      )

      local best_heading = nil
      local best_line = 0

      for id, heading_node in query:iter_captures(root, bufnr) do
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

    -- Check if a line is a section separator (--- or ***)
    local function is_separator_line(line_content)
      return line_content:match("^%-%-%-+%s*$") or line_content:match("^%*%*%*+%s*$")
    end

    -- Step 3: Find target line to insert above
    local function find_target_line(cursor_line, target_level)
      local bufnr = vim.api.nvim_get_current_buf()
      local total_lines = vim.fn.line("$")

      local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "markdown")
      if not ok then
        return total_lines + 1
      end

      local tree = parser:parse()[1]
      local root = tree:root()

      -- Get all lines below cursor
      local lines = vim.api.nvim_buf_get_lines(bufnr, cursor_line, total_lines, false)

      -- Get all headings below cursor
      local query = vim.treesitter.query.parse(
        "markdown",
        [[
        (atx_heading) @heading
        (setext_heading) @heading
      ]]
      )

      local headings = {}
      for id, node in query:iter_captures(root, bufnr) do
        local start_line = node:start() + 1
        if start_line > cursor_line then
          local level = get_heading_level(node)
          if level then
            headings[start_line] = level
          end
        end
      end

      -- Check each line: separator first (3c), then heading (3a)
      for i, line in ipairs(lines) do
        local actual_line = cursor_line + i

        -- 3c: Check for separator
        if is_separator_line(line) then
          return actual_line
        end

        -- 3a: Check for heading at or above target level
        if headings[actual_line] and headings[actual_line] <= target_level then
          return actual_line
        end
      end

      -- 3b: No match found, insert at EOF
      return total_lines + 1
    end

    -- Main insertion function
    function M.insert_heading(mode)
      local cursor_line = vim.fn.line(".")

      -- Step 1: Determine source heading
      local source_level = find_source_heading() or 1

      -- Step 2: Determine target heading marker
      local target_level = mode == "subheading" and math.min(source_level + 1, 6) or source_level

      -- Step 3: Determine target line
      local target_line = find_target_line(cursor_line, target_level)

      -- Step 4: Insert heading above target line
      local heading_text = string.rep("#", target_level) .. " "
      local insert_line = target_line - 1

      -- Avoid double blank lines
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

    -- Setup keymaps for markdown buffers
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function(ev)
        vim.keymap.set("n", "<localleader>h", function()
          M.insert_heading("sibling")
        end, { desc = "Insert sibling heading (TS)", buffer = ev.buf })

        vim.keymap.set("n", "<localleader>s", function()
          M.insert_heading("subheading")
        end, { desc = "Insert subheading (TS)", buffer = ev.buf })
      end,
    })
  end,
}
