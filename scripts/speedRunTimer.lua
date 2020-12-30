--[[Everything related to text while playing the main game (text relevant
    to menus etc will be defined in the menu file)]]--

SpeedRunTimer = {}

local font = love.graphics.newFont("resources/jackeyfont.ttf", 25.5)

local timer = 0.0

function SpeedRunTimer:init()
    timer = 0.0
    count = 0
    active = true
end

function SpeedRunTimer:update(dt)
    count = count + dt
    if active then
        if count > 0.1 then
            timer = timer + 0.1
            count = 0
        end
    end
end

function SpeedRunTimer:draw()
    local x, y = Text:getPosition()
    g.printf(tostring(string.format("(%.1f)",timer)), x + 950, y, 2500)
end

function SpeedRunTimer:stopAndGetScore()
    active = false
    return tostring(timer)
end