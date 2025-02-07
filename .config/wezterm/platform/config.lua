local helpers = require('platform.helpers')

local function apply_mac_config(config)
  local homebrew_path = '/opt/homebrew/bin'
  if helpers.is_valid_path(homebrew_path) then
    config.set_environment_variables = {
      PATH = homebrew_path .. ':' .. os.getenv('PATH'),
    }
  end
end

local function apply_windows_config(config)
  local launch_menu = {}
  local has_pwsh = helpers.has_executable_in_path('pwsh.exe')
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

local platform = {}

function platform.apply_to_config(config)
  if helpers.is_mac then
    apply_mac_config(config)
  elseif helpers.is_windows then
    apply_windows_config(config)
  end
end

return platform
