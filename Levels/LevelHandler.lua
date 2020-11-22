--[[Used to load current level, next level and so on.
    Also handles destroying levels, drawing levels and
    returning spawn coordinates for the player.
    LevelList is used to load the correct level. Active level
    should be set to true. LevelInit table gets leveldata from
    the Levels file, this data is then asigned to the Blocks table.
    ]]--

require("Levels.Levels")

LevelHandler = {}

local Stages = Levels:getLevels()


grassPositions = {}

function LevelHandler:initGrassPositions()
    for i = 1, 150, 1 do
        grassPositions[i] = {x,y}
    end
end

Levelinit = {}
for i = 1, #Stages, 1 do
    Levelinit[i] = Stages[i]
end
local testNum = 0

World = 0
SpeedRun = false
local isPlaying = false
local leveldata
local blocks
local dLocations
local newLevelUnlock = false
local secretLevel = false
local changing = false

function LevelHandler:initDiamonds()
    dLocations = {}
    for i = 0, 20, 1 do
        dLocations[i] = {x, y, v}
    end
end

--Initializes all "blocks" (where each level stores data such as physics bodies, fixtures and shapes)--
function LevelHandler:initBlocks()
    blocks = {}
    for i = 0, 250, 1 do
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
    if World == 9 then
        LevelList[41] = true
    end
    if World == 10 then
        LevelList[45] = true
    end
    if World == 11 then
        LevelList[49] = true
    end
    if World == 12 then
        LevelList[53] = true
    end
    if World == 13 then
        LevelList[57] = true
    end
    if World == 0 then
        LevelList[61] = true
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
    for i = 1, #dLocations, 1 do
        dLocations[i] = nil 
    end
end
--Calls dispose function, sets current leveList value to false and the next one to true--
function LevelHandler:next(goBack)
    isPlaying = true
    LevelHandler:dispose()
    local matchFound = false
    for i = 0, #LevelList, 1 do
        if matchFound then
            matchFound = false
            if goBack then
                i = i - 2
                LevelList[i] = true
                value = i
                break
            else
                LevelList[i] = true
                value = i
                break
            end
        end
        if LevelList[i] == true then
            LevelList[i] = false
            matchFound = true
        end
    end
    changing = true
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
            elseif leveldata[i][1] == "return" then
                blocks[i].s = p.newRectangleShape(leveldata[i][4], leveldata[i][5])
                blocks[i].f = p.newFixture(blocks[i].b, blocks[i].s)
                blocks[i].f:setUserData("return")
            elseif leveldata[i][1] == "bounceRight" then
                blocks[i].s = p.newRectangleShape(leveldata[i][4], leveldata[i][5])
                blocks[i].f = p.newFixture(blocks[i].b, blocks[i].s)
                blocks[i].f:setUserData("bounceRight")
            elseif leveldata[i][1] == "bounceLeft" then
                blocks[i].s = p.newRectangleShape(leveldata[i][4], leveldata[i][5])
                blocks[i].f = p.newFixture(blocks[i].b, blocks[i].s)
                blocks[i].f:setUserData("bounceLeft")
            elseif leveldata[i][1] == "bounceUp" then
                blocks[i].s = p.newRectangleShape(leveldata[i][4], leveldata[i][5])
                blocks[i].f = p.newFixture(blocks[i].b, blocks[i].s)
                blocks[i].f:setUserData("bounceUp")
            elseif leveldata[i][1] == "bounceUpSmall" then
                blocks[i].s = p.newRectangleShape(leveldata[i][4], leveldata[i][5])
                blocks[i].f = p.newFixture(blocks[i].b, blocks[i].s)
                blocks[i].f:setUserData("bounceUpSmall")
            else
                blocks[i].s = p.newRectangleShape(leveldata[i][4], leveldata[i][5])
                blocks[i].f = p.newFixture(blocks[i].b, blocks[i].s)
            end
            for v = 0, 13, 1 do
                if leveldata[i][1] == "goal"..tostring(v) then
                    blocks[i].s = p.newRectangleShape(leveldata[i][4], leveldata[i][5])
                    blocks[i].f = p.newFixture(blocks[i].b, blocks[i].s)
                    blocks[i].f:setUserData("goal"..tostring(v))
                    testNum = tostring(v)
                end
            end
        end
    end
    currentSpawn = leveldata.spawn
    textboxLocation = leveldata.textboxLocation
    for i = 1, #leveldata.grassLocations, 1 do
        grassPositions[i].x = leveldata.grassLocations[i][1]
        grassPositions[i].y = leveldata.grassLocations[i][2]
    end
    for i = 1, #leveldata.diamondLocations, 1 do
        dLocations[i].x = leveldata.diamondLocations[i][1]
        dLocations[i].y = leveldata.diamondLocations[i][2]
    end
    if leveldata.levelType ~= nil then
        levelType = leveldata.levelType
    end
    Diamonds:init()
    Grass:init()
end
--Loads the current level depending on LevelList value--
function LevelHandler:loadCurrentLevel(secret)
    LevelHandler:initBlocks()
    LevelHandler:initDiamonds()
    LevelHandler:initGrassPositions()
    p.setMeter(100)
    w = p.newWorld(0, 12.8*p.getMeter(), true)
    w:setCallbacks(beginContact, endContact)
    persisting = 0
    for i = 0, #LevelList, 1 do
        if LevelList[i] == true then
            if i == 1 then
                Levels:changeColor("yellow")
                newLevelUnlock = true
                if Player:checkLives() <= 9 then
                    Player:initLives()
                end
            end
            if i == 6 then
                Levels:changeColor("greenish")
                DataHandler:saveGame(2)
                if Player:checkLives() <= 9 then
                    Player:initLives()
                    newLevelUnlock = true
                end
            end
            if i == 11 then
                Levels:changeColor("blueish")
                DataHandler:saveGame(3)
                if Player:checkLives() <= 9 then
                    Player:initLives()
                    newLevelUnlock = true
                end
            end
            if i == 16 then
                Levels:changeColor("red")
                DataHandler:saveGame(4)
                if Player:checkLives() <= 9 then
                    Player:initLives()
                    newLevelUnlock = true
                end
            end
            if i == 21 then
                Levels:changeColor("blue")
                DataHandler:saveGame(5)
                if Player:checkLives() <= 9 then
                    Player:initLives()
                    newLevelUnlock = true
                end
            end
            if i == 26 then
                Levels:changeColor("lightYellow")
                DataHandler:saveGame(6)
                if Player:checkLives() <= 9 then
                    Player:initLives()
                    newLevelUnlock = true
                end
            end
            if i == 31 then
                Levels:changeColor("lightPurple")
                DataHandler:saveGame(7)
                if Player:checkLives() <= 9 then
                    Player:initLives()
                    newLevelUnlock = true
                end
            end
            if i == 36 then
                Levels:changeColor("lightOrange")
                DataHandler:saveGame(8)
                if Player:checkLives() <= 9 then
                    Player:initLives()
                    newLevelUnlock = true
                end
            end
            if i == 41 then
                Levels:changeColor("lightPink")
                DataHandler:saveGame(9)
                if Player:checkLives() <= 9 then
                    Player:initLives()
                    newLevelUnlock = true
                end
            end
            if i == 45 then
                Levels:changeColor("orange")
                DataHandler:saveGame(10)
                if Player:checkLives() <= 9 then
                    Player:initLives()
                    newLevelUnlock = true
                end
            end
            if i == 49 then
                Levels:changeColor("otherRed")
                DataHandler:saveGame(11)
                if Player:checkLives() <= 9 then
                    Player:initLives()
                    newLevelUnlock = true
                end
            end
            if i == 53 then
                Levels:changeColor("veryLightPink")
                DataHandler:saveGame(12)
                if Player:checkLives() <= 9 then
                    Player:initLives()
                    newLevelUnlock = true
                end
            end
            if i == 57 then
                Levels:changeColor("purple")
                DataHandler:saveGame(13)
                if Player:checkLives() <= 9 then
                    Player:initLives()
                    newLevelUnlock = true
                end
            end
            if i == 61 then
                Levels:changeColor("pink")
            end

            if secret ~= nil then
                secretLevel = true
                leveldata = Levelinit[i].s
            else
                secretLevel = false
                leveldata = Levelinit[i]
            end
            LevelHandler:loadLevelData(leveldata)
            if States.menu ~= true then
                Text:reset()
                Text:dialogSetup1("Lives:"..Player:checkLives())
                if secret ~= nil then
                    Text:dialogSetup(Text:storylineSecret(Levelinit[i].s.num))
                else
                    Text:dialogSetup(Text:storyline(i))
                end
            end
            break
        end
    end
    if States.menu ~= true then
        Text:moveUp()
    end
    if isPlaying == false then
        Player:init(LevelHandler:playerSpawnLocation())
    end
end

--Draws the level
function LevelHandler:drawLevel()
    g.setColor(LevelHandler:colors(2))
    
    g.rectangle("fill", -3000, -1200, 9180, 9020)
    
    g.setColor(LevelHandler:colors(1))

    for i = 1, #blocks, 1 do
        if blocks[i].b ~= nil then
            if blocks[i].f:getUserData() ~= nil then
                if blocks[i].f:getUserData() == "goal" or blocks[i].f:getUserData() == "secret" then
                    g.setColor(1.0, 1.0, 1.0, 0.0)
                end

                for v = 0, 13, 1 do
                    if blocks[i].f:getUserData() == "goal"..tostring(v) then
                        g.setColor(1.0, 1.0, 1.0, 0.0)
                    end
                end
            end

            g.polygon("fill", blocks[i].b:getWorldPoints(blocks[i].s:getPoints()))
            g.setColor(LevelHandler:colors(1))
        else
            break
        end
    end
    for i = 1, 4, 1 do
        if levelType == "long" then
            g.rectangle("fill", Stages.borders2[i][1], Stages.borders2[i][2], Stages.borders2[i][3], Stages.borders2[i][4])
        elseif levelType == "high" then
            g.rectangle("fill", Stages.borders1[i][1], Stages.borders1[i][2], Stages.borders1[i][3], Stages.borders1[i][4])
        elseif levelType == "normal" then
            g.rectangle("fill", Stages.borders[i][1], Stages.borders[i][2], Stages.borders[i][3], Stages.borders[i][4])
        end
    end
    if LevelHandler:getCurrentLevel() == 62 then
        g.printf("1", -2895, 560, 400, "center", 0, 1)
        g.printf("2", -2595, 560, 400, "center", 0, 1)
        g.printf("3", -2295, 560, 400, "center", 0, 1)
        g.printf("4", -1995, 560, 400, "center", 0, 1)
        g.printf("5", -1695, 560, 400, "center", 0, 1)
        g.printf("6", -1395, 560, 400, "center", 0, 1)
        g.printf("7", -1095, 560, 400, "center", 0, 1)
        g.printf("8", -795, 560, 400, "center", 0, 1)
        g.printf("9", -495, 560, 400, "center", 0, 1)
        g.printf("10", -195, 560, 400, "center", 0, 1)
        g.printf("11", 100, 560, 400, "center", 0, 1)
        g.printf("12", 400, 560, 400, "center", 0, 1)
        g.printf("13", 700, 560, 400, "center", 0, 1)
    end
    --g.printf(tostring(testNum - 1), -2444, 500, 400, "center", 0, 1)
end
--Returns spawn location depending on which level is active
function LevelHandler:playerSpawnLocation()
    local x, y
    x = leveldata.spawn[1]
    y = leveldata.spawn[2]
    return x, y
end

function LevelHandler:playerReturnSpawnLocation()
    local x, y
    if leveldata.ReturnSpawn ~= nil then
        x = leveldata.ReturnSpawn[1]
        y = leveldata.ReturnSpawn[2]
        return x, y
    else
        return nil 
    end
end

function LevelHandler:textboxLocation()
    local x, y
    x = leveldata.textboxLocation[1]
    y = leveldata.textboxLocation[2]
    return x, y
end

function LevelHandler:colors(colorChoice)
    local colorBg = Levels:getBackgroundColor()
    local color = Levels:getColour()
    
    if colorChoice == 1 then
        return color.r, color.g, color.b
    elseif colorChoice == 2 then
        return colorBg.r, colorBg.g, colorBg.b
    end
end

function LevelHandler:getDiamondsLocation()
    local dLoc = {}
    for i = 1, #dLocations, 1 do
        if dLocations[i].x ~= nil then
            dLoc[i] = dLocations[i]
        end
    end
    return dLoc
end

function LevelHandler:textboxColor()
    local color
    if leveldata ~= nil then
        color = leveldata.textboxColor
        return color
    end
end

--If leveldata contains .gravitychange then gravity can be changed
function LevelHandler:returnGravityChange()
    if leveldata.gravityChange ~= nil then
        return leveldata.gravityChange
    else
        return false
    end
end

function LevelHandler:getGrass()
    return grassPositions
end

function LevelHandler:getCurrentLevel()
    local ActiveLevel = LevelList
    for i = 1, #ActiveLevel, 1 do
        if ActiveLevel[i] == true then
            return i
        end
    end
end

function LevelHandler:getSecretLevel()
    if secretLevel then
        return true
    end
end

function LevelHandler:getUnder10Lives()
    local newLevel = newLevelUnlock
    newLevelUnlock = false
    return newLevel
end