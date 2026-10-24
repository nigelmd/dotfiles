local wezterm = require("wezterm")
local act = wezterm.action

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
	{ key = "Enter", mods = "CMD", action = act.ToggleFullScreen },
	-- toggle latte <-> mocha; see THEME section below
	{ key = "T", mods = "CMD|SHIFT", action = act.EmitEvent("toggle-theme") },
}

-- dont use the stupid MacOS Spaces and start the rows below the stupid notch
config.native_macos_fullscreen_mode = false
config.macos_fullscreen_extend_behind_notch = false

config.allow_square_glyphs_to_overflow_width = "Always" -- or consider "Always"

-- THEME ----------------------------------------------------------------------
-- ~/.config/theme (latte|mocha) is the single source of truth, written by
-- ~/.local/bin/theme. That script also re-themes tmux and announces the flavor
-- to every attached wezterm as a user var, which travels through ssh. This
-- config is re-evaluated whenever the file changes.
local HOME = os.getenv("HOME")
local THEME_FILE = HOME .. "/.config/theme"
local THEME_BIN = HOME .. "/.local/bin/theme"
local SCHEMES = { latte = "Catppuccin Latte", mocha = "Catppuccin Mocha" }

local function read_flavor()
	local f = io.open(THEME_FILE)
	local s = f and f:read("*l")
	if f then
		f:close()
	end
	return SCHEMES[s] and s or "mocha"
end

wezterm.add_to_config_reload_watch_list(THEME_FILE)
config.color_scheme = SCHEMES[read_flavor()]
local scheme = wezterm.color.get_builtin_schemes()[config.color_scheme]
-- the scheme's own tab bar, except the active tab blends into the pane
config.colors = { tab_bar = scheme.tab_bar }
config.colors.tab_bar.active_tab = { bg_color = scheme.background, fg_color = scheme.foreground }
config.window_frame = {
	border_top_height = "30px",
	border_left_color = scheme.background,
	border_right_color = scheme.background,
	border_bottom_color = scheme.background,
	border_top_color = scheme.background,
}

-- pcall: the script is missing until dotfiles are linked on this machine
local function run_theme(arg)
	pcall(wezterm.run_child_process, { THEME_BIN, arg })
end

-- tmux announced a flavor: write it through the script unless the file already
-- says so (stops ping-pong), then re-read the config. The explicit reload covers
-- the case where the file watch above does not fire.
wezterm.on("user-var-changed", function(window, pane, name, value)
	if name == "THEME" and SCHEMES[value] then
		if value ~= read_flavor() then
			run_theme(value)
		end
		wezterm.reload_configuration()
	end
end)

-- CMD+SHIFT+T: a pane carrying a THEME user var is attached to a tmux running
-- this system (local or over ssh), so forward Option+t and let it drive; else toggle here.
wezterm.on("toggle-theme", function(window, pane)
	if pane:get_user_vars().THEME then
		window:perform_action(act.SendKey({ key = "t", mods = "ALT" }), pane)
	else
		run_theme("toggle")
		wezterm.reload_configuration()
	end
end)
-------------------------------------------------------------------------------

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

-- Finally, return the configuration to wezterm:
return config
