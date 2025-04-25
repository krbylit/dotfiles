-- TODO: implement truncation method for when window not big enough for file path
local colors = require("tokyonight.colors").setup({ style = "night" })
-- local colors = require("tokyonight").load({ style = "night" })
local current_repo_name = ""
local current_branch = ""

-- Function to update the repository name and branch based on the current buffer
local function update_git_info()
	local current_dir = vim.fn.expand("%:p:h")

	-- Get repo name
	local git_dir = vim.fn.system("git -C " .. current_dir .. " rev-parse --show-toplevel 2>/dev/null")
	if vim.v.shell_error == 0 then
		current_repo_name = vim.fn.fnamemodify(git_dir, ":t"):gsub("\n", "")

		-- Get branch name
		local branch = vim.fn.system("git -C " .. current_dir .. " branch --show-current 2>/dev/null")
		if vim.v.shell_error == 0 then
			current_branch = branch:gsub("\n", "")
		else
			current_branch = ""
		end
	else
		current_repo_name = "" -- Reset if not in a git repo
		current_branch = ""
	end
end

-- Autocmd to update the git info whenever a buffer is entered or switched
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	callback = function()
		local cb = function()
			update_git_info()
		end
		vim.schedule(cb)
	end,
})

-- Function to get path relative to git root
local function get_relative_path()
	local full_path = vim.fn.expand("%:p")
	local git_root = vim.fn.system("git -C " .. vim.fn.expand("%:p:h") .. " rev-parse --show-toplevel"):gsub("\n", "")

	-- If the path starts with git_root, remove it
	local relative_path = full_path:gsub("^" .. vim.pesc(git_root) .. "/?", "")
	return relative_path
end

-- Custom section_filename to highlight the Git root directory and show branch
local function custom_section_filename(args)
	local result = ""

	-- If we're in a git repo
	if current_repo_name ~= "" then
		-- Get the relative path
		local relative_path = get_relative_path()
		local parts = {}
		for part in relative_path:gmatch("[^/]+") do
			table.insert(parts, part)
		end

		-- Format repo and branch with icons
		--    󰘬  󰳏    󰘬  󰊢      󰊤        
		-- Branch
		result = string.format(
			"%%#MiniStatuslineBranchIcon#%s%%*",
			"" -- Branch icon
		)
		result = result .. string.format("%%#MiniStatuslineBoldBranchName#%s%%*", current_branch)
		-- Repo
		result = result .. string.format(
			"%%#MiniStatuslineRepoIcon#%s%%*",
			"" -- Repo icon
		)
		result = result .. string.format("%%#MiniStatuslineBoldRepoName#%s%%*", current_repo_name)

		-- Add the rest of the path if it exists
		if #parts > 0 then
			for i, part in ipairs(parts) do
				if i == #parts then
					-- Last part (filename) gets special highlighting
					result = result
						.. string.format(
							"%%#MiniStatuslinePathName#/%s",
							string.format("%%#MiniStatuslineBoldFileName#%s%%*", part)
						)
				else
					-- Middle parts of the path
					result = result .. string.format("%%#MiniStatuslinePathName#/%s%%*", part)
				end
			end
		end
	else
		-- Not in a git repo - show full path with home directory replaced
		local filepath = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":~")
		local parts = {}
		for part in filepath:gmatch("[^/]+") do
			table.insert(parts, part)
		end

		-- Format the parts
		for i, part in ipairs(parts) do
			if i == 1 then
				result = string.format("%%#MiniStatuslinePathName#%s%%*", part)
			elseif i == #parts then
				result = result
					.. string.format(
						"%%#MiniStatuslinePathName#/%s",
						string.format("%%#MiniStatuslineBoldFileName#%s%%*", part)
					)
			else
				result = result .. string.format("%%#MiniStatuslinePathName#/%s%%*", part)
			end
		end
	end

	-- Add file modification and readonly flags
	local file_flags = "%m%r"
	return result .. file_flags
end

return {
	"echasnovski/mini.statusline",
	version = false,
	-- cond = function()
	-- 	return vim.bo.filetype ~= "snacks_dashboard"
	-- end,
	config = function()
		vim.api.nvim_set_hl(
			0,
			"MiniStatuslineBoldFileName",
			{ italic = true, bold = true, fg = colors.teal, bg = colors.bg }
		)
		vim.api.nvim_set_hl(
			0,
			"MiniStatuslineBoldRepoName",
			{ italic = false, bold = true, fg = colors.orange, bg = colors.bg }
		)
		vim.api.nvim_set_hl(
			0,
			"MiniStatuslineRepoIcon",
			{ italic = false, bold = false, fg = colors.orange, bg = colors.bg }
		)
		vim.api.nvim_set_hl(
			0,
			"MiniStatuslineBoldBranchName",
			{ italic = false, bold = true, fg = colors.cyan, bg = colors.bg }
		)
		vim.api.nvim_set_hl(
			0,
			"MiniStatuslineBranchIcon",
			{ italic = false, bold = false, fg = colors.cyan, bg = colors.bg }
		)
		vim.api.nvim_set_hl(0, "MiniStatuslinePathName", { fg = colors.fg_dark, bg = colors.bg })
		vim.api.nvim_set_hl(0, "MiniStatuslineRecording", { fg = colors.bg_dark1, bg = colors.red })
		-- Mode indicator hl groups
		vim.api.nvim_set_hl(0, "MiniStatuslineModeNormal", { fg = colors.bg_dark1, bg = colors.blue })
		vim.api.nvim_set_hl(0, "MiniStatuslineModeInsert", { fg = colors.bg_dark1, bg = colors.green })
		vim.api.nvim_set_hl(0, "MiniStatuslineModeVisual", { fg = colors.bg_dark1, bg = colors.purple })
		vim.api.nvim_set_hl(0, "MiniStatuslineModeReplace", { fg = colors.bg_dark1, bg = colors.magenta2 })
		vim.api.nvim_set_hl(0, "MiniStatuslineModeCommand", { fg = colors.bg_dark1, bg = colors.orange })
		vim.api.nvim_set_hl(0, "MiniStatuslineModeOther", { fg = colors.bg_dark1, bg = colors.teal })
		-- General hl groups
		vim.api.nvim_set_hl(0, "MiniStatuslineDevinfo", { fg = colors.fg, bg = colors.blue7 })
		vim.api.nvim_set_hl(0, "MiniStatuslineFileinfo", { fg = colors.fg, bg = colors.blue7 })
		-- vim.api.nvim_set_hl(0, "MiniStatuslineInactive", { fg = colors.bg_dark1, bg = colors.teal })
		-- Nvim statusline hl groups
		vim.api.nvim_set_hl(0, "StatusLine", { bg = colors.bg })
		vim.api.nvim_set_hl(0, "StatusLineNC", { bg = colors.bg }) -- For inactive windows

		require("mini.statusline").setup({
			content = {
				active = function()
					-- if vim.bo.filetype == "snacks_dashboard" then
					-- 	return MiniStatusline.combine_groups({
					-- 		{ hl = "MiniStatuslineDashboard", strings = { mode } },
					-- 	})
					-- end
					local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
					local git = MiniStatusline.section_git({ trunc_width = 40 })
					local diff = MiniStatusline.section_diff({ trunc_width = 75 })
					local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
					local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
					local filename = custom_section_filename({ trunc_width = 140 })
					local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
					local location = MiniStatusline.section_location({ trunc_width = 75 })
					local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
					local mode_status = require("noice").api.status.mode.get()

					return MiniStatusline.combine_groups({
						{ hl = mode_hl, strings = { mode } },
						{ hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
						"%<", -- Mark general truncate point
						{ hl = "MiniStatuslinePathName", strings = { filename } },
						"%=", -- End left alignment
						{ hl = "MiniStatuslineRecording", strings = { mode_status } },
						{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
						{ hl = mode_hl, strings = { search, location } },
					})
				end,
				inactive = nil,
			},
			use_icons = true,
			set_vim_settings = true,
		})
	end,
}
