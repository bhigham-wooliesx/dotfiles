local utils = {}

--- Merge all the given tables into a single one and return it.
function utils.merge_all(...)
  local merged_table = {}
  for _, table in ipairs({ ... }) do
    for key, value in pairs(table) do
      merged_table[key] = value
    end
  end
  return merged_table
end

--- Deep clone the given table.
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

local function is_list(item)
  if type(item) ~= 'table' then
    return false
  end
  -- a list has list indices, an object does not
  return ipairs(item)(item, 0) and true or false
end

--- Flatten the given list of (item or (list of (item or ...)) to a list of item.
-- (nested lists are supported)
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

-- Remove the directory path from a string, equivalent to POSIX basename(3)
function utils.basename(s)
  return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

return utils
