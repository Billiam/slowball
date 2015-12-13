local function Proxy(f)
  return setmetatable({}, {__index = function(self, k)
    local v = f(k)
    rawset(self, k, v)
    return v
  end})
end

local Resources = {}

function Resources.init()
  Resources.state = Proxy(function(k) return assert(love.filesystem.load('state/' .. k .. '.lua'))() end)
  Resources.entity = Proxy(function(k) return assert(love.filesystem.load('entity/' .. k .. '.lua'))() end)
  Resources.system = Proxy(function(k) return assert(love.filesystem.load('system/' .. k .. '.lua'))() end)
end

function Resources.reload()
  Resources.init()
end

Resources.init()

return Resources
