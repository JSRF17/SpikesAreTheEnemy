
--[[
    Draws a transition effect when transitioning from the menu.
]]--

Transition = {}

local color = ""
local transitioning = false

local curtain1 = {}
curtain1[1] = {x = 0, y = 1200} 


function Transition:init()
    if handle ~= nil then
        Timer.cancel(handle)
        Timer.cancel(handle1)
    end

    curtain1[1] = {x = 0, y = 1200, alpha = 0} 
end

function Transition:draw()
    g.setColor(1, 1, 1)

    if color == "" then
        g.setColor(1, 1, 1)
    else
        g.setColor(LevelHandler:colors(1))
    end

    g.rectangle("fill", curtain1[1].x, curtain1[1].y, 1280, 720)
end

function Transition:activate(choice, quicker)
    transitioning = true

    if choice then
        color = "asLevel"
    else
        color = ""
    end

    if quicker then
        handle1 = Timer.tween(0.82, curtain1[1], {y = 0}, 'in-out-quad')
    else
        handle1 = Timer.tween(1.3, curtain1[1], {y = 0}, 'in-out-quad')
    end
end

function Transition:down(quicker)
    if quicker then
        handle = Timer.tween(1, curtain1[1], {y = 1200}, 'in-out-quad')
    else
        handle = Timer.tween(1.3, curtain1[1], {y = 1200}, 'in-out-quad')
    end

    Timer.script(function(wait)
        wait(1.32)
        transitioning = false
    end)
end

function Transition:deathTransition()
    Transition:activate(true, true)
    
    Timer.script(function(wait)
        wait(1)
        Transition:down(true)
    end)
end

function Transition:getState()
    return transitioning
end