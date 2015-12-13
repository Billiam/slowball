local beholder = require('vendor.beholder')
local EntityUpdate = {}

function EntityUpdate.mark(entity)
  beholder.trigger("UPDATE_ENTITY", entity)
end

function EntityUpdate.set(entity, field, value)
  local old = entity[field]

  entity[field] = value
  if old ~= value then
    EntityUpdate.mark(entity)
  end
end

return EntityUpdate
