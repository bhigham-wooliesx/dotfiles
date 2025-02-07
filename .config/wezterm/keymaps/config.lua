local actions = require('keymaps.actions')
local helpers = require('keymaps.helpers')
local platform_helpers = require('platform.helpers')
local utils = require('utils')
local vars = require('vars')
local wezterm = require('wezterm')

local mods = helpers.mods
local define_key = helpers.define_key
local define_vim_key = helpers.define_vim_key
local define_key_table = helpers.define_key_table
local action = wezterm.action

local keymaps = {}

function keymaps.apply_to_config(config)
  -- Leader key
  config.leader = { mods = mods.C, key = 'a', timeout_milliseconds = 10000 }

  local key_tables = {}
  local keys = {
    -- Restore default CTRL+a functionality behind leader (i.e. CTRL+a CTRL+a)
    define_key(mods.LC, 'a', action.SendKey({ mods = mods.C, key = 'a' })),

    -- Pane management
    define_key(mods.L, { '"', '|' }, action.SplitHorizontal({ domain = 'CurrentPaneDomain' })),
    define_key(mods.L, { '%', '\\' }, action.SplitVertical({ domain = 'CurrentPaneDomain' })),
    define_key(mods.L, 'm', action.TogglePaneZoomState),

    define_vim_key(mods.C, 'h', action.ActivatePaneDirection('Left')),
    define_vim_key(mods.C, 'j', action.ActivatePaneDirection('Down')),
    define_vim_key(mods.C, 'k', action.ActivatePaneDirection('Up')),
    define_vim_key(mods.C, 'l', action.ActivatePaneDirection('Right')),

    define_key(
      mods.L,
      'r',
      define_key_table(key_tables, {
        name = 'resize_pane',
        options = { one_shot = false },
        keys = {
          define_key(mods._, 'Escape', action.PopKeyTable),
          define_key(mods.L, 'r', action.PopKeyTable),
          define_key(mods._, { 'h', 'LeftArrow' }, action.AdjustPaneSize({ 'Left', 3 })),
          define_key(mods._, { 'j', 'DownArrow' }, action.AdjustPaneSize({ 'Down', 3 })),
          define_key(mods._, { 'k', 'UpArrow' }, action.AdjustPaneSize({ 'Up', 3 })),
          define_key(mods._, { 'l', 'RightArrow' }, action.AdjustPaneSize({ 'Right', 3 })),
        },
      })
    ),

    -- Workspace management
    define_key(mods.L, 'w', actions.select_workspace(platform_helpers.get_workspaces())),
    define_key(mods.L, 'l', action.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES|LAUNCH_MENU_ITEMS' })),
    define_key(mods.L, 'n', action.SwitchWorkspaceRelative(1)),
    define_key(mods.L, 'p', action.SwitchWorkspaceRelative(-1)),

    -- Open config in editor
    define_key(
      mods.D,
      ',',
      action.SpawnCommandInNewTab({
        args = { vars.editor, wezterm.config_file },
        cwd = wezterm.config_dir,
      })
    ),
  }

  config.keys = utils.flatten_list(keys)
  config.key_tables = key_tables
end

return keymaps
