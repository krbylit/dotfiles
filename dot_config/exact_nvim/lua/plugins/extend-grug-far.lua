return {
    "MagicDuck/grug-far.nvim",
    keys = function(_, keys)
        local which_key = require("which-key")
        local ext_keys = {
            -- Disable LazyVim mapping first, since we extend those mappings.
            { "<leader>sr", false },
            which_key.add({
                {
                    "<leader>sf",
                    function()
                        require("grug-far").open({
                            prefills = {
                                flags = "--pcre2",
                                paths = vim.fn.expand("%:p"),
                            },
                        })
                    end,
                    desc = "Search and replace in buffer",
                    mode = { "n" },
                    silent = true,
                    remap = false,
                },
                {
                    "<leader>sv",
                    function()
                        local selection = require("grug-far").get_current_visual_selection_as_range_str()
                        require("grug-far").open({
                            prefills = {
                                flags = "--pcre2",
                                paths = selection,
                            },
                        })
                    end,
                    desc = "Search and replace in selection",
                    mode = { "v" },
                    silent = true,
                    remap = false,
                },
                {
                    "<leader>sr",
                    function()
                        local grug = require("grug-far")
                        local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
                        grug.open({
                            transient = true,
                            prefills = {
                                filesFilter = ext and ext ~= "" and "*." .. ext or nil,
                                flags = "--pcre2",
                            },
                        })
                    end,
                    mode = { "n", "v" },
                    desc = "Search and Replace",
                },
            }),
        }
        keys = vim.tbl_deep_extend("force", keys or {}, ext_keys)
        return keys
    end,
}
