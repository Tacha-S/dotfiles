local wezterm = require 'wezterm'

return {
  color_scheme = 'Molokai',
  window_background_opacity = 0.9,
  font_dirs = {'/usr/share/fonts/opentype'},
  font = wezterm.font_with_fallback {{family = 'SauceCodePro NF Medium', weight = 'Medium'}, {family = 'Source Han Code JP M', weight = 'Medium'}},
  font_size = 14.0,

  leader = { key="q", mods="CTRL" },
  keys = {
    -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
    { key = "a", mods = "LEADER|CTRL",  action=wezterm.action{SendString="\x01"}},
    { key = "-", mods = "LEADER",       action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
    { key = "\\",mods = "LEADER",       action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
    { key = "z", mods = "LEADER",       action="TogglePaneZoomState" },
    { key = "c", mods = "LEADER",       action=wezterm.action{SpawnTab="CurrentPaneDomain"}},
    { key = "1", mods = "CTRL",         action=wezterm.action.ActivateTabRelative(1)},
    { key = "j", mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Left"}},
    { key = "k", mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Down"}},
    { key = "i", mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Up"}},
    { key = "l", mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Right"}},
    { key = "J", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Left", 5}}},
    { key = "K", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Down", 5}}},
    { key = "I", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Up", 5}}},
    { key = "L", mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Right", 5}}},
    { key = "x", mods = "LEADER",       action=wezterm.action{CloseCurrentPane={confirm=false}}},
    { key = 'v', mods = 'LEADER', action = wezterm.action.ShowLauncher },
    { key = 'o', mods = 'LEADER|CTRL',       action=wezterm.action.PaneSelect {alphabet = '1234567890'}},
  },
  ssh_domains = {
    {
      -- This name identifies the domain
      name = 'office',
      -- The hostname or address to connect to. Will be used to match settings
      -- from your ssh config file
      remote_address = '192.168.128.10',
      -- The username to use on the remote host
      username = 'gisen',
    },
  },
}
