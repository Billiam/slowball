local hc = require('vendor.hc')
local tiny = require('vendor.tiny')

local collider

local Collidable = tiny.processingSystem()
Collidable.filter = tiny.requireAll('collider', 'position')

function Collidable:onAddToWorld()
  collider = hc.new()
end

function Collidable:onRemoveFromWorld()
  collider = nil
end

function Collidable:onAdd(e)
  if e.collider == 'circle' then
    local shape = collider:circle(e.position.x, e.position.y, e.radius)
    e.collider_ref = shape
    shape.ref = e
  else
    return
  end
end

function Collidable:onRemove(e)
  collider:remove(e.collider_ref)
  e.collider_ref = nil
end

function Collidable:process(e, dt) 
  e.collider_ref:moveTo(e.position.x, e.position.y)

  for shape, delta in pairs(collider:collisions(e.collider_ref)) do
    if shape.ref.radius then
      local target = shape.ref

      local normal = (target.position - e.position):normalized()
          
      -- get normal components of initial velocities
      local eNorm = e.velocity * normal
      local tNorm = target.velocity * normal

        -- ensure objects are moving toward each other
      if eNorm - tNorm > 0 then
        -- get tangent and components of initial velocities
        local tangent = normal:rotated(math.pi * 0.5)

        local eTan = e.velocity * tangent
        local tTan = target.velocity * tangent

        -- collision response
        local total_mass = e.mass + target.mass

        local eNormNew = ((eNorm * (e.mass - target.mass)) + (2 * target.mass * tNorm)) / total_mass
        local tNormNew = ((tNorm * (target.mass - e.mass)) + (2 * e.mass * eNorm)) / total_mass

        target.velocity = normal * tNormNew + tangent * tTan
        e.velocity = normal * eNormNew + tangent * eTan
      end

      local current_distance = (target.position - e.position):len()
      local min_distance = target.radius + e.radius

      -- Ensure objects are not overlapping
      if current_distance < min_distance then
        local push_vector = normal * (min_distance - current_distance)/2
        target.position = target.position + push_vector -- could multiply these values by mass ratio
        e.position = e.position - push_vector
      end
    end
  end
end

return Collidable
