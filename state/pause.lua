--[[
    Calls different functions in the menuSystem file
]]--

Pause = {}

function Pause:loadMenu(state)
    MenuSystem:init(2, state)
   --MenuSystem:state()
end

function Pause:update(dt)
    MenuSystem:update(dt)
    MenuSystem:Animate()
end

function Pause:draw()
    MenuSystem:draw()
end

