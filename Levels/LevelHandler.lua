--[[Used to load current level, next level and so on.
    Also handles destroying levels, drawing levels and
    returning spawn coordinates for the player.
    LevelList is used to load the correct level. Active level
    should be set to true. LevelInit table gets leveldata from
    the Levels file, this data is then asigned to the Blocks table.
    ]]--


require("Levels.Levels")


LevelHandler = {}

local Levels = Levels:getLevels()

Levelinit = {}

for i = 1, #Levels, 1 do
    Levelinit[i] = Levels[i]
end
--Maybe not set as a global variable? Think about that--
World = 0
local isPlaying = false
local leveldata
--Initializes all "blocks" (where each level stores data such as physics bodies, fixtures and shapes)--
function LevelHandler:initBlocks()
    blocks = {}
    for i = 0, 150, 1 do
        blocks[i] = {}
    end
end

function LevelHandler:loadLevels()
    if LevelList ~= nil then
        isPlaying = false
        LevelList = nil
    end
    LevelList = {}
    for i = 0, 100, 1 do
        LevelList[i] = {}
    end
    if World == 1 then
        LevelList[1] = true
    end
    if World == 2 then
        LevelList[6] = true
    end
    if World == 3 then
        LevelList[11] = true
    end
    if World == 4 then
        LevelList[16] = true
    end
    if World == 5 then
        LevelList[21] = true
    end
    if World == 6 then
        LevelList[26] = true
    end
    if World == 7 then
        LevelList[31] = true
    end
    if World == 8 then
        LevelList[36] = true
    end
    return LevelList
end
--Disposes of all the physics bodies, shapes and fixtures and destroys the physics world--
function LevelHandler:dispose()
    for i = 1, #blocks, 1 do
        if blocks[i].b ~= nil then
            blocks[i].b:destroy()
        end
    end
    blocks = nil
    w:destroy()
end
--Calls dispose function, sets current leveList value to false and the next one to true--
function LevelHandler:next()
    isPlaying = true
    LevelHandler:dispose()
    local matchFound = false
    for i = 0, #LevelList, 1 do
        if matchFound then
            matchFound = false
            LevelList[i] = true
            break
        end
        if LevelList[i] == true then
            LevelList[i] = false
            matchFound = true
        end
    end
    LevelHandler:loadCurrentLevel()
end

--Loads the level data and assigns data to the blocks
function LevelHandler:loadLevelData(leveldata)
    for i = 1, #leveldata, 1 do
        if type(leveldata[i][1]) == "number" then
            blocks[i].b = p.newBody(w, leveldata[i][1], leveldata[i][2], "static")
            blocks[i].s = p.newRectangleShape(leveldata[i][3], leveldata[i][4])
            blocks[i].f = p.newFixture(blocks[i].b, blocks[i].s)
            blocks[i].f:setUserData("normal")
        elseif type(leveldata[i][1]) == "string" then
            blocks[i].b = p.newBody(w, leveldata[i][2], leveldata[i][3], "kinematic")
            if leveldata[i][1] == "spike" then
                blocks[i].s = p.newPolygonShape(leveldata[i][4])
                blocks[i].f = p.newFixture(blocks[i].b, blocks[i].s)
                blocks[i].f:setUserData("spike")
            elseif leveldata[i][1] == "goal" then
                blocks[i].s = p.newRectangleShape(leveldata[i][4], leveldata[i][5])
                blocks[i].f = p.newFixture(blocks[i].b, blocks[i].s)
                blocks[i].f:setUserData("goal")
            elseif leveldata[i][1] == "secret" then
                blocks[i].s = p.newRectangleShape(leveldata[i][4], leveldata[i][5])
                blocks[i].f = p.newFixture(blocks[i].b, blocks[i].s)
                blocks[i].f:setUserData("secret")
            else
                blocks[i].s = p.newRectangleShape(leveldata[i][4], leveldata[i][5])
                blocks[i].f = p.newFixture(blocks[i].b, blocks[i].s)
            end
        end
    end
    currentSpawn = leveldata.spawn
end
--Loads the current level depending on LevelList value--
function LevelHandler:loadCurrentLevel(secret)
    LevelHandler:initBlocks()
    p.setMeter(100)
    w = p.newWorld(0, 12.8*p.getMeter(), true)
    w:setCallbacks(beginContact, endContact)
    persisting = 0

    for i = 0, #LevelList, 1 do
        if LevelList[i] == true then
            if i == 1 then
                effect.dmg.palette = "stark_bw"
                if speedrunMode then
                    speedrunTimerStart = love.timer.getTime()
                end
            end
            if i == 6 then
                effect.dmg.palette = "dark_yellow" --orange
                Player:initLives()
                DataHandler:saveGame(1)
            end
            if i == 11 then
                effect.dmg.palette = "light_yellow" --pink
                Player:initLives()
                DataHandler:saveGame(2)
            end
            if i == 16 then
                effect.dmg.palette = "green" --blue
                Player:initLives()
                DataHandler:saveGame(3)
            end
            if i == 21 then
                effect.dmg.palette = "greyscale" --red
                Player:initLives()
                DataHandler:saveGame(4)
            end
            if i == 26 then
                effect.dmg.palette = "pocket" --LimeGreen
                Player:initLives()
                DataHandler:saveGame(5)
            end
            if i == 31 then
                effect.dmg.palette = "dark_yellow" --turqoise
                Player:initLives()
                DataHandler:saveGame(6)
            end
            if i == 36 then
                effect.dmg.palette = "light_yellow"
                Player:initLives()
            end
            Text:moveDown()
            if secret ~= nil then
                leveldata = Levelinit[i].s
            else
                leveldata = Levelinit[i]
            end
            LevelHandler:loadLevelData(leveldata)
            Text:reset()
            if secret ~= nil then
                Text:dialogSetup(Text:storylineSecret(Levelinit[i].s.num))
            else
                Text:dialogSetup(Text:storyline(i))
            end
            break
        end
    end

    if not isPlaying then
        Player:init(LevelHandler:playerSpawnLocation())
    end
end
--Draws the level
function LevelHandler:drawLevel()
    love.graphics.setColor(0.4, 0.4, 0.4)
    love.graphics.rectangle("fill", 0, 0, 1280, 720)
    love.graphics.setColor(1, 1, 1)
    for i = 1, #blocks, 1 do
        if blocks[i].b ~= nil then
            if blocks[i].f:getUserData() ~= nil then
                if blocks[i].f:getUserData() == "goal" then
                    love.graphics.setColor(1, 1, 1, 0)
                elseif blocks[i].f:getUserData() == "secret" then
                    love.graphics.setColor(1, 1, 1, 0.5)
                end
            end
            g.polygon("fill", blocks[i].b:getWorldPoints(blocks[i].s:getPoints()))
            love.graphics.setColor(1, 1, 1)
        end
    end
end
--Returns spawn location depending on which level is active
function LevelHandler:playerSpawnLocation()
    local x, y
    x = leveldata.spawn[1]
    y = leveldata.spawn[2]
    return x, y
end
--If leveldata contains .gravitychange then gravity can be changed
function LevelHandler:returnGravityChange()
    if leveldata.gravityChange ~= nil then
        return leveldata.gravityChange
    else
        return false
    end
end