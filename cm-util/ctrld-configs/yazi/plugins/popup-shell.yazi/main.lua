-- popup-shell.yazi
-- A plugin to spawn an interactive fish shell in a "popup" by hiding yazi

return {
    entry = function()
        -- Hide Yazi and get a permit to control the terminal
        local permit = ya.hide()

        -- Spawn fish shell with inherited stdin/stdout/stderr for full interactivity
        local child, err = Command("fish")
            :env("IS_YAZI_SUBSHELL", "1")
            :stdin(Command.INHERIT)
            :stdout(Command.INHERIT)
            :stderr(Command.INHERIT)
            :spawn()

        if not child then
            ya.notify({
                title = "Failed to spawn fish shell",
                content = "Error: " .. tostring(err),
                level = "error",
                timeout = 5,
            })
            return
        end

        -- Wait for the shell to exit
        local status, err = child:wait()

        -- The permit will be automatically dropped when it goes out of scope,
        -- restoring Yazi's TUI display
    end,
}
