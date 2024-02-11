local wezterm = require 'wezterm';

local config = wezterm.config_builder()

config.leader = { key = 'a', mods = 'CTRL' , timeout_milliseconds = 1000 }

config.keys = {
  -- splitting
  {
    mods   = "LEADER",
    key    = "|",
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' }
  },
  {
    mods   = "LEADER",
    key    = "_",
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }
  }
}

return config
