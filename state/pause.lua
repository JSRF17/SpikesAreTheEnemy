--[[
    Pause menu
]]--

Pause = {}

function Pause:loadMenu(state)
    MenuSystem:init(2, state)
end

function Pause:update(dt)
    MenuSystem:update(dt)
    MenuSystem:Animate()
end

function Pause:draw()
    g.setColor(LevelHandler:colors(2))
    g.rectangle("fill", -3000, -1200, 9180, 9020)
    g.setColor(LevelHandler:colors(1))
    MenuSystem:draw()
end

