local Initializer = require('lib.initializer')
local State = require('vendor.state')
local Resource = require('resource')

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

