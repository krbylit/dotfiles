-- Mini file navigator
-- https://github.com/echasnovski/mini.files

-- mini.files map key for toggling dotfiles
local MiniFiles = require("mini.files")
local show_dotfiles = true
local filter_show = function(fs_entry)
	return true
end
local filter_hide = function(fs_entry)
	return not vim.startswith(fs_entry.name, ".") or vim.startswith(fs_entry.name, ".env")
end
local toggle_dotfiles = function()
	show_dotfiles = not show_dotfiles
	local new_filter = show_dotfiles and filter_show or filter_hide
	MiniFiles.refresh({ content = { filter = new_filter } })
end
-- Function to copy selected file's path
local get_filepath = function(buf_id)
	local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
	local fs_entry = MiniFiles.get_fs_entry().path
	if fs_entry then
		vim.fn.setreg("+", fs_entry)
		vim.notify("Copied path to clipboard: " .. fs_entry)
	end
end
local files_set_cwd = function()
	-- Works only if cursor is on the valid file system entry
	local cur_entry_path = MiniFiles.get_fs_entry().path
	local cur_directory = vim.fs.dirname(cur_entry_path)
	if cur_directory then
		vim.fn.chdir(cur_directory)
	end
end
-- autocmd used here since mini.files keymaps only available when menu is open
vim.api.nvim_create_autocmd("User", {
	pattern = "MiniFilesBufferCreate",
	callback = function(args)
		local buf_id = args.data.buf_id
		-- Tweak left-hand side of mapping to your liking
		vim.keymap.set("n", "g~", files_set_cwd, { desc = "Set cwd", buffer = args.data.buf_id })
		vim.keymap.set("n", "g.", toggle_dotfiles, { desc = "Toggle hidden files", buffer = buf_id })
		vim.keymap.set("n", "yp", function()
			get_filepath(buf_id)
		end, { desc = "Copy file path", buffer = buf_id })
	end,
})

return {
	"echasnovski/mini.files",
	-- No need to copy this inside `setup()`. Will be used automatically.
	-- init = function()
	-- 	vim.g.loaded_netrw = 1
	-- 	vim.g.loaded_netrwPlugin = 1
	-- end,
	keys = {
		-- NOTE: for some reason this mapping isn't taking here or in which-key spec, but works in keymaps.lua
		-- {
		-- 	"[<leader>e]",
		-- 	function()
		-- 		minifiles_toggle()
		-- 	end,
		-- 	desc = "Toggle mini file explorer",
		-- },
	},
	opts = {
		-- Customization of shown content
		content = {
			-- Predicate for which file system entries to show
			-- filter = nil,
			filter = filter_show,
			-- What prefix to show to the left of file system entry
			prefix = nil,
			-- In which order to show file system entries
			sort = nil,
		},

		-- Module mappings created only inside explorer.
		-- Use `''` (empty string) to not create one.
		mappings = {
			close = "q",
			go_in = "l",
			go_in_plus = "L",
			go_out = "h",
			go_out_plus = "H",
			reset = "<BS>",
			reveal_cwd = "@",
			show_help = "g?",
			synchronize = "=",
			trim_left = "<",
			trim_right = ">",
		},

		-- General options
		options = {
			-- Whether to delete permanently or move into module-specific trash
			permanent_delete = true,
			-- Whether to use for editing directories
			use_as_default_explorer = true,
		},

		-- Customization of explorer windows
		windows = {
			-- Maximum number of windows to show side by side
			max_number = math.huge,
			-- Whether to show preview of file/directory under cursor
			preview = true,
			-- Width of focused window
			width_focus = 50,
			-- Width of non-focused window
			width_nofocus = 15,
			-- Width of preview window
			width_preview = 35,
		},
	},
}
