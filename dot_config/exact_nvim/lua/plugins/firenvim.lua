---@type LazySpec
return {
    "glacambre/firenvim",
    build = ":call firenvim#install(0)",
    -- enabled = vim.env.IS_SSH ~= "1",
    enabled = false,
}
