-- Configurable statusline at the bottom of the screen.
-- https://github.com/nvim-lualine/lualine.nvim

local cached_repo_name = nil

-- Function to get the repository name from the current working directory
local function get_repo_name()
	if cached_repo_name then
		return cached_repo_name
	end

	-- Check if current directory is a git repository
	local git_dir = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null")

	-- If it's not a git repository, return an empty string
	if vim.v.shell_error ~= 0 then
		cached_repo_name = ""
		return cached_repo_name
	end

	-- Extract the repository name from the git directory path
	cached_repo_name = vim.fn.fnamemodify(git_dir, ":t"):gsub("\n", "")
	return cached_repo_name
end

-- -- Update the cached repo name when the working directory changes
-- vim.api.nvim_create_autocmd("DirChanged", {
-- 	callback = function()
-- 		set_repo_name()
-- 	end,
-- })

return {
	"nvim-lualine/lualine.nvim",
	-- dependencies = { "nvim-tree/nvim-web-devicons" },
	dependencies = { "echasnovski/mini.icons" },
	-- LazyVim defaults
	opts = function()
		MiniIcons.mock_nvim_web_devicons()
		-- PERF: we don't need this lualine require madness 🤷
		local lualine_require = require("lualine_require")
		lualine_require.require = require

		-- Options for printing file path
		local path_ops = { relative = "cwd", length = 4 }

		local icons = LazyVim.config.icons

		vim.o.laststatus = vim.g.lualine_laststatus

		local opts = {
			options = {
				theme = "auto",
				globalstatus = vim.o.laststatus == 3,
				disabled_filetypes = { statusline = { "snacks_dashboard", "dashboard", "alpha", "ministarter" } },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					{ get_repo_name },
					{ "branch" },
				},

				lualine_c = {
					-- LazyVim.lualine.root_dir(),
					{
						"diagnostics",
						symbols = {
							error = icons.diagnostics.Error,
							warn = icons.diagnostics.Warn,
							info = icons.diagnostics.Info,
							hint = icons.diagnostics.Hint,
						},
					},
					{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
					{ LazyVim.lualine.pretty_path(path_ops) },
				},
				lualine_x = {
					-- stylua: ignore
					{
						function() return require("noice").api.status.command.get() end,
						cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
						color = function() return LazyVim.ui.fg("Statement") end,
					},
					-- stylua: ignore
					{
						-- This components shows the '@recording' msg when recording macro
						function() return require("noice").api.status.mode.get() end,
						cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
						color = function() return LazyVim.ui.fg("Constant") end,
					},
					-- stylua: ignore
					{
						function() return "  " .. require("dap").status() end,
						cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
						color = function() return LazyVim.ui.fg("Debug") end,
					},
					-- stylua: ignore
					{
						require("lazy.status").updates,
						cond = require("lazy.status").has_updates,
						color = function() return LazyVim.ui.fg("Special") end,
					},
					{
						"diff",
						symbols = {
							added = icons.git.added,
							modified = icons.git.modified,
							removed = icons.git.removed,
						},
						source = function()
							local gitsigns = vim.b.gitsigns_status_dict
							if gitsigns then
								return {
									added = gitsigns.added,
									modified = gitsigns.changed,
									removed = gitsigns.removed,
								}
							end
						end,
					},
				},
				lualine_y = {
					{ "progress", separator = " ", padding = { left = 1, right = 0 } },
					{ "location", padding = { left = 0, right = 1 } },
				},
				lualine_z = {
					function()
						-- return " " .. os.date("%R")
						return " " .. os.date("%c")
					end,
				},
			},
			-- extensions = { "neo-tree", "lazy" },
			extensions = { "aerial", "mason", "nvim-dap-ui", "toggleterm", "trouble", "lazy" },
		}

		-- do not add trouble symbols if aerial is enabled
		-- And allow it to be overriden for some buffer types (see autocmds)
		if vim.g.trouble_lualine and LazyVim.has("trouble.nvim") then
			local trouble = require("trouble")
			local symbols = trouble.statusline({
				mode = "symbols",
				groups = {},
				title = false,
				filter = { range = true },
				format = "{kind_icon}{symbol.name:Normal}",
				hl_group = "lualine_c_normal",
			})
			table.insert(opts.sections.lualine_c, {
				symbols and symbols.get,
				cond = function()
					return vim.b.trouble_lualine ~= false and symbols.has()
				end,
			})
		end

		opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, opts)
		return opts
	end,
}
