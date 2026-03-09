-- Options are automatically loaded before lazy.nvim startup

local opt = vim.opt

vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#ed8796", bg = "" })

-- Global options for VS Code and console use
vim.env.PATH = "/opt/homebrew/bin:" .. (vim.env.PATH or "")
vim.g.python3_host_prog = "/opt/homebrew/bin/python3"
vim.g.mapleader = "," -- Set leader key to comma
vim.api.nvim_set_keymap("", " ", "<Nop>", { noremap = true, silent = true })
vim.g.maplocalleader = " "
-- Asynchronously set global for `$(chezmoi source-path)`
vim.schedule(function()
  vim.system({ "chezmoi", "source-path" }, { text = true }, function(result)
    if result.code == 0 and result.stdout then
      vim.g.chezmoi_source_path = vim.fn.fnamemodify(result.stdout:gsub("\n", ""), ":p")
    end
  end)
end)
-- LazyVim root dir detection
-- vim.g.root_spec = { { ".git" }, "lua", "lsp", "cwd" }
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" } -- default

-- Ensure the 'list' option is enabled
vim.opt.list = true
-- Set 'listchars' to only display trailing spaces
vim.opt.listchars = {
  trail = "-", -- Show trailing spaces as `-`
  tab = "  ", -- A tab will appear as spaces (effectively hidden)
  nbsp = " ", -- Hide non-breaking spaces
  space = " ", -- Hide space indicators
}
-- Remove 'blank' from sessionoptions to avoid opening empty unnamed buffers
vim.opt.sessionoptions:remove("blank")
vim.opt.sessionoptions:remove("help")
vim.opt.sessionoptions:remove("skiprtp")
-- vim.opt.sessionoptions:remove("curdir")
-- Remove 'localoptions' to prevent session from saving/restoring buffer-local options like
-- tabstop, shiftwidth, etc. This allows guess-indent.nvim to always detect fresh indentation.
vim.opt.sessionoptions:remove("localoptions")
-- NOTE: adding options can result in unexpected behavior, e.g. if you make nvim config changes and load an existing session, those changes may not be integrated.
-- vim.opt.sessionoptions:append("localoptions")
-- vim.opt.sessionoptions:append("options")
-- Change dir to currently open buffer
-- FIXME: something is setting this to false after options load. doesn't seem to be mini.misc auto root, or project.nvim
-- opt.autochdir = true
-- Add '-' to keyword so kebab case is considered a word (i.e. 'variable-name' is one word)
vim.opt.iskeyword:append("-")

-- Disable auto-comment behaviors globally (fallback for filetypes without after/ftplugin)
-- after/ftplugin/<filetype>.lua files override built-in ftplugins for common languages
vim.opt.formatoptions:remove("c") -- Don't auto-wrap comments using textwidth
vim.opt.formatoptions:remove("r") -- Don't auto-insert comment leader on Enter in insert mode
vim.opt.formatoptions:remove("o") -- Don't auto-insert comment leader on o/O in normal mode

-- use bash for shell, fish is very slow in nvim
-- opt.shell = "bash"
if vim.env.IS_SSH ~= "1" then
  opt.shell = "fish"
else
  opt.shell = "bash"
end
-- opt.shell = "/opt/homebrew/bin/fish"
opt.undofile = true -- Save undo history between sessions
opt.fileformat = "unix" -- Use Unix line endings (LF) - recommended for all modern systems
opt.fixendofline = true -- Ensure files end with a newline (fixes eol on write)
-- NOTE: setting `tabstop` here sets it globally, and that seems to be what causes indentation to sometimes change back to 4 even when in a project that sets it to 2. We don't need this here since we have a root ~/.editorconfig that sets to 4.
-- opt.tabstop = 4 -- A tab is equal to 4 spaces
opt.shiftwidth = 0 -- Number of spaces to use for each step of (auto)indent; 0=use tabstop val
opt.expandtab = true -- Convert tabs to spaces
opt.autoindent = true
opt.cursorline = true -- Enable highlighting of the current line
opt.cursorlineopt = "number" -- Only highlight the line number
-- opt.scrolloff = 999 -- Lines of context
opt.scrolloff = 8 -- Lines of context
opt.relativenumber = true
opt.smartindent = true -- Insert indents automatically
-- opt.colorcolumn = "88" -- Shows a column line at 80 characters
opt.wrap = true -- Set text display to wrap. Doesn't change text in buffer
opt.linebreak = true -- wrap long lines at a blank
-- NOTE: Disabling line wrap indicators as we're getting these from statuscol.nvim
opt.breakindent = true -- Enable break indent
opt.breakindentopt = "shift:2,sbr,min:20"
-- opt.showbreak = "↳" -- Show a symbol for a line break
opt.wrapmargin = 0
opt.textwidth = 0
-- opt.showbreak = "	" -- Show a symbol for a line break
-- opt.textwidth = 80 -- Maximum width of text. Actually changes text in the buffer NOTE: disabling because it causes messes
opt.mousehide = true -- Hide mouse cursor while typing
opt.winheight = 1 -- Minimum window height
opt.winminheight = 1 -- Minimum window height
opt.updatetime = 250 -- CursorHold event timing, LSP idle timing, diagnostics updates, etc.

-- Sync with system clipboard locally; skip on SSH where there's no provider
-- (the OSC 52 autocmd below handles copying to local clipboard over SSH)
if vim.env.IS_SSH ~= "1" then
  opt.clipboard = "unnamedplus"
end

-- OSC 52: push yanked text to local clipboard over SSH via Ghostty.
-- We don't set vim.g.clipboard because Zellij doesn't support OSC 52 paste,
-- which breaks normal yank/paste. Instead, we fire OSC 52 copy as a side-effect
-- on yank, keeping Neovim's internal registers fully functional.
if vim.env.IS_SSH == "1" or vim.env.HOMELAB == "1" then
  local osc52_copy = require("vim.ui.clipboard.osc52").copy("+")
  vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("OSC52Yank", { clear = true }),
    callback = function()
      local event = vim.v.event
      if event.operator == "y" then
        osc52_copy(event.regcontents)
      end
    end,
  })
end

-- Enable diagnostics by default
vim.diagnostic.enable(true)
-- FORMATTING
-- default "tcqj"
opt.formatoptions = "qnlj"
vim.g.autoformat = true
vim.g.lazyvim_prettier_needs_config = false

if vim.fn.has("nvim-0.10") == 1 then
  opt.smoothscroll = true
  opt.foldexpr = "v:lua.require'lazyvim.util'.treesitter.foldexpr()"
  opt.foldmethod = "expr"
  opt.foldtext = ""
  opt.foldcolumn = "1"
else
  opt.foldmethod = "indent"
  opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"
  opt.foldcolumn = "1"
end

if vim.env.IS_SSH ~= "1" then
  vim.o.showtabline = 2
end

-- ================================================================
-- LAZYVIM OPTS
-- ================================================================
-- Set to "basedpyright" to use basedpyright instead of pyright.
vim.g.lazyvim_python_lsp = "pyright"

-- ================================================================
-- FILETYPES
-- ================================================================
-- WARN: May want to move all autocmds to autocmds.lua to decrease the chance of an autocmd being loaded more than once.
-- Enable `csvview.nvim` for CSV files
local filetype_options_augroup = vim.api.nvim_create_augroup("FileTypeOptions", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = filetype_options_augroup,
  pattern = "csv",
  callback = function()
    require("csvview").enable()
    vim.opt_local.wrap = false
  end,
})

-- Disable diagnostics in certain filetypes
local diagnostics_disabled_fts = {
  "markdown",
  "txt",
  -- "json",
  -- "sh",
  -- "bash",
  -- "zsh",
  -- "fish",
  "conf",
  "cfg",
  "ini",
  -- "toml",
  -- "yaml",
  -- "yml",
  "gitconfig",
}
local diagnostics_config_augroup = vim.api.nvim_create_augroup("DiagnosticsConfig", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = diagnostics_config_augroup,
  pattern = diagnostics_disabled_fts,
  callback = function()
    -- Disable diagnostics only in current buffer.
    vim.diagnostic.enable(false, { bufnr = 0 })
  end,
})

-- Disable autoformat for .env files (detected as 'sh' filetype; lsp_format=fallback causes bashls to format them)
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = diagnostics_config_augroup,
  pattern = { ".env", "*.env", ".env.*", "*.env.*" },
  callback = function()
    vim.b.autoformat = false
    vim.diagnostic.enable(false, { bufnr = 0 })
  end,
})

-- Disable by file extension
local diagnostics_disabled_extensions = {
  "*.tfvars",
  "*.tfbackend",
}
-- Disable by file path
local diagnostics_disabled_dirs = {
  vim.fn.expand("$HOME") .. "/.local/share/nvim/scratch/*",
}
-- Combine for autocmd
local diagnostics_disabled_patterns = {}
vim.list_extend(diagnostics_disabled_patterns, diagnostics_disabled_dirs)
vim.list_extend(diagnostics_disabled_patterns, diagnostics_disabled_extensions)
-- Strip newlines if they exist, as `patterns` disallows those.
diagnostics_disabled_patterns = vim.tbl_map(function(p)
  return p:gsub("\n", "")
end, diagnostics_disabled_patterns)
-- Disable diagnostics by other patterns
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = diagnostics_config_augroup,
  pattern = diagnostics_disabled_patterns,
  callback = function()
    -- Disable diagnostics only in current buffer.
    vim.diagnostic.enable(false, { bufnr = 0 })
  end,
})

-- Add chezmoi template files as filetypes to nvim so that yaml and toml LSPs can parse them
-- TODO: move these to a separate options module and import here
vim.filetype.add({
  extension = {
    tmpl = function(path, bufnr)
      if path:find(".toml.tmpl") then
        return "toml"
      end
      if path:find(".json.tmpl") then
        return "json"
      end
      if path:find(".yaml.tmpl") then
        return "yaml"
      end
      if path:find(".sh.tmpl") then
        return "sh"
      end
      if path:find(".conf.tmpl") then
        return "conf"
      end
    end,
    chezmoiignore = "gitignore",
    watchmanconfig = "json",
    gitconfig = "gitconfig",
    json = function(path, bufnr)
      if path:find("neoconf") then
        return "jsonc"
      end
      return "json"
    end,
    tfvars = "terraform",
    tfbackend = "terraform",
  },
  filename = {
    -- ["dot_zshrc"] = "zsh",
    -- ["dot_gitconfig"] = "gitconfig",
    -- ["dot_neoconf"] = "jsonc", -- NOTE: this one isn't working for some reason, hence above json func
    -- ["neoconf"] = "jsonc",
  },
  pattern = {
    [".*dot_zshrc"] = "zsh",
    [".*dot_gitconfig"] = "gitconfig",
    [".*gitconfig$"] = "gitconfig",
    [".*dot_bash.*"] = "bash",
    [".*ssh/.*config"] = "sshconfig",
  },
  -- pattern = {
  -- 	[".*gitconfig$"] = "gitconfig",
  -- 	[".*zshrc$"] = "zsh",
  -- 	-- 	[".*%.toml%.tmpl$"] = "toml",
  -- 	-- 	[".*%.yaml%.tmpl$"] = "yaml",
  -- },
})
