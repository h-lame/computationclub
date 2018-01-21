dofile('util.lua')

function _copy_array(onto, from)
  for _, e in pairs(from) do
    onto[#onto + 1] = e
  end
end

function concatenate(a1, a2)
  local new = {}
  _copy_array(new, a1)
  _copy_array(new, a2)
  return new
end

local _private = {}

function strict_read(table, key)
  if _private[key] then
    return _private[key]
  else
    error("Invalid key: " .. key)
  end
end

function strict_write(table, key, value)
  if _private[key] and value ~= nil then
    error("Duplicate key: " .. key)
  else
    _private[key] = value
  end
end

local mt = {
  __index = strict_read,
  __newindex = strict_write
}

treasure = {}
setmetatable(treasure, mt)
treasure.gold = 100

print(treasure.gold)

-- treasure.gold = 20
treasure.gold = nil

print(treasure.gold)
