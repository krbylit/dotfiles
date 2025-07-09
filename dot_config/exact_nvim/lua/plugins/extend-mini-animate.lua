return {
    "echasnovski/mini.animate",
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
        },

        -- Vertical scroll
        scroll = {
            -- Whether to enable this animation
            enable = true,

            -- Timing of animation (how steps will progress in time)
            -- timing = --<function: linear animation, total 250ms>,

            -- Subscroll generator based on total scroll
            -- subscroll = --<function: implements equal scroll with at most 60 steps>,
        },

        -- Window resize
        resize = {
            -- Whether to enable this animation
            enable = true,

            -- Timing of animation (how steps will progress in time)
            -- timing = --<function: linear animation, total 250ms>,

            -- Subresize generator for all steps of resize animations
            -- subresize = --<function: implements equal linear steps>,
        },

        -- Window open
        open = {
            -- Whether to enable this animation
            enable = true,

            -- Timing of animation (how steps will progress in time)
            -- timing = --<function: linear animation, total 250ms>,

            -- Floating window config generator visualizing specific window
            -- winconfig = --<function: implements static window for 25 steps>,

            -- 'winblend' (window transparency) generator for floating window
            -- winblend = --<function: implements equal linear steps from 80 to 100>,
        },

        -- Window close
        close = {
            -- Whether to enable this animation
            enable = true,

            -- Timing of animation (how steps will progress in time)
            -- timing = --<function: linear animation, total 250ms>,

            -- Floating window config generator visualizing specific window
            -- winconfig = --<function: implements static window for 25 steps>,

            -- 'winblend' (window transparency) generator for floating window
            -- winblend = --<function: implements equal linear steps from 80 to 100>,
        },
    },
}
