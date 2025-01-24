local M = {}

M.setup = function()
	local function get_lua_files(directory)
		local files = {}
		local config_path = vim.fn.stdpath("config")
		local full_path = config_path .. "/lua/" .. directory

		local function scan_dir(dir)
			for file, type in vim.fs.dir(dir) do
				local full_file_path = dir .. "/" .. file
				if type == "file" and file:match("%.lua$") and file ~= "init.lua" then
					local require_path = full_file_path:gsub(config_path .. "/lua/", ""):gsub("%.lua$", "")
					table.insert(files, require_path)
				elseif type == "directory" and file ~= "." and file ~= ".." then
					scan_dir(full_file_path)
				end
			end
		end

		scan_dir(full_path)
		return files
	end

	-- Load all modules in firenvim-config directory
	local modules = get_lua_files("firenvim-config")
	for _, module_path in ipairs(modules) do
		local success, module = pcall(require, module_path)
		if success then
			if module.setup then
				module.setup()
			end
		else
			vim.notify("Failed to load " .. module_path .. ": " .. module, vim.log.levels.ERROR)
		end
	end
end

return M
