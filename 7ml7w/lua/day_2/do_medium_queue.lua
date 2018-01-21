Queue = {
  stuff = {}
}
function Queue:new()
  local instance = {
    stuff = self.stuff
  }

  setmetatable(instance, self)
  self.__index = self

  return instance
end

function Queue:add(value)
  -- if #self.stuff > 0 then
  --   self.stuff[#self.stuff + 1] = self.stuff[1]
  -- end
  -- self.stuff[1] = value
  table.insert(self.stuff, value)
end

function Queue:remove()
  -- local pop = self.stuff[#self.stuff]
  -- self.stuff[#self.stuff] = nil
  -- return pop
  return table.remove(self.stuff, 1)
end

q = Queue:new()

print('***: q:remove() == nil')
print(q:remove() == nil)

print('***: q:add(something) then q:remove() == something and q:remove == nil')
q:add('add this')

print(q:remove() == 'add this')
print(q:remove() == nil)

print('***: q:add(something); q:add(anotherthing) then q:remove() == something and q:remove == anotherthing and q:remove == nil')
q:add('add this')
q:add('then this')

print(q:remove() == 'add this')
print(q:remove() == 'then this')
print(q:remove() == nil)
