local Filters = {}

function Filters.requireAnySets(...)
  local callbacks = {...}

  return function(system, e)
    for i, c in ipairs(callbacks) do
      if c(system, e) then
        return true
      end
    end
    return false
  end
end

function Filters.requireSets(...)
  local callbacks = {... }
  
  return function(system, e)
    for i, c in ipairs(callbacks) do
      if not c(system, e) then
        return false
      end
    end
    return true
  end
end

return Filters
