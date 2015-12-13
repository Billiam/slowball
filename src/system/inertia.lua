local tiny = require('vendor.tiny')

local Inertia = tiny.processingSystem()
Inertia.filter = tiny.requireAll('velocity', 'position')

function Inertia:process(e, dt)
  e.position = e.position + e.velocity * dt * (e.dt_modifier or 1)
end

return Inertia
