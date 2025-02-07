local wezterm = require('wezterm')

local helpers = {}

function helpers.get_appearance()
  local appearance = wezterm.gui and wezterm.gui.get_appearance() or 'Dark'
  return appearance:find('Dark') and 'dark' or 'light'
end

function helpers.update_right_status(window, segments)
  local formattedSegments = {}

  for _, segment in ipairs(segments) do
    if segment.enabled then
      local icon = segment.icon and segment.icon .. '  ' or ''
      local text = ' ' .. icon .. segment.label .. ' '
      table.insert(formattedSegments, { Text = text })
    end
  end

  window:set_right_status(wezterm.format(formattedSegments))
end

return helpers
