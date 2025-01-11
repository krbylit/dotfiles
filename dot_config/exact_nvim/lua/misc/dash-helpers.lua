-- Function to randomly select dashboard art
local dashboard_art = require("misc.dashboard-art")
math.randomseed(os.time())
local function select_random_logo(logo_table)
	if #logo_table == 0 then
		return ""
	end
	local index = math.random(#logo_table)
	return logo_table[index] -- Return a string
end
local function save_logo(logo)
	-- Remove trailing spaces and trailing blank lines
	logo = logo:gsub("[ \t]+$", ""):match("(.-)%s*\n*$")

	-- local file_path = vim.fn.expand("~/.config/nvim/lua/misc/nvim-logo.cat")
	local file_path = vim.fn.expand("/tmp/nvim-logo.cat")
	local file = io.open(file_path, "w") -- Open file for writing
	if file then
		file:write(logo) -- Write the logo string to the file
		file:close() -- Close the file
		local result = vim.fn.system({ "chmod", "777", file_path })
		if vim.v.shell_error ~= 0 then
			vim.notify("Failed to set permissions on " .. file_path .. ": " .. result, vim.log.levels.ERROR)
		end
		return file_path
	else
		vim.notify("Failed to save logo to " .. file_path)
	end
end
local function measure_logo_file(file_path)
	-- Open the file for reading
	local file = io.open(file_path, "r")
	if not file then
		vim.notify("Failed to read logo file: " .. file_path, vim.log.levels.ERROR)
		return 0, 0 -- Default to no width and height if the file cannot be read
	end

	-- Read all lines from the file
	local lines = {}
	for line in file:lines() do
		table.insert(lines, line)
	end
	file:close()

	-- Calculate the dimensions
	local width = 0
	for _, line in ipairs(lines) do
		width = math.max(width, vim.fn.strdisplaywidth(line)) -- Determine the widest line
	end

	-- Return the width and the number of lines (height)
	return width, #lines
end
local function measure_logo(logo)
	local lines = vim.split(logo, "\n") -- Split logo into lines
	local width = 0
	for _, line in ipairs(lines) do
		width = math.max(width, vim.fn.strdisplaywidth(line)) -- Longest line's display width
	end
	return width, #lines
end

local M = {
	measure_logo_file = measure_logo_file,
	measure_logo = measure_logo,
	random_logo = function()
		local logo = select_random_logo(dashboard_art)
		return logo
	end,
	random_logo_file = function()
		local path = save_logo(select_random_logo(dashboard_art))
		return path
	end,
}
return M
