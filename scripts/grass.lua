
--[[
    Handles logic for loading, initializing, drawing, updating and animating grass.
    Each grass patch is animated individually so that theu will move individually when the player runs our walks through them.
]]--

Grass = {}

local grass = g.newImage("resources/grass.png")
local frameCoordinates = {
    --GrassBig    
    {0, 0, 15, 14},{19, 0, 15, 14},{38, 0, 15, 14},{56, 0, 15, 14},{74, 0, 15, 14},
    --GrassSmall
    {0, 0, 15, 9},{19, 0, 15, 9},{38, 0, 15, 9},{56, 0, 15, 9},{74, 0, 15, 9}
}

local framesBigGrass = {}
local framesSmallGrass = {}

local currentFrame = 1
local currentFrameSmallGrass = 6
local animationTimeGrass = 0
local activeFrameBig = {}
local activeFrameSmall = {}
local tableOfGrass = {}
local randomTabel = {}
local animationComplete = false
local animationCompleteSmall = false

local grassHitboxes = {x,y,width,heigth}

function Grass:init()
    tableOfGrass = LevelHandler:getGrass()

    for i = 1, #tableOfGrass, 1 do
        grassHitboxes[i] = {x, y}
        grassHitboxes[i].x = tableOfGrass[i].x 
        grassHitboxes[i].y = tableOfGrass[i].y
        grassHitboxes[i].width = 58
        grassHitboxes[i].height = 30
        framesBigGrass[i] = {}
        framesSmallGrass[i] = {}
    end
    for i = 1, #grassHitboxes, 1 do 
        if grassHitboxes[i].x ~= nil then
            grassHitboxes[i].y = grassHitboxes[i].y - 35
            grassHitboxes[i].x = grassHitboxes[i].x - 30
        end
    end

    for i = 1, #frameCoordinates, 1 do
        for v = 1, #framesBigGrass, 1 do
            framesBigGrass[v][i] = g.newQuad(frameCoordinates[i][1],frameCoordinates[i][2],frameCoordinates[i][3],frameCoordinates[i][4],grass:getDimensions())
        end
        for z = 1, #framesSmallGrass, 1 do
            framesSmallGrass[z][i] = g.newQuad(frameCoordinates[i][1],frameCoordinates[i][2],frameCoordinates[i][3],frameCoordinates[i][4], grass:getDimensions())
        end
    end

    for i = 1, #tableOfGrass, 1 do
        activeFrameBig[i] = {touched, grass, static}
        activeFrameSmall[i] = {touched, grass, static}
    end
    for i = 1, #framesBigGrass, 1 do
        activeFrameBig[i].touched = false
        activeFrameBig[i].grass = framesBigGrass[i][currentFrame]
        activeFrameBig[i].static = framesBigGrass[i][currentFrame]
    end
    for i = 1, #framesSmallGrass, 1 do
        activeFrameSmall[i].touched = false
        activeFrameSmall[i].grass = framesSmallGrass[i][currentFrameSmallGrass]
        activeFrameSmall[i].static = framesSmallGrass[i][currentFrameSmallGrass]
    end

    math.randomseed(os.time())
    for i = 1, 150, 1 do
        randomTabel[i] = math.random(1,2)
    end

end

function Grass:animate(dt)
    animationTimeGrass = animationTimeGrass + dt
    if animationTimeGrass > 0.1 then
        if currentFrame < 4 then
            animationComplete = false
            currentFrame = currentFrame + 1
        else
            animationComplete = true
            currentFrame = 1
        end
        if currentFrameSmallGrass < 9 then
            animationCompleteSmall = false
            currentFrameSmallGrass = currentFrameSmallGrass + 1
        else
            animationCompleteSmall = true
            currentFrameSmallGrass = 6
        end
        for i = 1, #framesBigGrass, 1 do
            activeFrameBig[i].grass = framesBigGrass[i][currentFrame]
        end
        for i = 1, #framesSmallGrass, 1 do
            activeFrameSmall[i].grass = framesSmallGrass[i][currentFrameSmallGrass]
        end
        animationTimeGrass = 0
    end
end

function Grass:update()
    PlayerX = Player:getPositionX() 
    PlayerY = Player:getPositionY()
    for i = 1, #grassHitboxes, 1 do
        if grassHitboxes[i].y ~= nil and PlayerX ~= nil then
            if PlayerX >= grassHitboxes[i].x and PlayerX <= grassHitboxes[i].x + grassHitboxes[i].width/2 
            and PlayerY >= grassHitboxes[i].y and PlayerY <= grassHitboxes[i].y + grassHitboxes[i].height/2 then
                if Player:getVelocity() ~= 0 then
                    activeFrameBig[i].touched = true
                    activeFrameSmall[i].touched = true
                else
                    if animationComplete then
                        activeFrameBig[i].touched = false
                    end
                    if animationCompleteSmall then
                        activeFrameSmall[i].touched = false
                    end
                end
                break
            end
            if PlayerX < grassHitboxes[i].x or PlayerX > grassHitboxes[i].x then
                if animationComplete then
                    activeFrameBig[i].touched = false
                end
                if animationCompleteSmall then
                    activeFrameSmall[i].touched = false
                end
            end
        end
    end
end

function Grass:draw()
    g.setColor(LevelHandler:colors(1))
    for i = 1, #tableOfGrass, 1 do
        if grassHitboxes[i].y ~= nil then
            --g.rectangle("line", grassHitboxes[i].x, grassHitboxes[i].y, grassHitboxes[i].width, grassHitboxes[i].height)
        end
        if type(tableOfGrass[i].x) == "number" then
            
            if tableOfGrass[i].s == "single" then
                if activeFrameSmall[i].touched == true then
                    love.graphics.draw(grass, activeFrameSmall[i].grass, tableOfGrass[i].x - 20, tableOfGrass[i].y - 23, 0, 2.5, 1.5)
                else
                    love.graphics.draw(grass, activeFrameSmall[1].static, tableOfGrass[i].x - 20, tableOfGrass[i].y - 23, 0, 2.5, 1.5)
                end
            else
                if randomTabel[i] == 1 then
                    if activeFrameBig[i].touched then
                        love.graphics.draw(grass, activeFrameBig[i].grass, tableOfGrass[i].x - 20, tableOfGrass[i].y - 27, 0, 2.5, 1.5)
                    else
                        love.graphics.draw(grass, activeFrameBig[1].static, tableOfGrass[i].x - 20, tableOfGrass[i].y - 27, 0, 2.5, 1.5)
                    end
                end
                if randomTabel[i] == 2 then
                    if activeFrameSmall[i].touched == true then
                        love.graphics.draw(grass, activeFrameSmall[i].grass, tableOfGrass[i].x - 20, tableOfGrass[i].y - 23, 0, 2.5, 1.5)
                    else
                        love.graphics.draw(grass, activeFrameSmall[1].static, tableOfGrass[i].x - 20, tableOfGrass[i].y - 23, 0, 2.5, 1.5)
                    end
                end
            end
        end
    end
end