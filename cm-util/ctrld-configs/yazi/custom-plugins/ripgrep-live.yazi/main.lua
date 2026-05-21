-- ripgrep-live.yazi plugin
-- Interactive ripgrep search with fzf, then reveal the selected file in yazi

return {
  entry = function()
    -- Hide yazi UI before running interactive command
    local _permit = ui.hide()

    -- Run the yazi_ripgrep Fish function using spawn (like fzf does)
    -- Only pipe stdout, let stderr through for fzf UI
    local child, err = Command("fish"):arg("-c"):arg("yazi_ripgrep"):stdout(Command.PIPED):spawn()

    if not child then
      ya.notify({
        title = "Ripgrep Live",
        content = "Failed to spawn yazi_ripgrep: " .. tostring(err),
        level = "error",
        timeout = 5,
      })
      return
    end

    -- Wait for the command to complete
    local output, err = child:wait_with_output()

    if not output then
      ya.notify({
        title = "Ripgrep Live",
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
