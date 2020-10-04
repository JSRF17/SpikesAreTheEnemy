--[[
    Calls different functions in the menuSystem file
]]--

Pause = {}

function Pause:loadMenu()
    MenuSystem:init(2)
   --MenuSystem:state()
end

function Pause:update()
    MenuSystem:update()
    MenuSystem:Animate()
end

function Pause:draw()
    MenuSystem:draw()
end

