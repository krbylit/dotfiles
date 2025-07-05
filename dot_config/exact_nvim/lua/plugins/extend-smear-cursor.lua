return {
    "sphamba/smear-cursor.nvim",
    -- lazy = false,
    enabled = vim.env.IS_SSH ~= "1",

    opts = {
        -- default, range
        -- How fast the smear's head moves towards the target.
        -- 0: no movement, 1: instantaneous
        stiffness = 1, -- 0.6      [0, 1]

        -- Initial velocity factor in the direction opposite to the target
        -- anticipation = 0.1, -- 0.55,

        -- Velocity reduction over time. O: no reduction, 1: full reduction
        -- Adjust "bounciness" of smear, higher reduces overshoot, lower more elastic smear
        damping = 0.9, -- 0.65

        -- How fast the smear's tail moves towards the target.
        -- 0: no movement, 1: instantaneous
        trailing_stiffness = 0.1, -- 0.3      [0, 1]

        -- How much the smear slows down when getting close to the target.
        -- < 0: less slowdown, > 0: more slowdown. Keep small, e.g. [-0.2, 0.2]
        -- NOTE: setting this seems to cause minor performance issues
        -- slowdown_exponent = -0.1,

        -- Controls if middle points are closer to the head or the tail.
        -- < 1: closer to the tail, > 1: closer to the head
        trailing_exponent = 1,

        -- When to switch between rasterization methods
        -- max_slope_horizontal = 0, -- 0.5,
        -- min_slope_vertical = 0, -- 2,

        max_shade_no_matrix = 0, -- 0.75, -- 0: more overhangs, 1: more matrices
        matrix_pixel_threshold = 0, -- 0.7 -- 0: all pixels, 1: no pixel
        matrix_pixel_threshold_vertical_bar = 0.3, -- 0.3 -- 0: all pixels, 1: no pixel
        matrix_pixel_min_factor = 0, -- 0.5 -- 0: all pixels, 1: no pixel
        volume_reduction_exponent = 0.1, -- 0.3 -- 0: no reduction, 1: full reduction
        minimum_volume_factor = 0.1, -- 0.7 -- 0: no limit, 1: no reduction

        -- Stop animating when the smear's tail is within this distance (in characters) from the target.
        distance_stop_animating = 0.1, -- 0.1      > 0

        -- Set to `true` to prevent the smear from overlapping the target character, hiding it until the animation is over.
        never_draw_over_target = true,

        -- Attempt to hide the real cursor by drawing a character below it.
        -- Can be useful when not using `termguicolors`
        -- Do not set to `true` if `never_draw_over_target` is `false`.
        hide_target_hack = true, -- true     boolean

        -- Maximum smear length
        max_length = 120,

        -- Sets animation framerate
        time_interval = 60, -- milliseconds

        -- Smear cursor in insert mode.
        -- See also `vertical_bar_cursor_insert_mode` and `distance_stop_animating_vertical_bar`.
        smear_insert_mode = false,

        -- After changing target position, wait before triggering animation.
        -- Useful if the target changes and rapidly comes back to its original position.
        -- E.g. when hitting a keybinding that triggers CmdlineEnter.
        -- Increase if the cursor makes weird jumps when hitting keys.
        delay_animation_start = 5, -- milliseconds

        -- Amount of time the cursor has to stay still before triggering animation.
        -- Useful if the target changes and rapidly comes back to its original position.
        -- E.g. when hitting a keybinding that triggers CmdlineEnter.
        -- Increase if the cursor makes weird jumps when hitting keys.
        delay_event_to_smear = 1, -- milliseconds

        -- Disable smear in the current buffer if the animation is stuck for at least this amount of time.
        -- Set to nil to disable this feature.
        delay_disable = 500, -- milliseconds

        -- List of filetypes where the plugin is disabled.
        filetypes_disabled = {},

        -- Smear cursor when entering or leaving command line mode
        smear_to_cmd = false,

        -- Smear cursor when switching buffers or windows.
        smear_between_buffers = true,

        -- Smear cursor when moving within line or to neighbor lines.
        smear_between_neighbor_lines = true,

        -- Draw the smear in buffer space instead of screen space when scrolling
        scroll_buffer_space = true,

        -- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
        -- Smears will blend better on all backgrounds.
        -- NOTE: enabling this fixes issue where we'd see large opaque blocks around cursor when switching windows when multiple windows open
        legacy_computing_symbols_support = true,
        legacy_computing_symbols_support_vertical_bars = true,
    },
}
