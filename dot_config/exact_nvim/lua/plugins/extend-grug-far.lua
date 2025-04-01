return {
    "MagicDuck/grug-far.nvim",
    keys = function(_, keys)
        local which_key = require("which-key")
        local ext_keys = {
            which_key.add({
                {
                    "<leader>sf",
                    function()
                        require("grug-far").open({ prefills = { paths = vim.fn.expand("%:p") } })
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
                        require("grug-far").open({ prefills = { paths = selection } })
                    end,
                    desc = "Search and replace in selection",
                    mode = { "v" },
                    silent = true,
                    remap = false,
                },
            }),
        }
        keys = vim.tbl_deep_extend("force", keys or {}, ext_keys)
        return keys
    end,
}
