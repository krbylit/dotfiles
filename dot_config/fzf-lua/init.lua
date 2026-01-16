-- fzf-lua CLI-only configuration
-- This config is used ONLY when running fzf-lua from the command line
-- via: nvim -l "$XDG_DATA_HOME/nvim/lazy/fzf-lua/scripts/cli.lua"
--
-- Neovim plugin uses: ~/.config/nvim/lua/plugins/extend-fzf-lua.lua

require("fzf-lua").setup({
  { "cli" }, -- inherit cli profile

  -- Configure fzf options for preview window positioning
  -- fzf_opts = {
  --     ["--preview-window"] = "right:50%:border-left",
  --     ["--layout"] = "reverse",
  -- },
  fzf_opts = {
    -- ["--tmux"] = false,
    ["--border"] = "horizontal",
    ["--height"] = "80%",
    ["--ansi"] = true, -- Enable ANSI color codes from fd/rg
    -- ["--border-label-pos"] = "4:bottom",
    -- ["--border"] = os.getenv("TMUX") and "rounded" or "horizontal",
  },

  -- Highlight groups for path coloring
  hls = {
    dir_part = "Comment", -- Directory path (dimmed)
    file_part = "Normal", -- Filename (bright)
    -- Required fzf field for CLI mode
    fzf = {
      -- placeholder setting
      -- ["gutter"] = "-1",
    },
  },

  winopts = {
    -- split = "belowright new",
    split = "belowright vnew",
    -- fullscreen = true,
    border = "rounded",
    preview = {
      default = "bat", -- override the default previewer?
      -- default uses the 'builtin' previewer
      border = "rounded", -- preview border: accepts both `nvim_open_win`
      -- and fzf values (e.g. "border-top", "none")
      -- native fzf previewers (bat/cat/git/etc)
      -- can also be set to `fun(winopts, metadata)`
      wrap = true, -- preview line wrap (fzf's 'wrap|nowrap')
      hidden = false, -- start preview hidden
      vertical = "down:45%", -- up|down:size
      horizontal = "right:45%", -- right|left:size
      layout = "horizontal", -- horizontal|vertical|flex
      flip_columns = 100, -- #cols to switch to horizontal on flex
      -- Only used with the builtin previewer:
      title = true, -- preview border title (file/buf)?
      title_pos = "center", -- left|center|right, title alignment
      scrollbar = "float", -- `false` or string:'float|border'
      -- float:  in-window floating border
      -- border: in-border "block" marker
      scrolloff = -1, -- float scrollbar offset from right
      -- applies only when scrollbar = 'float'
      delay = 20, -- delay(ms) displaying the preview
      -- prevents lag on fast scrolling
      winopts = { -- builtin previewer window options
        number = true,
        relativenumber = false,
        cursorline = true,
        cursorlineopt = "both",
        cursorcolumn = false,
        signcolumn = "no",
        list = false,
        foldenable = false,
        foldmethod = "manual",
        scrolloff = -1,
        winblend = 0,
      },
    },
  },
  -- Files picker configuration
  files = {
    rg_opts = [[--color=always --files --hidden --follow --pcre2 -g "!**/.git/**" -g "!**/node_modules/**" -g "!**/target/**" -g "!**/.venv/**" -g "!**/virtual-env/**" -g "!**/dist/**" -g "!**/build/**"]],
    fd_opts = [[--color=always --type f --hidden --follow --exclude .git --exclude .venv --exclude virtual-env --exclude node_modules --exclude target --exclude dist --exclude build]],
    -- NOTE: using this removes colors from output list
    -- formatter = "path.filename_first", -- VS Code style: filename first, then path
    cwd_prompt = false,
    cwd_header = true,
    cwd_prompt_shorten_len = 32,
    cwd_prompt_shorten_val = 1,
    -- Disable icons for CLI usage (nvim-web-devicons not available)
    file_icons = false,
    git_icons = false,
    color_icons = false,
    hidden = true,
    no_ignore = true,
    follow = true, -- follow symlinks
    actions = {
      ["enter"] = function(selected, opts)
        if not selected[1] then
          return
        end
        -- Print selected file path(s) to stdout for shell insertion
        local paths = {}
        for _, item in ipairs(selected) do
          local file = require("fzf-lua").path.entry_to_file(item, opts)
          table.insert(paths, file.path)
        end
        local paths_str = table.concat(paths, " ")
        -- Print to stdout (will be captured by Fish keybinding)
        io.write(paths_str)
        io.flush()
        os.exit(0)
      end,
      ["ctrl-o"] = function(selected, opts)
        if not selected[1] then
          return
        end
        -- Build list of file paths from all selected items
        local files = {}
        for _, item in ipairs(selected) do
          local file = require("fzf-lua").path.entry_to_file(item, opts)
          table.insert(files, vim.fn.shellescape(file.path))
        end
        -- Open all selected files in nvim (as tabs)
        os.execute(string.format("nvim -p %s </dev/tty >/dev/tty", table.concat(files, " ")))
        os.exit(0)
      end,
    },
  },

  -- Live grep configuration
  grep = {
    rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --pcre2 --glob=!**/node_modules/** --glob=!**/.git/** --glob=!**/target/** --glob=!**/.venv/** --glob=!**/virtual_env/** --glob=!**/dist/** --glob=!**/build/** --glob=!**/package-lock.json",
    rg_glob = true,
    glob_flag = "--iglob",
    glob_separator = "%s%-%-",
    formatter = "path.filename_first", -- VS Code style: filename first, then path
    no_ignore = true,
    hidden = true,
    -- Disable icons for CLI usage
    file_icons = false,
    git_icons = false,
    actions = {
      ["enter"] = function(selected, opts)
        if not selected[1] then
          return
        end
        -- Print selected file path(s) to stdout for shell insertion
        local paths = {}
        for _, item in ipairs(selected) do
          local file = require("fzf-lua").path.entry_to_file(item, opts)
          table.insert(paths, file.path)
        end
        local paths_str = table.concat(paths, " ")
        -- Print to stdout (will be captured by Fish keybinding)
        io.write(paths_str)
        io.flush()
        os.exit(0)
      end,
      ["ctrl-o"] = function(selected, opts)
        if not selected[1] then
          return
        end
        -- Build list of file paths from all selected items
        local files = {}
        for _, item in ipairs(selected) do
          local file = require("fzf-lua").path.entry_to_file(item, opts)
          table.insert(files, vim.fn.shellescape(file.path))
        end
        -- Open all selected files in nvim (as tabs)
        os.execute(string.format("nvim -p %s </dev/tty >/dev/tty", table.concat(files, " ")))
        vim.cmd.qall()
      end,
    },
  },

  -- Git commits configuration
  git = {
    commits = {
      file_icons = false,
      git_icons = false,
      actions = {
        ["enter"] = function(selected)
          if not selected[1] then
            return
          end
          -- Extract commit hash (first field before space/colon)
          local commit_hash = selected[1]:match("^(%S+)")
          if commit_hash then
            -- Print to stdout (will be captured by Fish keybinding)
            io.write(commit_hash)
            io.flush()
            os.exit(0)
          end
        end,
        -- Default doesn't work because we exit nvim after yank
        -- ["ctrl-y"] = { fn = require("fzf-lua").actions.git_yank_commit, exec_silent = false },
        ["ctrl-y"] = function(selected)
          if not selected[1] then
            return
          end
          -- Extract commit hash (first field before space/colon)
          local commit_hash = selected[1]:match("^(%S+)")
          if commit_hash then
            -- Copy to system clipboard using printf (more reliable than echo -n)
            os.execute(string.format("printf '%%s' %s | pbcopy", vim.fn.shellescape(commit_hash)))
            print("Copied: " .. commit_hash)
          end
        end,
      },
    },
  },

  -- Keymaps
  keymap = {
    builtin = {
      ["<c-p>"] = "toggle-preview",
    },
    fzf = {
      ["ctrl-o"] = "accept", -- Make ctrl-o accept/open the file
    },
  },
})
