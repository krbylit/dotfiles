local augroup = vim.api.nvim_create_augroup("ObsidianMd", { clear = true })
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup,
  pattern = { "markdown", "*.md" },
  callback = function()
    vim.schedule(function()
      vim.opt_local.conceallevel = 2
    end)
  end,
})

return {
  "epwalsh/obsidian.nvim",

  enabled = true,
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  -- ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  event = {
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    -- refer to `:h file-pattern` for more examples
    "BufReadPre "
      .. vim.fn.expand("~")
      .. "/obsidian-vault/*.md",
    "BufNewFile " .. vim.fn.expand("~") .. "/obsidian-vault/*.md",
  },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see below for full list of optional dependencies 👇
  },
  keys = {
    -- Note navigation
    { "gf", "<cmd>ObsidianFollowLink<cr>", desc = "Follow link", ft = "markdown" },
    { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Show backlinks", ft = "markdown" },
    { "<leader>ol", "<cmd>ObsidianLinks<cr>", desc = "Show links", ft = "markdown" },

    -- Note creation and search
    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New note", ft = "markdown" },
    { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search notes", ft = "markdown" },
    { "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick switch note", ft = "markdown" },

    -- Daily notes
    { "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "Today's note", ft = "markdown" },
    { "<leader>oy", "<cmd>ObsidianYesterday<cr>", desc = "Yesterday's note", ft = "markdown" },
    { "<leader>om", "<cmd>ObsidianTomorrow<cr>", desc = "Tomorrow's note", ft = "markdown" },

    -- Utilities
    { "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Open in Obsidian app", ft = "markdown" },
    { "<leader>oc", "<cmd>ObsidianToggleCheckbox<cr>", desc = "Toggle checkbox", ft = "markdown" },
    { "<leader>oT", "<cmd>ObsidianTemplate<cr>", desc = "Insert template", ft = "markdown" },
  },
  opts = {
    ui = {
      enable = true, -- set to false to disable all additional syntax features
      update_debounce = 200, -- update delay after a text change (in milliseconds)
      max_file_length = 5000, -- disable UI features for files with more than this many lines
      -- Define how various check-boxes are displayed
      checkboxes = {
        -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
        [">"] = { char = "", hl_group = "ObsidianRightArrow" },
        ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
        ["!"] = { char = "", hl_group = "ObsidianImportant" },
        -- Replace the above with this if you don't have a patched font:
        -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
        -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },

        -- You can also add more custom ones...
      },
      -- Use bullet marks for non-checkbox lists.
      bullets = { char = "•", hl_group = "ObsidianBullet" },
      external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      -- Replace the above with this if you don't have a patched font:
      -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      reference_text = { hl_group = "ObsidianRefText" },
      highlight_text = { hl_group = "ObsidianHighlightText" },
      tags = { hl_group = "ObsidianTag" },
      block_ids = { hl_group = "ObsidianBlockID" },
      hl_groups = {
        -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
        ObsidianTodo = { bold = true, fg = "#f78c6c" },
        ObsidianDone = { bold = true, fg = "#89ddff" },
        ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
        ObsidianTilde = { bold = true, fg = "#ff5370" },
        ObsidianImportant = { bold = true, fg = "#d73128" },
        ObsidianBullet = { bold = true, fg = "#89ddff" },
        ObsidianRefText = { underline = true, fg = "#c792ea" },
        ObsidianExtLinkIcon = { fg = "#c792ea" },
        ObsidianTag = { italic = true, fg = "#89ddff" },
        ObsidianBlockID = { italic = true, fg = "#89ddff" },
        ObsidianHighlightText = { bg = "#75662e" },
      },
    },
    attachments = {
      -- The default folder to place images in via `:ObsidianPasteImg`.
      -- If this is a relative path it will be interpreted as relative to the vault root.
      -- You can always override this per image by passing a full path to the command instead of just a filename.
      img_folder = "assets/imgs", -- This is the default
      -- A function that determines the text to insert in the note when pasting an image.
      -- It takes two arguments, the `obsidian.Client` and an `obsidian.Path` to the image file.
      -- This is the default implementation.
      ---@param client obsidian.Client
      ---@param path obsidian.Path the absolute path to the image file
      ---@return string
      img_text_func = function(client, path)
        path = client:vault_relative_path(path) or path
        return string.format("![%s](%s)", path.name, path)
      end,
    },
    workspaces = {
      -- {
      --     name = "personal",
      --     path = "~/vaults/personal",
      -- },
      {
        name = "work",
        -- path = "~/.local/share/chezmoi/vaults/work",
        path = "~/obsidian-vault",
      },
    },

    -- Where to put new notes created with :ObsidianNew
    notes_subdir = "07_Notes",
    new_notes_location = "notes_subdir",
    completion = {
      -- Set to false to disable completion.
      nvim_cmp = true,
      -- Trigger completion at 2 chars.
      min_chars = 2,
    },
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
      template = nil,
    },

    -- Templates configuration
    templates = {
      folder = "06_Metadata/Templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },

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
    mappings = {
      -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- Toggle check-boxes.
      ["<leader>ch"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
      -- Smart action depending on context, either follow link or toggle checkbox.
      ["<cr>"] = {
        action = function()
          return require("obsidian").util.smart_action()
        end,
        opts = { buffer = true, expr = true },
      },
    },
    -- see below for full list of options 👇
  },
}
