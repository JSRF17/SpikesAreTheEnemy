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
    {0, 32, 16, 16},{16, 32, 16, 16},{32, 32, 16, 16},{0, 48.5, 16, 15},
    {16, 48.5, 16, 15},{32, 48.5, 16, 15},{48, 48, 16, 15},{0, 64, 16, 15},
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
local offsety = 10
local directionx2 = 2.5
local directiony2 = 2.2
local offsetx2 = -8
local offsety2 = -33
local lives = 0
local orientation = 0

--Used when spawing bubbles as the self.x and self.y will be nill once the player is destroyed--
storedX = -500
storedY = -500

function Player:initLives(speedrun)
    if speedrun then
        lives = 1000 
    else
        lives = 10
    end
end

--Used to spawn player. creates shape, physics object and so on--
function Player:init(x, y, tutorial)
    if tutorial then
        self.x = x
        self.y = y
    else
        self.x = x
        self.y = y
        player = {}
        player.b = p.newBody(w, self.x, self.y, "dynamic") 
        player.s = p.newRectangleShape(20, 23)
        player.f = p.newFixture(player.b, player.s)
        player.b:setFixedRotation( true )
        player.f:setUserData("player")

        player.leftSide = love.physics.newRectangleShape( -10, 0, 5 , 5, 0)
        player.leftSide = love.physics.newFixture(player.b, player.leftSide, 1)
        player.leftSide:setUserData("left")

        player.rightSide = love.physics.newRectangleShape( 10, 0, 5 , 5, 0)
        player.rightSide = love.physics.newFixture(player.b, player.rightSide, 1)
        player.rightSide:setUserData("right")
        player.b:setBullet( true )
    end
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
    if jumping == true then
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
    if idle == true and jumping == false then
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
    if runing == true and jumping == false then
        animationTimeRun = animationTimeRun + dt
        if runingFast == false then
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
        if runingFast == true then
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

function Player:draw()
    if LevelHandler:colors(1) ~= nil then
        g.setColor(LevelHandler:colors(1))
    else
        g.setColor(1, 1, 1)
    end
    if debug == true then
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
    g.setColor(1, 1, 1)
end

function Player:lostLife()
    lives = lives - 1
end

function Player:bonusLives()
    lives = lives + 5
end

function Player:checkLives()
    return lives
end

function Player:drawLives()
    g.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.printf(tostring(lives), 1280/2 - 200, 670, 300, "center", 0, 1.25)
end

function Player:track()
    local cx, cy = player.b:getWorldPoints(player.s:getPoints())
    self.x = cx
    self.y = cy
end

function Player:getPositionX()
    if player ~= nil then
        local x = self.x
        return x 
    else
        return nil
    end
end

function Player:getPositionY()
    if player ~= nil then
        local y = self.y
        return y
    else
        return nil
    end
end
--Handles user input for player controls***Fix walljump issue***--
local JumpKeyUp = true
local jump = true
function Player:controls(dt)
    local type = CollisionHandler:getType()
    local isColliding = CollisionHandler:getStatus()
    local x, y = player.b:getLinearVelocity()
    if love.keyboard.isDown("right") or TouchControls:getEvent("X") == "right" then
        offsetx = 10
        offsety = 10
        directiony = 2.2
        directionx = 2.5
        offsetx2 = -8
        directionx2 = -2.5
        runing = true
        idle = false
        player.b:applyForce(40, 0)
        if x > 400 then
            player.b:setLinearVelocity( 400, y )
        end
    elseif love.keyboard.isDown("left") or TouchControls:getEvent("X") == "left" then
        offsetx = -26
        offsety = 10
        directiony = 2.2
        directionx = -2.5
        offsetx2 = 26
        directionx2 = 2.5
        runing = true
        idle = false
        player.b:applyForce(-40, 0)
        if x < -400 then
            player.b:setLinearVelocity( -400, y )
        end
    end
    if love.keyboard.isDown("up") == false and TouchControls:getEvent("Y") == "" then
        JumpKeyUp = true
    end
    if type ~= "left" and type ~= "right" then
        if isColliding == true then
            if jump == true then
                if love.keyboard.isDown("up") and JumpKeyUp == true or TouchControls:getEvent("Y") == "up" and JumpKeyUp == true then
                    jump = false
                    runing = false
                    idle = false
                    jumping = true
                    JumpKeyUp = false
                    if orientation == 0 then
                        player.b:setLinearVelocity( x, -600 )
                    elseif orientation ~= 0 then
                        player.b:setLinearVelocity( x, 600 )
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
        if love.keyboard.isDown("up") and JumpKeyUp == true or TouchControls:getEvent("Y")== "up" and JumpKeyUp == true then
            if CollisionHandler:checkIfPlayerTouchGround() == false then
                if type == "left" then
                    if orientation == 0 then
                        player.b:setLinearVelocity( 210, -500 )
                    elseif orientation ~= 0 then
                        player.b:setLinearVelocity( 210, 500 )
                    end
                elseif type == "right" then
                    if orientation == 0 then
                        player.b:setLinearVelocity( -210, -500 )
                    elseif orientation ~= 0 then
                        player.b:setLinearVelocity( -210, 500 )
                    end
                end
            else
                if orientation == 0 then
                    player.b:setLinearVelocity( x, -550 )
                elseif orientation ~= 0 then
                    player.b:setLinearVelocity( x, 550 )
                end
            end
            JumpKeyUp = false
        end
    end
    if love.keyboard.isDown("down") or TouchControls:getEvent("Y") == "down" then
        if orientation == 0 then
            player.b:applyForce(0, 300)
        elseif orientation ~= 0 then
            player.b:applyForce(0, -300)
        end
    end
    if x > 300 or x < -300 then
        runingFast = true 
    elseif x < 300 and x > 0 or x > -300 and x < 0 then
        runingFast = false
    end 
    if x == 0 and y == 0 then
        runing = false
        idle = true
    end
    CollisionHandler:resetCollision()
    if type == "none" or isColliding == false then
        jump = true
    end
end

function Player:getVelocity()
    if player.b ~= nil then
        x, y = player.b:getLinearVelocity()
        return x, y
    end
    return nil
end

function Player:getStatus(get)
    if get == true then
        return player.be
    elseif player == nil then
        return false
    elseif player.b ~= nil then
        return true
    end
end

function Player:pushPlayer(direction, first)
    if direction == "up" then
        player.b:applyForce(0, -30)
        orientation = 0
    elseif direction == "down" then
        player.b:applyForce(0, 30)
        if first then
            offsetx2 = 26
        end
        orientation = 90
    elseif direction == "justUp" then
        player.b:applyForce(0, -20)
    end
end



