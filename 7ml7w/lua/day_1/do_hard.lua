function add(previous, next)
  return previous + next
end

function reduce(max, init, f)
  local collector = init
  for i = 1, max do
    collector = f(collector, i)
  end
  return collector
end

print(reduce(5,0, add))
print(reduce(5,10, print))

function factorial(n)
  return reduce(n,1,function(previous, next) return previous * next end)
end

print(factorial(5))
print(factorial(0))
print(factorial(100))
