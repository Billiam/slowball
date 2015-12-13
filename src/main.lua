local Initializer = require('lib.initializer')
local State = require('vendor.state')
local Resource = require('resource')

local accumulator = 0
local update_rate = 1/60

local function init(arg)
  for _,argument in ipairs(arg) do
    if argument == '--debug' then
      io.stdout:setvbuf("no")

      local inspect = require('vendor.inspect')
      _G.dump = function(...) print(inspect(...)) end
    end
  end

  Initializer.init()
end

function love.load(arg)
  init(arg)
  State.switch(Resource.state.game)
end


function love.run()
  if love.math then
    love.math.setRandomSeed(os.time())
    for i=1,3 do love.math.random() end
  end

  if love.event then
    love.event.pump()
  end

  if love.load then love.load(arg) end

  -- We don't want the first frame's dt to include time taken by love.load.
  if love.timer then love.timer.step() end

  local dt = 0

  -- Main loop time.
  while true do
    -- Process events.
    if love.event then
      love.event.pump()
      for e,a,b,c,d in love.event.poll() do
        if e == "quit" then
          if not love.quit or not love.quit() then
            if love.audio then
              love.audio.stop()
            end
            return
          end
        end
        love.handlers[e](a,b,c,d)
      end
    end

    -- Update dt, as we'll be passing it to update
    if love.timer then
      love.timer.step()
      dt = love.timer.getDelta()
  
      accumulator = accumulator + dt
      while accumulator >= update_rate do
        love.update(update_rate)
        accumulator = accumulator - update_rate
      end
    else
      love.update(dt)
    end
    
    if love.window and love.graphics and love.window.isCreated() then
      love.graphics.clear()
      love.graphics.origin()
      if love.draw then love.draw() end
      love.graphics.present()
    end

    if love.timer then love.timer.sleep(0.001) end
  end
end

function love.update(dt)
  State.current().update(dt)
end

function love.draw()
  State.current().draw()
end

function love.joystickreleased(joystick, button)
  State.current().joystickreleased(joystick, button)
end

function love.joystickpressed(joystick, button)
  State.current().joystickpressed(joystick, button)
end

function love.keypressed(key)
  State.current().keypressed(key)
end

