local filetypes = {
    { text = "markdown" },
    { text = "javascript" },
    { text = "python" },
    { text = "json" },
    { text = "yaml" },
    { text = "toml" },
    { text = "lua" },
    { text = "rust" },
    { text = "javascriptreact" },
    -- { text = "css" },
    -- { text = "go" },
    -- { text = "html" },
    -- { text = "odin" },
    -- { text = "typescript" },
    -- { text = "typescriptreact" },
    -- { text = "zig" },
}

return {
    "snacks.nvim",
    keys = {
        {
            "-",
            function()
                require("utils.snacks.scratch").new_scratch(filetypes)
            end,
            desc = "Toggle Scratch Buffer",
        },
        {
            "_",
            function()
                require("utils.snacks.scratch").select_scratch()
            end,
            desc = "Select Scratch Buffer",
        },
    },
}
