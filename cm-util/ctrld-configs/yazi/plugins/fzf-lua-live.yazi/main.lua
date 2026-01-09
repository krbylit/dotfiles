-- fzf-lua-live.yazi plugin
-- Interactive live grep search using fzf-lua's live_grep_native, then reveal the selected file in yazi

return {
	entry = function()
		-- Hide yazi UI before running interactive command
		local _permit = ya.hide()

		-- Get XDG_DATA_HOME or default to ~/.local/share
		local xdg_data_home = os.getenv("XDG_DATA_HOME") or os.getenv("HOME") .. "/.local/share"
		local fzf_lua_script = xdg_data_home .. "/nvim/lazy/fzf-lua/scripts/cli.lua"

		-- Build the command: nvim -l <script> live_grep_native search=<query>
		-- We'll pass an empty search query initially (user will type in fzf-lua)
		local cmd_args = {
			"-l",
			fzf_lua_script,
			"live_grep_native",
			"search=",
		}

		-- Run the fzf-lua live grep command
		-- Only pipe stdout, let stderr through for fzf UI
		local child, err = Command("nvim"):args(cmd_args):stdout(Command.PIPED):spawn()

		if not child then
			ya.notify({
				title = "FZF-Lua Live Grep",
				content = "Failed to spawn nvim fzf-lua: " .. tostring(err),
				level = "error",
				timeout = 5,
			})
			return
		end

		-- Wait for the command to complete
		local output, err = child:wait_with_output()

		if not output then
			ya.notify({
				title = "FZF-Lua Live Grep",
				content = "Failed to get output: " .. tostring(err),
				level = "error",
				timeout = 5,
			})
			return
		end

		-- Get the file path from stdout and trim whitespace
		local file_path = output.stdout:gsub("^%s*(.-)%s*$", "%1")

		-- Check if we got a valid file path (user might have cancelled)
		if file_path == "" or not output.status.success then
			-- Silent return - cancellation is normal
			return
		end

		-- Reveal the file in yazi
		ya.mgr_emit("reveal", { file_path })
	end,
}
