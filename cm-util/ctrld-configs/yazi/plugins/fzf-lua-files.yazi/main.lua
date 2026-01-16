-- fzf-lua-files.yazi plugin
-- Interactive file search using fzf-lua's files, then reveal the selected file in yazi

return {
  entry = function()
    -- Hide yazi UI before running interactive command
    local _permit = ya.hide()

    -- Get XDG_DATA_HOME or default to ~/.local/share
    local xdg_data_home = os.getenv("XDG_DATA_HOME") or os.getenv("HOME") .. "/.local/share"
    local fzf_lua_script = xdg_data_home .. "/nvim/lazy/fzf-lua/scripts/cli.lua"

    -- Build the command: nvim -l <script> files
    -- Run the fzf-lua files command
    -- Only pipe stdout, let stderr and stdin through for fzf UI
    local child, err = Command("nvim")
      :arg("-l")
      :arg(fzf_lua_script)
      :arg("files")
      :stdin(Command.INHERIT)
      :stdout(Command.PIPED)
      :stderr(Command.INHERIT)
      :spawn()

    if not child then
      ya.notify({
        title = "FZF-Lua Files",
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
        title = "FZF-Lua Files",
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
