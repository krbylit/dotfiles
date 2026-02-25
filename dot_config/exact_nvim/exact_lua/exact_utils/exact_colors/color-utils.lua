local M = {}

--- Open a scratch buffer showing color swatches for a flat table of {name = hex} pairs.
---@param title string
---@param color_table table<string, string>
function M.show_color_palette(title, color_table)
  local flat = {}
  local function collect(tbl, prefix)
    for k, v in pairs(tbl) do
      local key = prefix and (prefix .. "." .. k) or tostring(k)
      if type(v) == "table" then
        collect(v, key)
      elseif type(v) == "string" and v:match("^#%x%x%x%x%x%x$") then
        table.insert(flat, { key = key, hex = v })
      end
    end
  end
  collect(color_table, nil)
  table.sort(flat, function(a, b)
    return a.key < b.key
  end)

  local lines = {}
  local swatches = {}
  for _, entry in ipairs(flat) do
    table.insert(lines, string.format("██████  %-30s  %s", entry.key, entry.hex))
    table.insert(swatches, entry.hex)
  end

  vim.cmd("enew")
  local buf = vim.api.nvim_get_current_buf()
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.swapfile = false
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { title, "", unpack(lines) })

  local ns = vim.api.nvim_create_namespace("colorscheme_palette")
  for i, hex in ipairs(swatches) do
    local hl_name = "PaletteSwatch" .. i
    vim.api.nvim_set_hl(0, hl_name, { fg = hex })
    vim.api.nvim_buf_add_highlight(buf, ns, hl_name, i + 1, 0, 6) -- +1 for title + blank line
  end
  vim.bo.modifiable = false
end

--- Register palette viewer commands for installed colorschemes.
function M.setup()
  vim.api.nvim_create_user_command("TokyonightColors", function()
    local c = require("tokyonight.colors").setup()
    M.show_color_palette("Tokyonight Palette (" .. (c.style or "current") .. ")", c)
  end, { desc = "Show tokyonight color palette" })

  vim.api.nvim_create_user_command("CatppuccinColors", function(args)
    local flavour = args.args ~= "" and args.args or nil
    local palette = require("catppuccin.palettes").get_palette(flavour)
    M.show_color_palette("Catppuccin Palette (" .. (flavour or "current") .. ")", palette)
  end, {
    desc = "Show catppuccin color palette",
    nargs = "?",
    complete = function()
      return { "latte", "frappe", "macchiato", "mocha" }
    end,
  })

  vim.api.nvim_create_user_command("TeideColors", function()
    local c = require("teide.colors").setup(require("teide.config").extend())
    M.show_color_palette("Teide Palette", c)
  end, { desc = "Show teide color palette" })
end

return M
