local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Dracula"
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 13

config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 10,
}

config.initial_rows = 40
config.initial_cols = 90
config.window_background_opacity = 0.93
config.macos_window_background_blur = 5

return config
