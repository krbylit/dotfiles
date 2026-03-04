return {
  entry = function()
    -- local output = Command("lazydocker"):arg("info"):stderr(Command.PIPED):output()
    -- if output.stderr ~= "" then
    --   ya.notify({
    --     title = "lazydocker",
    --     content = "Lazydocker is not installed\nError: " .. output.stderr,
    --     level = "warn",
    --     timeout = 5,
    --   })
    -- else
    ya.manager_emit("shell", {
      "lazydocker",
      block = true,
      confirm = false,
    })
    -- end
  end,
}
