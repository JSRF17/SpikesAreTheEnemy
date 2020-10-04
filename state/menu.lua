--[[
    Calls different functions in the menuSystem file
]]--

Menu = {}

function Menu:loadMenu()
    MenuSystem:init(1)
   --MenuSystem:state()
end

function Menu:update()
    MenuSystem:update()
    MenuSystem:Animate()
end

function Menu:draw()
    MenuSystem:draw()
end