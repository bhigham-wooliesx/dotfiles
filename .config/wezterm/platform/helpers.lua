local utils = require('utils')
local vars = require('vars')
local wezterm = require('wezterm')

local helpers = {}

helpers.is_linux = wezterm.target_triple == 'x86_64-unknown-linux-gnu'
helpers.is_mac = wezterm.target_triple == 'aarch64-apple-darwin' or wezterm.target_triple == 'x86_64-apple-darwin'
helpers.is_windows = wezterm.target_triple == 'x86_64-pc-windows-msvc'

function helpers.has_executable_in_path(executable)
  return helpers.is_windows and wezterm.run_child_process({ 'where.exe', '/Q', executable })
    or wezterm.run_child_process({ 'test', '-f', executable })
end

function helpers.is_valid_path(path)
  return #wezterm.glob(path) > 0
end

function helpers.get_cwd_file_path(active_pane)
  local current_working_dir = active_pane:get_current_working_dir()
  local cwd_file_path = current_working_dir
      and current_working_dir.scheme == 'file'
      and current_working_dir.file_path:gsub('^(' .. wezterm.home_dir .. ')(.*)', '~%2')
    or nil
  return cwd_file_path
end

function helpers.is_foreground_process_vim(pane)
  -- Use this if you are *NOT* lazy-loading smart-splits.nvim
  -- return pane:get_user_vars().IS_NVIM == 'true'

  -- if you *ARE* lazy-loading smart-splits.nvim (unreliable)
  local process_name = utils.basename(pane:get_foreground_process_name())
  return process_name == 'nvim' or process_name == 'vim'
end

function helpers.get_workspaces()
  local workspaces = {}

  for _, project_dir in ipairs(wezterm.read_dir(vars.projects_dir)) do
    table.insert(workspaces, {
      id = project_dir,
      label = project_dir:match('([^/]+)$'),
    })
  end

  table.insert(workspaces, {
    id = vars.dotfiles_dir,
    label = 'dotfiles',
  })

  return workspaces
end

return helpers
