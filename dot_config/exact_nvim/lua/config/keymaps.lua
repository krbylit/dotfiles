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
map({ "n", "v" }, "j", "gj", { noremap = true, silent = true })
map({ "n", "v" }, "k", "gk", { noremap = true, silent = true })
map({ "n", "v" }, "^", "g^", { noremap = true, silent = true })
map({ "n", "v" }, "$", "g$", { noremap = true, silent = true })
-- Scrolling
-- TODO: figure out other maps, these conflict with window movement
-- map({ "n", "v" }, "<C-j>", "10j", { noremap = true, silent = true })
-- map({ "n", "v" }, "<C-k>", "10k", { noremap = true, silent = true })

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
		require("snacks").bufdelete() -- enable once we use `snacks` again
	end
end)

-- Map ",e" to toggle mini.files
local function is_snacks_dashboard()
	return vim.bo.filetype == "snacks_dashboard"
end
wk.add({
	mode = "n",
	remap = false,
	{
		"<leader>e",
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
		"<leader>E",
		function()
			if not MiniFiles.close() then
				MiniFiles.open(MiniFiles.get_latest_path())
			end
		end,
		desc = "MiniFiles Explorer (cwd)",
	},
})

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
