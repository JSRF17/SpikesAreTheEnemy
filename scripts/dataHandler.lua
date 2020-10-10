--[[
    Simple file for handling the save data, writes a value to a file, loads file and so on.
]]--

DataHandler = {}

local file = love.filesystem.newFile("datan.sav")
local fileSetttingSound = love.filesystem.newFile("settingSound.sav")
local fileSetttingMusic = love.filesystem.newFile("settingMusic.sav")
local fileSetttingControl = love.filesystem.newFile("settingControl.sav")
local fileSetttingControlV = love.filesystem.newFile("settingControlV.sav")

function DataHandler:loadSettings(choice)
    fileSetttingSound:open("r")
    fileSetttingMusic:open("r")
    fileSetttingControl:open("r")
    fileSetttingControlV:open("r")

    local data = {}
    data[1] = tostring(fileSetttingSound:read())
    data[2] = tostring(fileSetttingMusic:read())
    data[3] = tostring(fileSetttingControl:read())
    data[4] = tostring(fileSetttingControlV:read())

    fileSetttingSound:close()
    fileSetttingSound:close()
    fileSetttingMusic:close()
    fileSetttingControl:close()
    fileSetttingControlV:close()
    
    return data
end

function DataHandler:loadGame()
    file:open("r")
    local data = file:read()
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

function DataHandler:saveSetting(setting, type)
    local setting = setting
    local type = type
    if type == "sound" then
        fileSetttingSound:open("w")
        fileSetttingSound:write(setting)
        fileSetttingSound:close()
    elseif type == "music" then
        fileSetttingMusic:open("w")
        fileSetttingMusic:write(setting)
        fileSetttingMusic:close()
    elseif type == "dPad" then
        fileSetttingControl:open("w")
        fileSetttingControl:write(setting)
        fileSetttingControl:close()
    elseif type == "vissibleControls" then
        fileSetttingControlV:open("w")
        fileSetttingControlV:write(setting)
        fileSetttingControlV:close()
    end
end

function DataHandler:init()
    local number = 0
    file:open("w")
    file:write(number)
    file:close()
end

function DataHandler:initSettings()
    fileSetttingSound:open("w")
    fileSetttingMusic:open("w")
    fileSetttingControl:open("w")
    fileSetttingControlV:open("w")
    fileSetttingSound:write("empty")
    fileSetttingMusic:write("empty")
    fileSetttingControl:write("empty")
    fileSetttingControlV:write("empty")
    fileSetttingSound:close()
    fileSetttingMusic:close()
    fileSetttingControl:close()
    fileSetttingControlV:close()
end


