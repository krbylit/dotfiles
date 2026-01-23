return {
  "folke/sidekick.nvim",
  ---@type sidekick.Config
  opts = {
    jump = {
      jumplist = true, -- add an entry to the jumplist
    },
    signs = {
      enabled = true, -- enable signs by default
      icon = " ",
    },
    nes = {
      ---@type boolean|fun(buf:integer):boolean?
      -- enabled = function(buf)
      --   return vim.g.sidekick_nes ~= false and vim.b.sidekick_nes ~= false
      -- end,
      enabled = true,
      debounce = 100,
      trigger = {
        -- events that trigger sidekick next edit suggestions
        events = { "ModeChanged i:n", "TextChanged", "User SidekickNesDone" },
      },
      clear = {
        -- events that clear the current next edit suggestion
        events = { "TextChangedI", "InsertEnter" },
        esc = true, -- clear next edit suggestions when pressing <Esc>
      },
      ---@type sidekick.diff.Opts
      diff = {
        inline = "words",
      },
    },
    -- Work with AI cli tools directly from within Neovim
    cli = {
      watch = true, -- notify Neovim of file changes done by AI CLI tools
      ---@type sidekick.win.Opts
      win = {
        --- This is run when a new terminal is created, before starting it.
        --- Here you can change window options `terminal.opts`.
        ---@param terminal sidekick.cli.Terminal
        config = function(terminal)
          -- Force terminal to use Normal highlight group background
          terminal.opts.wo.winhighlight = "Normal:Normal,NormalNC:NormalNC"
        end,
        wo = {}, ---@type vim.wo
        bo = {}, ---@type vim.bo
        layout = "right", ---@type "float"|"left"|"bottom"|"top"|"right"
        --- Options used when layout is "float"
        ---@type vim.api.keyset.win_config
        float = {
          width = 0.9,
          height = 0.9,
        },
        -- Options used when layout is "left"|"bottom"|"top"|"right"
        ---@type vim.api.keyset.win_config
        split = {
          width = 80, -- set to 0 for default split width
          height = 20, -- set to 0 for default split height
        },
        --- CLI Tool Keymaps (default mode is `t`)
        ---@type table<string, sidekick.cli.Keymap|false>
        keys = {
          -- NOTE: Since agent CLIs run in zellij, we can scroll back using zellij's scroll mode (<c-g>s, u/d/j/k)
          buffers = { "<c-b>", "buffers", mode = "nt", desc = "open buffer picker" },
          files = { "<c-f>", "files", mode = "nt", desc = "open file picker" },
          hide_n = { "q", "hide", mode = "n", desc = "hide the terminal window" },
          hide_ctrl_q = { "<c-q>", "hide", mode = "n", desc = "hide the terminal window" },
          hide_ctrl_dot = { "<c-.>", "hide", mode = "nt", desc = "hide the terminal window" },
          hide_ctrl_z = { "<c-z>", "hide", mode = "nt", desc = "hide the terminal window" },
          prompt = { "<c-p>", "prompt", mode = "t", desc = "insert prompt or context" },
          stopinsert = { "<c-q>", "stopinsert", mode = "t", desc = "enter normal mode" },
          -- Navigate windows in terminal mode. Only active when:
          -- * layout is not "float"
          -- * there is another window in the direction
          -- With the default layout of "right", only `<c-h>` will be mapped
          nav_left = { "<c-h>", "nav_left", expr = true, desc = "navigate to the left window" },
          nav_down = { "<c-j>", "nav_down", expr = true, desc = "navigate to the below window" },
          nav_up = { "<c-k>", "nav_up", expr = true, desc = "navigate to the above window" },
          nav_right = { "<c-l>", "nav_right", expr = true, desc = "navigate to the right window" },
        },
        ---@type fun(dir:"h"|"j"|"k"|"l")?
        --- Function that handles navigation between windows.
        --- Defaults to `vim.cmd.wincmd`. Used by the `nav_*` keymaps.
        nav = nil,
      },
      ---@type sidekick.cli.Mux
      mux = {
        -- backend = vim.env.ZELLIJ and "zellij" or "tmux", -- default to tmux unless zellij is detected
        backend = "zellij", -- default to tmux unless zellij is detected
        enabled = true,
        -- terminal: new sessions will be created for each CLI tool and shown in a Neovim terminal
        -- window: when run inside a terminal multiplexer, new sessions will be created in a new tab
        -- split: when run inside a terminal multiplexer, new sessions will be created in a new split
        -- NOTE: zellij only supports `terminal`
        create = "terminal", ---@type "terminal"|"window"|"split"
        split = {
          vertical = true, -- vertical or horizontal split
          size = 0.5, -- size of the split (0-1 for percentage)
        },
      },
      ---@type table<string, sidekick.cli.Config|{}>
      tools = {
        aider = { cmd = { "aider" } },
        amazon_q = { cmd = { "q" } },
        claude = { cmd = { "claude" } },
        codex = { cmd = { "codex", "--enable", "web_search_request" } },
        copilot = { cmd = { "copilot", "--banner" } },
        crush = {
          cmd = { "crush" },
          -- crush uses <a-p> for its own functionality, so we override the default
          keys = { prompt = { "<a-p>", "prompt" } },
        },
        cursor = { cmd = { "cursor-agent" } },
        gemini = { cmd = { "gemini" } },
        grok = { cmd = { "grok" } },
        opencode = {
          cmd = { "opencode" },
          -- HACK: https://github.com/sst/opencode/issues/445
          env = { OPENCODE_THEME = "system" },
        },
        qwen = { cmd = { "qwen" } },
      },
      --- Add custom context. See `lua/sidekick/context/init.lua`
      ---@type table<string, sidekick.context.Fn>
      context = {
        -- Custom context that returns absolute file path instead of relative
        abs_file = function(ctx)
          local Loc = require("sidekick.cli.context.location")
          -- Check if it's a valid file buffer
          if not Loc.is_file(ctx.buf) then
            return false
          end
          -- Get the absolute path (don't convert to relative)
          -- Claude Code will automatically add @ prefix
          local name = vim.api.nvim_buf_get_name(ctx.buf)
          if not name or name == "" then
            name = "[No Name]"
          end
          -- Return as sidekick.Text format with SidekickLocFile highlight
          return { { { name, "SidekickLocFile" } } }
        end,
        -- Custom context that returns absolute path with position (/abs/path:L10:C5)
        abs_position = function(ctx)
          local Loc = require("sidekick.cli.context.location")
          if not Loc.is_file(ctx.buf) then
            return false
          end
          -- Get the absolute path (don't convert to relative)
          -- Claude Code will automatically add @ prefix
          local name = vim.api.nvim_buf_get_name(ctx.buf)
          if not name or name == "" then
            name = "[No Name]"
          end
          -- Format as absolute_path:L{row}:C{col} (@ will be added by Claude Code)
          local location = string.format("%s:L%d:C%d", name, ctx.row, ctx.col)
          return { { { location, "SidekickLocFile" } } }
        end,
        -- Custom context like {this} but uses absolute paths
        abs_this = function(ctx)
          local Loc = require("sidekick.cli.context.location")
          local Context = require("sidekick.cli.context")
          if Loc.is_file(ctx.buf) then
            -- For file buffers, inline abs_position logic
            -- Claude Code will automatically add @ prefix
            local name = vim.api.nvim_buf_get_name(ctx.buf)
            if not name or name == "" then
              name = "[No Name]"
            end
            local location = string.format("%s:L%d:C%d", name, ctx.row, ctx.col)
            return { { { location, "SidekickLocFile" } } }
          end
          -- For non-file buffers, return "this" + selection
          local ret = { { { "this", "SidekickLocFile" } } }
          local sel = Context.context.selection(ctx)
          if sel then
            vim.list_extend(ret, { { { " " } }, sel })
          end
          return ret
        end,
      },
      ---@type table<string, sidekick.Prompt|string|fun(ctx:sidekick.context.ctx):(string?)>
      prompts = {
        changes = "Can you review my changes?",
        diagnostics = "Can you help me fix the diagnostics in {file}?\n{diagnostics}",
        diagnostics_all = "Can you help me fix these diagnostics?\n{diagnostics_all}",
        document = "Add documentation to {function|line}",
        explain = "Explain {this}",
        fix = "Can you fix {this}?",
        optimize = "How can {this} be optimized?",
        review = "Can you review {file} for any issues or improvements?",
        tests = "Can you write tests for {this}?",
        -- simple context prompts
        buffers = "{buffers}",
        file = "{file}",
        line = "{line}",
        position = "{position}",
        quickfix = "{quickfix}",
        selection = "{selection}",
        ["function"] = "{function}",
        class = "{class}",
      },
      -- preferred picker for selecting files
      picker = "snacks", ---@type sidekick.picker
    },
    copilot = {
      -- track copilot's status with `didChangeStatus`
      status = {
        enabled = true,
        level = vim.log.levels.WARN,
        -- set to vim.log.levels.OFF to disable notifications
        -- level = vim.log.levels.OFF,
      },
    },
    ui = {
      icons = {
        attached = " ",
        started = " ",
        installed = " ",
        missing = " ",
        external_attached = "󰖩 ",
        external_started = "󰖪 ",
        terminal_attached = " ",
        terminal_started = " ",
      },
    },
    debug = false, -- enable debug logging
  },
  keys = {
    {
      "<tab>",
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if not require("sidekick").nes_jump_or_apply() then
          return "<tab>" -- fallback to normal tab
        end
      end,
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },
    {
      "<c-.>",
      function()
        require("sidekick.cli").toggle()
      end,
      desc = "Sidekick Toggle",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>aa",
      function()
        require("sidekick.cli").toggle()
      end,
      desc = "Sidekick Toggle CLI",
    },
    {
      "<leader>as",
      function()
        require("sidekick.cli").select()
      end,
      -- Or to select only installed tools:
      -- require("sidekick.cli").select({ filter = { installed = true } })
      desc = "Select CLI",
    },
    {
      "<leader>ad",
      function()
        require("sidekick.cli").close()
      end,
      desc = "Detach a CLI Session",
    },
    {
      "<leader>at",
      function()
        require("sidekick.cli").send({ msg = "{abs_this}" })
      end,
      mode = { "x", "n" },
      desc = "Send This (Absolute Path)",
    },
    {
      "<leader>af",
      function()
        require("sidekick.cli").send({ msg = "{abs_file}" })
      end,
      desc = "Send File (Absolute Path)",
    },
    {
      "<leader>av",
      function()
        require("sidekick.cli").send({ msg = "{selection}" })
      end,
      mode = { "x" },
      desc = "Send Visual Selection",
    },
    {
      "<leader>ap",
      function()
        require("sidekick.cli").prompt()
      end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
    -- Example of a keybinding to open Claude directly
    {
      "<leader>ac",
      function()
        require("sidekick.cli").toggle({ name = "claude", focus = true })
      end,
      desc = "Sidekick Toggle Claude",
    },
  },
}
