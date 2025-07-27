-- Taken from: https://github.com/mcauley-penney/nvim/blob/main/lua/plugins/statuscol.lua

-- TODO: Don't show statuscolumn at all in Scratch buffer. Add util for detecting Scratch buffer based off our diagnostic disable logic, use here and in diagnostic disable
return {
    "luukvbaal/statuscol.nvim",
    -- condition = function()
    --     return tools.is_scratch_buffer()
    -- end,
    config = function()
        local builtin = require("statuscol.builtin")
        require("statuscol").setup({
            relculright = true,
            thousands = ",",
            ft_ignore = {
                "aerial",
                "help",
                "neo-tree",
                "toggleterm",
            },
            segments = {
                {
                    sign = {
                        namespace = { "diagnostic" },
                    },
                    condition = {
                        function()
                            -- return tools.is_scratch_buffer() or tools.diagnostics_available() or " "
                            return tools.diagnostics_available() or " "
                        end,
                    },
                },
                -- {
                --     text = { " " },
                -- },
                {
                    text = {
                        "%=",
                        function(args)
                            local mode = vim.fn.mode()
                            local normalized_mode = vim.fn.strtrans(mode):lower():gsub("%W", "")

                            -- case 1
                            if normalized_mode ~= "v" and vim.v.virtnum == 0 then
                                return builtin.lnumfunc(args)
                            end

                            if vim.v.virtnum < 0 then
                                return "-"
                            end

                            local line = builtin.lnumfunc(args)

                            if vim.v.virtnum > 0 then
                                local num_wraps = vim.api.nvim_win_text_height(args.win, {
                                    start_row = args.lnum - 1,
                                    end_row = args.lnum - 1,
                                })["all"] - 1

                                if vim.v.virtnum == num_wraps then
                                    line = "└"
                                else
                                    line = "├"
                                end
                            end

                            -- Highlight cases
                            if normalized_mode == "v" then
                                local pos_list = vim.fn.getregionpos(
                                    vim.fn.getpos("v"),
                                    vim.fn.getpos("."),
                                    { type = mode, eol = true }
                                )
                                local s_row, e_row = pos_list[1][1][2], pos_list[#pos_list][2][2]

                                if vim.v.lnum >= s_row and vim.v.lnum <= e_row then
                                    return tools.hl_str("CursorLineNr", line)
                                end
                            end

                            return vim.fn.line(".") == vim.v.lnum and tools.hl_str("CursorLineNr", line)
                                or tools.hl_str("LineNr", line)
                        end,
                        " ",
                    },
                    condition = {
                        function()
                            return vim.wo.number or vim.wo.relativenumber
                        end,
                    },
                },
                {
                    -- Diff signs
                    sign = {
                        namespace = { "MiniDiff" },
                        maxwidth = 1,
                        colwidth = 1,
                    },
                    -- condition = {
                    --     function()
                    --         return tools.is_scratch_buffer()
                    --     end,
                    -- },
                },
                -- FIX: Big lag when going over a marked line
                -- This may actually just be visual, but if we see slowdown this is a place to look.
                {
                    -- Mark signs
                    text = {
                        function(args)
                            return tools.get_mark_for_line(args.lnum) or " "
                        end,
                    },
                },
                -- {
                -- Blank space
                --     text = { " " },
                -- },
                {
                    -- Fold signs
                    text = { builtin.foldfunc },
                    click = "v:lua.ScFa",
                    -- FIX: With this condition check, segments are disabled always, not just scratch buffers.
                    -- condition = {
                    --     function()
                    --         return tools.is_scratch_buffer()
                    --     end,
                    -- },
                },
                {
                    text = { " " },
                    -- condition = {
                    --     function()
                    --         return tools.is_scratch_buffer()
                    --     end,
                    -- },
                },
                {
                    text = { " " },
                    -- condition = {
                    --     function()
                    --         return tools.is_scratch_buffer()
                    --     end,
                    -- },
                },
            },
        })
    end,
}
