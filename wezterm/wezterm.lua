local wezterm = require 'wezterm';

local launch_menu = {}
local default_prog = {}
local environment_variables = {}
local font_size = 0

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  table.insert(launch_menu, {
    label = "PowerShell 7",
    args = { "C:/Program Files/PowerShell/7/pwsh.exe", "-nologo" },
  })

  table.insert(launch_menu, {
    label = "PowerShell",
    args = { "powershell.exe", "-NoLogo" },
  })

  environment_variables = {
    ComSpec = "C:/Program Files/PowerShell/7/pwsh.exe",
  }

  -- default_prog = { "C:/Program Files/PowerShell/7/pwsh.exe", "-nologo" }

  font_size = 12.0
elseif wezterm.target_triple == "aarch64-apple-darwin" or wezterm.target_triple == "x86_64-apple-darwin" then
  table.insert(launch_menu, {
    label = "Fish",
    args = { "/opt/homebrew/bin/fish", "-l" }
  })

  environment_variables = {
    SHELL = "/opt/homebrew/bin/fish",
  }

  default_prog = { "/opt/homebrew/bin/fish", "-l" }

  font_size = 15.0
  --  default_prog = {"/opt/homebrew/bin/fish", "-l"}
else
  environment_variables = {
    SHELL = "/usr/bin/fish",
  }

  table.insert(launch_menu, {
    label = "Fish",
    args = { "/usr/bin/fish", "-l" }
  })
end

local keys = {
  { key = "l", mods = "ALT", action = "ShowLauncher" },
  { key = "t", mods = "ALT", action = "ShowTabNavigator" },
  { key = "v", mods = "ALT", action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = "s", mods = "ALT", action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
}

for i = 1, 9 do
  table.insert(keys, {
    key = tostring(i),
    mods = "ALT",
    action = wezterm.action { ActivateTab = i - 1 },
  })
end

-- Tab Bar Config {{{

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = ''

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = ''

wezterm.on("update-right-status", function(window, pane)
  local background = "#2d81a3"
  local foreground = "#e6ebf3"
  local edge_background = "#dbdbdb"
  local edge_foreground = background
  local red_foreground = "#b95d76"
  local green_foreground = "#618774"

  -- "Wed Mar 3 08:14"
  local date = "  " .. wezterm.strftime("%a %b %-d %H:%M ");

  local battery_foreground = foreground;
  local bat = ""
  for _, b in ipairs(wezterm.battery_info()) do
    local battery_icon = '';
    wezterm.log_info(b.state);
    if b.state == 'Charging' or b.state == 'Full' then
      if b.state_of_charge < 0.3 then
        battery_icon = '';
      elseif b.state_of_charge < 0.4 then
        battery_icon = '';
      elseif b.state_of_charge < 0.5 then
        battery_icon = '';
      elseif b.state_of_charge < 0.7 then
        battery_icon = '';
      elseif b.state_of_charge < 0.9 then
        battery_icon = '';
      elseif b.state_of_charge < 1.0 then
        battery_icon = '';
      elseif b.state_of_charge == 1.0 then
        battery_icon = '';
      end
    else
      if b.state_of_charge < 0.2 then
        battery_icon = '';
      elseif b.state_of_charge < 0.3 then
        battery_icon = '';
      elseif b.state_of_charge < 0.4 then
        battery_icon = '';
      elseif b.state_of_charge < 0.5 then
        battery_icon = '';
      elseif b.state_of_charge < 0.6 then
        battery_icon = '';
      elseif b.state_of_charge < 0.7 then
        battery_icon = '';
      elseif b.state_of_charge < 0.8 then
        battery_icon = '';
      elseif b.state_of_charge < 0.9 then
        battery_icon = '';
      elseif b.state_of_charge < 1.0 then
        battery_icon = '';
      elseif b.state_of_charge == 1.0 then
        battery_icon = '';
      end
    end
    bat = battery_icon .. " " .. string.format("%.0f%%", b.state_of_charge * 100);

    if b.state_of_charge < 0.15 then
      battery_foreground = red_foreground;
    end

    if b.state == 'Charging' then
      battery_foreground = green_foreground
    end
  end

  local status = {}

  if bat ~= '' then
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


  window:set_right_status(wezterm.format(status));
end)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)

  local edge_background = "#dbdbdb"
  local background = "#eaeaea"
  local foreground = "#1d344f"

  if tab.is_active then
    background = "#2d81a3"
    foreground = "#e6ebf3"
  elseif hover then
    background = "#2d81a3"
    foreground = "#e6ebf3"
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
  set_environment_variables = environment_variables,
  window_background_opacity = 0.95,
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  font = wezterm.font("PlemolJP Console NF"),
  font_size = font_size,
  color_scheme_dirs = { "~/.config/wezterm/colors" },
  color_scheme = "dayfox",
  launch_menu = launch_menu,
  keys = keys,
  use_fancy_tab_bar = false,
}
