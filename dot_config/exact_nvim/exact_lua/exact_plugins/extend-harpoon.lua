-- Highly configurable bookmarking plugin
-- https://github.com/ThePrimeagen/harpoon/tree/harpoon2

return {
  "ThePrimeagen/harpoon",
  enabled = vim.env.IS_SSH ~= "1",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = function()
    -- Generate a unique session ID once per nvim session
    local session_id = vim.fn.getpid() .. "_" .. os.time()

    return {
      ---@type HarpoonSettings
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = false, -- Don't save to disk on UI close
        key = function()
          -- Use session ID so all harpooned files in this session share one list
          return session_id
        end,
      },
      default = {
        -- Don't persist to disk - list resets when nvim quits
        encode = false,
      },
    }
  end,
  -- Override default keys so they don't show in our main which-key menu
  keys = function()
    local harpoon = require("harpoon")
    local keys = {
      {
        "<leader>H",
        function()
          harpoon:list():add()
        end,
        desc = "Harpoon File",
      },
      {
        "<C-n>",
        function()
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon Quick Menu",
      },
    }
    for i = 1, 5 do
      table.insert(keys, {
        "<C-" .. i .. ">",
        function()
          harpoon:list():select(i)
        end,
        desc = "Harpoon to File " .. i,
      })
    end
    return keys
  end,
}
