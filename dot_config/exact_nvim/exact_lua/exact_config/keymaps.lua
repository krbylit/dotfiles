-- Keymaps are automatically loaded on the VeryLazy event

local map = vim.keymap.set
local wk = require("which-key")
local MiniFiles = require("mini.files")

-- Load plugin specific keymaps from `plugin-keymaps` module
if vim.g.started_by_firenvim == true then
  -- NOTE: Firenvim keymaps need to be loaded here, in the normal execution order of loading keymaps
  require("firenvim-config.keymaps").setup()
end
-- ================================================================
-- MOVEMENT
-- ================================================================
-- Make basic movement operate on visual lines rather than logical lines when word-wrapped.
-- NOTE: we are already getting these mappings from somewhere, but leaving these here in case they disappear in the future.
-- vim.keymap.set({ "n", "v", "x" }, "j", function()
-- 	return vim.v.count == 0 and "gj" or "j"
-- end, { noremap = true, expr = true, silent = true })
-- vim.keymap.set({ "n", "v", "x" }, "k", function()
-- 	return vim.v.count == 0 and "gk" or "k"
-- end, { noremap = true, expr = true, silent = true })
-- Change half-screen scroll to move visual lines and not logical lines
-- vim.keymap.set("n", "<C-d>", "25<C-e>", { noremap = true })
-- vim.keymap.set("n", "<C-u>", "25<C-y>", { noremap = true })
map({ "n", "v" }, "^", "g^", { noremap = true, silent = true })
map({ "n", "v" }, "$", "g$", { noremap = true, silent = true })
-- Scrolling
-- TODO: figure out other maps, these conflict with window movement
-- map({ "n", "v" }, "<C-j>", "10j", { noremap = true, silent = true })
-- map({ "n", "v" }, "<C-k>", "10k", { noremap = true, silent = true })
local toggle_scrolloff = function()
  local enable = vim.wo.scrolloff == 999
  vim.wo.scrolloff = enable and 8 or 999
end
map({ "n", "v", "i", "x" }, "<C-g>", toggle_scrolloff, { noremap = true, expr = true, silent = true })
-- NOTE: these are explicitly set because at some point we lost them and `<[f>` searches for file in path
local m = require("nvim-treesitter-textobjects.move")
vim.keymap.set("n", "]f", function()
  m.goto_next_start("@function.outer")
end, { silent = true, noremap = true, desc = "Next function" })
vim.keymap.set("n", "[f", function()
  m.goto_previous_start("@function.outer")
end, { silent = true, noremap = true, desc = "Prev function" })

-- ================================================================
-- COMMENTS
-- ================================================================
-- Remap commenting with 'gcc' to 'Super + /' in normal mode
map("n", "<D-/>", "gcc", { remap = true, silent = true })
-- Remap 'gc' to 'Super + /' in visual mode
map("x", "<D-/>", "gc", { remap = true, silent = true })

-- ================================================================
-- WINDOWS / TABS
-- ================================================================
-- Better tab nav
wk.add({
  mode = "n",
  { "]<tab>", "<cmd>tabnext<cr>", desc = "Next Tab" },
  { "[<tab>", "<cmd>tabprevious<cr>", desc = "Previous Tab" },
})

-- ================================================================
-- UTILITY
-- ================================================================
-- wk.add({ "<leader>ll", "<cmd>Lazy<cr>", desc = "Lazy", mode = { "n" } })
wk.add({ "<leader>xc", "<cmd>call setqflist([])<cr>", desc = "Clear Quickfix", remap = false, mode = "n" })
-- Smart `dd`. Does not override last yank register if deleting an empty line.
local dd = function()
  if vim.api.nvim_get_current_line():match("^%s*$") then
    return '"_dd'
  else
    return "dd"
  end
end
map("n", "dd", dd, { noremap = true, expr = true })
-- Unbind ctrl-z so it doesn't suspend terminal
map({ "n", "v", "i" }, "<c-z>", "<Nop>", { noremap = true, expr = true })
-- Clear all virtual text / ext marks in buffer (useful for octo.nvim comment virt text)
map("n", "<leader>uv", function()
  vim.api.nvim_buf_clear_namespace(0, -1, 0, -1)
end, { desc = "Clear all virtual text/extmarks in buffer" })

-- ================================================================
-- FILES
-- ================================================================
-- Buffer maps
map("n", "<c-q>", function()
  if vim.bo.filetype == "snacks_dashboard" then
    vim.cmd("q") -- Close the dashboard
  end
  local listed_buffers = vim.fn.getbufinfo({ buflisted = 1, bufloaded = 1 })
  -- If closing last buffer, open dashboard
  if #listed_buffers == 1 then
    vim.cmd("lua Snacks.dashboard({win=0})") -- Open the dashboard
  else
    require("snacks").bufdelete.delete() -- enable once we use `snacks` again
  end
end)

-- Map ",e" to toggle mini.files
local function is_snacks_dashboard()
  return vim.bo.filetype == "snacks_dashboard"
end

-- On SSH, map yazi keybindings to mini.files equivalents
if vim.env.IS_SSH == "1" then
  wk.add({
    mode = "n",
    remap = false,
    {
      "<leader>E",
      function()
        if not MiniFiles.close() then
          if is_snacks_dashboard() then
            MiniFiles.open(vim.fn.getcwd(), false)
          else
            MiniFiles.open(vim.api.nvim_buf_get_name(0))
          end
        end
      end,
      desc = "MiniFiles Explorer (file)",
    },
    {
      "<leader>cw",
      function()
        if not MiniFiles.close() then
          MiniFiles.open(vim.cmd.pwd())
        end
      end,
      desc = "MiniFiles Explorer (cwd)",
    },
    {
      "<leader>e",
      function()
        if not MiniFiles.close() then
          if is_snacks_dashboard() then
            MiniFiles.open(vim.fn.getcwd(), false)
          else
            MiniFiles.open(vim.api.nvim_buf_get_name(0))
          end
        end
      end,
      desc = "MiniFiles Explorer (toggle)",
    },
  })
else
  wk.add({
    mode = "n",
    remap = false,
    {
      "<leader>m",
      function()
        if not MiniFiles.close() then
          if is_snacks_dashboard() then
            -- get current director
            local cwd = vim.fn.getcwd()
            -- Open in current directory
            MiniFiles.open(cwd, false)
          else
            -- Open in current file's directory
            MiniFiles.open(vim.api.nvim_buf_get_name(0))
          end
        end
      end,
      desc = "MiniFiles Explorer (file)",
    },
    {
      "<leader>M",
      function()
        if not MiniFiles.close() then
          MiniFiles.open(vim.cmd.pwd())
        end
      end,
      desc = "MiniFiles Explorer (cwd)",
    },
  })
end

-- Marks maps
-- Function to delete the mark on the current line
local function delete_mark()
  local line = vim.fn.line(".") -- Get the current line number
  local marks = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" -- Local marks ('a' to 'z')
  for mark in marks:gmatch(".") do
    local mark_pos = vim.fn.getpos("'" .. mark) -- Get the position of the mark
    if mark_pos[2] == line then -- Check if the mark is on the current line
      vim.cmd("delmarks " .. mark) -- Delete the mark
      print("Deleted mark '" .. mark .. "' on line " .. line)
      return
    end
  end
  print("No mark found on the current line.")
end
wk.add({
  mode = "n",
  remap = false,
  { "<leader>'", group = "marks" },
  -- Delete current line mark
  { "<leader>'d", delete_mark, desc = "Delete mark on current line" },
  -- Delete all file marks
  { "<leader>'f", "<cmd>delm a-z<cr>", desc = "Delete all file marks" },
  -- Delete all global marks
  { "<leader>'g", "<cmd>delm A-Z<cr>", desc = "Delete all global marks" },
})
