-- Dynamically load all keymaps in `plugin-keymaps` directory

local M = {}

M.setup = function()
	-- Get the list of files in the plugin-keymaps directory
	local function get_files()
		local plugin_keymaps_dir = vim.fn.stdpath("config") .. "/lua/plugin-keymaps"
		local files = {}
		-- Get list of files
		for file, _ in vim.fs.dir(plugin_keymaps_dir) do
			local fname = vim.fs.basename(file)
			if fname ~= "init.lua" and fname ~= "template-maps.lua" and fname:match("%.lua$") then
				-- strip the .lua extension and insert into the files table
				local stripped_fname = fname:gsub("%.lua$", "")
				table.insert(files, stripped_fname)
			end
		end
		return files
	end

	-- Loop through each file and require it, then call its setup function
	for _, plugin in ipairs(get_files()) do
		local success, return_val = pcall(require, "plugin-keymaps/" .. plugin)
		if not success then
			vim.notify("Failed to load " .. plugin .. " ERROR: " .. return_val, vim.log.levels.ERROR)
		else
			if return_val.setup then
				return_val.setup()
			end
		end
	end
end

return M
