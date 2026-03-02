-- QoL mini-plugins
-- https://github.com/folke/snacks.nvim
local function get_terminal_size()
  local width = vim.api.nvim_get_option_value("columns", {}) -- Get terminal width
  local height = vim.api.nvim_get_option_value("lines", {}) -- Get terminal height
  return width, height
end
local terminal_width, terminal_height = get_terminal_size()
local logo_file = require("utils.dashboard.dash-helpers").random_logo_file()
local measure_logo_file = require("utils.dashboard.dash-helpers").measure_logo_file
local logo_width, logo_height = measure_logo_file(logo_file)
local pane_width = math.floor(terminal_width / 4)

-- Calculate speed multiplier based on logo line count
-- Adjusted to keep animation duration similar with different heights
local logo_speed_multiplier = 1
if logo_height > 20 then
  logo_speed_multiplier = 1.75
elseif logo_height > 15 then
  logo_speed_multiplier = 1.5
elseif logo_height > 10 then
  logo_speed_multiplier = 1.25
end
local lolcat_delay = math.max(1, math.floor(4 / logo_speed_multiplier))

local tte_cmds = {
  "synthgrid --text-gradient-steps 12 --grid-gradient-steps 12 --max-active-blocks .9",
  "slide --movement-speed 2 --final-gradient-steps 24 --final-gradient-frames 12 --movement-easing in_out_circ",
  "sweep --final-gradient-steps 24",
  "expand --movement-speed .5 --final-gradient-steps 24 --final-gradient-frames 8",
  "middleout --center-movement-speed 1.5 --full-movement-speed .5 --final-gradient-steps 24",
  "overflow --overflow-cycles-range 4-5 --overflow-speed 3 --final-gradient-steps 24",
  "randomsequence --speed .05 --final-gradient-steps 24 --final-gradient-frames 12",
  "scattered --movement-speed .75 --final-gradient-steps 24 --final-gradient-frames 12",
  "slice --movement-speed .35",
  "beams --beam-delay 2 --beam-gradient-frames 2 --final-wipe-speed 5 --beam-row-speed-range 40-60 --beam-column-speed-range 15-20",
  "smoke --final-gradient-steps 24",
  "highlight --highlight-brightness 1.75 --highlight-width 4 --final-gradient-steps 12",
}
local random_tte_cmd = tte_cmds[math.random(#tte_cmds)]

local terminal_toys_cmds = {
  "terminal-toys cube --tick-rate 20 --amplitude 5 --frequency 5 --color-speed .5",
  "terminal-toys cube --tick-rate 20 --amplitude 3 --frequency 1 --speed 1 --color-speed .2 --x-rotation-speed .04 --y-rotation-speed .75",
  "terminal-toys cube --tick-rate 20 --amplitude 3 --frequency 1 --speed 1 --color-speed .2 --x-rotation-speed .4 --y-rotation-speed .01",
  "terminal-toys cube --tick-rate 20 --amplitude 3 --frequency 1 --speed 1 --color-speed .2 --x-rotation-speed .4 --y-rotation-speed .1",
  "terminal-toys cube --tick-rate 20 --amplitude 5 --frequency 5 --speed .5 --color-speed .5 --x-rotation-speed .04 --y-rotation-speed .75 --z-rotation-speed .1",
  "terminal-toys cube --tick-rate 20 --amplitude 5 --frequency 5 --speed .5 --color-speed .5 --x-rotation-speed .4 --y-rotation-speed .01 --z-rotation-speed .1",
  "terminal-toys cube --tick-rate 20 --amplitude 5 --frequency 5 --speed .5 --color-speed .5 --x-rotation-speed .4 --y-rotation-speed .1 --z-rotation-speed .1",
  "terminal-toys cube --tick-rate 20 --amplitude 5 --frequency 5 --speed .5 --color-speed .5 --x-rotation-speed .04 --y-rotation-speed .75",
  "terminal-toys cube --tick-rate 20 --amplitude 5 --frequency 5 --speed .5 --color-speed .5 --x-rotation-speed .4 --y-rotation-speed .01",
  "terminal-toys cube --tick-rate 20 --amplitude 5 --frequency 5 --speed .5 --color-speed .5 --x-rotation-speed .4 --y-rotation-speed .1",
  "terminal-toys cube --tick-rate 20 --amplitude 5 --frequency 5",
  "terminal-toys cube --tick-rate 20 --amplitude 3 --frequency 1 --speed 1 --x-rotation-speed .04 --y-rotation-speed .75",
  "terminal-toys cube --tick-rate 20 --amplitude 3 --frequency 1 --speed 1 --x-rotation-speed .4 --y-rotation-speed .01",
  "terminal-toys cube --tick-rate 20 --amplitude 3 --frequency 1 --speed 1 --x-rotation-speed .4 --y-rotation-speed .1",
  "terminal-toys cube --tick-rate 20 --amplitude 5 --frequency 5 --speed .5 --x-rotation-speed .04 --y-rotation-speed .75 --z-rotation-speed .1",
  "terminal-toys cube --tick-rate 20 --amplitude 5 --frequency 5 --speed .5 --x-rotation-speed .4 --y-rotation-speed .01 --z-rotation-speed .1",
  "terminal-toys cube --tick-rate 20 --amplitude 5 --frequency 5 --speed .5 --x-rotation-speed .4 --y-rotation-speed .1 --z-rotation-speed .1",
  "terminal-toys cube --tick-rate 20 --amplitude 5 --frequency 5 --speed .5 --x-rotation-speed .04 --y-rotation-speed .75",
  "terminal-toys cube --tick-rate 20 --amplitude 5 --frequency 5 --speed .5 --x-rotation-speed .4 --y-rotation-speed .01",
  "terminal-toys cube --tick-rate 20 --amplitude 5 --frequency 5 --speed .5 --x-rotation-speed .4 --y-rotation-speed .1",
  -- "terminal-toys life -m Braille",
  -- "terminal-toys bubble -m Braille -a 25 -b 50 -n 8",
  -- "terminal-toys bubble -m Braille -a 10 -b 150",
}
local random_terminal_toys_cmd = terminal_toys_cmds[math.random(#terminal_toys_cmds)]

local picker = require("snacks.picker")

---@diagnostic disable: missing-fields
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    ---@type snacks.win.Config
    styles = {
      notification = {
        wo = { wrap = true }, -- Wrap notifications
      },
      lazygit = {
        -- Make lazygit fullscreen
        height = 0,
        width = 0,
      },
      terminal = {
        keys = {
          -- Keymap to escape to normal mode in nvim. Allows scrolling terminal, entering commands, etc.
          term_normal = {
            "<c-q>",
            function(self)
              vim.cmd("stopinsert")
            end,
            mode = "t",
            expr = true,
            desc = "Escape to normal mode",
          },
        },
      },
    },
    bigfile = { enabled = true },
    ---@type snacks.terminal.Config
    terminal = {
      -- Open Snacks terminals as float
      ---@type snacks.win.Config
      win = {
        style = "terminal",
        position = "float",
        width = 160, -- set your preferred column width
      },
      -- Auto-run zellij when terminal opens
      shell = "zellij",
    },
    input = { enabled = true },
    ---@type snacks.lazygit.Config: snacks.terminal.Opts
    lazygit = {
      enabled = true,
      configure = true,
      win = {
        -- 0 = max width/height
        height = 0,
        width = 0,
        position = "float",
        style = "lazygit",
      },
    },
    notifier = {
      style = "fancy", -- "compact" | "minimal" | "fancy"
      enabled = true, -- Disabling for now because <leader>un not working to view all notis
      timeout = 3000,
    },
    quickfile = {},
    -- FIX: disabling for now as upgrading from snacks #70afc4225ac8ae3e6c8af88d205b03991a173af3 makes scroll not work well (likely due to our high scrolloff setting?)
    scroll = { enabled = false },
    scope = { enabled = true },
    ---@type snacks.statuscolumn.Config
    -- FIX: Doesn't appear to be working in conjunction with statuscol. We like snacks because the folds and git signs are nice.
    statuscolumn = {
      enabled = false,
      -- left = { "mark", "sign" }, -- priority of signs on the left (high to low)
      -- right = { "fold", "git" }, -- priority of signs on the right (high to low)
      -- folds = {
      --     open = true, -- show open fold icons
      --     git_hl = true, -- use Git Signs hl for fold icons
      -- },
      -- git = {
      --     -- patterns to match Git signs
      --     patterns = { "GitSign", "MiniDiffSign" },
      -- },
      -- refresh = 100, -- refresh at most every 100ms
    },
    ---@type snacks.words.Config
    words = { enabled = true },
    ---@type snacks.zen.Config
    zen = {
      enabled = true,
      toggles = {
        diagnostics = false,
        inlay_hints = false,
      },
    },
    gh = {
      --- Keymaps for GitHub buffers
      ---@type table<string, snacks.gh.Keymap|false>?
      keys = {
        select = { "<cr>", "gh_actions", desc = "Select Action" },
        edit = { "i", "gh_edit", desc = "Edit" },
        comment = { "a", "gh_comment", desc = "Add Comment" },
        close = { "c", "gh_close", desc = "Close" },
        reopen = { "o", "gh_reopen", desc = "Reopen" },
      },
    },
    ---@type snacks.picker.Config
    picker = {
      ---@type snacks.picker.matcher.Config
      matcher = {
        fuzzy = true, -- use fuzzy matching
        smartcase = true, -- use smartcase
        ignorecase = true, -- use ignorecase
        sort_empty = false, -- sort results when the search string is empty
        filename_bonus = true, -- give bonus for matching file names (last part of the path)
        file_pos = true, -- support patterns like `file:line:col` and `file:line`
        -- the bonusses below, possibly require string concatenation and path normalization,
        -- so this can have a performance impact for large lists and increase memory usage
        cwd_bonus = true, -- give bonus for matching files in the cwd
        frecency = true, -- frecency bonus
        history_bonus = true, -- give more weight to chronological order
      },
      actions = {
        -- NOTE: Custom action to delete all buffers NOT selected in picker (inverse of <C-x>)
        bufdelete_unselected = function(picker)
          -- Reset picker state BEFORE deleting buffers
          picker.preview:reset()

          local selected_items = picker:selected()
          local selected_bufs = {}
          for _, item in ipairs(selected_items) do
            if item.buf then
              selected_bufs[item.buf] = true
            end
          end

          local all_listed_bufs = vim.tbl_filter(function(bufnr)
            return vim.bo[bufnr].buflisted
          end, vim.api.nvim_list_bufs())

          for _, bufnr in ipairs(all_listed_bufs) do
            if not selected_bufs[bufnr] then
              require("snacks.bufdelete").delete(bufnr)
            end
          end

          -- Clear selection and reset target AFTER deleting
          picker.list:set_selected()
          picker.list:set_target()
          -- Refresh the picker to show the new state
          picker:find()
        end,
        sidekick_send = function(...)
          return require("sidekick.cli.picker.snacks").send(...)
        end,
      },
      ---@type snacks.picker.sources.Config
      win = {
        -- input window
        input = {
          keys = {
            -- Make <C-c> close in normal as well as insert mode
            ["<C-c>"] = { "close", mode = { "i", "n" } },
            ["<a-w>"] = { "toggle_cwd", mode = { "n", "i" } },
            ["<C-p>"] = { "focus_preview", mode = { "i", "n" } }, -- or any other key you prefer
            ["<C-i>"] = { "focus_input", mode = { "i", "n" } }, -- or any other key you prefer
            ["<C-l>"] = { "focus_list", mode = { "i", "n" } }, -- or any other key you prefer
            -- NOTE: This lets us close all selected buffers. We get this from default snacks keymaps as <C-x>, but put here explicitly for documentation
            -- ["<C-x>"] = { "bufdelete", mode = { "n", "i" } },
            ["<C-o>"] = { "bufdelete_unselected", mode = { "n", "i" } },
            -- Send selection to Sidekick (CLI AI Agent)
            ["<c-i>"] = {
              "sidekick_send",
              mode = { "n", "i" },
            },
          },
        },
        -- result list window
        list = {
          keys = {
            -- Make <C-c> close in normal as well as insert mode
            ["<C-c>"] = { "close", mode = { "i", "n" } },
            ["<C-p>"] = { "focus_preview", mode = { "i", "n" } }, -- or any other key you prefer
            ["<C-i>"] = { "focus_input", mode = { "i", "n" } }, -- or any other key you prefer
            ["<C-l>"] = { "focus_list", mode = { "i", "n" } }, -- or any other key you prefer
            -- ["<C-x>"] = { "bufdelete", mode = { "n", "i" } },
            -- NOTE: We also get this from default snacks keymaps.
            ["dd"] = "bufdelete",
            ["<C-o>"] = { "bufdelete_unselected", mode = { "n", "i" } },
          },
        },
        -- preview window
        preview = {
          keys = {
            -- Make <C-c> close in normal as well as insert mode
            ["<C-c>"] = { "close", mode = { "i", "n" } },
            ["<C-p>"] = { "focus_preview", mode = { "i", "n" } }, -- or any other key you prefer
            ["<C-i>"] = { "focus_input", mode = { "i", "n" } }, -- or any other key you prefer
            ["<C-l>"] = { "focus_list", mode = { "i", "n" } }, -- or any other key you prefer
          },
        },
      },
      ---@type snacks.picker.sources.Config
      sources = {
        gh_issue = {
          -- your gh_issue picker configuration comes here
          -- or leave it empty to use the default settings
        },
        gh_pr = {
          -- your gh_pr picker configuration comes here
          -- or leave it empty to use the default settings
        },
        -- ---@type snacks.picker.explorer.Config
        explorer = {
          finder = "explorer",
          sort = { fields = { "sort" } },
          supports_live = true,
          tree = true,
          watch = true,
          diagnostics = true,
          diagnostics_open = false,
          git_status = true,
          git_status_open = false,
          git_untracked = true,
          follow_file = true,
          focus = "list",
          auto_close = false,
          jump = { close = false },
          layout = { preset = "sidebar", preview = false },
          -- to show the explorer to the right, add the below to
          -- your config under `opts.picker.sources.explorer`
          -- layout = { layout = { position = "right" } },
          formatters = {
            file = { filename_only = true },
            severity = { pos = "right" },
          },
          matcher = { sort_empty = false, fuzzy = false },
          config = function(opts)
            return require("snacks.picker.source.explorer").setup(opts)
          end,
          win = {
            list = {
              keys = {
                ["<BS>"] = "explorer_up",
                ["l"] = "confirm",
                ["h"] = "explorer_close", -- close directory
                ["a"] = "explorer_add",
                ["d"] = "explorer_del",
                ["r"] = "explorer_rename",
                ["c"] = "explorer_copy",
                ["m"] = "explorer_move",
                ["o"] = "explorer_open", -- open with system application
                ["P"] = "toggle_preview",
                ["y"] = { "explorer_yank", mode = { "n", "x" } },
                ["p"] = "explorer_paste",
                ["u"] = "explorer_update",
                ["<c-c>"] = "tcd",
                ["<leader>/"] = "picker_grep",
                ["<c-t>"] = "terminal",
                ["."] = "explorer_focus",
                ["I"] = "toggle_ignored",
                ["H"] = "toggle_hidden",
                ["Z"] = "explorer_close_all",
                ["]g"] = "explorer_git_next",
                ["[g"] = "explorer_git_prev",
                ["]d"] = "explorer_diagnostic_next",
                ["[d"] = "explorer_diagnostic_prev",
                ["]w"] = "explorer_warn_next",
                ["[w"] = "explorer_warn_prev",
                ["]e"] = "explorer_error_next",
                ["[e"] = "explorer_error_prev",
              },
            },
          },
        },
        -- ---@type snacks.picker.notifications.Config: snacks.picker.Config
        -- ---@field filter? snacks.notifier.level|fun(notif: snacks.notifier.Notif): boolean
        -- notifications = {},
        ---@type snacks.picker.files.Config: snacks.picker.proc.Config
        files = {
          hidden = true,
          ignored = true,
          -- Exclude dirs from file search
          exclude = {
            "**/.venv/**",
            "**/venv/**",
            "**/virtual_env/**",
            "**/node_modules/**",
            "**/dist/**",
            "**/build/**",
            "**/target/**",
            "**/__pycache__/**",
          },
        },
        zoxide = {
          finder = "files_zoxide",
          format = "file",
          formatters = {
            file = {
              full_path = true, -- This will show the full path instead of just the directory name
              truncate = false,
            },
          },
        },
        -- ---@type snacks.picker.buffers.Config: snacks.picker.Config
        -- buffers = {},
        ---@type snacks.picker.grep.Config
        grep = {
          args = { "-P" }, -- Enable PCRE2
          hidden = false,
          ignored = false,
          -- Exclude dirs from text search
          exclude = {
            "**/.venv/**",
            "**/venv/**",
            "**/virtual_env/**",
            "**/node_modules/**",
            "**/dist/**",
            "**/build/**",
            "**/target/**",
            "**/__pycache__/**",
            "package-lock.json",
          },
          formatters = {
            file = {
              filename_first = true,
              filename_only = false,
              full_path = true,
              git_status_hl = true,
              min_width = 40,
              truncate = false,
            },
          },
        },
        ---@type snacks.picker.lsp.Config
        lsp_declarations = {},
        ---@type snacks.picker.lsp.Config
        lsp_definitions = {},
        ---@type snacks.picker.lsp.Config
        lsp_implementations = {},
        ---@type snacks.picker.lsp.Config
        lsp_references = {},
        ---@type snacks.picker.lsp.Config
        lsp_symbols = {},
        ---@type snacks.picker.lsp.Config
        lsp_type_definitions = {},
      },
      ---@type snacks.picker.layout.Config
      layout = {
        preset = "ivy",
        reverse = false,
      },
      ---@type snacks.picker.formatters.Config
      formatters = {
        file = {
          filename_first = true,
          filename_only = false,
          full_path = true,
          git_status_hl = true,
          min_width = 40,
          truncate = false,
        },
      },
    },
    ---@type snacks.explorer.Config
    explorer = {
      replace_netrw = false,
    },
    ---@type snacks.dashboard.Config
    dashboard = {
      enabled = vim.env.IS_SSH ~= "1",
      -- height = terminal_height,
      -- width = terminal_width,
      -- row = 1,
      -- col = 1,
      pane_gap = 4,
      sections = {
        -- lolcat logo
        -- {
        --   pane = 1,
        --   section = "terminal",
        --   -- cmd = 'cat "' .. logo_file .. '" | lolcat -a -d 2 -s 15 -F 0.3 -t -p 100 -f',
        --   -- Using lolcat
        --   cmd = 'bash -c "for i in {1..10}; do clear; cat \\"'
        --     .. logo_file
        --     .. '\\" | lolcat -a -d '
        --     .. lolcat_delay
        --     .. ' -s 15 -F 0.3 -t -p 100 -f; sleep 4; done"',
        --   height = logo_height,
        --   width = logo_width,
        --   -- height = math.floor(terminal_height / 3),
        --   -- width = terminal_width,
        --   -- indent = indent,
        --   -- random = 100,
        --   padding = 2,
        --   ttl = 0, -- cmd is cached by snacks, so upping random or setting ttl to 0 makes it refresh on every load
        -- },
        -- tte logo
        {
          pane = 1,
          height = 1,
        },
        {
          pane = 1,
          section = "terminal",
          width = logo_width,
          cmd = 'bash -c "tte --input-file \\"' .. logo_file .. '\\" ' .. random_tte_cmd .. '"',
          height = logo_height + 1, -- tte cuts off unless we add a line
          padding = 1,
          ttl = 0, -- cmd is cached by snacks, so upping random or setting ttl to 0 makes it refresh on every load
        },
        -- terminal-toys animation
        -- {
        --   pane = 2,
        --   height = 1,
        -- },
        -- {
        --   pane = 2,
        --   section = "terminal",
        --   -- cmd = random_terminal_toys_cmd,
        --   cmd = "terminal-toys bubble -m Braille -a 25 -b 50 -n 8",
        --   height = logo_height,
        --   padding = 2, -- for use with terminal-toys
        --   ttl = 0, -- cmd is cached by snacks, so upping random or setting ttl to 0 makes it refresh on every load
        -- },
        -- blank panel (for use when terminal-toys not in use)
        {
          pane = 2,
          height = logo_height,
          -- padding = logo_height + 1, -- for use with lolcat
          padding = logo_height + 2, -- for use with tte
        },
        { icon = " ", pane = 2, title = "Keymaps", section = "keys", indent = 2, padding = 1 },
        { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        {
          pane = 2,
          icon = " ",
          title = "Git Status",
          -- cmd = "hub --no-pager diff --stat -B -M -C",
          -- cmd = "hub status --short --branch --renames",
          cmd = "git rev-parse --is-inside-work-tree >/dev/null 2>&1 && hub status --short --branch --renames || true",
          section = "terminal",
          height = 5,
          ttl = 0,
        },
        -- terminal-toys animation
        -- {
        --   section = "terminal",
        --   cmd = random_terminal_toys_cmd,
        --   height = 15,
        --   -- height = terminal_height - logo_height - 15, -- fill height
        --   width = terminal_width,
        --   -- padding = 3, -- for use with terminal-toys
        --   ttl = 0, -- cmd is cached by snacks, so upping random or setting ttl to 0 makes it refresh on every load
        -- },
        {
          pane = 1,
          section = "startup",
        },
      },
    },
    ---@type snacks.indent
    indent = {
      ---@type snacks.indent.Config
      indent = {
        enabled = false, -- enable indent guides
        char = "│",
        blank = " ",
        -- blank = "∙",
        only_scope = true, -- only show indent guides of the scope
        only_current = true, -- only show indent guides in the current window
        -- hl = "SnacksIndent", ---@type string|string[] hl groups for indent guides
        -- can be a list of hl groups to cycle through
        hl = {
          "SnacksIndent1",
          "SnacksIndent2",
          "SnacksIndent3",
          "SnacksIndent4",
          "SnacksIndent5",
          "SnacksIndent6",
          "SnacksIndent7",
          "SnacksIndent8",
        },
      },
      ---@type snacks.indent.animate
      animate = {
        enabled = vim.fn.has("nvim-0.10") == 1 and vim.env.IS_SSH ~= "1",
        easing = "linear",
        duration = {
          step = 20, -- ms per step
          total = 500, -- maximum duration
        },
      },
      ---@type snacks.indent.Scope.Config: snacks.scope.Config
      scope = {
        enabled = true, -- enable highlighting the current scope
        char = "│",
        underline = false, -- underline the start of the scope
        only_current = true, -- only show scope in the current window
        hl = "SnacksIndentScope", ---@type string|string[] hl group for scopes
      },
      chunk = {
        -- when enabled, scopes will be rendered as chunks, except for the
        -- top-level scope which will be rendered as a scope.
        enabled = true,
        -- only show chunk scopes in the current window
        only_current = true,
        hl = "SnacksIndentChunk", ---@type string|string[] hl group for chunk scopes
        char = {
          corner_top = "┌",
          corner_bottom = "└",
          -- corner_top = "╭",
          -- corner_bottom = "╰",
          horizontal = "─",
          vertical = "│",
          arrow = ">",
          -- arrow = "─",
        },
      },
      blank = {
        char = " ",
        -- char = "·",
        hl = "SnacksIndentBlank", ---@type string|string[] hl group for blank spaces
      },
      -- filter for buffers to enable indent guides
      filter = function(buf)
        return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ""
      end,
      priority = 200,
    },
    scratch = {
      name = "Scratch",
      ft = function()
        if vim.bo.buftype == "" and vim.bo.filetype ~= "" then
          return vim.bo.filetype
        end
        return "markdown"
      end,
      ---@type string|string[]?
      icon = nil, -- `icon|{icon, icon_hl}`. defaults to the filetype icon
      root = vim.fn.stdpath("data") .. "/scratch",
      autowrite = true, -- automatically write when the buffer is hidden
      -- unique key for the scratch file is based on:
      -- * name
      -- * ft
      -- * vim.v.count1 (useful for keymaps)
      -- * cwd (optional)
      -- * branch (optional)
      filekey = {
        cwd = true, -- use current working directory
        branch = true, -- use current branch name
        count = true, -- use vim.v.count1
      },
      win = { style = "scratch" },
      ---@type table<string, snacks.win.Config>
      win_by_ft = {
        python = {
          keys = {
            ["source"] = {
              "<cr>",
              function(self)
                local name = "scratch." .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.buf), ":e")
                Snacks.debug.run({ buf = self.buf, name = name })
              end,
              desc = "Source buffer",
              mode = { "n", "x" },
            },
          },
        },
        javascript = {
          keys = {
            ["source"] = {
              "<cr>",
              function(self)
                local name = "scratch." .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.buf), ":e")
                Snacks.debug.run({ buf = self.buf, name = name })
              end,
              desc = "Source buffer",
              mode = { "n", "x" },
            },
          },
        },
        lua = {
          keys = {
            ["source"] = {
              "<cr>",
              function(self)
                local name = "scratch." .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.buf), ":e")
                Snacks.debug.run({ buf = self.buf, name = name })
              end,
              desc = "Source buffer",
              mode = { "n", "x" },
            },
          },
        },
      },
    },
    ---@type snacks.image.Config
    image = {
      enabled = vim.env.IS_SSH ~= "1",
      -- ImageMagick conversion is required for everything except PNG
      -- (defaults shown in docs; keeping explicit so it’s obvious)
      formats = {
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
      },
      convert = {
        notify = false,
        magick = {
          default = { "{src}[0]", "-scale", "1920x1080>" },
          vector = { "-density", 192, "{src}[{page}]" },
          math = { "-density", 192, "{src}[{page}]", "-trim" },
          pdf = { "-density", 192, "{src}[{page}]", "-background", "white", "-alpha", "remove", "-trim" },
        },
      },
      doc = {
        -- enable image viewer for documents
        -- a treesitter parser must be available for the enabled languages.
        enabled = true,
        -- render the image inline in the buffer
        -- if your env doesn't support unicode placeholders, this will be disabled
        -- takes precedence over `opts.float` on supported terminals
        inline = true,
        -- render the image in a floating window
        -- only used if `opts.inline` is disabled
        -- float = true,
        -- max_width = 80,
        -- max_height = 40,
        -- Set to `true`, to conceal the image text when rendering inline.
        -- (experimental)
        ---@param lang string tree-sitter language
        ---@param type snacks.image.Type image type
        conceal = function(lang, type)
          -- only conceal math expressions
          return type == "math"
        end,
      },
      img_dirs = { "img", "images", "assets", "static", "public", "media", "attachments" },
    },
    profiler = {
      opts = function(_, opts)
        ---@type snacks.profiler.Config
        opts = vim.tbl_deep_extend("force", opts or {}, {
          -- Toggle the profiler
          -- Snacks.toggle.profiler():map("<leader>pp"),
          -- -- Toggle the profiler highlights
          -- Snacks.toggle.profiler_highlights():map("<leader>ph"),
          autocmds = true,
          runtime = vim.env.VIMRUNTIME, ---@type string
          -- thresholds for buttons to be shown as info, warn or error
          -- value is a tuple of [warn, error]
          thresholds = {
            time = { 2, 10 },
            pct = { 10, 20 },
            count = { 10, 100 },
          },
          on_stop = {
            highlights = true, -- highlight entries after stopping the profiler
            pick = true, -- show a picker after stopping the profiler (uses the `on_stop` preset)
          },
          ---@type snacks.profiler.Highlights
          highlights = {
            min_time = 0, -- only highlight entries with time > min_time (in ms)
            max_shade = 20, -- time in ms for the darkest shade
            badges = { "time", "pct", "count", "trace" },
            align = 80,
          },
          pick = {
            picker = "snacks", ---@type snacks.profiler.Picker
            ---@type snacks.profiler.Badge.type[]
            badges = { "time", "count", "name" },
            ---@type snacks.profiler.Highlights
            preview = {
              badges = { "time", "pct", "count" },
              align = "right",
            },
          },
          startup = {
            event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
            after = true, -- stop the profiler **after** the event. When false it stops **at** the event
            pattern = nil, -- pattern to match for the autocmd
            pick = true, -- show a picker after starting the profiler (uses the `startup` preset)
          },
          ---@type table<string, snacks.profiler.Pick|fun():snacks.profiler.Pick?>
          presets = {
            startup = { min_time = 1, sort = false },
            on_stop = {},
            filter_by_plugin = function()
              return { filter = { def_plugin = vim.fn.input("Filter by plugin: ") } }
            end,
          },
          ---@type string[]
          globals = {
            "vim",
            "lazy",
            "require",
            -- "vim.api",
            -- "vim.keymap",
            -- "Snacks.dashboard.Dashboard",
          },
          -- filter modules by pattern.
          -- longest patterns are matched first
          filter_mod = {
            default = true, -- default value for unmatched patterns
            ["^vim%."] = false,
            ["mason-core.functional"] = false,
            ["mason-core.functional.data"] = false,
            ["mason-core.optional"] = false,
            ["which-key.state"] = false,
          },
          filter_fn = {
            default = true,
            ["^.*%._[^%.]*$"] = false,
            ["trouble.filter.is"] = false,
            ["trouble.item.__index"] = false,
            ["which-key.node.__index"] = false,
            ["smear_cursor.draw.wo"] = false,
            ["^ibl%.utils%."] = false,
          },
          icons = {
            time = " ",
            pct = " ",
            count = " ",
            require = "󰋺 ",
            modname = "󰆼 ",
            plugin = " ",
            autocmd = "⚡",
            file = " ",
            fn = "󰊕 ",
            status = "󰈸 ",
          },
        })
      end,
    },
  },
  keys = {
    {
      "<leader><space>",
      function()
        Snacks.picker.smart()
      end,
      desc = "Smart Find Files",
    },
    {
      "<leader>ft",
      function()
        Snacks.picker.files({ dirs = { "/tmp" }, hidden = true, supports_live = true })
      end,
      desc = "Find Files in /tmp",
    },
    {
      "<leader>fc",
      function()
        Snacks.picker.files({ cwd = vim.fn.expand("~/.local/share/chezmoi") })
      end,
      desc = "Find Config File",
    },
    -- TODO: Check on snacks.gh later. We need ability to comment on specific lines in a PR diff, and only Octo provides this currently.
    -- {
    --     "<leader>gi",
    --     function()
    --         Snacks.picker.gh_issue()
    --     end,
    --     desc = "GitHub Issues (open)",
    -- },
    -- {
    --     "<leader>gI",
    --     function()
    --         Snacks.picker.gh_issue({ state = "all" })
    --     end,
    --     desc = "GitHub Issues (all)",
    -- },
    -- {
    --     "<leader>gp",
    --     function()
    --         Snacks.picker.gh_pr()
    --     end,
    --     desc = "GitHub Pull Requests (open)",
    -- },
    -- {
    --     "<leader>gP",
    --     function()
    --         Snacks.picker.gh_pr({ state = "all" })
    --     end,
    --     desc = "GitHub Pull Requests (all)",
    -- },
    {
      "<leader>z",
      function()
        Snacks.picker.zoxide()
      end,
      desc = "Zoxide",
    },
    -- NOTE: `reveal()` does not toggle open the explorer
    -- {
    --     "<leader>fE",
    --     function()
    --         Snacks.explorer.reveal()
    --     end,
    --     desc = "Open Explorer at File",
    -- },
    {
      "<leader>fe",
      function()
        Snacks.explorer.open()
      end,
      desc = "Open Explorer",
    },
    -- Obsidian: find existing note or create new one, inserting wikilink at cursor
    {
      "<leader>oN",
      function()
        local buf = vim.api.nvim_get_current_buf()
        local main_win = vim.api.nvim_get_current_win()

        local Note = require("obsidian.note")
        local Path = require("obsidian.path")

        local function insert_link(note, open_vsplit)
          local link = note:format_link()
          -- Re-read cursor position at call time (picker may have moved focus).
          -- Clamp col+1 to line length so inserting on an empty line (col=0)
          -- doesn't produce an out-of-range start_col error.
          local cur_row, cur_col = unpack(vim.api.nvim_win_get_cursor(main_win))
          local line = vim.api.nvim_buf_get_lines(buf, cur_row - 1, cur_row, true)[1] or ""
          local insert_col = math.min(cur_col + 1, #line)
          vim.api.nvim_buf_set_text(buf, cur_row - 1, insert_col, cur_row - 1, insert_col, { link })
          vim.api.nvim_win_set_cursor(main_win, { cur_row, insert_col + #link })
          if open_vsplit then
            note:open({ open_strategy = "vsplit", sync = true })
          end
        end

        local function create_note(name)
          if not name or name == "" then
            return
          end
          local id = name:gsub("%s+", "-"):gsub("[^%w%-_]", "")
          local note = Note.create({
            id = id,
            dir = Path.new(Obsidian.opts.notes_subdir),
            verbatim = true,
            aliases = { name },
            should_write = true,
          })
          insert_link(note, true)
        end

        -- Replicate :Obsidian search exactly: use obsidian's own rg command
        -- (--type=md, --type-add md:*.qmd, exclude patterns) via the snacks
        -- low-level pick API with source="grep" and a custom cmd/args.
        -- This is the same approach obsidian.nvim's _snacks.lua picker uses.
        local obs_search = require("obsidian.search")
        local grep_args = obs_search.build_grep_cmd()
        local grep_cmd = table.remove(grep_args, 1)

        Snacks.picker.pick({
          source = "grep",
          title = "Obsidian Search",
          cwd = tostring(Obsidian.dir),
          cmd = grep_cmd,
          args = grep_args,
          actions = {
            -- Enter: insert wikilink + load existing note buffer in background (no focus switch)
            confirm = function(picker, item)
              picker:close()
              if not item then
                return
              end
              local path = Snacks.picker.util.path(item)
              if not path then
                return
              end
              vim.api.nvim_set_current_win(main_win)
              insert_link(Note.from_file(path), false)
              -- Load buffer in background so it's accessible without stealing focus
              local bufnr = vim.fn.bufadd(path)
              vim.fn.bufload(bufnr)
            end,
            -- Ctrl-I: insert wikilink only, do not open
            obsidian_insert_link = function(picker, item)
              picker:close()
              if not item then
                return
              end
              local path = Snacks.picker.util.path(item)
              if not path then
                return
              end
              vim.api.nvim_set_current_win(main_win)
              insert_link(Note.from_file(path), false)
            end,
            -- Ctrl-N: create new note from query text, insert wikilink + open vsplit
            obsidian_create_note = function(picker, _)
              local query = picker.input.filter.pattern or ""
              picker:close()
              vim.schedule(function()
                vim.ui.input({ prompt = "New note title: ", default = query }, function(input)
                  create_note(input)
                end)
              end)
            end,
          },
          win = {
            input = {
              keys = {
                ["<C-i>"] = { "obsidian_insert_link", mode = { "i", "n" }, desc = "Insert wikilink (no open)" },
                ["<C-n>"] = { "obsidian_create_note", mode = { "i", "n" }, desc = "Create new note" },
              },
            },
          },
        })
      end,
      desc = "Find/create obsidian note + wikilink at cursor",
      ft = "markdown",
    },
  },
}
