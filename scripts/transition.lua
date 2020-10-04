
--[[
    Draws a transition effect when transitioning from the menu.
]]--

Transition = {}

local curtain1 = {}
curtain1[1] = {x = 0, y = 1200} 

function Transition:init()
    curtain1[1] = {x = 0, y = 1200} 
end

function Transition:draw()
    g.setColor(1, 1, 1)
    g.rectangle("fill", curtain1[1].x, curtain1[1].y, 2000, 720)
end

function Transition:activate()
    local function move()
        Timer.tween(1.3, curtain1[1], {y = 0}, 'in-out-quad')
        Timer.script(function(wait)
            wait(2.4)
            Timer.tween(1.3, curtain1[1], {y = 1200}, 'in-out-quad')
        end)
    end
    move()
end