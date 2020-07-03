Speedrun = {}
local speedrunTime = 0
local speedrunTimerStart

function Speedrun:update()
    if speedrunTimerStart ~= nil and LevelHandler:getCurrentLevel() ~= 40 then
        speedrunTime = math.floor((love.timer.getTime() - speedrunTimerStart) * 1000)
    end
end

function Speedrun:init()
    if CheatCodes:getSpeedrunMode() then
        speedrunTimerStart = love.timer.getTime()
    else
        Speedrun:destroy()
    end
end

function Speedrun:destroy()
    speedrunTimerStart = nil
    speedrunTime = 0
    CheatCodes:setSpeedrunMode(false)
end

function Speedrun:drawTime()
    if CheatCodes:getSpeedrunMode() then
        local diff = speedrunTime
        Speedrun:update()
        if diff > 0 then
            local mil = math.floor(diff % 1000)
            local sec = math.floor(diff / 1000) % 60
            local min = math.floor(diff / 1000 / 60) % 60
            local hrs = math.floor(diff / 1000 / 60 / 60)
            local string = ""

            if hrs > 0 then
                string = string..string.format("%02d", hrs)..":"
            end
            if min > 0 or hrs > 0 then
                string = string..string.format("%02d", min)..":"
            end
            string = string..string.format("%02d", sec).."."..string.format("%03d", mil)

            local limit = 0
            local xpos = 0
            local ypos = 20
            if State.game then
                love.graphics.setColor(0,0,0, 1)
                xpos = windowWidth/2 - 200
                limit = 300
                if LevelHandler:getCurrentLevel() == 40 then
                    ypos = windowHeight/2 - 100
                end
            end
            if State.paused then
                love.graphics.setColor(1,1,1, 1)
                xpos = windowWidth/2 - 400
                limit = 700
            end
            
            love.graphics.printf(string, xpos , ypos, limit, "center", 0, 1.25)
        end
    end
end
