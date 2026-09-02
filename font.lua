return {
    configure = function(config)
        local wezterm = require 'wezterm'
        config.font_size = 14
        config.font = wezterm.font("MesloLGS Nerd Font Mono")
    end
}
