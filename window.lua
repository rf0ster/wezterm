return {
    configure = function(config)
        config.window_decorations = "RESIZE"
        config.window_background_opacity = 0.92
        config.macos_window_background_blur = 0

        config.window_padding = {
          left = '1cell',
          right = '1cell',
          top = '0.2cell',
          bottom = '0.2cell',
        }
        -- Set border style
        config.window_frame = {
            border_left_width = 0,
            border_right_width = 0,
            border_bottom_height = 0,
            border_top_height = 0,

            border_left_color = "#222",
            border_right_color = "#222",
            border_bottom_color = "#222",
            border_top_color = "#222",
        }
    end
}

