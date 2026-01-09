-- local is_not_single_window = function(win_id)
--     -- local tabpage_id = vim.api.nvim_win_get_tabpage(win_id)
--     -- return #vim.api.nvim_tabpage_list_wins(tabpage_id) > 1
--     return true
-- end
-- local animate = require("mini.animate")
return {
    "nvim-mini/mini.animate",
    
    -- enabled = false,
    version = "*",
    opts = {
        -- Cursor path
        -- NOTE: This can provide a nice minimal cursor trail if smear-cursor is slow/not working. Enabling the LazyExtra for some reason enables this as well as smear-cursor, but we'll disable for now since we have smear-cursor.
        cursor = {
            -- Whether to enable this animation
            enable = false,

            -- Timing of animation (how steps will progress in time)
            -- timing = --<function: linear animation, total 250ms>,

            -- Path generator for visualized cursor movement
            -- path = --<function: implements shortest line path no longer than 1000>,
            -- path = animate.gen_path.line(),
            -- path = animate.gen_path.walls(),
            -- path = animate.gen_path.spiral(),
            -- path = animate.gen_path.angle(),
        },

        -- Vertical scroll
        scroll = {
            -- Whether to enable this animation
            enable = true,

            -- Timing of animation (how steps will progress in time)
            -- timing = --<function: linear animation, total 250ms>,

            -- Subscroll generator based on total scroll
            -- subscroll = --<function: implements equal scroll with at most 60 steps>,
            -- subscroll = animate.gen_subscroll.equal({ max_output_steps = 60 }),
        },

        -- Window resize
        resize = {
            -- Whether to enable this animation
            enable = false,

            -- Timing of animation (how steps will progress in time)
            -- timing = --<function: linear animation, total 250ms>,

            -- Subresize generator for all steps of resize animations
            -- subresize = --<function: implements equal linear steps>,
        },

        -- Window open
        open = {
            -- Whether to enable this animation
            enable = false,

            -- Timing of animation (how steps will progress in time)
            -- timing = --<function: linear animation, total 250ms>,
            -- timing = animate.gen_timing.linear({ duration = 800, unit = "total" }),

            -- Floating window config generator visualizing specific window
            -- winconfig = --<function: implements static window for 25 steps>,
            -- winconfig = animate.gen_winconfig.wipe({
            --     -- predicate = is_not_single_window,
            --     direction = "from_edge",
            -- }),
            -- winconfig = animate.gen_winconfig.center({
            --     -- predicate = is_not_single_window,
            --     direction = "from_center",
            -- }),

            -- 'winblend' (window transparency) generator for floating window
            -- winblend = --<function: implements equal linear steps from 80 to 100>,
        },

        -- Window close
        close = {
            -- Whether to enable this animation
            enable = false,

            -- Timing of animation (how steps will progress in time)
            -- timing = --<function: linear animation, total 250ms>,
            -- timing = animate.gen_timing.linear({ duration = 800, unit = "total" }),

            -- Floating window config generator visualizing specific window
            -- winconfig = --<function: implements static window for 25 steps>,
            -- winconfig = animate.gen_winconfig.wipe({
            --     -- predicate = is_not_single_window,
            --     direction = "to_edge",
            -- }),
            -- winconfig = animate.gen_winconfig.center({
            --     -- predicate = is_not_single_window,
            --     direction = "to_center",
            -- }),

            -- 'winblend' (window transparency) generator for floating window
            -- winblend = --<function: implements equal linear steps from 80 to 100>,
        },
    },
}
