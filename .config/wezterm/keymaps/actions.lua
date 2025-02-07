local platform_helpers = require('platform.helpers')
local wezterm = require('wezterm')

local action = wezterm.action
local action_callback = wezterm.action_callback

local actions = {}

function actions.select_workspace(workspaces)
  return action_callback(function(window, pane)
    window:perform_action(
      action.InputSelector({
        title = 'Select Workspace',
        choices = workspaces,
        fuzzy = true,
        fuzzy_description = 'Search for Workspace: ',
        action = action_callback(function(inner_window, inner_pane, id, label)
          if not id and not label then
            return
          end

          inner_window:perform_action(
            action.SwitchToWorkspace({
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

function actions.vim_passthrough(mods, key, intended_action)
  return action_callback(function(window, pane)
    local resolved_action = platform_helpers.is_foreground_process_vim(pane) and action.SendKey({ mods, key })
      or intended_action
    window:perform_action(resolved_action, pane)
  end)
end

return actions
