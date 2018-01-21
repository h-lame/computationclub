scheduler = require 'scheduler'

function punch()
  for i = 1, 5 do
    scheduler.wait(1.0)
    print('punch '.. i)
  end
end

function block()
  for i = 1, 3 do
    scheduler.wait(2.0)
    print('block '.. i)
  end
end

scheduler.schedule(0.0, coroutine.create(punch))
scheduler.schedule(0.0, coroutine.create(block))

scheduler.run()
