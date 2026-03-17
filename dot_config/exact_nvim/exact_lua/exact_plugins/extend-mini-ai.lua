-- Extend mini.ai with Markdown-specific text objects
-- This adds specialized text objects for working with Markdown documents

return {
  "nvim-mini/mini.ai",
  -- event = "VeryLazy",
  opts = function(_, opts)
    -- Ensure opts table exists
    opts = opts or {}

    -- Function to set up markdown-only motion helpers for a buffer.
    local function setup_markdown_keymaps(bufnr)
      local function jump_heading(flags)
        local view = vim.fn.winsaveview()
        local found = vim.fn.search("^#\\+\\s", flags)
        if found == 0 then
          vim.fn.winrestview(view)
        end
      end

      vim.keymap.set("n", "]]", function()
        jump_heading("W")
      end, { buffer = bufnr, desc = "Next markdown heading", nowait = true, silent = true })

      vim.keymap.set("n", "[[", function()
        jump_heading("bW")
      end, { buffer = bufnr, desc = "Previous markdown heading", nowait = true, silent = true })

      vim.keymap.set("n", "]h", function()
        local current_line = vim.fn.getline(".")
        local level = current_line:match("^(#+)")
        if level then
          local pattern = "^" .. string.rep("#", #level) .. "\\s"
          vim.fn.search(pattern, "W")
        else
          vim.fn.search("^#\\{1,6\\}\\(\\s\\|$\\)", "W")
        end
      end, { buffer = bufnr, desc = "Next same-level heading" })

      vim.keymap.set("n", "[h", function()
        local current_line = vim.fn.getline(".")
        local level = current_line:match("^(#+)")
        if level then
          local pattern = "^" .. string.rep("#", #level) .. "\\s"
          vim.fn.search(pattern, "bW")
        else
          vim.fn.search("^#\\{1,6\\}\\(\\s\\|$\\)", "bW")
        end
      end, { buffer = bufnr, desc = "Previous same-level heading" })
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "markdown", "markdown.pandoc" },
      callback = function(ev)
        -- Set buffer-local markdown motion helpers and override generic mappings
        setup_markdown_keymaps(ev.buf)

        -- Helper to create Markdown text objects only in markdown buffers
        local function markdown_textobjects()
          -- local filetype = vim.bo.filetype
          -- if not (filetype == "markdown" or filetype == "markdown.pandoc") then
          --   return {}
          -- end

          local gen_spec = require("mini.ai").gen_spec

          return {
            -- Heading: any markdown heading (# Title, ## Subtitle, etc.)
            -- 'ah' includes the # symbols and heading text
            -- 'ih' is just the heading text without # symbols
            h = {
              "#+%s+()[^\n]+()",
            },

            -- Code block: fenced code blocks with ```
            -- 'ak' includes the fence delimiters
            -- 'ik' is just the code content
            k = {
              {
                "```[^\n]*\n().-\n()```",
              },
            },

            -- Link: [text](url) or [text][ref]
            -- 'al' includes brackets and parentheses
            -- 'il' is just the link text
            l = function()
              -- Pattern for [text](url) or [text][ref] or ![alt](url)
              return {
                "%!?%[().-()%]%b()",
                "%!?%[().-()%]%[.-%]",
              }
            end,

            -- Bold: **text** or __text__
            -- Use non-balanced type for multi-character delimiters
            ["*"] = gen_spec.pair("**", "**"),
            B = gen_spec.pair("__", "__"),

            -- Italic: *text* or _text_
            -- Single character, can use greedy
            I = gen_spec.pair("_", "_", { type = "greedy" }),

            -- Strikethrough: ~~text~~
            -- Use non-balanced type for multi-character delimiter
            ["~"] = gen_spec.pair("~~", "~~"),

            -- List item: captures bullet or numbered list items
            -- 'ao' includes the bullet/number and content
            -- 'io' is just the content
            o = {
              {
                "%s*[%-%*%+]%s+()[^\n]+()", -- Bullet lists
                "%s*%d+%.%s+()[^\n]+()", -- Numbered lists
              },
            },

            -- Blockquote: lines starting with >
            -- 'a>' includes the > marker
            -- 'i>' is just the quoted text
            [">"] = {
              ">%s*()[^\n]+()",
            },

            -- Footnote reference: [^1]
            n = {
              {
                "%[%^().-()%]",
              },
            },

            -- Table cell (bonus): content between | delimiters
            -- Useful for markdown tables
            ["|"] = {
              {
                "|%s*().-()%s*|",
              },
            },
          }
        end

        -- Extend custom_textobjects with markdown-specific ones
        local original_custom = opts.custom_textobjects or {}
        opts.custom_textobjects = vim.tbl_deep_extend("force", original_custom, markdown_textobjects())
        local ai = require("mini.ai")
        ai.config.custom_textobjects = opts.custom_textobjects
      end,
    })

    -- Manually trigger for current buffer if it's already markdown
    -- This handles the case where nvim is opened directly to a markdown file
    local current_ft = vim.bo.filetype
    if current_ft == "markdown" or current_ft == "markdown.pandoc" then
      setup_markdown_keymaps(vim.api.nvim_get_current_buf())
    end

    return opts
  end,
}
