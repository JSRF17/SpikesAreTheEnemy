
--[[
    Diamonds
]]--

Diamonds = {}

local diamond = g.newImage("resources/diamond2.png")
local getDiamondTable
local diamondTable = {}
for i = 1, 20, 1 do
    diamondTable[i] = {y, x, v}
end
local diamondTableRect = {}
for i = 1, 20, 1 do
    diamondTableRect[i] = {y, x, v}
end
local Done
local count = 0
local livesText = ""
local animationTime = 0
local yValue = 0

function Diamonds:count()
   count = count + 1
end

function Diamonds:init()
    for i = 1, 20, 1 do
        diamondTable[i] = {y, x, v}
    end
    for i = 1, 20, 1 do
        diamondTableRect[i] = {y, x, v}
    end
    getDiamondTable = LevelHandler:getDiamondsLocation()
    for i = 1, #getDiamondTable, 1 do
        diamondTable[i].y = getDiamondTable[i].y
        diamondTable[i].x = getDiamondTable[i].x
        diamondTableRect[i].x = getDiamondTable[i].x
        diamondTableRect[i].x = diamondTableRect[i].x
        diamondTableRect[i].y = getDiamondTable[i].y
        diamondTableRect[i].width = 55
        diamondTableRect[i].height = 45
        diamondTableRect[i].hit = false
    end
    for i = 1, #diamondTableRect, 1 do
        if diamondTableRect[i].x ~= nil then
            diamondTableRect[i].x = diamondTableRect[i].x - 20
            diamondTableRect[i].y = diamondTableRect[i].y - 20
        end
    end
    Done = "yas"
end

function Diamond:animate(dt)
    animationTime = animationTime + dt
    if animationTime > 0.1 then
        yValue = yValue + 1
        for i = 1, #diamondTable, 1 do
            if diamondTable[i].y ~= nil then
                diamondTableRect[i].y = diamondTableRect[i].y - yValue
            end
        end
        if yValue > 9 then
            yValue = 0
        end
        animationTime = 0
    end
end

function Diamonds:update()
    PlayerX = Player:getPositionX() 
    PlayerY = Player:getPositionY()
    --animate through a sprite sheet instead, using tweening seems to be a cpu hog
    --[[Timer.every(0.5, function()
        if Done == "yas" then
            for i = 1, #diamondTable, 1 do
                if diamondTable[i].y ~= nil then
                    Timer.tween(0.5, diamondTable[i], {y = diamondTable[i].y - 15}, 'in-out-quad')
                end
            end
            Done = "nas"
        elseif Done == "nas"then 
            for i = 1, #diamondTable, 1 do
                if diamondTable[i].y ~= nil then
                    Timer.tween(0.5, diamondTable[i], {y = diamondTable[i].y + 15}, 'in-out-quad')
                end
            end
            Done = "yas"
        end
    end)]]--
    for i = 1, #diamondTableRect, 1 do
        if diamondTableRect[i].y ~= nil and diamondTableRect[i].hit == false and PlayerX ~= nil then
            if PlayerX >= diamondTableRect[i].x and PlayerX <= diamondTableRect[i].x + diamondTableRect[i].width
            and PlayerY >= diamondTableRect[i].y and PlayerY <= diamondTableRect[i].y + diamondTableRect[i].height then
                Timer.tween(1, diamondTable[i], {y = diamondTable[i].y - 2000}, 'in-out-quad')
                diamondTableRect[i].hit = true
                Diamonds:count()
                SoundHandler:PlaySound("coin")
            end
        end
    end
    if count == 10 then
        count = 0
        livesText = "5 up!"
        Timer.script(function(wait)
            wait(2)
            livesText = ""
        end)
        Player:bonusLives()
        Text:dialogSetup1("Lives:"..Player:checkLives())
    end
end

function Diamonds:draw()
    g.setColor(LevelHandler:colors(1))
    for i = 1, #getDiamondTable, 1 do
        if i < 10 then
            g.draw(diamond, diamondTable[i].x, diamondTable[i].y, 0, 1, 1)
            if diamondTableRect[i].x ~= nil then
                g.rectangle("line", diamondTableRect[i].x, diamondTableRect[i].y, diamondTableRect[i].width, diamondTableRect[i].height)
            end
        end
    end
end

function Diamonds:countReset()
    count = 0
end

function Diamonds:drawCount()
    g.setColor(0.2, 0.2, 0.2, 0.7)
    g.rectangle("fill", 600, 20, 80, 50)
    g.setColor(LevelHandler:colors(1))
    font = love.graphics.newFont("resources/jackeyfont.ttf", 25)
    love.graphics.setFont(font)
    if livesText ~= "" then
        g.printf(livesText, 444, 30, 400, "center", 0, 1)
    else
        g.printf("D:"..count, 444, 30, 400, "center", 0, 1)
    end
end