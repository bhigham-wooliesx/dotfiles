local utils = require('utils')
local wezterm = require('wezterm')

---@class UI
local ui = {}

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

  -- Color scheme based on system appearance
  local appearance = wezterm.gui and wezterm.gui.get_appearance() or 'Dark'
  if appearance:find('Dark') then
    config.color_scheme = 'Catppuccin Mocha'
  else
    config.color_scheme = 'Catppuccin Latte'
  end

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
    top = '0.5cell',
    bottom = '0cell',
  }

  -- Tab bar configuration
  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = true
  config.hide_tab_bar_if_only_one_tab = true
  config.tab_max_width = 64
  config.show_new_tab_button_in_tab_bar = false

  -- Additional performance tweaks
  config.front_end = 'WebGpu' -- Modern GPU rendering for better performance

  -- Set up event handlers
  ui.setup_status_update(config)
  ui.setup_right_status()

  return config
end

---Set up the status update handler for dynamic UI adjustments
---@param config table The WezTerm configuration table
function ui.setup_status_update(config)
  wezterm.on('update-status', function(window, pane)
    -- Set up dynamic padding based on foreground process
    local process_name = pane:get_foreground_process_name()
    local is_vim = utils.is_process_vim(process_name)

    if is_vim then
      window:set_config_overrides({
        window_padding = {
          left = '0cell',
          right = '0cell',
          top = '0.5cell',
          bottom = '0cell',
        },
      })
    else
      window:set_config_overrides({
        window_padding = config.window_padding,
      })
    end
  end)
end

---Set up the right status bar with useful information
function ui.setup_right_status()
  wezterm.on('update-right-status', function(window, _)
    local active_pane = window:active_pane()
    local active_workspace = window:active_workspace()
    local cwd_file_path = utils.get_cwd_file_path(active_pane)
    local username = os.getenv('USER') or os.getenv('LOGNAME') or os.getenv('USERNAME')

    -- Get battery info if available
    local battery_info = ''
    local battery_icon = ''
    local success, batteries = pcall(wezterm.battery_info)

    if success and batteries and #batteries > 0 then
      local battery = batteries[1]
      local charge = battery.state_of_charge * 100
      local state = battery.state

      -- Choose appropriate icon based on charge level and state
      if state == 'Charging' then
        battery_icon = wezterm.nerdfonts.md_battery_charging
      elseif charge > 90 then
        battery_icon = wezterm.nerdfonts.md_battery
      elseif charge > 70 then
        battery_icon = wezterm.nerdfonts.md_battery_80
      elseif charge > 50 then
        battery_icon = wezterm.nerdfonts.md_battery_60
      elseif charge > 30 then
        battery_icon = wezterm.nerdfonts.md_battery_40
      elseif charge > 10 then
        battery_icon = wezterm.nerdfonts.md_battery_20
      else
        battery_icon = wezterm.nerdfonts.md_battery_alert
      end

      battery_info = string.format('%.0f%%', charge)
    end

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
        enabled = battery_info ~= '',
      },
      {
        label = wezterm.strftime('%H:%M'),
        icon = wezterm.nerdfonts.oct_clock,
        enabled = true,
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
  end)
end

return ui
