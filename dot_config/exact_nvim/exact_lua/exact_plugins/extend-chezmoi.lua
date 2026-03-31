if vim.env.IS_SSH == "1" then
  return { "xvzc/chezmoi.nvim", enabled = false }
end

-- Plugin to help editing chezmoi managed config files
-- https://github.com/xvzc/chezmoi.nvim

return {
  "xvzc/chezmoi.nvim",
  -- Lazy-load only when editing chezmoi files
  event = {
    "BufReadPre " .. os.getenv("HOME") .. "/.local/share/chezmoi/*",
    "BufNewFile " .. os.getenv("HOME") .. "/.local/share/chezmoi/*",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "alker0/chezmoi.vim",
    },
  },
  config = function(_, opts)
    local ext_opts = {
      -- NOTE: may help chezmoi hanging at times
      -- extra_args = { "--no-tty" },
      edit = {
        watch = false,
        force = false,
        -- Default ignore_patterns are preserved (run_onchange_*, run_once_*, etc.)
      },
      events = {
        on_open = {
          notification = {
            enable = false, -- Don't notify when opening chezmoi files
          },
        },
        on_watch = {
          notification = {
            enable = false, -- Don't notify when watch is enabled
          },
        },
        on_apply = {
          notification = {
            enable = true, -- Notify when changes are applied
          },
        },
      },
      telescope = {
        select = { "<CR>" },
      },
    }
    -- Register autocmd for chezmoi file watching (only when not in SSH)
    -- Runs when plugin loads (lazy-loaded), not at startup
    if vim.env.IS_SSH ~= "1" then
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = { vim.env.HOME .. "/.local/share/chezmoi/*" },
        callback = function(ev)
          require("chezmoi.commands.__edit").watch(ev.buf)
        end,
      })
    end
    -- Extend opts with ext_opts (merge LazyVim opts + our overrides)
    local merged_opts = vim.tbl_deep_extend("force", opts or {}, ext_opts)
    -- Setup plugin with merged opts (LazyVim defaults + our overrides)
    require("chezmoi").setup(merged_opts)
  end,
}
