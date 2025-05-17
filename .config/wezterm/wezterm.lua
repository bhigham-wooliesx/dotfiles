local keymaps = require('keymaps')
local platform = require('platform')
local ui = require('ui')
local wezterm = require('wezterm')

local config = wezterm.config_builder()

-- Core configuration
config.automatically_reload_config = false
config.check_for_updates = true

-- Apply configuration modules
ui.apply_to_config(config)
keymaps.apply_to_config(config)
platform.apply_to_config(config)

return config
