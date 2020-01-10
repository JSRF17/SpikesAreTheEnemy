--[[
    Simple file for handling the save data, writes a value to a file, loads file and so on.
]]

DataHandler = {}

local file = love.filesystem.newFile("datan.sav")

function DataHandler:loadGame()
    file:open("r")
    data = file:read()
    file:close()
    return data
end

function DataHandler:saveGame(num)
    world = num
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


