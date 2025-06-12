return {
    "sphamba/smear-cursor.nvim",

    opts = {
        -- default, range
        -- How fast the smear's head moves towards the target.
        -- 0: no movement, 1: instantaneous
        stiffness = 0.5, -- 0.6      [0, 1]
        -- How fast the smear's tail moves towards the target.
        -- 0: no movement, 1: instantaneous
        trailing_stiffness = 0.2, -- 0.3      [0, 1]
        -- How much the smear slows down when getting close to the target.
        -- < 0: less slowdown, > 0: more slowdown. Keep small, e.g. [-0.2, 0.2]
        -- NOTE: new update throws many errors with this setting
        -- slowdown_exponent = -0.1,
        -- Stop animating when the smear's tail is within this distance (in characters) from the target.
        -- Controls if middle points are closer to the head or the tail.
        -- < 1: closer to the tail, > 1: closer to the head
        trailing_exponent = 1,
        distance_stop_animating = 0.1, -- 0.1      > 0
        -- Attempt to hide the real cursor by drawing a character below it.
        hide_target_hack = true, -- true     boolean
        -- Maximum smear length
        max_length = 80,

        -- Sets animation framerate
        time_interval = 17, -- milliseconds

        -- After changing target position, wait before triggering animation.
        -- Useful if the target changes and rapidly comes back to its original position.
        -- E.g. when hitting a keybinding that triggers CmdlineEnter.
        -- Increase if the cursor makes weird jumps when hitting keys.
        delay_animation_start = 5, -- milliseconds

        -- List of filetypes where the plugin is disabled.
        filetypes_disabled = {},

        -- Smear cursor when entering or leaving command line mode
        smear_to_cmd = true,

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
