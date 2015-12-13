local tiny = require('vendor.tiny')
local Filters = require('lib.system_filters')

local Kicking = tiny.processingSystem()

Kicking.filter = Filters.requireAnySets(
  tiny.requireAll('kicking', 'kick_force', 'kick_distance'),
  tiny.requireAll('kickable', 'mass')
)

local kickable_things = {}

function Kicking:onAdd(entity)
  if entity.kickable then
    kickable_things[entity] = #kickable_things + 1
    table.insert(kickable_things, entity)
  end
end

function Kicking:onRemove(entity)
  if entity.kickable then
    local i = kickable_things[entity]
    if i then
      table.remove(kickable_things, i)
      kickable_things[entity] = nil
    end
  end
end

function Kicking:process(e, dt)
  if e.kickable then
    return
  end
  
  local len = #kickable_things
  local kickable
  
  for i=1, len do
    kickable = kickable_things[i]
    local difference = kickable.position - e.position
  
    local distance = difference:len() - (e.radius + kickable.radius)
    if distance < e.kick_distance then
      local normal = difference:normalized()
      local kicking_speed = e.velocity * normal
      local kicking_velocity = math.max(0, kicking_speed) * normal

      kickable.velocity = kickable.velocity + kicking_velocity + normal * e.kick_force
    end
  end
end

return Kicking
