--[[
    Simple file for handling the save data, writes a value to a file, loads file and so on.
]]

DataHandler = {}

local file = love.filesystem.newFile("datan.sav")

function DataHandler:loadGame()
    if not CheatCodes:getSpeedrunMode() then
        file:open("r")
        data = file:read()
        file:close()
        return data
    else
        return CheatCodes:getSpeedrunWorld()
    end
end

function DataHandler:saveGame(world)
    if CheatCodes:getSpeedrunMode() and CheatCodes:getSpeedrunWorld() < world then
        return CheatCodes:setSpeedrunWorld(world)
    end
    if tonumber(DataHandler:loadGame()) < world then
        file:open("w")
        file:write(world)
        file:close()
    end
end

function DataHandler:init()
    local number = 0
    file:open("w")
    file:write(number)
    file:close()
end
