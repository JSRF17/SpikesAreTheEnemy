
--[[
    Handles logic for initializing, drawing, animating and updating diamonds that can be picked up in every level
]]--

Diamonds = {}

local font = love.graphics.newFont("resources/jackeyfont.ttf", 25)

local diamond = g.newImage("resources/diamondAnim2.png")
local frameCoordinates = {
    {1, 0, 27, 21},{30, 0, 27, 21},{59, 0, 27, 21},{88, 0, 27, 21},{117, 0, 27, 21},
    {146, 0, 27, 21},{175, 0, 27, 21},{204, 0, 27, 21},{233, 0, 27, 21},{74, 0, 27, 21}
}

local framesDiamond = {}
local currentFrame = 1
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
local moveTime = 0
local moveUp = true
local moveY = 0
local yValue = 0
local animateActive = true

function Diamonds:count()
   count = count + 1
end

function Diamonds:init()
    for i = 1, #frameCoordinates, 1 do
        framesDiamond[i] = g.newQuad(frameCoordinates[i][1],frameCoordinates[i][2],frameCoordinates[i][3],frameCoordinates[i][4],diamond:getDimensions())
    end
    activeFrame = framesDiamond[currentFrame]
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

function Diamonds:animate(dt)
    animationTime = animationTime + dt
    moveTime = moveTime + dt
    if animationTime > 0.03 then
        if animateActive then
            currentFrame = currentFrame + 1
            if currentFrame > 9 then
                currentFrame = 1
                animateActive = false
            end
            activeFrame = framesDiamond[currentFrame]
            animationTime = 0
        end
    end
    if animationTime > 2 then
        animationTime = 0
        animateActive = true
    end
    if moveTime > 0.01 then
        if moveUp then
            moveY = moveY + 0.3
        elseif moveUp ~= true then
            moveY = moveY - 0.3
        end
        if moveY > 9 then
            moveY = moveY - 0.3
            moveResetUp = true
        end
        if moveY < -9 then
            moveY = moveY + 0.3
            moveResetUp = false
        end
        if moveResetUp then
            moveY = moveY - 0.3
            moveUp = false
        elseif moveResetUp == false then
            moveY = moveY + 0.3
            moveUp = true
        end
    end
end

function Diamonds:update()
    PlayerX = Player:getPositionX() 
    PlayerY = Player:getPositionY()
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
    if count > 9 then
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
            g.draw(diamond, activeFrame, diamondTable[i].x, diamondTable[i].y + moveY, 0, 1, 1)
            if diamondTableRect[i].x ~= nil then
                --g.rectangle("line", diamondTableRect[i].x, diamondTableRect[i].y, diamondTableRect[i].width, diamondTableRect[i].height)
            end
        else
            break
        end
    end
end

function Diamonds:countReset()
    count = 0
end

function Diamonds:drawCount()
    g.setColor(0.3, 0.3, 0.3, 0.8)
    g.rectangle("fill", 600, 20, 80, 50)
    g.setColor(LevelHandler:colors(1))
    love.graphics.setFont(font)
    if livesText ~= "" then
        g.printf(livesText, 444, 30, 400, "center", 0, 1)
    else
        g.printf("D:"..count, 444, 30, 400, "center", 0, 1)
    end
end