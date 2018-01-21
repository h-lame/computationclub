function retry(times, body)
  for i = 1, times do
    attempt = coroutine.create(body)
    _, yielded = coroutine.resume(attempt)
    if coroutine.status(attempt) == 'dead' then
      return yielded, i
    end
  end
  print("Retry count of "..times.." exceeded")
  return
end

math.randomseed(os.time())

print(retry(
  5,
  function()
    local eh = math.random()
    print(eh)
    if eh > 0.2 then
      coroutine.yield('Something bad hapened')
    end

    print('Succeeded')
  end
))
