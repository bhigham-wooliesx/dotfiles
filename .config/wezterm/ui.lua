local utils = require('utils')
local wezterm = require('wezterm')

---@class UI
local ui = {}

local function get_battery_status()
  local info, icon
  local success, batteries = pcall(wezterm.battery_info)

  if success and batteries and #batteries > 0 then
    local battery = batteries[1]
    local charge = battery.state_of_charge * 100
    local state = battery.state

    info = string.format('%.0f%%', charge)

    -- Choose appropriate icon based on charge level and state
    if state == 'Charging' then
      icon = wezterm.nerdfonts.md_battery_charging
    elseif charge > 90 then
      icon = wezterm.nerdfonts.md_battery
    elseif charge > 70 then
      icon = wezterm.nerdfonts.md_battery_80
    elseif charge > 50 then
      icon = wezterm.nerdfonts.md_battery_60
    elseif charge > 30 then
      icon = wezterm.nerdfonts.md_battery_40
    elseif charge > 10 then
      icon = wezterm.nerdfonts.md_battery_20
    else
      icon = wezterm.nerdfonts.md_battery_alert
    end
  end

  return info, icon
end

local function recompute_padding(window, pane)
  local config_overrides = window:get_config_overrides() or {}
  local process_name = pane:get_foreground_process_name()
  local process_is_vim = utils.is_process_vim(process_name)

  if not process_is_vim then
    if not config_overrides.window_padding then
      return
    end
    config_overrides.window_padding = nil
  else
    local new_padding = {
      left = '0cell',
      right = '0cell',
      top = '1cell',
      bottom = '0cell',
    }
    if config_overrides.window_padding and new_padding.left == config_overrides.window_padding.left then
      return
    end
    config_overrides.window_padding = new_padding
  end

  window:set_config_overrides(config_overrides)
end

local function update_right_status_segments(window)
  local window_dimensions = window:get_dimensions()
  local window_is_fullscreen = window_dimensions.is_full_screen
  local active_workspace = window:active_workspace()
  local active_pane = window:active_pane()
  local cwd_file_path = utils.get_cwd_file_path(active_pane)
  local username = os.getenv('USER') or os.getenv('LOGNAME') or os.getenv('USERNAME')
  local battery_info, battery_icon = get_battery_status()

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
      label = battery_info,
      icon = battery_icon,
      enabled = window_is_fullscreen and battery_info ~= nil,
    },
    {
      label = wezterm.strftime('%d/%m %H:%M'),
      icon = wezterm.nerdfonts.oct_clock,
      enabled = window_is_fullscreen,
    },
  }

  local formatted_segments = {}
  for _, segment in ipairs(segments) do
    if segment.enabled then
      local icon = segment.icon and segment.icon .. '  ' or ''
      table.insert(formatted_segments, { Text = ' ' .. icon .. segment.label .. ' ' })
    end
  end

  window:set_right_status(wezterm.format(formatted_segments))
end

---Apply UI configuration to WezTerm config
---@param config table The WezTerm configuration table
function ui.apply_to_config(config)
  -- Terminal bell
  config.audible_bell = 'Disabled'
  config.visual_bell = {
    fade_in_duration_ms = 75,
    fade_out_duration_ms = 75,
    target = 'CursorColor',
  }

  -- Color scheme
  config.color_scheme = 'Tokyo Night Moon'

  -- Font configuration
  config.font = wezterm.font_with_fallback({ 'JetBrainsMono Nerd Font' })
  config.font_size = 14.0
  config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }

  -- Window configuration
  config.window_close_confirmation = 'NeverPrompt'
  config.window_decorations = 'RESIZE'
  config.enable_scroll_bar = false
  config.use_resize_increments = false -- Allow for more precise window resizing

  -- Default window padding
  config.window_padding = {
    left = '1cell',
    right = '1cell',
    top = '1cell',
    bottom = '1cell',
  }

  -- Tab bar configuration
  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = true
  config.hide_tab_bar_if_only_one_tab = false
  config.tab_max_width = 64
  config.show_new_tab_button_in_tab_bar = false

  -- Set up event handlers
  wezterm.on('update-status', function(window, pane)
    recompute_padding(window, pane)
  end)

  wezterm.on('update-right-status', function(window)
    update_right_status_segments(window)
  end)

  return config
end

return ui
