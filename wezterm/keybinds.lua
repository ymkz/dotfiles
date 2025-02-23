local wezterm = require 'wezterm'
local act = wezterm.action

return {
  keys = {
    { key = 'C', mods = 'CTRL', action = act.CopyTo 'Clipboard' },
    { key = 'V', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
    { key = 'T', mods = 'CTRL', action = act.SpawnTab 'CurrentPaneDomain' },
    { key = 'Y', mods = 'CTRL', action = act.SplitVertical{ domain = 'CurrentPaneDomain' } },
    { key = 'F', mods = 'CTRL', action = act.Search 'CurrentSelectionOrEmptyString' },
    { key = 'W', mods = 'CTRL', action = act.CloseCurrentPane{ confirm = false } },
    { key = '1', mods = 'CTRL', action = act.ActivateTab(0) },
    { key = '2', mods = 'CTRL', action = act.ActivateTab(1) },
    { key = '3', mods = 'CTRL', action = act.ActivateTab(2) },
    { key = '4', mods = 'CTRL', action = act.ActivateTab(3) },
    { key = '5', mods = 'CTRL', action = act.ActivateTab(4) },
  },
}
