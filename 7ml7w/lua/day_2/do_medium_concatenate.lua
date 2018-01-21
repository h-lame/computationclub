dofile('util.lua')

function _copy_array(onto, from)
  for _, e in pairs(from) do
    onto[#onto + 1] = e
  end
end

function _concatenate(a1, a2)
  local new = {}
  _copy_array(new, a1)
  _copy_array(new, a2)
  return new
end

function _override_add_table(table, key, value)
  if type(value) == 'table' then
    setmetatable(value, {__add = _concatenate})
  end
  rawset(table, key, value)
end

setmetatable(_G, {__newindex = _override_add_table})

a = {1,2,3}
b = {4,5,6}

print('****: a + b')
print_table(a + b)

print('****: a + {7,8,9}')
print_table(a + {7,8,9})

print('****: {10,11,12} + b')
print_table({10,11,12} + b)

print('****: a + {one = 1, two = 2, three = 3}')
print_table(a + {one = 1, two = 2, three = 3})

print('****: {one = 1, two = 2, three = 3} + a')
print_table({one = 1, two = 2, three = 3} + a)

print('****: {1,2,3} + {4,5,6}')
-- this breaks: only variable assigned tables get the + hack
-- print_table({1,2,3} + {4,5,6})
print('this breaks')

print('****: a + 1')
-- this breaks _concatenate expects both args to be a table so
-- we get bad argument #1 to 'for iterator' (table expected, got number)
-- from lua
-- print(a + 1)
print('this breaks')
