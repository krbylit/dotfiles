-- fzf-lua-git-commits.yazi plugin
-- Interactive git commit search using fzf-lua's git_commits, then reveal the selected commit in yazi

return {
  entry = function()
    local _permit = ui.hide()

    local xdg_data_home = os.getenv("XDG_DATA_HOME") or os.getenv("HOME") .. "/.local/share"
    local fzf_lua_script = xdg_data_home .. "/nvim/lazy/fzf-lua/scripts/cli.lua"

    local child, err = Command("nvim")
      :arg("-l")
      :arg(fzf_lua_script)
      :arg("git_commits")
      :stdin(Command.INHERIT)
      :stdout(Command.PIPED)
      :stderr(Command.INHERIT)
      :spawn()

    if not child then
      ya.notify({
        title = "FZF-Lua Git Commits",
        content = "Failed to spawn nvim fzf-lua: " .. tostring(err),
        level = "error",
        timeout = 5,
      })
      return
    end

    local output, err = child:wait_with_output()

    if not output then
      ya.notify({
        title = "FZF-Lua Git Commits",
        content = "Failed to get output: " .. tostring(err),
        level = "error",
        timeout = 5,
      })
      return
    end

    local result = output.stdout:gsub("^%s*(.-)%s*$", "%1")

    if result == "" or not output.status.success then
      return
    end

    ya.mgr_emit("reveal", { result })
  end,
}
