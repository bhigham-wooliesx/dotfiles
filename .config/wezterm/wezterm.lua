local appearance = require('appearance.config')
local keymaps = require('keymaps.config')
local platform = require('platform.config')
local wezterm = require('wezterm')

local config = wezterm.config_builder()

config.automatically_reload_config = false
config.window_close_confirmation = 'NeverPrompt'
config.audible_bell = 'Disabled'

appearance.apply_to_config(config)
keymaps.apply_to_config(config)
platform.apply_to_config(config)

return config
