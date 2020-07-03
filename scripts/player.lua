--[[Includes logic relevant to the player. Functions for spawning the player
    at specific x and y coordinates, destroying the player, drawing the player,
    tracking the x and y coordinates of the player, spawning bubbles when dead and
    providing the user with methods of controling the player]]--

require("scripts.collisionHandler")

Player = {}

local debug = false

local imageFile = love.graphics.newImage("resources/tex.png")
local activeFrame
local currentFrame = 1
local frameCoordinates = {
    {0, 32, 16, 16},{16, 32, 16, 16},{32, 32, 16, 16},{0, 48, 16, 16},
    {16, 48, 16, 16},{32, 48, 16, 16},{48, 48, 16, 16},{0, 64, 16, 16},
    {16, 64, 16, 16},{32, 64, 16, 16},{48, 64, 16, 16}
}
local frames = {}
for i = 1, #frameCoordinates, 1 do
    frames[i] = g.newQuad(frameCoordinates[i][1],frameCoordinates[i][2],frameCoordinates[i][3],frameCoordinates[i][4], imageFile:getDimensions())
end
activeFrame = frames[currentFrame]
local animationTimeIdle = 0
local animationTimeRun = 0
local animationTimeJump = 0
local runing = false
local runingFast = false
local idle = true
local jumping = false
local directionx = 2.5
local directiony = 2.2
local offsetx = 10
local offsety = 8
local directionx2 = 2.5
local directiony2 = 2.2
local offsetx2 = -8
local offsety2 = -31
local lives = 0
local orientation = 0

--Used when spawing bubbles as the self.x and self.y will be nill once the player is destroyed--
storedX = -500
storedY = -500
--Circles that spawn when player dies--
die = {}
for i = 0, 6, 1 do
    die[i] = {rad = 5, x = -500, y = 100}
end

function Player:initLives()
    if CheatCodes:getInfiniteLives() then 
        lives = math.huge
    else
        lives = 10
    end
end

--Used to spawn player. creates shape, physics object and so on--
function Player:init(x, y)
    self.x = x
    self.y = y
    player = {}
    player.b = p.newBody(w, self.x, self.y, "dynamic")
    player.s = p.newRectangleShape(20, 23)
    player.f = p.newFixture(player.b, player.s)
    player.b:setFixedRotation(true)
    player.f:setUserData("player")

    player.leftSide = love.physics.newRectangleShape(-10, 0, 5 , 5, 0)
    player.leftSide = love.physics.newFixture(player.b, player.leftSide, 1)
    player.leftSide:setUserData("left")

    player.rightSide = love.physics.newRectangleShape(10, 0, 5 , 5, 0)
    player.rightSide = love.physics.newFixture(player.b, player.rightSide, 1)
    player.rightSide:setUserData("right")
    player.b:setBullet(true)
end

--Destroys the player and stores the last x and y values--
function Player:destroy()
    storedX = self.x
    storedY = self.y
    player.leftSide:destroy()
    player.rightSide:destroy()
    player.f:destroy()
    player.b:destroy()
    player.b = nil
    player.s = nil
    player.f = nil
    player = nil
    orientation = 0
end

function Player:animation(dt)
    if jumping then
        animationTimeJump = animationTimeJump + dt
        if animationTimeRun > 0.2 then
            if(currentFrame < 11) then
                currentFrame = currentFrame + 1
            elseif currentFrame == 11 then
                jumping = false
            else
                currentFrame = 8
            end
            activeFrame = frames[currentFrame]
            animationTimeJump = 0
        end
    end
    if idle and not jumping then
        animationTimeIdle = animationTimeIdle + dt
        if animationTimeIdle > 0.3 then
            if(currentFrame < 3) then
                currentFrame = currentFrame + 1
            else
                currentFrame = 1
            end
            activeFrame = frames[currentFrame]
            animationTimeIdle = 0
        end
    end
    if runing and not jumping then
        animationTimeRun = animationTimeRun + dt
        if not runingFast then
            if animationTimeRun > 0.1 then
                if(currentFrame < 7) then
                    currentFrame = currentFrame + 1
                else
                    currentFrame = 4
                end
                activeFrame = frames[currentFrame]
                animationTimeRun = 0
            end
        end
        if runingFast then
            if animationTimeRun > 0.05 then
                if(currentFrame < 7) then
                    currentFrame = currentFrame + 1
                else
                    currentFrame = 4
                end
                activeFrame = frames[currentFrame]
                animationTimeRun = 0
            end
        end
    end
end

function Player:draw(dt)
    g.setColor(1, 1, 1)
    if debug then
        for _, body in pairs(w:getBodies()) do
            for _, fixture in pairs(body:getFixtures()) do
                local shape = fixture:getShape()
                love.graphics.polygon("line", body:getWorldPoints(shape:getPoints()))
            end
        end
    end
    if orientation == 0 then
        love.graphics.draw(imageFile, activeFrame, self.x - offsetx, self.y - offsety, 0, directionx, directiony)
    elseif orientation ~= 0 then
        love.graphics.draw(imageFile, activeFrame, self.x + offsetx2, self.y - offsety2, 160.2, directionx2, directiony2)
    end
end

function Player:lostLife()
    lives = lives - 1
end

function Player:checkLives()
    return lives
end

function Player:drawLives()
    g.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.printf(tostring(lives), windowWidth/2 - 200, 670, 300, "center", 0, 1.25)
end

function Player:drawDead()
    for i = 0, #die, 1 do
        g.setColor(0.8,0.8,0.8)
        g.circle("fill", die[i].x, die[i].y, die[i].rad)
        g.setColor(1,1,1)
    end
end

function Player:track()
    local cx, cy = player.b:getWorldPoints(player.s:getPoints())
    self.x = cx
    self.y = cy
end

--Tweens the bubbles when player dies--
function Player:die(dt)
    for i = 0, #die, 1 do
        die[i].x = storedX
        die[i].y = storedY
    end
    function move()
        Timer.tween(0.2, die[1], {x = storedX - 10, y = storedY - 10}, 'in-out-quad')
        Timer.tween(0.2, die[2], {x = storedX + 10, y = storedY + 10}, 'in-out-quad')
        Timer.tween(0.2, die[3], {x = storedX - 5, y = storedY + 5}, 'in-out-quad')
        Timer.tween(0.2, die[4], {x = storedX + 5, y = storedY - 5}, 'in-out-quad')
        Timer.tween(0.2, die[5], {x = storedX - 10, y = storedY - 5}, 'in-out-quad')
        Timer.tween(0.2, die[6], {x = storedX + 10, y = storedY + 5}, 'in-out-quad')
        Timer.script(function(wait)
            wait(0.2)
            for i = 0, #die, 1 do
                Timer.tween(0, die[i], {x = -500, y = -500}, 'in-out-quad')
            end
        end)
    end
    move()
end

--Handles user input for player controls***Fix walljump issue***--
local JumpKeyUp = true
local jump = true
function Player:controls(dt)

    local type = CollisionHandler:getType()
    local isColliding = CollisionHandler:getStatus()
    local x, y = player.b:getLinearVelocity()

    if love.keyboard.isDown("right") and not love.keyboard.isDown("left") then
        offsetx = 10
        offsety = 8
        directiony = 2.2
        directionx = 2.5
        offsetx2 = -8
        directionx2 = -2.5
        runing = true
        idle = false
        player.b:applyForce(40, 0)
        if x > 400 then
            player.b:setLinearVelocity(400, y)
        end
    elseif love.keyboard.isDown("left") and not love.keyboard.isDown("right") then
        offsetx = -26
        offsety = 8
        directiony = 2.2
        directionx = -2.5
        offsetx2 = 26
        directionx2 = 2.5
        runing = true
        idle = false
        player.b:applyForce(-40, 0)
        if x < -400 then
            player.b:setLinearVelocity(-400, y)
        end
    end
    if not love.keyboard.isDown("up") then
        JumpKeyUp = true
    end
    if type ~= "left" and type ~= "right" then
        if isColliding then
            if jump then
                if love.keyboard.isDown("up") and JumpKeyUp then
                    jump = false
                    runing = false
                    idle = false
                    jumping = true
                    JumpKeyUp = false
                    if orientation == 0 then
                        player.b:setLinearVelocity(x, -600)
                    elseif orientation ~= 0 then
                        player.b:setLinearVelocity(x, 600)
                    end
                end
                Timer.script(function(wait)
                    wait(0.8)
                    jumping = false
                end)
            end
        end
    end
    if type == "left" or type == "right" then
        if love.keyboard.isDown("up") and JumpKeyUp then
            if y > 0.0001 or y < -0.0001 then
                if type == "left" then
                    if orientation == 0 then
                        player.b:setLinearVelocity(210, -500)
                    elseif orientation ~= 0 then
                        player.b:setLinearVelocity(210, 500)
                    end
                elseif type == "right" then
                    if orientation == 0 then
                        player.b:setLinearVelocity(-210, -500)
                    elseif orientation ~= 0 then
                        player.b:setLinearVelocity(-210, 500)
                    end
                end
            else
                if orientation == 0 then
                    player.b:setLinearVelocity(x, -550)
                elseif orientation ~= 0 then
                    player.b:setLinearVelocity(x, 550)
                end
            end
            JumpKeyUp = false
        end
    end
    if love.keyboard.isDown("down") then
        if orientation == 0 then
            player.b:applyForce(0, 300)
        elseif orientation ~= 0 then
            player.b:applyForce(0, -300)
        end
    end
    if x > 300 or x < -300 then
        runingFast = true
    elseif x < 300 and x > -300 then
        runingFast = false
    end
    if x == 0 and y == 0 then
        runing = false
        idle = true
    end
    CollisionHandler:resetCollision()
    if type == "none" or not isColliding then
        jump = true
    end
    if CheatCodes:getGodMode() then
        player.b:setPosition(love.mouse.getX(),love.mouse.getY())
    end
end

function Player:getVelocity()
    if player.b ~= nil then
        x, y = player.b:getLinearVelocity()
        return x, y
    end
    return nil
end

function Player:getStatus()
    if player == nil then
        return false
    end
    if player.b ~= nil then
        return true
    end
end

function Player:pushPlayer(direction)
    if direction == "up" then
        player.b:applyForce(0, -30)
        orientation = 0
    elseif direction == "down" then
        player.b:applyForce(0, 30)
        orientation = 90
    elseif direction == "justUp" then
        player.b:applyForce(0, -20)
    end
end

function Player:setLifes(v)
    if type(v) == "number" then
        lives = v
    elseif CheatCodes:getInfiniteLives() then
        Player:initLives()   
    elseif lives > 10 then
        lives = 10
    end
end
