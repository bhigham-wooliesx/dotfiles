local utils = require('utils')

---@class Platform
local platform = {}

---Apply macOS specific configuration
---@param config table The WezTerm configuration table
local function apply_mac_config(config)
  -- Add homebrew to PATH if it exists
  local homebrew_path = '/opt/homebrew/bin'

  if utils.is_valid_path(homebrew_path) then
    config.set_environment_variables = {
      PATH = homebrew_path .. ':' .. os.getenv('PATH'),
    }
  end

  -- Enable native IME support for better input method compatibility
  config.use_ime = true
end

---Apply Windows specific configuration
---@param config table The WezTerm configuration table
local function apply_windows_config(config)
  local launch_menu = {}
  local has_pwsh = utils.has_executable_in_path('pwsh.exe')
  local powershell_exe = has_pwsh and 'pwsh.exe' or 'powershell.exe'
  local powershell_args = { powershell_exe, '-NoLogo' }

  table.insert(launch_menu, {
    label = 'PowerShell',
    args = powershell_args,
  })

  table.insert(launch_menu, {
    label = 'Command Prompt',
    args = { os.getenv('COMSPEC'), '/k' },
  })

  config.default_prog = powershell_args
  config.launch_menu = launch_menu
end

---Apply Linux specific configuration
---@param config table The WezTerm configuration table
local function apply_linux_config(config)
  local default_shell = os.getenv('SHELL') or '/bin/bash'
  config.default_prog = { default_shell }

  -- Check for Wayland and adjust accordingly
  local wayland = os.getenv('WAYLAND_DISPLAY')
  if wayland then
    config.enable_wayland = true
  end
end

---Apply platform-specific configuration to WezTerm config
---@param config table The WezTerm configuration table
function platform.apply_to_config(config)
  local platform_target = utils.get_platform_target()

  if platform_target == 'macos' then
    apply_mac_config(config)
  elseif platform_target == 'windows' then
    apply_windows_config(config)
  elseif platform_target == 'linux' then
    apply_linux_config(config)
  end

  return config
end

return platform
