--[[
    Calls different functions in the menuSystem file
]]--

Menu = {}

function Menu:loadMenu()
    MenuSystem:init(1)
   --MenuSystem:state()
end

function Menu:update(dt)
    MenuSystem:update(dt)
    MenuSystem:Animate()
end

function Menu:draw()
    MenuSystem:draw()
end