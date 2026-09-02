local config = require 'wezterm'.config_builder()
config.font_size = 13

require 'colors'.configure(config)
require 'font'.configure(config)
require 'tab'.configure(config)
require 'window'.configure(config)
require 'keybinds'.configure(config)

return config
