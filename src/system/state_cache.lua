local tiny = require('vendor.tiny')

local StateCache

local StateCache = tiny.processingSystem()
StateCache.filter = tiny.requireAll('position')

function StateCache:process(e)
  e.previous_position = e.position:clone()
end

return StateCache
