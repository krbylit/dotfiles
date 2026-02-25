if vim.env.IS_SSH == "1" then
  return { "danilamihailov/beacon.nvim", enabled = false }
end

return {
  "danilamihailov/beacon.nvim",
  opts = {
    enabled = true, --- (boolean | fun():boolean) check if enabled
    lazy = false,
    speed = 3, --- integer speed at wich animation goes
    width = 80, --- integer width of the beacon window
    -- winblend = 70, --- integer starting transparency of beacon window :h winblend
    winblend = 20, --- integer starting transparency of beacon window :h winblend
    -- fps = 60, --- integer how smooth the animation going to be
    -- min_jump = 10, --- integer what is considered a jump. Number of lines
    fps = 60, --- integer how smooth the animation going to be
    min_jump = 5, --- integer what is considered a jump. Number of lines
    -- cursor_events = { "CursorMoved" }, -- table<string> what events trigger check for cursor moves
    cursor_events = { "FocusGained" }, -- table<string> what events trigger check for cursor moves
    -- window_events = { "WinEnter", "FocusGained" }, -- table<string> what events trigger cursor highlight
    window_events = { "FocusGained" }, -- table<string> what events trigger cursor highlight
    highlight = { bg = "white", ctermbg = 15 }, -- vim.api.keyset.highlight table passed to vim.api.nvim_set_hl
  },
}
