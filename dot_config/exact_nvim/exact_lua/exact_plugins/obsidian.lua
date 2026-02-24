-- local augroup = vim.api.nvim_create_augroup("ObsidianMd", { clear = true })
-- vim.api.nvim_create_autocmd({ "FileType" }, {
--   group = augroup,
--   pattern = { "markdown", "*.md" },
--   callback = function()
--     vim.schedule(function()
--       vim.opt_local.conceallevel = 2
--     end)
--   end,
-- })
-- FIX: Obsidian won't disable when in .claude
-- vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
--   group = augroup,
--   pattern = "*/obsidian-vault/.claude/*",
--   callback = function(ev)
--     -- Disable obsidian for this buffer
--     require("obsidian").setup({
--       workspaces = {
--         -- {
--         --     name = "personal",
--         --     path = "~/vaults/personal",
--         -- },
--         {
--           name = "work",
--           -- path = "~/.local/share/chezmoi/vaults/work",
--           path = "~/obsidian-vault",
--         },
--       },
--       ui = {
--         enable = false,
--       },
--     })
--
--     -- Optionally unmap obsidian keybindings for this buffer
--     -- local keymaps_to_unmap = { "gf", "<leader>ch", "<cr>" }
--     -- for _, key in ipairs(keymaps_to_unmap) do
--     --   pcall(vim.keymap.del, "n", key, { buffer = ev.buf })
--     -- end
--   end,
-- })

-- Matched as plain substrings against a normalized path that always has a leading "/".
-- This means:
--   Leading "/" in a pattern anchors to a path separator, so "/CLAUDE.md" matches
--   only files named exactly CLAUDE.md and not e.g. NOT_CLAUDE.md.
--   No leading "/" matches the substring anywhere in the path.
--   Trailing "/" matches only directories (not a file with that name).
local obsidian_excluded_paths = {
  "/src_code/",
  "/src/",
  ".claude/",
  "/CLAUDE.md",
  "/CLAUDE",
  "/SKILLS.md",
  "/AGENTS.md",
}

local function obsidian_path_excluded(fname)
  if not fname then
    return false
  end
  -- Normalize to always have a leading "/" so patterns with a leading "/"
  -- (e.g. "/CLAUDE.md") match correctly against both absolute paths (which
  -- already start with "/") and vault-relative paths (which don't).
  local normalized = fname:match("^/") and fname or ("/" .. fname)
  for _, excluded in ipairs(obsidian_excluded_paths) do
    if normalized:find(excluded, 1, true) then
      return true
    end
  end
  return false
end

return {
  "obsidian-nvim/obsidian.nvim",

  enabled = true,
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = false,
  -- ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre "
  --     .. vim.fn.expand("~")
  --     .. "/obsidian-vault/*.md",
  --   "BufNewFile " .. vim.fn.expand("~") .. "/obsidian-vault/*.md",
  -- },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see below for full list of optional dependencies 👇
  },
  keys = {
    -- Note navigation
    -- gf is configured in callbacks.enter_note to handle both Obsidian links and URLs
    { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Show backlinks", ft = "markdown" },
    { "<leader>ol", "<cmd>Obsidian links<cr>", desc = "Show links", ft = "markdown" },

    -- Note creation and search
    { "<leader>on", "<cmd>Obsidian new<cr>", desc = "New note" },
    { "<leader>os", "<cmd>Obsidian search<cr>", desc = "Search note contents" },
    { "<leader>oq", "<cmd>Obsidian quick_switch<cr>", desc = "Quick switch note", ft = "markdown" },
    { "<leader>oc", ":Obsidian cnew ", desc = "New custom note" },
    { "<leader>oS", ":Obsidian SprintTaskNew ", desc = "New custom note" },

    -- Daily notes
    { "<leader>ot", "<cmd>Obsidian today<cr>", desc = "Today's note" },
    { "<leader>oy", "<cmd>Obsidian yesterday<cr>", desc = "Yesterday's note" },
    { "<leader>or", "<cmd>Obsidian tomorrow<cr>", desc = "Tomorrow's note" },
    { "<leader>om", "<cmd>Obsidian monday<cr>", desc = "Next Monday's note" },
    { "<leader>od", "<cmd>Obsidian dailies<cr>", desc = "Search daily notes", ft = "markdown" },

    -- Utilities
    { "<leader>oo", "<cmd>Obsidian open<cr>", desc = "Open in Obsidian app", ft = "markdown" },
    { "<leader>op", "<cmd>Obsidian scratchpad<cr>", desc = "Open scratch pad" },
    { "<leader>ox", "<cmd>Obsidian toggle_checkbox<cr>", desc = "Toggle checkbox", ft = "markdown" },
    { "<leader>oT", "<cmd>Obsidian template<cr>", desc = "Insert template", ft = "markdown" },

    -- Markdown editing helpers (localleader)
    {
      "<localleader>i",
      "<cmd>Checkbox interactive<cr>",
      desc = "Change checkbox interactively",
      ft = "markdown",
      mode = "n",
    },
    { "<localleader>t", "o- [ ] ", desc = "Add todo item", ft = "markdown", mode = "n" },
    { "<localleader>b", "o- ", desc = "Add bullet point", ft = "markdown", mode = "n" },
    { "<localleader>1", "o# ", desc = "Heading level 1", ft = "markdown", mode = "n" },
    { "<localleader>2", "o## ", desc = "Heading level 2", ft = "markdown", mode = "n" },
    { "<localleader>3", "o### ", desc = "Heading level 3", ft = "markdown", mode = "n" },
    { "<localleader>4", "o#### ", desc = "Heading level 4", ft = "markdown", mode = "n" },
    { "<localleader>c", "o```<CR>```<Esc>O", desc = "Add code block", ft = "markdown", mode = "n" },
    { "<localleader>l", "a[]()<Esc>F[a", desc = "Insert link", ft = "markdown", mode = "n" },
    {
      "<C-p>",
      function()
        local formats = {
          "png",
          "jpg",
          "jpeg",
          "gif",
          "bmp",
          "webp",
          "tiff",
          "heic",
          "avif",
          "mp4",
          "mov",
          "avi",
          "mkv",
          "webm",
          "pdf",
          "icns",
        }

        local function is_image_path(s)
          if not s or s == "" then
            return false
          end
          local ext = s:match("%.([^%.%s]+)%s*$")
          if not ext then
            return false
          end
          ext = ext:lower()
          for _, fmt in ipairs(formats) do
            if ext == fmt then
              return true
            end
          end
          return false
        end

        local function make_relative(img_path, current_file)
          if not img_path:match("^/") then
            return img_path -- already relative
          end
          local current_dir = vim.fn.fnamemodify(current_file, ":h")
          local function split(path)
            local parts = {}
            for part in path:gmatch("[^/]+") do
              table.insert(parts, part)
            end
            return parts
          end
          local src = split(current_dir)
          local dst = split(img_path)
          local common = 0
          for i = 1, math.min(#src, #dst) do
            if src[i] == dst[i] then
              common = i
            else
              break
            end
          end
          local rel = {}
          for _ = common + 1, #src do
            table.insert(rel, "..")
          end
          for i = common + 1, #dst do
            table.insert(rel, dst[i])
          end
          return table.concat(rel, "/")
        end

        local function url_encode_path(path)
          -- % must be encoded first to avoid double-encoding other substitutions
          path = path:gsub("%%", "%%25")
          path = path:gsub(" ", "%%20")
          path = path:gsub("%(", "%%28")
          path = path:gsub("%)", "%%29")
          path = path:gsub("#", "%%23")
          return path
        end

        local function insert_link(img_path)
          img_path = vim.trim(img_path):gsub("^file://", "")
          img_path = vim.fn.expand(img_path)
          local rel = url_encode_path(make_relative(img_path, vim.api.nvim_buf_get_name(0)))
          local link = string.format("![img](%s)", rel)
          local row, col = unpack(vim.api.nvim_win_get_cursor(0))
          local line = vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1] or ""
          local insert_col = math.min(col + 1, #line)
          vim.api.nvim_buf_set_text(0, row - 1, insert_col, row - 1, insert_col, { link })
          vim.api.nvim_win_set_cursor(0, { row, insert_col + #link })
        end

        -- + is system clipboard (cmd+c), * is primary selection; check both
        local clip = vim.trim(vim.fn.getreg("+"))
        if not is_image_path(clip) then
          clip = vim.trim(vim.fn.getreg("*"))
        end

        -- Only auto-insert from clipboard if the path contains a slash (i.e. it
        -- has an explicit directory component). A bare filename like
        -- "20260218223540.png" falls through so the user can prepend the path.
        if is_image_path(clip) and clip:find("/", 1, true) then
          insert_link(clip)
        else
          -- Try img-clip for actual image data in clipboard (screenshots, copied images).
          -- img-clip is configured per filetype in img-clip.lua to save to the obsidian
          -- attachments folder and insert a relative markdown link.
          local ok, img_clip = pcall(require, "img-clip")
          if ok and img_clip.pasteImage() then
            -- img-clip defers its insertion, so defer stopinsert to run after it
            vim.schedule(function()
              vim.cmd("stopinsert")
            end)
            return
          end
          -- No image data found; fall back to manual path input
          vim.ui.input({ prompt = "Image path: " }, function(input)
            if not input or input == "" then
              return
            end
            insert_link(input)
          end)
        end
      end,
      desc = "Paste image link at cursor",
      ft = "markdown",
      mode = "n",
    },
    {
      "<localleader>h",
      function()
        local current_line = vim.fn.line(".")

        -- Check if current line is a heading first
        local heading_level = nil
        local current_line_content = vim.fn.getline(".")
        -- Match headings with or without text after # (accepts empty headings)
        local current_level = current_line_content:match("^(#+)")
        if current_level then
          heading_level = #current_level
        else
          -- Search backwards for heading (using native search)
          -- Pattern matches 1-6 # chars followed by space or end of line
          local pos = vim.fn.searchpos("^#\\{1,6\\}\\(\\s\\|$\\)", "bnW")
          if pos[1] > 0 then
            local line_content = vim.fn.getline(pos[1])
            local level = line_content:match("^(#+)")
            heading_level = #level
          end
        end

        -- Default to level 1 if no heading found
        if not heading_level then
          heading_level = 1
        end

        -- Find where to insert: before next heading/separator of same or higher level, or EOF
        -- Search for headings OR section separators (---, ===)
        local insert_line = vim.fn.line("$") -- Default to end of file
        local saved_pos = vim.fn.getcurpos()
        local search_start = current_line + 1
        vim.fn.cursor(search_start, 1)

        -- Search for headings (with or without text) OR section separators
        local next_pos = vim.fn.search("^\\(#\\{1,6\\}\\(\\s\\|$\\)\\|---\\+\\s*$\\|===\\+\\s*$\\)", "W")
        while next_pos > 0 do
          -- Skip if we matched the line right after cursor (we want to insert within current section)
          if next_pos == search_start then
            local line_content = vim.fn.getline(next_pos)
            local level = line_content:match("^(#+)")
            -- Only skip if this heading is appropriate level (would be our boundary)
            if
              line_content:match("^---+%s*$")
              or line_content:match("^===+%s*$")
              or (level and #level <= heading_level)
            then
              -- This is a boundary right after cursor, insert before it
              insert_line = next_pos - 1
              break
            end
          end

          local line_content = vim.fn.getline(next_pos)

          -- Check if it's a section separator (treat as boundary)
          if line_content:match("^---+%s*$") or line_content:match("^===+%s*$") then
            insert_line = next_pos - 1
            break
          end

          -- Check if it's a heading of appropriate level
          local level = line_content:match("^(#+)")
          if level and #level <= heading_level then
            insert_line = next_pos - 1
            break
          end

          vim.fn.cursor(next_pos + 1, 1)
          next_pos = vim.fn.search("^\\(#\\{1,6\\}\\(\\s\\|$\\)\\|---\\+\\s*$\\|===\\+\\s*$\\)", "W")
        end

        vim.fn.setpos(".", saved_pos) -- restore cursor

        -- Insert heading (with blank line before it if needed)
        local heading_text = string.rep("#", heading_level) .. " "
        local insert_line_content = vim.fn.getline(insert_line)

        if insert_line_content:match("^%s*$") then
          -- insert_line is already blank, just add heading without extra blank line
          vim.fn.append(insert_line, heading_text)
          vim.fn.cursor(insert_line + 1, #heading_text + 1)
        else
          -- insert_line has content, add blank line before heading
          vim.fn.append(insert_line, { "", heading_text })
          vim.fn.cursor(insert_line + 2, #heading_text + 1)
        end

        vim.cmd("startinsert!")
      end,
      desc = "Add heading (same level)",
      ft = "markdown",
      mode = "n",
    },
    {
      "<localleader>s",
      function()
        local current_line = vim.fn.line(".")

        -- Check if current line is a heading first
        local heading_level = nil
        local current_line_content = vim.fn.getline(".")
        -- Match headings with or without text after # (accepts empty headings)
        local current_level = current_line_content:match("^(#+)")
        if current_level then
          heading_level = #current_level
        else
          -- Search backwards for heading (using native search)
          -- Pattern matches 1-6 # chars followed by space or end of line
          local pos = vim.fn.searchpos("^#\\{1,6\\}\\(\\s\\|$\\)", "bnW")
          if pos[1] > 0 then
            local line_content = vim.fn.getline(pos[1])
            local level = line_content:match("^(#+)")
            heading_level = #level
          end
        end

        -- Default to level 2 if no heading found (subheading of implicit level 1)
        if not heading_level then
          heading_level = 2
        else
          heading_level = heading_level + 1
        end

        -- Clamp to max level 6
        if heading_level > 6 then
          heading_level = 6
        end

        -- Find where to insert: before next heading/separator of equal or higher level, or EOF
        -- Search for headings OR section separators (---, ===)
        -- Stop at headings equal to or higher than what we're inserting (not just parent level)
        local insert_line = vim.fn.line("$") -- Default to end of file
        local saved_pos = vim.fn.getcurpos()
        local search_start = current_line + 1
        vim.fn.cursor(search_start, 1)

        local next_pos = vim.fn.search("^\\(#\\+\\s\\|---\\+\\s*$\\|===\\+\\s*$\\)", "W")
        while next_pos > 0 do
          -- Skip if we matched the line right after cursor (we want to insert within current section)
          if next_pos == search_start then
            local line_content = vim.fn.getline(next_pos)
            local level = line_content:match("^(#+)")
            -- Only skip if this heading is appropriate level (would be our boundary)
            if
              line_content:match("^---+%s*$")
              or line_content:match("^===+%s*$")
              or (level and #level <= heading_level)
            then
              -- This is a boundary right after cursor, insert before it
              insert_line = next_pos - 1
              break
            end
          end

          local line_content = vim.fn.getline(next_pos)

          -- Check if it's a section separator (treat as boundary)
          if line_content:match("^---+%s*$") or line_content:match("^===+%s*$") then
            insert_line = next_pos - 1
            break
          end

          -- Check if it's a heading of equal or higher level than what we're inserting
          local level = line_content:match("^(#+)")
          if level and #level <= heading_level then
            insert_line = next_pos - 1
            break
          end

          vim.fn.cursor(next_pos + 1, 1)
          next_pos = vim.fn.search("^\\(#\\+\\s\\|---\\+\\s*$\\|===\\+\\s*$\\)", "W")
        end

        vim.fn.setpos(".", saved_pos) -- restore cursor

        -- Insert heading (with blank line before it if needed)
        local heading_text = string.rep("#", heading_level) .. " "
        local insert_line_content = vim.fn.getline(insert_line)

        if insert_line_content:match("^%s*$") then
          -- insert_line is already blank, just add heading without extra blank line
          vim.fn.append(insert_line, heading_text)
          vim.fn.cursor(insert_line + 1, #heading_text + 1)
        else
          -- insert_line has content, add blank line before heading
          vim.fn.append(insert_line, { "", heading_text })
          vim.fn.cursor(insert_line + 2, #heading_text + 1)
        end

        vim.cmd("startinsert!")
      end,
      desc = "Add sub-heading (one level deeper)",
      ft = "markdown",
      mode = "n",
    },
  },
  opts = {
    -- Disable legacy commands (use new "Obsidian <action>" format instead)
    legacy_commands = false,

    -- Disable frontmatter insertion for excluded paths
    ---@type obsidian.config.FrontmatterOpts
    frontmatter = {
      enabled = function(fname)
        return not obsidian_path_excluded(fname)
      end,

      -- Fields: id, aliases, tags, created (file birthtime, set once), updated (refreshed on save)
      func = function(note)
        local out = { id = note.id, aliases = note.aliases, tags = note.tags }

        -- created: preserve if already set, otherwise use file birthtime
        local existing_created = note:get_field("created")
        if existing_created then
          out.created = existing_created
        else
          local stat = note.path and (vim.uv or vim.loop).fs_stat(tostring(note.path))
          if stat and stat.birthtime then
            out.created = os.date("%Y-%m-%dT%H:%M:%S", stat.birthtime.sec)
          else
            out.created = os.date("%Y-%m-%dT%H:%M:%S")
          end
        end

        -- updated: always set to current time on save
        out.updated = os.date("%Y-%m-%dT%H:%M:%S")

        -- preserve any other metadata fields already on the note
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            if out[k] == nil then
              out[k] = v
            end
          end
        end

        return out
      end,

      sort = { "id", "aliases", "tags", "created", "updated" },
    },

    -- Checkbox configuration
    ---@type obsidian.config.CheckboxOpts
    checkbox = {
      enabled = true,
      create_new = true,
      -- Order defines checkbox state progression when toggling
      order = { " ", "/", "x", "-" },
    },

    ui = {
      -- NOTE: deprecated in newer obsidian.nvim
      enable = false, -- set to false to disable all additional syntax features
    },
    ---@type obsidian.config.AttachmentsOpts
    attachments = {
      -- The default folder to place images in via `:ObsidianPasteImg`.
      -- If this is a relative path it will be interpreted as relative to the vault root.
      -- You can always override this per image by passing a full path to the command instead of just a filename.
      folder = "05_Attachments/images", -- This is the default
    },
    workspaces = {
      -- {
      --     name = "personal",
      --     path = "~/vaults/personal",
      -- },
      {
        name = "work",
        path = "~/obsidian-vault",
      },
    },

    -- wiki_link_func = require("obsidian.builtin").wiki_link_id_prefix,
    -- markdown_link_func = require("obsidian.builtin").markdown_link,
    preferred_link_style = "wiki",
    ---@type obsidian.config.CommentOpts
    comment = {
      enabled = true,
    },
    completion = {
      -- Set to false to disable completion.
      nvim_cmp = true,
      -- Trigger completion at 2 chars.
      min_chars = 2,
    },
    -- Where to put new notes created with :ObsidianNew
    notes_subdir = "07_Notes",
    new_notes_location = "notes_subdir",
    ---@type obsidian.config.NoteOpts
    note = {
      -- template = "",
    },
    ---@type obsidian.config.DailyNotesOpts
    daily_notes = {
      -- Optional, if you keep daily notes in a separate directory.
      folder = "07_Notes/00_Daily",
      -- Optional, if you want to change the date format for the ID of daily notes.
      date_format = "%Y-%m-%d",
      -- Optional, if you want to change the date format of the default alias of daily notes.
      alias_format = "%B %-d, %Y",
      -- Optional, default tags to add to each new daily note created.
      default_tags = { "daily-notes" },
      -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
      template = "obsidian-daily-note.md",
      workdays_only = false,
    },

    -- Templates configuration
    ---@type obsidian.config.TemplateOpts
    templates = {
      folder = "06_Metadata/Templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      -- Custom substitutions for variables passed to templates
      substitutions = {
        -- Custom substitution for daily note heading: "Monday 2026-02-06"
        -- accessible in templates as `{{daily_heading}}`
        daily_heading = function(ctx)
          if not ctx.partial_note or not ctx.partial_note.id then
            return ""
          end

          -- Parse the note ID as a date (format: YYYY-MM-DD)
          local id = ctx.partial_note.id
          local year, month, day = id:match("(%d%d%d%d)-(%d%d)-(%d%d)")

          if not year then
            return id -- Return the ID as-is if we can't parse it
          end

          -- Create a timestamp from the parsed date
          local timestamp = os.time({
            year = tonumber(year),
            month = tonumber(month),
            day = tonumber(day),
            hour = 12, -- Use noon to avoid DST issues
          })

          -- Format as "Monday 24-02-06"
          local day_name = os.date("%A", timestamp)
          local short_date = os.date("%Y-%m-%d", timestamp)

          return string.format("%s %s", day_name, short_date)
        end,
      },
      ---@type obsidian.config.CustomTemplateOpts
      customizations = {},
    },
    -- ---@type obsidian.config.BacklinkOpts
    -- backlinks = {
    --   parse_headers = true,
    -- },
    ---@type obsidian.config.PickerNoteMappingOpts
    picker = {
      -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
      name = "fzf-lua",
      -- Optional, configure key mappings for the picker. These are the defaults.
      -- Not all pickers support all mappings.
      mappings = {
        -- Create a new note from your query.
        new = "<C-x>",
        -- Insert a link to the selected note.
        insert_link = "<C-l>",
      },
    },

    -- Callbacks for setting up buffer-local keymaps
    ---@type obsidian.config.CallbackConfig
    callbacks = {
      enter_note = function()
        if obsidian_path_excluded(vim.api.nvim_buf_get_name(0)) then
          return
        end

        -- Enable markview hybrid mode for obsidian notes (if not already on)
        local bufnr = vim.api.nvim_get_current_buf()
        local ok, state_mod = pcall(require, "markview.state")
        if ok then
          local state = state_mod.get_buffer_state(bufnr, false)
          if state and not state.hybrid_mode then
            vim.cmd("Markview hybridToggle")
          end
        end

        -- Buffer-local keymaps for obsidian notes
        -- gf to follow links
        vim.keymap.set("n", "gf", function()
          return require("obsidian").util.gf_passthrough()
        end, { noremap = false, expr = true, buffer = true, desc = "Follow Obsidian link" })

        -- <leader>ch to toggle checkboxes
        vim.keymap.set("n", "<leader>ch", function()
          return require("obsidian").util.toggle_checkbox()
        end, { buffer = true, desc = "Toggle checkbox" })

        -- <cr> for smart action
        vim.keymap.set("n", "<cr>", function()
          return require("obsidian").util.smart_action()
        end, { buffer = true, expr = true, desc = "Smart action" })
      end,
    },
    ---@type obsidian.config.FooterOpts
    footer = {
      enabled = true,
      format = "{{backlinks}} backlinks  {{properties}} properties  {{words}} words  {{chars}} chars",
      hl_group = "Comment",
      separator = string.rep("-", 80),
    },

    -- see below for full list of options 👇
  },
  config = function(_, opts)
    -- Setup obsidian.nvim with the opts
    require("obsidian").setup(opts)

    -- Register custom "monday" subcommand using obsidian.nvim's command system
    local commands = require("obsidian.commands")
    commands.register("monday", {
      nargs = 0,
      func = function()
        local now = os.date("*t")
        local current_weekday = now.wday -- 1=Sunday, 2=Monday, ..., 7=Saturday

        -- Calculate days until next Monday
        local days_until_monday
        if current_weekday == 1 then -- Sunday
          days_until_monday = 1
        elseif current_weekday == 2 then -- Monday
          days_until_monday = 7 -- Next Monday, not today
        else -- Tuesday-Saturday (3-7)
          days_until_monday = 9 - current_weekday
        end

        -- Use the daily note function with offset
        local note = require("obsidian.daily").daily(days_until_monday, {})
        note:open()
      end,
    })

    -- Register custom "scratchpad" subcommand that opens the scratch pad note
    commands.register("scratchpad", {
      nargs = 0,
      func = function()
        local note_path = tostring(Obsidian.workspace.path) .. "/00_Inbox/scratch_workspace/scratch-pad.md"
        vim.cmd("edit " .. note_path)
      end,
    })

    -- Register custom "cnew" (custom new) subcommand that creates notes with custom IDs
    -- Usage:
    --   :Obsidian cnew todos                    → creates 07_Notes/todos.md
    --   :Obsidian cnew projects/my-project      → creates 07_Notes/projects/my-project.md
    commands.register("cnew", {
      nargs = 1,
      func = function(data)
        local Note = require("obsidian.note")
        local Path = require("obsidian.path")
        local input = data.args -- Get the argument string

        if not input or input == "" then
          vim.notify("Usage: :Obsidian cnew <note-id> or :Obsidian cnew <path/to/note-id>", vim.log.levels.ERROR)
          return
        end

        -- Trim whitespace
        input = input:match("^%s*(.-)%s*$")

        -- Parse path: split by "/" to get directory and note ID
        local parts = vim.split(input, "/", { plain = true, trimempty = true })
        local id = parts[#parts] -- Last component is the note ID
        local subdir = nil

        -- If there are parent directories, construct the subdirectory path
        if #parts > 1 then
          table.remove(parts, #parts) -- Remove the ID from parts
          subdir = table.concat(parts, "/")
        end

        -- Sanitize the ID (replace spaces with hyphens, remove invalid characters)
        id = id:gsub("%s+", "-")
        id = id:gsub("[^%w%-_]", "")

        -- Construct the full directory path relative to notes_subdir
        local dir
        if subdir then
          dir = Path.new(Obsidian.opts.notes_subdir) / subdir
        else
          dir = Path.new(Obsidian.opts.notes_subdir)
        end

        -- Create note with verbatim=true to bypass note_id_func and use ID exactly as-is
        local note = Note.create({
          id = id,
          dir = dir, -- Specify the directory for the note
          verbatim = true, -- Skip note_id_func processing
          aliases = {}, -- Don't auto-add title as alias
          should_write = true,
        })

        -- Open the note
        note:open({ sync = true })
      end,
    })

    -- :Obsidian SprintTaskNew <note-id>
    --   Creates a new sprint task note in 01_Projects/ using the sprint-task.md template
    --   Example:
    --   :Obsidian SprintTaskNew my-feature   → creates 01_Projects/my-feature.md with sprint-task template
    commands.register("SprintTaskNew", {
      nargs = 1,
      func = function(data)
        local Note = require("obsidian.note")
        local Path = require("obsidian.path")
        local input = data.args

        if not input or input == "" then
          vim.notify("Usage: :Obsidian SprintTaskNew <note-id>", vim.log.levels.ERROR)
          return
        end

        input = input:match("^%s*(.-)%s*$")

        local parts = vim.split(input, "/", { plain = true, trimempty = true })
        local id = parts[#parts]
        local subdir = nil

        if #parts > 1 then
          table.remove(parts, #parts)
          subdir = table.concat(parts, "/")
        end

        id = id:gsub("%s+", "-"):gsub("[^%w%-_]", "")

        local dir
        if subdir then
          dir = Path.new("01_Projects") / subdir
        else
          dir = Path.new("01_Projects")
        end

        local note = Note.create({
          id = id,
          dir = dir,
          verbatim = true,
          aliases = {},
          should_write = true,
          template = "sprint-task.md",
        })

        note:open({ sync = true })
      end,
    })
  end,
}
