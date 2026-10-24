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
-- ~/.config/theme (latte|mocha) is the source of truth, written by
-- ~/.local/bin/theme. That script also re-themes tmux and announces the flavor
-- to every attached wezterm as a user var, which travels through ssh. Falls
-- back to the OS appearance when the file does not exist yet.
local HOME = os.getenv("HOME")
local SCHEMES = { latte = "Catppuccin Latte", mocha = "Catppuccin Mocha" }

local function read_flavor()
	local f = io.open(HOME .. "/.config/theme")
	if f then
		local s = f:read("*l")
		f:close()
		if SCHEMES[s] then
			return s
		end
	end
	local ok, appearance = pcall(function()
		return wezterm.gui.get_appearance()
	end)
	return (ok and appearance and appearance:find("Dark")) and "mocha" or "latte"
end

local function theme_overrides(flavor)
	local name = SCHEMES[flavor]
	local s = wezterm.color.get_builtin_schemes()[name]
	local tab_bar = s.tab_bar
	-- active tab blends into the pane, like the old hardcoded mocha values did
	tab_bar.active_tab = { bg_color = s.background, fg_color = s.foreground }
	return {
		color_scheme = name,
		colors = { tab_bar = tab_bar },
		window_frame = {
			border_top_height = "30px",
			border_left_color = s.background,
			border_right_color = s.background,
			border_bottom_color = s.background,
			border_top_color = s.background,
		},
	}
end

local function apply(flavor)
	for _, w in ipairs(wezterm.gui.gui_windows()) do
		w:set_config_overrides(theme_overrides(flavor))
	end
	wezterm.GLOBAL.theme = flavor
	-- keep this machine's file/tmux/nvim in step; idempotent, so no ping-pong
	wezterm.run_child_process({ HOME .. "/.local/bin/theme", flavor })
end
local initial = theme_overrides(read_flavor())
config.color_scheme = initial.color_scheme
config.colors = initial.colors
config.window_frame = initial.window_frame

wezterm.on("user-var-changed", function(window, pane, name, value)
	if name == "THEME" and SCHEMES[value] then
		apply(value)
	end
end)

-- CMD+SHIFT+T: inside tmux or ssh, forward Option+t so the tmux host drives and
-- tells us back; otherwise toggle locally.
wezterm.on("toggle-theme", function(window, pane)
	local proc = (pane:get_foreground_process_name() or ""):match("[^/]+$") or ""
	if proc == "tmux" or proc == "ssh" then
		window:perform_action(act.SendKey({ key = "t", mods = "ALT" }), pane)
	else
		local cur = wezterm.GLOBAL.theme or read_flavor()
		apply(cur == "mocha" and "latte" or "mocha")
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
