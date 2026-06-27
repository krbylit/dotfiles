-- Roll unfinished tasks forward into a freshly created daily note.
--
-- When a new "today" daily note is created (via the re-registered `Obsidian
-- today` command in plugins/obsidian.lua), `M.migrate` copies every unfinished
-- task from the most recent *previous* daily note into today's `## Tasks`
-- section verbatim, then marks those copied tasks in the previous note as
-- rescheduled (`- [>]`).
--
-- Definitions:
--   * Unfinished = a task bullet whose checkbox char is anything but `x`/`X`
--     AND whose body is non-empty. A body-less bullet (`- [ ]`, `- [ ]   `) is
--     skipped so empty placeholders never propagate.
--   * Completed (`- [x]`) tasks are never copied and never mutated.
--
-- The previous note is found by a single lexical-max scan over `YYYY-MM-DD.md`
-- filenames, so arbitrary gaps (weekends, vacations) are handled with no date
-- arithmetic. All logic lives here so both `<leader>ot` and the fish `t`
-- function (which just runs `nvim +'Obsidian today'`) share one code path.

local M = {}

---@param status string Single checkbox character.
---@return boolean
local function is_done(status)
  return status == "x" or status == "X"
end

--- Parse a markdown task line.
---@param line string
---@return string|nil indent, string|nil status, string|nil body
function M.parse_task(line)
  return line:match("^(%s*)%- %[(.)%]%s?(.*)")
end

--- Find the 1-indexed [start, finish] line range of a `## <heading>` section.
---@param lines string[]
---@param heading string
---@return integer|nil start, integer|nil finish
function M.section_bounds(lines, heading)
  local s
  for i, l in ipairs(lines) do
    if l:match("^##%s+" .. heading .. "%s*$") then
      s = i
      break
    end
  end
  if not s then
    return nil
  end
  local e = #lines
  for i = s + 1, #lines do
    if lines[i]:match("^##%s") then
      e = i - 1
      break
    end
  end
  return s, e
end

--- Absolute path of the most recent daily note strictly before `today_id`.
--- Lexical order == chronological for the `%Y-%m-%d` id format.
---@param today_id string e.g. "2026-06-26"
---@param daily_dir string
---@return string|nil
function M.find_previous_daily(today_id, daily_dir)
  local best
  for name, t in vim.fs.dir(daily_dir) do
    if t == "file" then
      local id = name:match("^(%d%d%d%d%-%d%d%-%d%d)%.md$")
      if id and id < today_id and (not best or id > best) then
        best = id
      end
    end
  end
  return best and (daily_dir .. "/" .. best .. ".md") or nil
end

---@param path string
---@return integer|nil bufnr A loaded buffer holding `path`, if any.
local function loaded_bufnr(path)
  local b = vim.fn.bufnr(path)
  if b ~= -1 and vim.api.nvim_buf_is_loaded(b) then
    return b
  end
end

--- Read a file, preferring a loaded buffer so unsaved edits are respected.
---@param path string
---@return string[] lines, integer|nil bufnr
function M.read_lines(path)
  local b = loaded_bufnr(path)
  if b then
    return vim.api.nvim_buf_get_lines(b, 0, -1, false), b
  end
  return vim.fn.readfile(path), nil
end

--- Write lines back, into the live buffer when one is loaded.
---@param path string
---@param lines string[]
---@param b integer|nil bufnr returned by read_lines
function M.write_lines(path, lines, b)
  if b then
    vim.api.nvim_buf_set_lines(b, 0, -1, false, lines)
  else
    vim.fn.writefile(lines, path)
  end
end

--- Collect unfinished tasks (with their nested children) from a `## Tasks`
--- section.
---@param lines string[]
---@return string[] migrate Verbatim lines to copy forward (parents + children).
---@return integer[] src Source indices whose checkbox should flip to `>`.
function M.collect_unfinished(lines)
  local s, e = M.section_bounds(lines, "Tasks")
  if not s then
    return {}, {}
  end
  local migrate, src = {}, {}
  local i = s + 1
  while i <= e do
    local indent, status, body = M.parse_task(lines[i])
    if indent and not is_done(status) and vim.trim(body) ~= "" then
      table.insert(migrate, lines[i])
      table.insert(src, i)
      -- Carry strictly-more-indented child lines verbatim; also flip any
      -- child that is itself an unfinished task.
      local j = i + 1
      while j <= e do
        local cindent = lines[j]:match("^(%s*)%S")
        if lines[j] ~= "" and cindent and #cindent > #indent then
          table.insert(migrate, lines[j])
          local _, cstatus = M.parse_task(lines[j])
          if cstatus and not is_done(cstatus) then
            table.insert(src, j)
          end
          j = j + 1
        else
          break
        end
      end
      i = j
    else
      i = i + 1
    end
  end
  return migrate, src
end

--- Roll unfinished tasks from the previous daily note into `today_note`.
--- Today is written to disk *before* the previous note is mutated, so an
--- interrupted run can never leave tasks rescheduled-away yet uncopied.
---@param today_note obsidian.Note Freshly written, disk-only (open() not yet called).
---@return integer moved Number of source tasks rescheduled.
function M.migrate(today_note)
  local today_path = tostring(today_note.path)
  local daily_dir = vim.fn.fnamemodify(today_path, ":h")
  local prev_path = M.find_previous_daily(today_note.id, daily_dir)
  if not prev_path then
    return 0
  end

  local prev_lines, prev_buf = M.read_lines(prev_path)
  local migrate, src = M.collect_unfinished(prev_lines)
  if #migrate == 0 then
    return 0
  end

  -- 1) Insert carried tasks into today, above the template's empty placeholder.
  local t_lines = vim.fn.readfile(today_path)
  local ts = M.section_bounds(t_lines, "Tasks")
  if not ts then
    return 0
  end
  local insert_at = ts
  if t_lines[ts + 1] == "" then
    insert_at = ts + 1
  end
  for k = #migrate, 1, -1 do
    table.insert(t_lines, insert_at + 1, migrate[k])
  end
  vim.fn.writefile(t_lines, today_path)

  -- 2) Mark the copied tasks rescheduled in the previous note (flip only the
  -- checkbox char; indent, body, and links are preserved verbatim).
  for _, idx in ipairs(src) do
    prev_lines[idx] = prev_lines[idx]:gsub("^(%s*%- %[).%]", "%1>]")
  end
  M.write_lines(prev_path, prev_lines, prev_buf)

  return #src
end

return M
