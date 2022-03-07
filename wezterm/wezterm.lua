local wezterm = require 'wezterm';

local launch_menu = {}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  table.insert(launch_menu, {
    label = "PowerShell 7",
    args = {"C:/Users/nazuna/AppData/Local/Microsoft/WindowsApps/pwsh.exe", "-nologo"},
  })

  table.insert(launch_menu, {
    label = "PowerShell",
    args = {"powershell.exe", "-NoLogo"},
  })

end

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)

return {
  default_prog = {"C:/Users/nazuna/AppData/Local/Microsoft/WindowsApps/pwsh.exe", "-nologo"},
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  window_frame = {
    font = wezterm.font({family="Roboto", weight="Bold"}),
    font_size = 10.0,
    active_titlebar_bg = "#e8e9ec",
    inactive_titlebar_bg = "#e8e9ec",
  },
  font = wezterm.font("PlemolJP Console NF"),
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
}
