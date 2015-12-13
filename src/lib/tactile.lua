local tactile = require('vendor.tactile')

tactile.buttons = {}

tactile.clearButtons = function()
  tactile.buttons = {}
end

tactile.updateButtons = function()
  for i,button in ipairs(tactile.buttons) do
    button:update()
  end
end

local originalButton = tactile.newButton

tactile.newButton = function(...)
  local btn = originalButton(...)
  
  table.insert(tactile.buttons, btn)
  
  return btn
end
