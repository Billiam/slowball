local tiny = require('vendor.tiny')
local tactile = require('vendor.tactile')
local beholder = require('vendor.beholder')

local Resource = require('resource')

local world

local update_filter = tiny.rejectAny('drawable')
local render_filter = tiny.requireAll('drawable')

local function initController()
  Resource.system.controllable:init()
end

local Game = {
  listeners = {}
}

function Game.enter()
  
  love.graphics.setBackgroundColor(130, 175, 200, 255)
  initController()
  
  Game.setup()
  Game.listeners.entity = beholder.observe('UPDATE_ENTITY', Game.entity_update)
end

function Game.entity_update(entity)
  world:addEntity(entity)
end

function Game.setup()
  world = tiny.world(
    Resource.system.slow_emitter,
    Resource.system.friction,
    Resource.system.controllable,
    Resource.system.inertia,
    Resource.system.collidable,
  
    Resource.system.kicking,
  
    Resource.system.tube_renderer,
    Resource.entity.ball(600, 500),
    Resource.entity.player(1, 200, 200)
  )
end

function Game.update(dt)
  tactile.updateButtons()
  world:update(dt, update_filter)
end

function Game.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end

function Game.draw()
  love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
  world:update(love.timer.getDelta(), render_filter)
end

return Game
