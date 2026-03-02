if vim.env.IS_SSH == "1" then
  return { "saghen/blink.cmp", enabled = false }
end

---@diagnostic disable: missing-fields
return {
  "saghen/blink.cmp",
  lazy = false,
  dependencies = {
    -- NOTE: necessary here otherwise copilot shows up in LazyVim as disabled, possibly a LazyVim bug
    { "zbirenbaum/copilot.lua", opts = { suggestion = { enabled = false }, panel = { enabled = false } } },
    { "saghen/blink.compat" },
    { "mikavilpas/blink-ripgrep.nvim" },
  },
  ---@type blink.cmp.ConfigStrict
  opts = {
    -- ---@type blink.cmp.AppearanceConfig,
    -- appearance = {},
    -- ---@type blink.cmp.FuzzyConfig,
    -- fuzzy = {},
    -- ---@type blink.cmp.SnippetsConfig,
    -- snippets = {},
    cmdline = {
      enabled = true,
      keymap = {
        preset = "cmdline",
      },
      completion = {
        ghost_text = {
          enabled = true,
        },
        menu = { auto_show = true },
      },
    },
    ---@type blink.cmp.SignatureConfig
    signature = {
      enabled = false,
      -- window = { border = "single" }
    },
    ---@type blink.cmp.CompletionConfig
    completion = {
      keyword = {
        range = "full",
      },
      list = { selection = { preselect = false, auto_insert = true } },
      documentation = {
        -- <C-space> will show docs
        auto_show = false,
        auto_show_delay_ms = 0,
        -- Disable highlighting for better performance
        -- treesitter_highlighting = false,
      },
      trigger = {
        show_on_blocked_trigger_characters = {},
      },
      ---@type blink.cmp.CompletionMenuConfig
      menu = {
        -- border = "single"
        auto_show = true,
        -- Smart detect what direction to show the menu based on the selected item's text
        direction_priority = function()
          local ctx = require("blink.cmp").get_context()
          local item = require("blink.cmp").get_selected_item()
          if ctx == nil or item == nil then
            return { "s", "n" }
          end

          local item_text = item.textEdit ~= nil and item.textEdit.newText or item.insertText or item.label
          local is_multi_line = item_text:find("\n") ~= nil

          -- after showing the menu upwards, we want to maintain that direction
          -- until we re-open the menu, so store the context id in a global variable
          if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
            vim.g.blink_cmp_upwards_ctx_id = ctx.id
            return { "n", "s" }
          end
          return { "s", "n" }
        end,
        -- draw = {
        --     components = {
        --         kind_icon = {
        --             ellipsis = false,
        --             -- Use mini.icons for completion items
        --             text = function(ctx)
        --                 local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
        --                 return kind_icon
        --             end,
        --             -- Optionally, you may also use the highlights from mini.icons
        --             highlight = function(ctx)
        --                 local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
        --                 return hl
        --             end,
        --         },
        --     },
        -- },
      },
      -- documentation = { window = { border = "single" } },
      ghost_text = {
        enabled = true,
      },
    },
    ---@type blink.cmp.SourceConfig
    sources = {
      default = vim.env.IS_SSH ~= "1" and { "lsp", "path", "snippets", "buffer", "copilot", "ripgrep" }
        or { "lsp", "path", "snippets", "buffer" },
      -- default = { "lsp", "path", "snippets", "buffer", "ripgrep" },
      -- default = { "lsp", "path", "snippets", "buffer", "copilot" },
      -- min_keyword_length = function(ctx)
      -- 	-- Don't show menu when typing 2 char commands in cmdline
      -- 	-- only applies when typing a command, doesn't apply to arguments
      -- 	if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
      -- 		return 2
      -- 	end
      -- 	return 0
      -- end,
      -- compat = {
      --   "avante_commands",
      --   "avante_mentions",
      --   "avante_files",
      -- },
      ---@type blink.cmp.SourceProviderConfig
      providers = {
        ripgrep = {
          module = "blink-ripgrep",
          name = "Ripgrep",
          -- the options below are optional, some default values are shown
          ---@module "blink-ripgrep"
          ---@type blink-ripgrep.Options
          opts = {
            -- Show debug information in `:messages` that can help in
            -- diagnosing issues with the plugin.
            debug = false,
            -- When a result is found for a file whose filetype does not have a
            -- treesitter parser installed, fall back to regex based highlighting
            -- that is bundled in Neovim.
            fallback_to_regex_highlighting = true,
            -- Specifies how to find the root of the project where the ripgrep
            -- search will start from. Accepts the same options as the marker
            -- given to `:h vim.fs.root()` which offers many possibilities for
            -- configuration. If none can be found, defaults to Neovim's cwd.
            --
            -- Examples:
            -- - ".git" (default)
            -- - { ".git", "package.json", ".root" }
            project_root_marker = ".git",
            -- For many options, see `rg --help` for an exact description of
            -- the values that ripgrep expects.

            -- the minimum length of the current word to start searching
            -- (if the word is shorter than this, the search will not start)
            prefix_min_len = 3,
            backend = {
              -- The number of lines to show around each match in the preview
              -- (documentation) window. For example, 5 means to show 5 lines
              -- before, then the match, and another 5 lines after the match.
              context_size = 5,
              ripgrep = {

                -- The maximum file size of a file that ripgrep should include in
                -- its search. Useful when your project contains large files that
                -- might cause performance issues.
                -- Examples:
                -- "1024" (bytes by default), "200K", "1M", "1G", which will
                -- exclude files larger than that size.
                max_filesize = "1M",

                -- Enable fallback to neovim cwd if project_root_marker is not
                -- found. Default: `true`, which means to use the cwd.
                project_root_fallback = true,

                -- The casing to use for the search in a format that ripgrep
                -- accepts. Defaults to "--ignore-case". See `rg --help` for all the
                -- available options ripgrep supports, but you can try
                -- "--case-sensitive" or "--smart-case".
                search_casing = "--smart-case",

                -- (advanced) Any additional options you want to give to ripgrep.
                -- See `rg -h` for a list of all available options. Might be
                -- helpful in adjusting performance in specific situations.
                -- If you have an idea for a default, please open an issue!
                --
                -- Not everything will work (obviously).
                additional_rg_options = {
                  "--max-count=10", -- Stop after 10 matches per file
                  "--max-depth=5", -- Limit directory depth
                },

                -- Absolute root paths where the rg command will not be executed.
                -- Usually you want to exclude paths using gitignore files or
                -- ripgrep specific ignore files, but this can be used to only
                -- ignore the paths in blink-ripgrep.nvim, maintaining the ability
                -- to use ripgrep for those paths on the command line. If you need
                -- to find out where the searches are executed, enable `debug` and
                -- look at `:messages`.
                ignore_paths = {
                  "/node_modules/",
                  "/.git/",
                  "/dist/",
                  "/build/",
                  "/.venv/",
                  "/target/",
                },
              },
            },
          },
          -- (optional) customize how the results are displayed. Many options
          -- are available - make sure your lua LSP is set up so you get
          -- autocompletion help
          transform_items = function(_, items)
            for _, item in ipairs(items) do
              -- example: append a description to easily distinguish rg results
              item.labelDetails = {
                description = "(rg)",
              }
            end
            return items
          end,
        },
        lsp = {
          override = {
            -- Show menu when on whitespace as well as in words
            get_trigger_characters = function(self)
              local trigger_characters = self:get_trigger_characters()
              vim.list_extend(trigger_characters, { "\n", "\t", " " })
              return trigger_characters
            end,
          },
        },
        copilot = vim.env.IS_SSH ~= "1" and {
          name = "copilot",
          module = "blink-copilot",
          score_offset = 100,
          async = true,
        } or nil,
        -- avante_commands = {
        --     name = "avante_commands",
        --     module = "blink.compat.source",
        --     score_offset = 90, -- show at a higher priority than lsp
        --     opts = {},
        -- },
        -- avante_files = {
        --     name = "avante_files",
        --     module = "blink.compat.source",
        --     score_offset = 100, -- show at a higher priority than lsp
        --     opts = {},
        -- },
        -- avante_mentions = {
        --     name = "avante_mentions",
        --     module = "blink.compat.source",
        --     score_offset = 1000, -- show at a higher priority than lsp
        --     opts = {},
        -- },
      },
    },
    ---@type blink.cmp.KeymapConfig
    keymap = {
      preset = "enter",
      -- ["<Tab>"] = {
      --   "snippet_forward",
      --   function() -- sidekick next edit suggestion
      --     return require("sidekick").nes_jump_or_apply()
      --   end,
      --   function() -- if you are using Neovim's native inline completions
      --     return vim.lsp.inline_completion.get()
      --   end,
      --   "fallback",
      -- },
      ["<C-y>"] = { "select_and_accept", "fallback" },
      -- NOTE: We can enable normal <Tab> behavior of indenting instead of accepting ghost text by setting to `fallback`. Otherwise, <S-Tab> will insert tab when ghost text showing.
      -- ["<Tab>"] = { "fallback" },

      -- NOTE: Default is <C-e> to hide cmp menu.
      -- ["<C-i>"] = { "hide", "fallback" },
    },
  },
}
