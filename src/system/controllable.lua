local tiny = require('vendor.tiny')
local tactile = require('vendor.tactile')
local Vector = require('vendor.vector')
local updater = require('lib.entity_update')

local Controllable = tiny.processingSystem()
Controllable.filter = tiny.requireAll('controllable')

local controller = {}

function Controllable:init()
  local keyboardLeft = tactile.key('left')
  local keyboardRight = tactile.key('right')
  local keyboardUp = tactile.key('up')
  local keyboardDown = tactile.key('down')
  
  local wasdUp = tactile.key('w')
  local wasdDown = tactile.key('s')
  local wasdLeft = tactile.key('a')
  local wasdRight = tactile.key('d')
  
  local keyboardXAxis = tactile.binaryAxis(keyboardLeft, keyboardRight)
  local keyboardYAxis = tactile.binaryAxis(keyboardUp, keyboardDown)

  local wasdXAxis = tactile.binaryAxis(wasdLeft, wasdRight)
  local wasdYAxis = tactile.binaryAxis(wasdUp, wasdDown)
  
  local gamepadXAxis = tactile.analogStick('leftx', 1)
  local gamepadYAxis = tactile.analogStick('lefty', 1)

  local gamepadA = tactile.gamepadButton('a', 1) --the second argument is controller number, in case you're wondering
  local gamepadR = tactile.gamepadButton('rightshoulder', 1)
  
  --controls
  controller.moveX = tactile.newAxis(keyboardXAxis, gamepadXAxis, wasdXAxis)
  controller.moveY = tactile.newAxis(keyboardYAxis, gamepadYAxis, wasdYAxis)
  controller.kick = tactile.newButton(gamepadA, gamepadR)
end

function Controllable:process(e, dt)
  e.velocity = (e.velocity + Vector(controller.moveX:getValue(), controller.moveY:getValue()) * e.torque * dt * (e.dt_modifier or 1)):trimmed(e.max_speed)
  updater.set(e, 'kicking', controller.kick:pressed() or nil)
end

return Controllable
