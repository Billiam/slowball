local tiny = require('vendor.tiny')
local Filters = require('lib.system_filters')

local Slows = tiny.processingSystem()
Slows.filter = Filters.requireSets(
  tiny.requireAll('position'),
  tiny.requireAny('slowable', 'slow_radius')
)

local min_speed = 0.25
local slow_emitters = {}

function Slows:onAdd(entity)
  if entity.slow_radius then
    slow_emitters[entity] = true
  end
end

function Slows:onRemove(entity)
  if entity.slow_radius then
    slow_emitters[entity] = nil
  end
end

function Slows:process(e, dt)
  if e.slow_radius then
    return
  end

  for emitter in pairs(slow_emitters) do
    e.dt_modifier = min_speed + math.min(1, (emitter.position:dist(e.position)/emitter.slow_radius)) * (1-min_speed)
  end
end

return Slows
