-- Disable auto-comment behaviors
vim.opt_local.formatoptions:remove("c")
vim.opt_local.formatoptions:remove("r")
vim.opt_local.formatoptions:remove("o")
-- Don't wrap so we get nice code blocks from markview.nvim
vim.opt_local.wrap = false
-- Folding suggested for obsidian.nvim: https://github.com/obsidian-nvim/obsidian.nvim/wiki/Folding
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.wo.foldmethod = "expr"
