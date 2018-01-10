function ends_in_3(num)
  if string.sub(''..num, -1) == '3' then
    return true
  else
    return false
  end
end

print(ends_in_3(3))
print(ends_in_3(13))
print(ends_in_3(123))
print(ends_in_3(34))
print(ends_in_3(300.03))
print(ends_in_3(300.031))

-- cribbed this from https://en.wikipedia.org/wiki/Primality_test#Pseudocode
function is_prime(num)
  if num <= 1 then
    return false
  elseif num <= 3 then
    return true
  elseif num % 2 == 0 or num % 3 == 0 then
    return false
  end
  local i = 5
  while i^2 <= num do
    if num % i == 0 or num % (i + 2) == 0 then
      return false
    else
      i = i + 6
    end
  end
  return true
end

for i = 1, 100 do
  print(i.." is prime? ")
  print(is_prime(i))
end

function primes_ending_in_3(how_many)
  local reported = 0
  local number = 1
  while reported < how_many do
    if ends_in_3(number) and is_prime(number) then
      print(number)
      reported = reported + 1
    end
    number = number + 1
  end
end


primes_ending_in_3(50)
