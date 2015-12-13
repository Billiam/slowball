local tiny = require('vendor.tiny')

local Lerper

local Lerper = tiny.processingSystem()
Lerper.drawable = true

Lerper.filter = tiny.requireAll('position', 'previous_position')

function Lerper:process(e)
  e.lerp_position = e.previous_position:lerp(e.position, self.world.lerp_amount)
end

return Lerper
