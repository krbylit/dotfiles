return {
  "suliatis/Jumppack.nvim",
  opts = {
    options = {
      -- Override default <C-o>/<C-i> with Jumppack interface
      global_mappings = true,

      -- Only show jumps within current working directory
      cwd_only = false,

      -- Wrap around edges when navigating jumplist
      wrap_edges = true,

      -- Default view mode ('list' or 'preview')
      default_view = "preview",
    },

    mappings = {
      -- Navigation
      jump_back = "<C-o>", -- Navigate backward in jumplist
      jump_forward = "<C-i>", -- Navigate forward in jumplist

      -- Selection
      choose = "<CR>", -- Jump to selected location
      choose_in_split = "<C-s>", -- Open in horizontal split
      choose_in_vsplit = "<C-v>", -- Open in vertical split
      choose_in_tabpage = "<C-t>", -- Open in new tab

      -- Control
      stop = "<Esc>", -- Close picker
      toggle_preview = "p", -- Toggle between list and preview modes

      -- Filtering (temporary filters, reset when picker closes)
      toggle_file_filter = "f", -- Show only jumps in current file
      toggle_cwd_filter = "c", -- Show only jumps in current working directory
      toggle_show_hidden = ".", -- Toggle visibility of hidden items
      reset_filters = "r", -- Clear all active filters

      -- Hide management
      toggle_hidden = "x", -- Hide/unhide current item
    },
    window = {
      -- Floating window configuration
      -- Can be a table or function returning a table
      config = function()
        local height = math.floor(vim.o.lines * 0.5)
        local width = math.floor(vim.o.columns * 0.6)
        return {
          relative = "editor",
          row = math.floor((vim.o.lines - height) / 2),
          col = math.floor((vim.o.columns - width) / 2),
          width = width,
          height = height,
          border = "rounded",
          title = " Jumplist ",
          title_pos = "center",
        }
      end,
    },
  },
}
