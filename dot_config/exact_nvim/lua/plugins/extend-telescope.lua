-- Fuzzy finder over lists. Highly extensible, used by many other plugins. Can be sourced by other plugins. UI provided by other plugins.
-- https://github.com/nvim-telescope/telescope.nvim

local find_files_with_hidden = function()
	local action_state = require("telescope.actions.state")
	local line = action_state.get_current_line()
	LazyVim.pick("find_files", { hidden = true, default_text = line })()
end

return {
	"nvim-telescope/telescope.nvim", -- tag = '0.1.8',
	-- or                              , branch = '0.1.x',
	dependencies = { "nvim-lua/plenary.nvim", "tsakirist/telescope-lazy.nvim" },
	-- tag = "0.1.8",
	keys = {
		{ "<leader> ", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
		-- { "<leader> ", find_files_with_hidden, desc = "Find Files (cwd)" },
		{
			mode = { "n" },
			"<leader>sp",
			"<cmd>Telescope lazy<CR>",
			desc = "Search Plugins",
		},
	},
	-- config = function()
	-- 	-- TODO: clean-up task extend this instead of override
	-- 	local telescope = require("telescope")
	--
	-- 	-- telescope.setup({
	-- 	-- 	-- ... your telescope config
	-- 	-- })
	--
	-- 	telescope.load_extension("chezmoi")
	-- 	-- vim.keymap.set("n", "<leader>cz", telescope.extensions.chezmoi.find_files, {})
	-- end,
	opts = {
		pickers = {
			-- Configure all pickers to use the ivy theme
			find_files = {
				theme = "ivy",
			},
			live_grep = {
				theme = "ivy",
			},
			buffers = {
				theme = "ivy",
			},
			help_tags = {
				theme = "ivy",
			},
			git_files = {
				theme = "ivy",
			},
			git_status = {
				theme = "ivy",
			},
			git_commits = {
				theme = "ivy",
			},
			git_branches = {
				theme = "ivy",
			},
			lsp_references = {
				theme = "ivy",
			},
			lsp_definitions = {
				theme = "ivy",
			},
			lsp_implementations = {
				theme = "ivy",
			},
			lsp_document_symbols = {
				theme = "ivy",
			},
			lsp_workspace_symbols = {
				theme = "ivy",
			},
			diagnostics = {
				theme = "ivy",
			},
			oldfiles = {
				theme = "ivy",
			},
		},
		defaults = {
			file_ignore_patterns = {
				-- NOTE: `file_ignore_patterns` will be used in all pickers that have a
				-- file associated. This might lead to the problem that lsp_ pickers
				-- aren't displaying results because they might be ignored by
				-- `file_ignore_patterns`. For example, setting up node_modules as ignored
				-- will never show node_modules in any results, even if you are
				-- interested in lsp_ results.
				-- If you only want `file_ignore_patterns` for `find_files` and
				-- `grep_string`/`live_grep` it is suggested that you setup `gitignore`
				-- and have fd and or ripgrep installed because both tools will not show
				-- `gitignore`d files on default.
				-- NOTE: these patterns simply filter what telescope shows from `rg`. We can actually exclude results from `rg` with glob args below
				-- "node_modules",
				"package%-lock%.json",
				-- "package%.json",
				"^virtual_env/",
			},
			vimgrep_arguments = {
				"rg",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
				"--pcre2", -- Use Perl Compatible RegEx so we can use lookarounds
				-- NOTE: playing with these ignores for a minute. Hopefully this allows us to search .env's and other .gitignore'd/hidden files without showing node_modules
				-- "--hidden",
				-- "--no-ignore-vcs",
				"--glob=!**/node_modules/**",
				"--glob=!**/dist/**",
				"--glob=!**/build/**",
				-- "--glob=!**/.git/**", -- Exclude .git
				-- "--glob=!**/.vscode/**", -- Exclude .vscode
				-- "--glob=!**/.DS_Store", -- Exclude .DS_Store
				-- "--glob=!**/.dockerignore", -- Exclude .DS_Store
				-- "--glob=!package.json",
				-- "--glob=!package-lock.json",
			},
			cache_picker = {
				ignore_empty_prompt = true,
			},
		},
		extensions = {
			chezmoi = {
				-- TODO: make this open from cm source. currently opens the target file
				-- mappings = { find_files = "<leader>fc", desc = "Find Config File" },
			},
			-- Search active plugins
			-- https://github.com/tsakirist/telescope-lazy.nvim
			lazy = {
				-- Optional theme (the extension doesn't set a default theme)
				theme = "ivy",
				-- Whether or not to show the icon in the first column
				show_icon = true,
				-- Mappings for the actions
				mappings = {
					open_in_browser = "<C-o>",
					open_in_file_browser = "<M-b>",
					open_in_find_files = "<C-f>",
					open_in_live_grep = "<C-g>",
					open_in_terminal = "<C-t>",
					open_plugins_picker = "<C-b>", -- Works only after having called first another action
					open_lazy_root_find_files = "<C-r>f",
					open_lazy_root_live_grep = "<C-r>g",
					change_cwd_to_plugin = "<C-c>d",
				},
				-- Extra configuration options for the actions
				actions_opts = {
					open_in_browser = {
						-- Close the telescope window after the action is executed
						auto_close = false,
					},
					change_cwd_to_plugin = {
						-- Close the telescope window after the action is executed
						auto_close = false,
					},
				},
				-- Configuration that will be passed to the window that hosts the terminal
				-- For more configuration options check 'nvim_open_win()'
				terminal_opts = {
					relative = "editor",
					style = "minimal",
					border = "rounded",
					title = "Telescope lazy",
					title_pos = "center",
					width = 0.5,
					height = 0.5,
				},
				-- Other telescope configuration options
			},
		},
	},
}
