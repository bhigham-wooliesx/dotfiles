local actions = require('keymaps.actions')
local utils = require('utils')
local wezterm = require('wezterm')

local helpers = {}

-- Return a table of shorthand mods values (_, C, S, A, D, M, L)
-- (e.g: mods._ for NONE, mods.CA for CTRL|ALT)
helpers.mods = setmetatable({
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

function helpers.define_key(mods, keys, action)
  local normalized_keys = (type(keys) == 'table') and keys or { keys }
  local binds = {}
  for _, key in ipairs(normalized_keys) do
    table.insert(binds, { mods = mods, key = key, action = action })
  end
  return binds
end

function helpers.define_vim_key(mods, key, intended_action)
  return helpers.define_key(mods, key, actions.vim_passthrough(mods, key, intended_action))
end

function helpers.define_key_table(key_tables, spec)
  key_tables[spec.name] = utils.flatten_list(spec.keys)
  local options = spec.options or {}
  options.name = spec.name
  return wezterm.action.ActivateKeyTable(options)
end

return helpers
