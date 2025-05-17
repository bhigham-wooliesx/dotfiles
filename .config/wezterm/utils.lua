local wezterm = require('wezterm')

---@class Utils
local utils = {}

---Remove the directory path from a string, equivalent to POSIX basename(3)
---@param s string The file path
---@return string basename The base filename without directory path
function utils.basename(s)
  local basename = string.gsub(s, '(.*[/\\])(.*)', '%2')
  return basename
end

---Merge all the given tables into a single one and return it.
---@param ... table Tables to merge
---@return table merged_table The merged table
function utils.merge_all(...)
  local merged_table = {}
  for _, tbl in ipairs({ ... }) do
    for key, value in pairs(tbl) do
      merged_table[key] = value
    end
  end
  return merged_table
end

---Deep clone the given table.
---@param original table The table to clone
---@return table clone A deep copy of the original table
function utils.deep_clone(original)
  local clone = {}
  for key, value in pairs(original) do
    if type(value) == 'table' then
      clone[key] = utils.deep_clone(value)
    else
      clone[key] = value
    end
  end
  return clone
end

---Check if the given item is a list (array-like table)
---@param item any The item to check
---@return boolean is_list True if the item is a list
local function is_list(item)
  if type(item) ~= 'table' then
    return false
  end
  -- a list has list indices, an object does not
  return ipairs(item)(item, 0) and true or false
end

---Flatten the given list of (item or (list of (item or ...)) to a list of item.
---@param list table The list to flatten
---@return table flattened_list The flattened list
function utils.flatten_list(list)
  local flattened_list = {}
  for _, item in ipairs(list) do
    if is_list(item) then
      for _, sub_item in ipairs(utils.flatten_list(item)) do
        table.insert(flattened_list, sub_item)
      end
    else
      table.insert(flattened_list, item)
    end
  end
  return flattened_list
end

---Get the current platform target
---@return string platform One of 'linux', 'windows', 'macos', or 'unknown'
function utils.get_platform_target()
  local platform = wezterm.target_triple
  if platform == 'x86_64-unknown-linux-gnu' then
    return 'linux'
  elseif platform == 'x86_64-pc-windows-msvc' then
    return 'windows'
  elseif platform == 'aarch64-apple-darwin' or platform == 'x86_64-apple-darwin' then
    return 'macos'
  else
    return 'unknown'
  end
end

---Get the current working directory path for the active pane
---@param active_pane table Wezterm pane object
---@return string|nil cwd_file_path The current working directory path or nil
function utils.get_cwd_file_path(active_pane)
  local current_working_dir = active_pane:get_current_working_dir()
  local cwd_file_path = nil
  if current_working_dir and current_working_dir.scheme == 'file' then
    cwd_file_path = current_working_dir.file_path:gsub('^(' .. wezterm.home_dir .. ')(.*)', '~%2')
  end
  return cwd_file_path
end

---Check if a path exists
---@param path string The path to check
---@return boolean is_valid True if the path exists
function utils.is_valid_path(path)
  return #wezterm.glob(path) > 0
end

---Check if an executable exists in the system's PATH
---@param executable string The executable name to check
---@return boolean exists True if the executable exists in PATH
function utils.has_executable_in_path(executable)
  return utils.get_platform_target() == 'windows' and wezterm.run_child_process({ 'where.exe', '/Q', executable })
    or wezterm.run_child_process({ 'test', '-f', executable })
end

---Check if the process name is a vim or neovim process
---@param process_name string The process name to check
---@return boolean is_vim True if the process is vim or neovim
function utils.is_process_vim(process_name)
  return process_name:find('vim') ~= nil or process_name:find('nvim') ~= nil
end

return utils
