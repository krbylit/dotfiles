-- vim.api.nvim_create_autocmd("User", {
--     pattern = "TSUpdate",
--     callback = function()
--         require("nvim-treesitter.parsers").comment = {
--             install_info = {
--                 url = "https://github.com/OXY2DEV/tree-sitter-comment",
--
--                 branch = "main", -- only needed if different from default branch
--                 queries = "queries/",
--             },
--         }
--     end,
-- })

return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  dependencies = {
    "OXY2DEV/markview.nvim",
  },
  opts = {
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed = {
      "awk",
      "bash",
      "c",
      "cmake",
      "comment",
      "diff",
      "dockerfile",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
      "html",
      "http",
      "javascript",
      "jq",
      "jsdoc",
      "json",
      "jsonc",
      "lua",
      "luadoc",
      "luap",
      "make",
      "markdown",
      "markdown_inline",
      "nix",
      "pem",
      "printf",
      "python",
      "query",
      "regex",
      "rust",
      "ssh_config",
      "tmux",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    },
    -- incremental_selection = {
    -- 	enable = true,
    -- 	keymaps = {
    -- 		init_selection = "<C-space>",
    -- 		node_incremental = "<C-space>",
    -- 		scope_incremental = false,
    -- 		node_decremental = "<bs>",
    -- 	},
    -- },
  },
}
