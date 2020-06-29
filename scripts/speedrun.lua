Speedrun = {}

function Speedrun:drawTime()
    if speedrunMode then
        local diff = 0
        if speedrunTimerStart ~= nil then
            diff = math.floor((love.timer.getTime() - speedrunTimerStart) * 1000)
        end
        if diff > 0 then
            local mil = math.floor(diff % 1000)
            local sec = math.floor(diff / 1000) % 60
            local min = math.floor(diff / 1000 / 60) % 60
            local hrs = math.floor(diff / 1000 / 60 / 60)
            local speedrunTime = ""

            if hrs > 0 then
                hrs = string.format("%02d", hrs)
                speedrunTime = speedrunTime..hrs..":"
            end
            if min > 0 or hrs > 0 then
                min = string.format("%02d", min)
                speedrunTime = speedrunTime..min..":"
            end

            sec = string.format("%02d", sec)
            mil = string.format("%03d", mil)
            speedrunTime = speedrunTime..sec.."."..mil

            local limit = 0
            local xpos = 0
            if State.game then
                love.graphics.setColor(0,0,0, 1)
                xpos = screenWidth/2 - 200
                limit = 300
            end
            if State.paused then
                love.graphics.setColor(1,1,1, 1)
                xpos = screenWidth/2 - 400
                limit = 700
            end
            
            love.graphics.printf(speedrunTime, xpos , 20, limit, "center", 0, 1.25)
        end
    end
end
