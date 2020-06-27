
--[[
    Draws a curtain when switching levels. This way the player can't
    see when the previous level gets deloaded and the next levels gets
    loaded. Also creates a cool transition effect!
]]--

Curtain = {}
curtain = {}
curtain[1] = {rad = 1000, x = 2500, y = 300}
function Curtain:init(x, y)
    self.x = x
    self.y = y

end

function Curtain:destroy()

end

function Curtain:draw()
    g.setColor(1,1,1,1)
    g.circle("fill", curtain[1].x, curtain[1].y, curtain[1].rad)
end

function Curtain:move()
    local function move()
        Timer.tween(4.5, curtain[1], {x = -2000}, 'in-out-quad')

        Timer.script(function(wait)
            wait(5)
            Timer.tween(0, curtain[1], {x = 2500}, 'in-out-quad')
        end)
    end
    move()
end

function Curtain:moveFromLeft()
    curtain[1] = {rad = 1000, x = -2000, y = 300}
    local function move()
        Timer.tween(4, curtain[1], {x = 3000}, 'in-out-quad')

        Timer.script(function(wait)
            wait(5)
            Timer.tween(0, curtain[1], {x = 2500}, 'in-out-quad')

        end)
    end
    move()
end

function Curtain:moveUp()
    curtain[1] = {rad = 1200, x = 650, y = 2100}
    local function move()
        Timer.tween(5, curtain[1], {y = -2000}, 'in-out-quad')

        Timer.script(function(wait)
            wait(5)
            Timer.tween(0, curtain[1], {x = 2500, y = 300}, 'in-out-quad')
            curtain[1] = {rad = 1000, x = 2500, y = 300}
        end)
    end
    move()
end

