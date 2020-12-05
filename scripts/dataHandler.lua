--[[
    Simple file for handling the save data, writes a value to a file, loads file and so on.
]]--

DataHandler = {}

local file = love.filesystem.newFile("datan.sav")
local fileSetttingSound = love.filesystem.newFile("settingSound.sav")
local fileSetttingMusic = love.filesystem.newFile("settingMusic.sav")
local fileSetttingControl = love.filesystem.newFile("settingControl.sav")
local fileSetttingControlV = love.filesystem.newFile("settingControlV.sav")
local VVVVVHigh = love.filesystem.newFile("VVVVV.sav")
local deathCount = love.filesystem.newFile("deathCount.sav")
local diamonds = love.filesystem.newFile("diamonds.sav")
local speedRunScore = love.filesystem.newFile("speedRun.sav")

function DataHandler:initVVVVV()
    local number = 0
    VVVVVHigh:open("w")
    VVVVVHigh:write(number)
    VVVVVHigh:close()
end

function DataHandler:VVVVVLoad()
    VVVVVHigh:open("r")
    local data = VVVVVHigh:read()
    VVVVVHigh:close()
    return data
end

function DataHandler:VVVVVSave(num)
    local Time = num
    if tonumber(DataHandler:VVVVVLoad()) < Time then
        VVVVVHigh:open("w")
        VVVVVHigh:write(Time)
        VVVVVHigh:close()
    end
end

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
    deathCount:open("w")
    deathCount:write(number)
    deathCount:close()
    diamonds:open("w")
    diamonds:write(number)
    diamonds:close()

    local score = "none"
    speedRunScore:open("w")
    speedRunScore:write(score)
    speedRunScore:close()
end

function DataHandler:addScore(inputScore)
    speedRunScore:open("r")
    local speedRunScore = tostring(speedRunScore:read())
    speedRunScore:close()
    local newCount = inputScore
    speedRunScore:open("w")
    speedRunScore:write(newCount)
    deathCount:close()
end

function DataHandler:getScore()
    speedRunScore:open("r")
    local currentScore = tostring(speedRunScore:read())
    speedRunScore:close()

    return currentScore
end

function DataHandler:add_death()
    deathCount:open("r")
    local currentCount = tostring(deathCount:read())
    deathCount:close()
    local newCount = currentCount + 1
    deathCount:open("w")
    deathCount:write(newCount)
    deathCount:close()
end

function DataHandler:getDeathCount()
    deathCount:open("r")
    local currentCount = tostring(deathCount:read())
    deathCount:close()

    return currentCount
end


function DataHandler:getDiamondCount()
    diamonds:open("r")
    local currentCount = tostring(diamonds:read())
    diamonds:close()

    return currentCount
end

function DataHandler:add_diamond()
    diamonds:open("r")
    local currentCount = tostring(diamonds:read())
    diamonds:close()
    local newCount = currentCount + 1
    diamonds:open("w")
    diamonds:write(newCount)
    diamonds:close()
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


