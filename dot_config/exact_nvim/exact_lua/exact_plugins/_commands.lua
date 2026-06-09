-- Custom commands
-- Global custom commands that can be used anywhere in Neovim

-- ============================================================
-- Todo commands (requires obsidian.nvim to be loaded first)
-- ============================================================

-- Helper function to add a todo item
local function add_todo(input)
  if not Obsidian then
    vim.notify("Obsidian not loaded", vim.log.levels.ERROR)
    return
  end

  local workspace_path = Obsidian.workspace.path
  local todo_file = workspace_path / "07_Notes/01_TODOs/todos.md"

  -- Check if file ends with newline so we don't create blank lines
  local needs_newline = false
  local check = io.open(tostring(todo_file), "r")
  if check then
    local size = check:seek("end")
    if size and size > 0 then
      check:seek("end", -1)
      needs_newline = check:read(1) ~= "\n"
    end
    check:close()
  end

  -- Append to file
  local file = io.open(tostring(todo_file), "a")
  if file then
    file:write((needs_newline and "\n" or "") .. "- [ ] " .. input .. "\n")
    file:close()
    vim.notify("TODO added: " .. input, vim.log.levels.INFO)
  else
    vim.notify("Failed to open TODOs file: " .. tostring(todo_file), vim.log.levels.ERROR)
  end
end

-- Register commands immediately
vim.api.nvim_create_user_command("TodoAdd", function(opts)
  if opts.args == "" then
    -- No argument provided, prompt for input
    vim.ui.input({ prompt = "TODO: " }, function(input)
      if not input or input == "" then
        return
      end
      add_todo(input)
    end)
  else
    -- Argument provided, use it directly
    add_todo(opts.args)
  end
end, { nargs = "?", desc = "Add todo to todos.md" })

vim.api.nvim_create_user_command("TodoOpen", function()
  if not Obsidian then
    vim.notify("Obsidian not loaded", vim.log.levels.ERROR)
    return
  end

  local workspace_path = Obsidian.workspace.path
  local todo_file = workspace_path / "07_Notes/01_TODOs/todos.md"
  vim.cmd("edit " .. tostring(todo_file))
end, { desc = "Open todos.md for editing" })

-- Keymaps for todo commands
vim.keymap.set("n", "<leader>ta", "<cmd>TodoAdd<cr>", { desc = "Add TODO" })
vim.keymap.set("n", "<leader>to", "<cmd>TodoOpen<cr>", { desc = "Open TODOs" })

-- ============================================================
-- Daily note todo commands
-- ============================================================

--- Get today's daily note path using obsidian.nvim config
local function get_today_daily_path()
  if not Obsidian then
    vim.notify("Obsidian not loaded", vim.log.levels.ERROR)
    return nil
  end
  local daily = require("obsidian.daily")
  local path = daily.daily_note_path(os.time())
  return tostring(path)
end

--- Add a todo to today's daily note, inserted above ## Notes
local function add_todo_today(input)
  local path = get_today_daily_path()
  if not path then
    return
  end

  -- Read the file
  local file = io.open(path, "r")
  if not file then
    vim.notify("Daily note not found: " .. path, vim.log.levels.ERROR)
    return
  end
  local content = file:read("*a")
  file:close()

  -- Insert the todo line above "## Notes"
  local todo_line = "- [ ] " .. input
  local new_content, count = content:gsub("(\n## Notes)", "\n" .. todo_line .. "\n%1")
  if count == 0 then
    -- No ## Notes section found, append to end
    new_content = content .. "\n" .. todo_line .. "\n"
  end

  file = io.open(path, "w")
  if not file then
    vim.notify("Failed to write daily note", vim.log.levels.ERROR)
    return
  end
  file:write(new_content)
  file:close()

  -- Reload buffer if it's open
  local bufnr = vim.fn.bufnr(path)
  if bufnr ~= -1 then
    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd("edit!")
    end)
  end

  vim.notify("TODO added to today's daily note", vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("TodoToday", function(opts)
  if opts.args == "" then
    vim.ui.input({ prompt = "Today TODO: " }, function(input)
      if not input or input == "" then
        return
      end
      add_todo_today(input)
    end)
  else
    add_todo_today(opts.args)
  end
end, { nargs = "?", desc = "Add todo to today's daily note" })

vim.keymap.set("n", "<leader>tt", "<cmd>TodoToday<cr>", { desc = "Add TODO to today" })

-- ============================================================
-- Backlog commands
-- ============================================================

local function get_backlog_path()
  if not Obsidian then
    vim.notify("Obsidian not loaded", vim.log.levels.ERROR)
    return nil
  end
  return tostring(Obsidian.workspace.path / "07_Notes/01_TODOs/backlog.md")
end

--- Get today's heading string (e.g. "# Monday 2026-04-10")
local function today_heading()
  return "# " .. os.date("%A %Y-%m-%d")
end

--- Move selected lines to backlog, grouped under today's date heading
local function move_to_backlog(line1, line2)
  local backlog_path = get_backlog_path()
  if not backlog_path then
    return
  end

  -- Get selected lines from current buffer
  local lines = vim.api.nvim_buf_get_lines(0, line1 - 1, line2, false)
  if #lines == 0 then
    return
  end

  -- Delete the selected lines from current buffer
  vim.api.nvim_buf_set_lines(0, line1 - 1, line2, false, {})

  -- Read backlog
  local file = io.open(backlog_path, "r")
  if not file then
    vim.notify("Backlog file not found: " .. backlog_path, vim.log.levels.ERROR)
    return
  end
  local content = file:read("*a")
  file:close()

  -- Check if today's heading already exists
  local heading = today_heading()
  local escaped_heading = heading:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1")

  if content:find(escaped_heading) then
    -- Append lines after the last line under today's heading
    -- Find the heading, then find the next L1 heading or end of file
    local heading_pos = content:find(escaped_heading)
    local after_heading = heading_pos + #heading
    -- Find the next L1 heading after this one
    local next_heading = content:find("\n# ", after_heading)
    local insert_pos
    if next_heading then
      -- Insert before the next heading (before its preceding newline)
      insert_pos = next_heading
    else
      -- No next heading, append to end
      insert_pos = #content
    end

    -- Ensure we end with a newline before inserting
    local prefix = ""
    if insert_pos > 0 and content:sub(insert_pos, insert_pos) ~= "\n" then
      prefix = "\n"
    end

    local insert_text = prefix .. table.concat(lines, "\n") .. "\n"
    content = content:sub(1, insert_pos) .. insert_text .. content:sub(insert_pos + 1)
  else
    -- Add new date heading at end of file
    local suffix = "\n" .. heading .. "\n\n" .. table.concat(lines, "\n") .. "\n"
    -- Ensure file ends with single newline before appending
    content = content:gsub("\n*$", "\n") .. suffix
  end

  file = io.open(backlog_path, "w")
  if not file then
    vim.notify("Failed to write backlog", vim.log.levels.ERROR)
    return
  end
  file:write(content)
  file:close()

  -- Reload backlog buffer if open
  local bufnr = vim.fn.bufnr(backlog_path)
  if bufnr ~= -1 then
    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd("edit!")
    end)
  end

  vim.notify(#lines .. " item(s) moved to backlog", vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("TodoBacklog", function(opts)
  move_to_backlog(opts.line1, opts.line2)
end, { range = true, desc = "Move selected todos to backlog" })

vim.api.nvim_create_user_command("BacklogOpen", function()
  local path = get_backlog_path()
  if path then
    vim.cmd("edit " .. path)
  end
end, { desc = "Open backlog.md" })

vim.keymap.set("v", "<leader>tb", ":TodoBacklog<cr>", { desc = "Move to backlog" })
vim.keymap.set("n", "<leader>tl", "<cmd>BacklogOpen<cr>", { desc = "Open backlog" })

-- ============================================================
-- Other custom commands (add more here)
-- ============================================================

return {}
