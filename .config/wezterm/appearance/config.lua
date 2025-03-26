local helpers = require('appearance.helpers')
local platform_helpers = require('platform.helpers')
local wezterm = require('wezterm')

local function get_right_status_segments(window)
  local active_pane = window:active_pane()
  local active_workspace = window:active_workspace()
  local cwd_file_path = platform_helpers.get_cwd_file_path(active_pane)
  local username = os.getenv('USER') or os.getenv('LOGNAME') or os.getenv('USERNAME')

  local segments = {
    {
      label = cwd_file_path,
      icon = wezterm.nerdfonts.oct_file_directory,
      enabled = active_workspace == 'default' and cwd_file_path ~= nil,
    },
    {
      label = active_workspace,
      icon = wezterm.nerdfonts.oct_repo,
      enabled = active_workspace ~= 'default',
    },
    {
      label = username .. '@' .. wezterm.hostname(),
      icon = wezterm.nerdfonts.oct_server,
      enabled = true,
    },
    {
      label = wezterm.strftime('%H:%M'),
      icon = wezterm.nerdfonts.oct_clock,
      enabled = false,
    },
  }

  return segments
end

local appearance = {}

function appearance.apply_to_config(config)
  if helpers.get_appearance() == 'dark' then
    config.color_scheme = 'Catppuccin Mocha'
  else
    config.color_scheme = 'Catppuccin Latte'
  end

  config.font = wezterm.font_with_fallback({ 'JetBrainsMono Nerd Font' })
  config.font_size = 14.0

  config.window_decorations = 'RESIZE'
  config.window_padding = {
    left = '1cell',
    right = '1cell',
    top = '0.5cell',
    bottom = '0.5cell',
  }

  config.hide_tab_bar_if_only_one_tab = false
  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = true
  config.tab_max_width = 64

  wezterm.on('update-right-status', function(window, _)
    local segments = get_right_status_segments(window)
    return helpers.update_right_status(window, segments)
  end)
end

return appearance
