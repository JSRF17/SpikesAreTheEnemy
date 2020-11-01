--[[
    Calls different functions in the menuSystem file
]]--

Pause = {}

function Pause:loadMenu()
    MenuSystem:init(2)
   --MenuSystem:state()
end

function Pause:update(dt)
    MenuSystem:update(dt)
    MenuSystem:Animate()
end

function Pause:draw()
    MenuSystem:draw()
end

