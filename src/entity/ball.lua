local Vector = require('vendor.vector')

local Ball = function(x, y, speed, angle)
  return {
    position = Vector(x, y),
    velocity = Vector.fromAngle(angle or 0, speed or 0),
    mass = 3,
    radius = 30,

    friction = 0.5,

    color = {255, 255, 255, 255},
    line_width = 10,
    dt_modifier = 0.4,
    kickable = true,
    
    slow_radius = 300,
    
    tube = true,
    height = 64,
    collider = 'circle'
  }
end

return Ball
