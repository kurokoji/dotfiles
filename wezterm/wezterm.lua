local wezterm = require 'wezterm';

local launch_menu = {}
local default_prog = {}
local environment_variables = {}
local font_size = 0

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  table.insert(launch_menu, {
    label = "PowerShell 7",
    args = {"C:/Program Files/PowerShell/7/pwsh.exe", "-nologo"},
  })

  table.insert(launch_menu, {
    label = "PowerShell",
    args = {"powershell.exe", "-NoLogo"},
  })

  environment_variables = {
    ComSpec = "C:/Program Files/PowerShell/7/pwsh.exe",
  }

  default_prog = {"C:/Program Files/PowerShell/7/pwsh.exe", "-nologo"}

  font_size = 12.0
elseif wezterm.target_triple == "aarch64-apple-darwin" or wezterm.target_triple == "x86_64-apple-darwin" then
  table.insert(launch_menu, {
    label = "Fish",
    args = {"/opt/homebrew/bin/fish", "-l"}
  })

  environment_variables = {
    SHELL = "/opt/homebrew/bin/fish",
  }

  default_prog = {"/opt/homebrew/bin/fish", "-l"}

  font_size = 15.0
--  default_prog = {"/opt/homebrew/bin/fish", "-l"}
else
  table.insert(launch_menu, {
    label = "Fish",
    args = {"/usr/bin/fish", "-l"}
  })
end

local keys = {
  {key="l", mods="ALT", action="ShowLauncher"},
  {key="t", mods="ALT", action="ShowTabNavigator"},
}

for i = 1, 9 do
  table.insert(keys, {
    key=tostring(i),
    mods="ALT",
    action=wezterm.action{ActivateTab=i-1},
  })
end

-- Tab Bar Config {{{

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = ''

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = ''

wezterm.on("update-right-status", function(window, pane)
  local background = "#ced5de"
  local foreground = "#1d344f"
  local edge_background = "#eaeaea"
  local edge_foreground = background

  -- "Wed Mar 3 08:14"
  local date = "  " ..  wezterm.strftime("%a %b %-d %H:%M ");

  local bat = ""
  for _, b in ipairs(wezterm.battery_info()) do
    bat = " " .. string.format("%.0f%%", b.state_of_charge * 100)
  end

  window:set_right_status(wezterm.format({
    {Background={Color=edge_background}},
    {Foreground={Color=edge_foreground}},
    {Text=SOLID_LEFT_ARROW},
    {Background={Color=background}},
    {Foreground={Color=foreground}},
    {Text=bat},
    {Background={Color=edge_background}},
    {Foreground={Color=edge_foreground}},
    {Text=SOLID_RIGHT_ARROW},
    {Background={Color=edge_background}},
    {Foreground={Color=edge_foreground}},
    {Text=SOLID_LEFT_ARROW},
    {Background={Color=background}},
    {Foreground={Color=foreground}},
    {Text=date},
    {Background={Color=edge_background}},
    {Foreground={Color=edge_foreground}},
    {Text=SOLID_RIGHT_ARROW},
  }));
end)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)

  local edge_background = "#eaeaea"
  local background = "#eaeaea"
  local foreground = "#1d344f"

  if tab.is_active then
    background = "#ced5de"
    foreground = "#1d344f"
  elseif hover then
    background = "#ced5de"
    foreground = "#1d344f"
  end

  local edge_foreground = background

  -- ensure that the titles fit in the available space,
  -- and that we have room for the edges.
  local title = (tonumber(tab.tab_index) + 1) .. " " .. wezterm.truncate_right(tab.active_pane.title, max_width-4)

  return {
    {Background={Color=edge_background}},
    {Foreground={Color=edge_foreground}},
    {Text=SOLID_LEFT_ARROW},
    {Background={Color=background}},
    {Foreground={Color=foreground}},
    {Text=title},
    {Background={Color=edge_background}},
    {Foreground={Color=edge_foreground}},
    {Text=SOLID_RIGHT_ARROW},
  }
end)
-- }}}

return {
  default_prog = default_prog,
  set_environment_variables = environment_variables,
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  font = wezterm.font("PlemolJP Console NF"),
  font_size = font_size,
  color_scheme_dirs = {"~/.config/wezterm/colors"},
  color_scheme = "dayfox_wezterm",
  -- colors {{{
  colors = {
    tab_bar = {
      background = "#e8e9ec",
      foreground = "#1d344f",

      active_tab = {
        bg_color = "#ced5de",
        fg_color = "#1d344f",

        -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
        -- label shown for this tab.
        -- The default is "Normal"
        intensity = "Bold",

        -- Specify whether you want "None", "Single" or "Double" underline for
        -- label shown for this tab.
        -- The default is "None"
        underline = "None",

        -- Specify whether you want the text to be italic (true) or not (false)
        -- for this tab.  The default is false.
        italic = false,

        -- Specify whether you want the text to be rendered with strikethrough (true)
        -- or not for this tab.  The default is false.
        strikethrough = false,
      },

      -- Inactive tabs are the tabs that do not have focus
      inactive_tab = {
        bg_color = "#bcbfc7",
        fg_color = "#13172c",

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `inactive_tab`.
      },

      -- You can configure some alternate styling when the mouse pointer
      -- moves over inactive tabs
      inactive_tab_hover = {
        bg_color = "#9c9fa7",
        fg_color = "#03071c",

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `inactive_tab_hover`.
      },

      -- The new tab button that let you create new tabs
      new_tab = {
        bg_color = "#e8e9ec",
        fg_color = "#13172c",

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `new_tab`.
      },

      -- You can configure some alternate styling when the mouse pointer
      -- moves over the new tab button
      new_tab_hover = {
        bg_color = "#9c9fa7",
        fg_color = "#03071c",

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `new_tab_hover`.
      }
    },
  },
  -- }}}
  launch_menu = launch_menu,
  keys = keys,
  use_fancy_tab_bar = false,
}
