-- NvimSnapshot command — prints core Neovim metrics for diagnostics

local function snapshot()
  local n_maps = #vim.api.nvim_get_keymap("n")
  local n_autocmds = #vim.api.nvim_get_autocmds({})
  local mem_kb = collectgarbage("count")
  local active_lsp = #vim.lsp.get_clients()
  local diagnostics = 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    diagnostics = diagnostics + #vim.diagnostic.get(buf)
  end

  local open_bufs = vim.api.nvim_list_bufs()
  local win_count = #vim.api.nvim_list_wins()
  local tab_count = #vim.api.nvim_list_tabpages()

  local buf_lines = { "buf # │ name                               │ listed │ loaded │ filetype" }
  for _, buf in ipairs(open_bufs) do
    local name = vim.api.nvim_buf_get_name(buf)
    local short = vim.fn.fnamemodify(name, ":~:.")
    local listed = vim.api.nvim_get_option_value("buflisted", { buf = buf })
    local loaded = vim.api.nvim_buf_is_loaded(buf)
    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
    table.insert(
      buf_lines,
      string.format(
        "%5d │ %-34s │ %-6s │ %-6s │ %s",
        buf,
        short:sub(1, 34),
        tostring(listed),
        tostring(loaded),
        ft
      )
    )
  end

  local header = (
    "Neovim State:\n"
    .. ("Keymaps: %d | Autocmds: %d | Mem: %.1f KB\n"):format(n_maps, n_autocmds, mem_kb)
    .. ("LSP clients: %d | Diags: %d | Buftotal: %d | Wins: %d | Tabs: %d\n\n"):format(
      active_lsp,
      diagnostics,
      #open_bufs,
      win_count,
      tab_count
    )
  )

  vim.notify(header .. table.concat(buf_lines, "\n"), vim.log.levels.INFO, { title = "Snapshot" })
end

vim.api.nvim_create_user_command("NvimSnapshot", snapshot, {})

return snapshot
