local tiny = require('vendor.tiny')

local Friction = tiny.processingSystem()
Friction.filter = tiny.requireAll('velocity', 'friction')

function Friction:process(e, dt)
  e.velocity = e.velocity * math.pow(1 - e.friction, dt)
end

return Friction
