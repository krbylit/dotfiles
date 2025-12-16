return {
    "ibhagwan/fzf-lua",
    opts = {
        -- Highlight groups for path coloring
        hls = {
            dir_part = "Comment", -- Directory path (dimmed)
            file_part = "Normal", -- Filename (bright)
        },
        winopts = {
            -- split = "belowright new",
            split = "belowright vnew",
            -- preview = {
            -- hidden = "hidden", -- Start with the preview hidden
            -- layout = "flex", -- Optional: auto layout preview
            -- },
            preview = {
                -- default     = 'bat',           -- override the default previewer?
                -- default uses the 'builtin' previewer
                border = "rounded", -- preview border: accepts both `nvim_open_win`
                -- and fzf values (e.g. "border-top", "none")
                -- native fzf previewers (bat/cat/git/etc)
                -- can also be set to `fun(winopts, metadata)`
                wrap = true, -- preview line wrap (fzf's 'wrap|nowrap')
                hidden = false, -- start preview hidden
                vertical = "down:45%", -- up|down:size
                horizontal = "right:60%", -- right|left:size
                layout = "horizontal", -- horizontal|vertical|flex
                flip_columns = 10, -- #cols to switch to horizontal on flex
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
                },
            },
        },
        files = {
            -- find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
            rg_opts = [[--color=never --files --hidden --follow --pcre2 -g "!**/.git/**" -g "!**/node_modules/**" -g "!**/target/**" -g "!**/dist/**" -g "!**/build/**"]],
            fd_opts = [[--color=never --type f --hidden --follow --exclude .git --exclude node_modules --exclude target --exclude dist --exclude build]],
            formatter = "path.filename_first", -- VS Code style: filename first, then path
            cwd_prompt = true,
            cwd_prompt_shorten_len = 32, -- shorten prompt beyond this length
            cwd_prompt_shorten_val = 1, -- shortened path parts length
        },
        grep = {
            rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --pcre2 --glob=!**/node_modules/** --glob=!**/.git/** --glob=!**/target/** --glob=!**/dist/** --glob=!**/build/** --glob=!**/package-lock.json",
            -- Set to 'true' to always parse globs in both 'grep' and 'live_grep'
            -- search strings will be split using the 'glob_separator' and translated
            -- to '--iglob=' arguments, requires 'rg'
            -- can still be used when 'false' by calling 'live_grep_glob' directly
            rg_glob = true, -- default to glob parsing?
            glob_flag = "--iglob", -- for case sensitive globs use '--glob'
            glob_separator = "%s%-%-", -- query separator pattern (lua): ' --' e.g. `search term -- !build/*` to search excluding build/ dir etc.
        },
        keymap = {
            builtin = {
                true,
                ["<c-p>"] = "toggle-preview",
            },
        },
    },
    -- NOTE: not needed as we set globbing in opts above
    -- keys = {
    -- 	{ "<leader>/", LazyVim.pick("live_grep_glob"), desc = "Grep (Root Dir)" },
    -- 	{ "<leader>sg", LazyVim.pick("live_grep_glob"), desc = "Grep (Root Dir)" },
    -- 	{ "<leader>sG", LazyVim.pick("live_grep_glob", { root = false }), desc = "Grep (cwd)" },
    -- },
}
