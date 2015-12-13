Vector = require('vendor.vector')

function Vector.fromAngle(angle, speed)
  return Vector(speed * math.cos(angle), speed * math.sin(angle))
end
