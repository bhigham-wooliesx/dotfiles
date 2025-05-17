local utils = require('utils')
local wezterm = require('wezterm')

---@class Keymaps
local keymaps = {}

-- Return a table of shorthand modifier values
-- (e.g: _ for NONE, CA for CTRL|ALT)
---@class ModKeys
local mod_keys = setmetatable({
  _SHORT_MOD_MAP = {
    _ = 'NONE',
    C = 'CTRL',
    S = 'SHIFT',
    A = 'ALT',
    D = 'SUPER', -- D for Desktop (Win/Cmd/Super)
    M = 'META',
    L = 'LEADER',
  },
}, {
  -- Dynamically transform key access of 'CSA' to 'CTRL|SHIFT|ALT'
  __index = function(self, key)
    local resolved_mods = self._SHORT_MOD_MAP[key:sub(1, 1)]
    for i = 2, #key do
      local char = key:sub(i, i)
      resolved_mods = resolved_mods .. '|' .. self._SHORT_MOD_MAP[char]
    end
    return resolved_mods
  end,
})

---Define keyboard shortcuts with the specified modifiers and keys
---@param mods string The modifier keys (e.g., "CTRL|SHIFT")
---@param keys string|table The key or keys to bind
---@param action table The action to perform when the key is pressed
---@return table binds The key bindings
local function define_key(mods, keys, action)
  local normalized_keys = (type(keys) == 'table') and keys or { keys }
  local binds = {}
  for _, key in ipairs(normalized_keys) do
    table.insert(binds, { mods = mods, key = key, action = action })
  end
  return binds
end

---Define a key table for modal key operations
---@param key_tables table The table of key tables
---@param spec table The specification for the key table
---@return table action The action to activate the key table
local function define_key_table(key_tables, spec)
  key_tables[spec.name] = utils.flatten_list(spec.keys)
  local options = spec.options or {}
  options.name = spec.name
  return wezterm.action.ActivateKeyTable(options)
end

---Create a workspace selector
---@param workspaces table List of workspaces
---@return function callback The action callback
local function select_workspace(workspaces)
  return wezterm.action_callback(function(window, pane)
    window:perform_action(
      wezterm.action.InputSelector({
        title = 'Select Workspace',
        choices = workspaces,
        fuzzy = true,
        fuzzy_description = 'Search for Workspace: ',
        action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
          if not id and not label then
            return
          end

          inner_window:perform_action(
            wezterm.action.SwitchToWorkspace({
              name = label,
              spawn = { cwd = id },
            }),
            inner_pane
          )
        end),
      }),
      pane
    )
  end)
end

---Apply key mappings to WezTerm config
---@param config table The WezTerm configuration table
function keymaps.apply_to_config(config)
  -- Editor
  local editor = os.getenv('EDITOR') or 'vim'

  -- Workspaces
  local workspaces = {}

  -- Add projects workspaces
  local projects_dir = wezterm.home_dir .. '/Projects'

  if utils.is_valid_path(projects_dir) then
    for _, project_dir in ipairs(wezterm.read_dir(projects_dir)) do
      table.insert(workspaces, {
        id = project_dir,
        label = project_dir:match('([^/]+)$'),
      })
    end
  end

  -- Add dotfiles workspace
  local dotfiles_path = wezterm.home_dir .. '/.dotfiles'

  if utils.is_valid_path(dotfiles_path) then
    table.insert(workspaces, {
      id = dotfiles_path,
      label = 'dotfiles',
    })
  end

  -- Keys
  config.leader = { mods = mod_keys.C, key = 'a', timeout_milliseconds = 10000 }

  local key_tables = {}
  local keys = {
    -- Restore default CTRL+a functionality behind leader (i.e. CTRL+a CTRL+a)
    define_key(mod_keys.LC, 'a', wezterm.action.SendKey({ mods = mod_keys.C, key = 'a' })),

    -- Pane management
    define_key(mod_keys.L, { '|' }, wezterm.action.SplitHorizontal({ domain = 'CurrentPaneDomain' })),
    define_key(mod_keys.L, { '-' }, wezterm.action.SplitVertical({ domain = 'CurrentPaneDomain' })),
    define_key(mod_keys.L, 'm', wezterm.action.TogglePaneZoomState),

    -- Close pane
    define_key(mod_keys.L, 'x', wezterm.action.CloseCurrentPane({ confirm = true })),

    -- Pane navigation
    -- define_key(mod_keys.C, 'h', wezterm.action.ActivatePaneDirection('Left')),
    -- define_key(mod_keys.C, 'j', wezterm.action.ActivatePaneDirection('Down')),
    -- define_key(mod_keys.C, 'k', wezterm.action.ActivatePaneDirection('Up')),
    -- define_key(mod_keys.C, 'l', wezterm.action.ActivatePaneDirection('Right')),

    -- Resize pane mode
    define_key(
      mod_keys.L,
      'r',
      define_key_table(key_tables, {
        name = 'resize_pane',
        options = { one_shot = false },
        keys = {
          define_key(mod_keys._, 'Escape', wezterm.action.PopKeyTable),
          define_key(mod_keys.L, 'r', wezterm.action.PopKeyTable),
          define_key(mod_keys._, { 'h', 'LeftArrow' }, wezterm.action.AdjustPaneSize({ 'Left', 3 })),
          define_key(mod_keys._, { 'j', 'DownArrow' }, wezterm.action.AdjustPaneSize({ 'Down', 3 })),
          define_key(mod_keys._, { 'k', 'UpArrow' }, wezterm.action.AdjustPaneSize({ 'Up', 3 })),
          define_key(mod_keys._, { 'l', 'RightArrow' }, wezterm.action.AdjustPaneSize({ 'Right', 3 })),
        },
      })
    ),

    -- Workspace management
    define_key(mod_keys.L, 'w', select_workspace(workspaces)),
    define_key(mod_keys.L, 'l', wezterm.action.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES|LAUNCH_MENU_ITEMS' })),
    define_key(mod_keys.L, 'n', wezterm.action.SwitchWorkspaceRelative(1)),
    define_key(mod_keys.L, 'p', wezterm.action.SwitchWorkspaceRelative(-1)),

    -- Open config in editor
    define_key(
      mod_keys.D,
      ',',
      wezterm.action.SpawnCommandInNewTab({
        args = { editor, wezterm.config_file },
        cwd = wezterm.config_dir,
      })
    ),
  }

  config.keys = utils.flatten_list(keys)
  config.key_tables = key_tables

  -- Additional performance tweaks
  config.enable_kitty_keyboard = true -- Enhanced keyboard protocol support
end

return keymaps
