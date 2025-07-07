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

-- file sort prefs by location
local pref_by_location = require("pref-by-location")
pref_by_location:setup({
    -- -- Disable this plugin completely.
    -- -- disabled = false -- true|false (Optional)
    --
    -- -- Hide "enable" and "disable" notifications.
    -- -- no_notify = false -- true|false (Optional)
    --
    -- -- You can backup/restore this file. But don't use same file in the different OS.
    -- -- save_path =  -- full path to save file (Optional)
    -- --       - Linux/MacOS: os.getenv("HOME") .. "/.config/yazi/pref-by-location"
    -- --       - Windows: os.getenv("APPDATA") .. "\\yazi\\config\\pref-by-location"
    --
    -- -- You don't have to set "prefs". Just use keymaps below work just fine
    -- prefs = { -- (Optional)
    --     -- location: String | Lua pattern (Required)
    --     --   - Support literals full path, lua pattern (string.match pattern): https://www.lua.org/pil/20.2.html
    --     --     And don't put ($) sign at the end of the location. %$ is ok.
    --     --   - If you want to use special characters (such as . * ? + [ ] ( ) ^ $ %) in "location"
    --     --     you need to escape them with a percent sign (%) or use a helper funtion `pref_by_location.is_literal_string`
    --     --     Example: "/home/test/Hello (Lua) [world]" => { location = "/home/test/Hello %(Lua%) %[world%]", ....}
    --     --     or { location = pref_by_location.is_literal_string("/home/test/Hello (Lua) [world]"), .....}
    --
    --     -- sort: {} (Optional) https://yazi-rs.github.io/docs/configuration/yazi#mgr.sort_by
    --     --   - extension: "none"|"mtime"|"btime"|"extension"|"alphabetical"|"natural"|"size"|"random", (Optional)
    --     --   - reverse: true|false (Optional)
    --     --   - dir_first: true|false (Optional)
    --     --   - translit: true|false (Optional)
    --     --   - sensitive: true|false (Optional)
    --
    --     -- linemode: "none" |"size" |"btime" |"mtime" |"permissions" |"owner" (Optional) https://yazi-rs.github.io/docs/configuration/yazi#mgr.linemode
    --     --   - Custom linemode also work. See the example below
    --
    --     -- show_hidden: true|false (Optional) https://yazi-rs.github.io/docs/configuration/yazi#mgr.show_hidden
    --
    --     -- Some examples:
    --     -- Match any folder which has path start with "/mnt/remote/". Example: /mnt/remote/child/child2
    --     { location = "^/mnt/remote/.*", sort = { "extension", reverse = false, dir_first = true, sensitive = false } },
    --     -- Match any folder with name "Downloads"
    --     { location = ".*/Downloads", sort = { "btime", reverse = true, dir_first = true }, linemode = "btime" },
    --     -- Match exact folder with absolute path "/home/test/Videos".
    --     -- Use helper function `pref_by_location.is_literal_string` to prevent the case where the path contains special characters
    --     {
    --         location = pref_by_location.is_literal_string("/home/test/Videos"),
    --         sort = { "btime", reverse = true, dir_first = true },
    --         linemode = "btime",
    --     },
    --
    --     -- show_hidden for any folder with name "secret"
    --     {
    --         location = ".*/secret",
    --         sort = { "natural", reverse = false, dir_first = true },
    --         linemode = "size",
    --         show_hidden = true,
    --     },
    --
    --     -- Custom linemode also work
    --     {
    --         location = ".*/abc",
    --         linemode = "size_and_mtime",
    --     },
    --     -- DO NOT ADD location = ".*". Which currently use your yazi.toml config as fallback.
    --     -- That mean if none of the saved perferences is matched, then it will use your config from yazi.toml.
    --     -- So change linemode, show_hidden, sort_xyz in yazi.toml instead.
    -- },
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
