---@type LazySpec
return {
  "mikavilpas/yazi.nvim",
  enabled = vim.env.IS_SSH ~= "1",
  lazy = true,
  event = "VeryLazy",
  dependencies = {
    { "nvim-lua/plenary.nvim", lazy = true },
  },
  keys = {
    -- 👇 in this section, choose your own keymappings!
    {
      "<leader>E",
      mode = { "n", "v" },
      "<cmd>Yazi<cr>",
      desc = "Open yazi at the current file",
    },
    {
      -- Open in the current working directory
      "<leader>cw",
      "<cmd>Yazi cwd<cr>",
      desc = "Open the file manager in nvim's working directory",
    },
    {
      "<leader>e",
      "<cmd>Yazi toggle<cr>",
      desc = "Resume the last yazi session",
    },
  },
  ---@type YaziConfig | {}
  opts = {
    -- open visible splits and quickfix items as yazi tabs for easy navigation
    -- https://github.com/mikavilpas/yazi.nvim/pull/359
    open_multiple_tabs = true,
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = true,
    -- when yazi is closed with no file chosen, change the Neovim working
    -- directory to the directory that yazi was in before it was closed. Defaults
    -- to being off (`false`)
    change_neovim_cwd_on_close = true,
    -- - you can customize only some of the keymaps (not all of them)
    -- - you can opt out of all keymaps by setting `keymaps = false`
    keymaps = {
      show_help = "<f1>",
      open_file_in_vertical_split = "<c-v>",
      open_file_in_horizontal_split = "<c-x>",
      open_file_in_tab = "<c-t>",
      grep_in_directory = "<c-s>",
      replace_in_directory = "<c-g>",
      cycle_open_buffers = "<tab>",
      copy_relative_path_to_selected_files = "<c-y>",
      send_to_quickfix_list = "<c-q>",
      change_working_directory = "<c-\\>",
      open_and_pick_window = "<c-o>",
    },
    integrations = {
      grep_in_directory = function(directory)
        Snacks.picker.grep({ dirs = { directory } })
      end,
      grep_in_selected_files = function(selected_files)
        Snacks.picker.grep_buffers({ glob = selected_files })
      end,
      --
      -- --- Similarly, search and replace in the files in the directory
      -- replace_in_directory = function(directory)
      --   -- default: grug-far.nvim
      -- end,
      -- replace_in_selected_files = function(selected_files)
      --   -- default: grug-far.nvim
      -- end,
    },
    future_features = {
      -- use a file to store the last directory that yazi was in before it was
      -- closed. Defaults to `true`.
      use_cwd_file = true,

      -- use a new shell escaping implementation that is more robust and works
      -- on more platforms. Defaults to `true`. If set to `false`, the old
      -- shell escaping implementation will be used, which is less robust and
      -- may not work on all platforms.
      new_shell_escaping = true,
    },
  },
  -- 👇 if you use `open_for_directories=true`, this is recommended
  init = function()
    -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
    -- vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
}
