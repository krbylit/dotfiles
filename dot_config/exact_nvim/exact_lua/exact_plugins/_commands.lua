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
-- Other custom commands (add more here)
-- ============================================================

return {}
