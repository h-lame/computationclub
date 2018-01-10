function for_loop(a, b, f)
  local n = a
  while n <= b do
    f(n)
    n = n+1
  end
end

print_n = function(n) print(n) end
print '1 to 10'
for_loop(10, 1, print_n)

print '10 to 1'
for_loop(10, 1, print_n)
