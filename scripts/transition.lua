
--[[
    Draws a transition effect when transitioning from the menu.
]]--

Transition = {}

local color = ""
local transitioning = false

local transitionComplete = true

local curtain1 = {}
curtain1[1] = {x = 0, y = 1200} 


function Transition:draw()
    g.setColor(1, 1, 1)

    if color == "" then
        g.setColor(1, 1, 1)
    else
        g.setColor(LevelHandler:colors(1))
    end
    g.rectangle("fill", curtain1[1].x, curtain1[1].y, 1780, 720)
end

function Transition:activate(choice, death)
    if choice then
        color = "asLevel"
    else
        color = ""
    end
    function move_down()
        Timer.tween(0.8, curtain1[1], {y = 1200}, 'in-out-quad')
    end

    if death then
        Timer.tween(0.8, curtain1[1], {y = 0}, 'in-out-quad', move_down)
    else
        transitioning = true
        Timer.tween(0.8, curtain1[1], {y = 0}, 'in-out-quad')
    end
end

function Transition:down()
   
    Timer.tween(0.8, curtain1[1], {y = 1200}, 'in-out-quad')

    Timer.script(function(wait)
        wait(0.9)
        transitioning = false
    end)
end

function Transition:deathTransition()
    Transition:activate(true, true)
    Timer.script(function(wait)
        wait(1.4)
        transitionComplete = true
    end)
end

function Transition:getState()
    return transitioning
end
