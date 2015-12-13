local Vector = require('vendor.vector')

local Player = function(id, x, y, speed, angle)
  return {
    player_id = id or 1,
    position = Vector(x, y),
    velocity = Vector.fromAngle(angle or 0, speed or 0),
    radius = 15,
    mass = 8,
    torque = 3200,

    controllable = true,
    -- very high friction
    friction = 0.9995,

    color = {218, 231, 239, 255},
    line_width = 4,
  
--    slowable = true,
    max_speed = 640,
    
    kick_force = 300,
    kick_distance = 10,
    
    tube = true,
    height = 8,
    collider = 'circle'
  }
end

return Player
