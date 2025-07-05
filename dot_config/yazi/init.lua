-- Load Yazi plugins
require("folder-rules"):setup()
require("searchjump"):setup({
    unmatch_fg = "#b2a496",
    match_str_fg = "#000000",
    match_str_bg = "#73AC3A",
    first_match_str_fg = "#000000",
    first_match_str_bg = "#73AC3A",
    lable_fg = "#EADFC8",
    lable_bg = "#BA603D",
    only_current = false, -- only search the current window
    show_search_in_statusbar = true,
    auto_exit_when_unmatch = true,
    enable_capital_lable = false,
    search_patterns = {}, -- demo:{"%.e%d+","s%d+e%d+"}
})

local config_dir = os.getenv("HOME") .. "/.config"
local starship_conf = config_dir .. "/yazi/yazi-starship.toml"
-- local starship_conf = config_dir .. "/starship.toml"
require("starship"):setup({ config_file = starship_conf })

-- Give Yazi a border
require("full-border"):setup({
    -- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
    type = ui.Border.ROUNDED,
})

-- Custom right-hand display of size and last modified time
function Linemode:size_and_mtime()
    local time = math.floor(self._file.cha.mtime or 0)
    if time == 0 then
        time = ""
    elseif os.date("%Y", time) == os.date("%Y") then
        time = os.date("%b %d %H:%M", time)
    else
        time = os.date("%b %d  %Y", time)
    end

    local size = self._file:size()
    return string.format("%s %s", size and ya.readable_size(size) or "-", time)
end

-- Add relative line numbers to relative-motions plugin
require("relative-motions"):setup({ show_numbers = "relative", show_motion = true, enter_mode = "first" })

-- bookmarks.yazi default config
require("bookmarks"):setup({
    last_directory = { enable = false, persist = false, mode = "dir" },
    persist = "none",
    desc_format = "full",
    file_pick_mode = "hover",
    custom_desc_input = false,
    notify = {
        enable = false,
        timeout = 1,
        message = {
            new = "New bookmark '<key>' -> '<folder>'",
            delete = "Deleted bookmark in '<key>'",
            delete_all = "Deleted all bookmarks",
        },
    },
})

-- FIXME: shell still not popping up for interactive use
require("custom-shell"):setup({
    history_path = "default",
    save_history = false,
})

-- Allows yanked files to be pasted into ANY open yazi session
require("session"):setup({
    sync_yanked = true,
})

-- projects.yazi, store and restore sessions
require("projects"):setup({
    save = {
        -- method = "yazi", -- yazi | lua
        method = "lua", -- yazi | lua
        yazi_load_event = "@projects-load", -- event name when loading projects in `yazi` method
        -- lua_save_path = "", -- path of saved file in `lua` method, comment out or assign explicitly
        -- default value:
        -- windows: "%APPDATA%/yazi/state/projects.json"
        -- unix: "~/.local/state/yazi/projects.json"
    },
    last = {
        update_after_save = true,
        update_after_load = true,
        -- NOTE: only works with `lua` save.method
        load_after_start = true,
    },
    merge = {
        event = "projects-merge",
        quit_after_merge = false,
    },
    event = {
        save = {
            enable = true,
            name = "project-saved",
        },
        load = {
            enable = true,
            name = "project-loaded",
        },
        delete = {
            enable = true,
            name = "project-deleted",
        },
        delete_all = {
            enable = true,
            name = "project-deleted-all",
        },
        merge = {
            enable = true,
            name = "project-merged",
        },
    },
    notify = {
        enable = true,
        title = "Projects",
        timeout = 3,
        level = "info",
    },
})

-- FIXME: the below replace searchjump with `fd`
-- -- default restore.yazi
-- require("restore"):setup({
--     -- Set the position for confirm and overwrite dialogs.
--     -- don't forget to set height: `h = xx`
--     -- https://yazi-rs.github.io/docs/plugins/utils/#ya.input
--     position = { "center", w = 70, h = 40 }, -- Optional
--
--     -- Show confirm dialog before restore.
--     -- NOTE: even if set this to false, overwrite dialog still pop up
--     show_confirm = true, -- Optional
--
--     -- colors for confirm and overwrite dialogs
--     theme = { -- Optional
--         -- Default using style from your flavor or theme.lua -> [confirm] -> title.
--         -- If you edit flavor or theme.lua you can add more style than just color.
--         -- Example in theme.lua -> [confirm]: title = { fg = "blue", bg = "green"  }
--         title = "blue", -- Optional. This valid has higher priority than flavor/theme.lua
--
--         -- Default using style from your flavor or theme.lua -> [confirm] -> content
--         -- Sample logic as title above
--         header = "green", -- Optional. This valid has higher priority than flavor/theme.lua
--
--         -- header color for overwrite dialog
--         -- Default using color "yellow"
--         header_warning = "yellow", -- Optional
--         -- Default using style from your flavor or theme.lua -> [confirm] -> list
--         -- Sample logic as title and header above
--         list_item = { odd = "blue", even = "blue" }, -- Optional. This valid has higher priority than flavor/theme.lua
--     },
-- })
--
-- -- default copy file contents
-- require("copy-file-contents"):setup({
--     append_char = "\n",
--     notification = true,
-- })
