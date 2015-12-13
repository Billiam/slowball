local tiny = require('vendor.tiny')

local TubeRenderer = tiny.processingSystem()
TubeRenderer.filter = tiny.requireAll('tube', 'height', 'radius', 'position', 'color', 'line_width')

function TubeRenderer.compare(e1, e2)
  return e1.position.y < e2.position.y
end

function TubeRenderer:process(e, dt)
  self:render(e, dt)
end

function TubeRenderer:preProcess()
  table.sort(self.entities, self.compare)
end

function TubeRenderer:render(e, dt)
  love.graphics.push()
  --TODO: scale field globally...?
  love.graphics.scale(1, 0.65)
  
  love.graphics.setColor(e.color)
  love.graphics.setLineWidth(e.line_width)
  
  --shadow
  love.graphics.setStencil(function()
    love.graphics.circle("fill", e.position.x, e.position.y, e.radius, math.sqrt(e.radius) * 5)
    love.graphics.circle("fill", e.position.x, e.position.y + e.height * 0.7, e.radius, math.sqrt(e.radius) * 5)
    love.graphics.rectangle("fill", e.position.x - e.radius, e.position.y, e.radius * 2, e.height * 0.7)
  end)
  love.graphics.setColor(0, 0, 0, 50)
  love.graphics.rectangle("fill", e.position.x - e.radius, e.position.y - e.radius, e.radius * 2, e.height * 0.7 + e.radius * 2)
  
  --back wall
  love.graphics.setColor(200, 200, 200, 200)
  love.graphics.setInvertedStencil(function()
    love.graphics.circle("fill", e.position.x, e.position.y, e.radius - e.line_width, math.sqrt(e.radius - e.line_width) * 5)
  end)
  love.graphics.circle("fill", e.position.x, e.position.y - e.height, e.radius - e.line_width, math.sqrt(e.radius - e.line_width) * 5)
  love.graphics.setStencil()

  --bottom
  love.graphics.setInvertedStencil(function()
    love.graphics.circle("fill", e.position.x, e.position.y - e.height, e.radius - e.line_width, math.sqrt(e.radius - e.line_width) * 5)
  end)
  love.graphics.setColor(220, 220, 220, 200)
  love.graphics.arc("fill", e.position.x, e.position.y, e.radius, 0, math.pi,  math.sqrt(e.radius) * 2.5)

  -- top
  love.graphics.rectangle("fill", e.position.x - e.radius, e.position.y - e.height, e.radius * 2, e.height)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.circle("fill", e.position.x, e.position.y - e.height, e.radius, math.sqrt(e.radius) * 5)

  love.graphics.setStencil()
  love.graphics.pop()
end

return TubeRenderer
