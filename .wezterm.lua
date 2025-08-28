local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- For example, changing the initial geometry for new windows:
config.initial_rows = 100
config.initial_cols = 205

-- change default login shell
config.default_prog = { "/opt/homebrew/bin/nu" }

config.term = "xterm-256color"

config.font_size = 15
config.line_height = 1.2
config.font = wezterm.font_with_fallback({
	{
		family = "Operator Mono Lig",
		scale = 1,
		weight = "Medium",
		-- harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
	},
	{ family = "Hack Nerd Font", scale = 1, weight = "Bold" },
})

config.keys = {
	{
		key = "Enter",
		mods = "CMD",
		action = wezterm.action.ToggleFullScreen,
	},
}

-- dont use the stupid MacOS Spaces and start the rows below the stupid notch
config.native_macos_fullscreen_mode = false
config.macos_fullscreen_extend_behind_notch = false

config.allow_square_glyphs_to_overflow_width = "Always" -- or consider "Always"

config.colors = {
	tab_bar = {
		active_tab = {
			bg_color = "#1E1E2E", -- Example background color
			fg_color = "#f8f8f2", -- Example foreground color
		},
		-- You can also define colors for other tab states like:
		inactive_tab = {
			bg_color = "#000000",
			fg_color = "#000000",
		},
		inactive_tab_hover = {
			bg_color = "#1E1E2E", -- Example background color
			fg_color = "#f8f8f2", -- Example foreground color
		},
		-- new_tab = { ... },
		-- new_tab_hover = { ... },
	},
}

-- color_scheme
config.color_scheme = "Catppuccin Mocha"

config.hide_tab_bar_if_only_one_tab = true

-- This will place the window management buttons (minimize, maximize, close)
-- into the tab bar instead of showing a separate title bar.
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_background_opacity = 1

-- Ensure the tab bar is displayed.
config.tab_max_width = 999
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false

function GET_MAX_COLS(window)
	local tab = window:active_tab()
	local cols = tab:get_size().cols
	return cols
end

wezterm.on("window-config-reloaded", function(window)
	wezterm.GLOBAL.cols = GET_MAX_COLS(window)
end)

wezterm.on("window-resized", function(window)
	wezterm.GLOBAL.cols = GET_MAX_COLS(window)
end)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = tab.active_pane.title
	local full_title = "[" .. tab.tab_index + 1 .. "] " .. title
	local pad_length = (wezterm.GLOBAL.cols // #tabs - #full_title) // 2
	if pad_length * 2 + #full_title > max_width then
		pad_length = (max_width - #full_title) // 2
	end
	return string.rep(" ", pad_length) .. full_title .. string.rep(" ", pad_length)
end)

-- Optional: If you want tabs to stretch to fill the entire tab bar area.
-- config.stretch_tabs_to_fill_bar = true

-- Optional: Adjust window frame borders for a more integrated look.
-- You can customize colors to match your theme.
config.window_frame = {
	-- border_left_width = "1px",
	-- border_right_width = "1px",
	-- border_bottom_height = "1px",
	border_top_height = "30px", -- Set to 0 to remove the top border and integrate tabs fully.
	border_left_color = "#1E1E2E",
	border_right_color = "#1E1E2E",
	border_bottom_color = "#1E1E2E",
	border_top_color = "#1E1E2E",
}

-- Finally, return the configuration to wezterm:
return config
