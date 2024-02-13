local wezterm = require("wezterm")

local colorscheme_name = "Material Lighter"

local home = os.getenv("HOME")
-- local scheme = wezterm.color.get_builtin_schemes()[colorscheme_name]
local launch_menu = {}
local default_prog = {}
local environment_variables = {}
local font_size = 0

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	table.insert(launch_menu, {
		label = "PowerShell 7",
		args = { "C:/Program Files/PowerShell/7/pwsh.exe", "-NoProfileLoadTime" },
	})

	table.insert(launch_menu, {
		label = "PowerShell",
		args = { "powershell.exe", "-NoLogo" },
	})

	table.insert(launch_menu, {
		label = "Nihingo Yet Another GOing Shell",
		args = { "nyagos.exe" },
	})

	-- environment_variables = {
	--   ComSpec = "C:/Program Files/PowerShell/7/pwsh.exe",
	-- }
	--
	home = os.getenv("USERPROFILE")

	default_prog = { "C:/Program Files/PowerShell/7/pwsh.exe", "-NoProfileLoadTime" }

	font_size = 11.0
elseif wezterm.target_triple == "aarch64-apple-darwin" or wezterm.target_triple == "x86_64-apple-darwin" then
	table.insert(launch_menu, {
		label = "Fish",
		args = { "/opt/homebrew/bin/fish", "-l" },
	})

	environment_variables = {
		SHELL = "/opt/homebrew/bin/fish",
	}

	default_prog = { "/opt/homebrew/bin/fish", "-l" }

	font_size = 14.0
else
	environment_variables = {
		SHELL = "/usr/bin/fish",
	}

	default_prog = { "/usr/bin/fish", "-l" }

	table.insert(launch_menu, {
		label = "Fish",
		args = { "/usr/bin/fish", "-l" },
	})

	font_size = 12.0
end

local scheme, _ = wezterm.color.load_scheme(home .. "/.config/wezterm/colors/material-lighter.toml")

local keys = {
	{ key = "l", mods = "META", action = wezterm.action.ShowLauncher },
	{ key = "t", mods = "META", action = wezterm.action.ShowTabNavigator },
	{ key = "s", mods = "META", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "v", mods = "META", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "h", mods = "SHIFT|META", action = wezterm.action.MoveTabRelative(-1) },
	{ key = "l", mods = "SHIFT|META", action = wezterm.action.MoveTabRelative(1) },
}

for i = 1, 9 do
	table.insert(keys, {
		key = tostring(i),
		mods = "META",
		action = wezterm.action({ ActivateTab = i - 1 }),
	})
end

-- Tab Bar Config {{{

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = ""

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = ""

wezterm.on("update-status", function(window, pane)
	local background = scheme.tab_bar.active_tab.bg_color
	local foreground = scheme.tab_bar.active_tab.fg_color
	local edge_background = scheme.tab_bar.background
	local edge_foreground = background
	local red_foreground = scheme.ansi[2]
	local green_foreground = scheme.ansi[4]

	-- "Wed Mar 3 08:14"
	local date = "  " .. wezterm.strftime("%a %b %-d %H:%M ")

	local battery_foreground = foreground
	local bat = ""
	for _, b in ipairs(wezterm.battery_info()) do
		local battery_icon = ""
		-- wezterm.log_info(b.state);

		if b.state == "Charging" or b.state == "Full" then
			if b.state_of_charge <= 0.1 then
				battery_icon = "󰢜"
			elseif b.state_of_charge <= 0.2 then
				battery_icon = "󰂆"
			elseif b.state_of_charge <= 0.3 then
				battery_icon = "󰂇"
			elseif b.state_of_charge <= 0.4 then
				battery_icon = "󰂈"
			elseif b.state_of_charge <= 0.5 then
				battery_icon = "󰢝"
			elseif b.state_of_charge <= 0.6 then
				battery_icon = "󰂉"
			elseif b.state_of_charge <= 0.7 then
				battery_icon = "󰢞"
			elseif b.state_of_charge <= 0.8 then
				battery_icon = "󰂊"
			elseif b.state_of_charge <= 0.9 then
				battery_icon = "󰂋"
			elseif b.state_of_charge <= 1.0 then
				battery_icon = "󰂅"
			end
		else
			if b.state_of_charge <= 0.1 then
				battery_icon = "󰁺"
			elseif b.state_of_charge <= 0.2 then
				battery_icon = "󰁻"
			elseif b.state_of_charge <= 0.3 then
				battery_icon = "󰁼"
			elseif b.state_of_charge <= 0.4 then
				battery_icon = "󰁽"
			elseif b.state_of_charge <= 0.5 then
				battery_icon = "󰁾"
			elseif b.state_of_charge <= 0.6 then
				battery_icon = "󰁿"
			elseif b.state_of_charge <= 0.7 then
				battery_icon = "󰂀"
			elseif b.state_of_charge <= 0.8 then
				battery_icon = "󰂁"
			elseif b.state_of_charge <= 0.9 then
				battery_icon = "󰂂"
			elseif b.state_of_charge <= 1.0 then
				battery_icon = "󰁹"
			end
		end
		bat = battery_icon .. " " .. string.format("%.0f%%", b.state_of_charge * 100)

		if b.state_of_charge < 0.15 then
			battery_foreground = red_foreground
		end

		if b.state == "Charging" then
			battery_foreground = green_foreground
		end
	end

	local status = {}

	if bat ~= "" then
		local t = {
			{ Background = { Color = edge_background } },
			{ Foreground = { Color = edge_foreground } },
			{ Text = SOLID_LEFT_ARROW },
			{ Background = { Color = background } },
			{ Foreground = { Color = battery_foreground } },
			{ Text = bat },
			{ Background = { Color = edge_background } },
			{ Foreground = { Color = edge_foreground } },
			{ Text = SOLID_RIGHT_ARROW },
		}
		for _, v in ipairs(t) do
			table.insert(status, v)
		end
	end

	local t = {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = date },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
	}

	for _, v in ipairs(t) do
		table.insert(status, v)
	end

	window:set_right_status(wezterm.format(status))
end)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	wezterm.log_info(config)
	local edge_background = scheme.tab_bar.background
	local background = scheme.tab_bar.inactive_tab.bg_color
	local foreground = scheme.tab_bar.inactive_tab.fg_color

	if tab.is_active then
		background = scheme.tab_bar.active_tab.bg_color
		foreground = scheme.tab_bar.active_tab.fg_color
	elseif hover then
		background = scheme.tab_bar.new_tab_hover.bg_color
		foreground = scheme.tab_bar.new_tab_hover.fg_color
	end

	local edge_foreground = background

	-- ensure that the titles fit in the available space,
	-- and that we have room for the edges.
	local title = (tonumber(tab.tab_index) + 1) .. " " .. wezterm.truncate_right(tab.active_pane.title, max_width - 4)

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end)
-- }}}

return {
	default_prog = default_prog,
	set_environment_variables = environment_variables,
	window_background_opacity = 1.00,
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	front_end = "WebGpu",
	webgpu_power_preference = "HighPerformance",
	--  font = wezterm.font("PlemolJP Console NF"),
	--  font = wezterm.font("Cica"),
	font = wezterm.font("UDEV Gothic NF"),
	font_size = font_size,
	color_scheme_dirs = { "~/.config/wezterm/colors" },
	color_scheme = colorscheme_name,
	launch_menu = launch_menu,
	keys = keys,
	use_fancy_tab_bar = false,
	tab_bar_style = {
		new_tab = wezterm.format({
			{ Background = { Color = scheme.tab_bar.background } },
			{ Foreground = { Color = scheme.tab_bar.new_tab.bg_color } },
			{ Text = SOLID_LEFT_ARROW },
			{ Background = { Color = scheme.tab_bar.new_tab.bg_color } },
			{ Foreground = { Color = scheme.tab_bar.new_tab.fg_color } },
			{ Text = "+" },
			{ Background = { Color = scheme.tab_bar.background } },
			{ Foreground = { Color = scheme.tab_bar.new_tab.bg_color } },
			{ Text = SOLID_RIGHT_ARROW },
		}),
		new_tab_hover = wezterm.format({
			{ Background = { Color = scheme.tab_bar.background } },
			{ Foreground = { Color = scheme.tab_bar.new_tab_hover.bg_color } },
			{ Text = SOLID_LEFT_ARROW },
			{ Background = { Color = scheme.tab_bar.new_tab_hover.bg_color } },
			{ Foreground = { Color = scheme.tab_bar.new_tab_hover.fg_color } },
			{ Text = "+" },
			{ Background = { Color = scheme.tab_bar.background } },
			{ Foreground = { Color = scheme.tab_bar.new_tab_hover.bg_color } },
			{ Text = SOLID_RIGHT_ARROW },
		}),
	},
}
