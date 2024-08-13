-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "tokyonight_night"
config.font = wezterm.font("FiraCode Nerd Font", { weight = 'Medium' })
config.font_size = 14
config.hide_tab_bar_if_only_one_tab = true
config.freetype_load_flags = 'NO_HINTING'
-- and finally, return the configuration to wezterm
return config
