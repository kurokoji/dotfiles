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

  font_size = 12.0

  default_prog = {"C:/Program Files/PowerShell/7/pwsh.exe", "-nologo"}
elseif wezterm.target_triple == "aarch64-apple-darwin" or wezterm.target_triple == "x86_64-apple-darwin" then
  table.insert(launch_menu, {
    label = "Fish",
    args = {"/opt/homebrew/bin/fish", "-l"}
  })

  environment_variables = {
    SHELL = "/opt/homebrew/bin/fish",
  }

  font_size = 15.0
--  default_prog = {"/opt/homebrew/bin/fish", "-l"}
else
  table.insert(launch_menu, {
    label = "Fish",
    args = {"/usr/bin/fish", "-l"}
  })

  default_prog = {"/usr/bin/fish", "-l"}
end

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)

return {
  default_prog = default_prog,
  set_environment_variables = environment_variables,
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  window_frame = {
    font = wezterm.font({family="PlemolJP Console NF", weight="Bold", italic=true}),
    font_size = font_size - 2.0,
    active_titlebar_bg = "#e8e9ec",
    inactive_titlebar_bg = "#e8e9ec",
  },
  font = wezterm.font("PlemolJP Console NF"),
  font_size = font_size,
  color_scheme = "iceberg-light",
  -- colors {{{
  colors = {
    tab_bar = {
      background = "#e8e9ec",

      active_tab = {
        bg_color = "#dcdfe7",
        fg_color = "#33374c",

        -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
        -- label shown for this tab.
        -- The default is "Normal"
        intensity = "Normal",

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
        italic = true,

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `inactive_tab_hover`.
      },

      -- The new tab button that let you create new tabs
      new_tab = {
        bg_color = "#bcbfc7",
        fg_color = "#13172c",

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `new_tab`.
      },

      -- You can configure some alternate styling when the mouse pointer
      -- moves over the new tab button
      new_tab_hover = {
        bg_color = "#9c9fa7",
        fg_color = "#03071c",
        italic = true,

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `new_tab_hover`.
      }
    }
  },
  -- }}}
  launch_menu = launch_menu,
  keys = {
    {key="l", mods="ALT", action="ShowLauncher"},
  },
  window_background_opacity = 0.95,
}
