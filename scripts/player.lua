--[[Includes logic relevant to the player. Functions for spawning the player 
    at specific x and y coordinates, destroying the player, drawing the player,
    tracking the x and y coordinates of the player, spawning bubbles when dead and 
    providing the user with methods of controling the player]]--

require("scripts.collisionHandler")

Player = {}

local debug = false

local imageFile = love.graphics.newImage("resources/tex2.png")
local activeFrame
local currentFrame = 1
local frameCoordinates = {
    {0, 32, 16, 16},{16, 32, 16, 16},{32, 32, 16, 16},{0, 48.5, 16, 15},
    {16, 48.5, 16, 15},{32, 48.5, 16, 15},{48, 48, 16, 15},{0, 64, 16, 15},
    {16, 64, 16, 16},{32, 64, 16, 16},{48, 64, 16, 16},{-1, 81, 16, 16},
    {-18, 81, 16, 16}
}
local frames = {}
for i = 1, #frameCoordinates, 1 do
    frames[i] = g.newQuad(frameCoordinates[i][1],frameCoordinates[i][2],frameCoordinates[i][3],frameCoordinates[i][4], imageFile:getDimensions())
end
activeFrame = frames[currentFrame]
local animationTimeIdle = 0
local animationTimeRun = 0
local animationTimeJump = 0
local blinkTime = 0
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
local test = true
local died = false
local Blink = true
local BlinkReset = true
local blink = 0
local bouncedX = false 
local fixedSpeed = true
local wallTouch = false

local controlsAvailable = true

--Used when spawing bubbles as the self.x and self.y will be nill once the player is destroyed--
storedX = -500
storedY = -500

function Player:initLives(speedrun)
    if speedrun then
        lives = 10000 
    else
        lives = 10
    end
end

--Used to spawn player. creates shape, physics object and so on--
function Player:init(x, y, direction)
    runing = false
    runingFast = false
    idle = true 
    jumping = false

    if tutorial then
        self.x = x
        self.y = y
    elseif test == true then
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

        --player.bottom = love.physics.newRectangleShape( 0, 12, 5 , 5, 0)
        --player.bottom = love.physics.newFixture(player.b, player.bottom, 1)
        --player.bottom:setUserData("bottom")

        player.b:setBullet( true )
        test = false
    end
    if direction == "left" then
        offsetx = -26
        offsety = 10
        directiony = 2.2
        directionx = -2.5
        offsetx2 = 26
        directionx2 = 2.5
    elseif direction == "right" then
        offsetx = 10
        offsety = 10
        directiony = 2.2
        directionx = 2.5
        offsetx2 = -8
        directionx2 = -2.5
    end
end

--Destroys the player and stores the last x and y values--
function Player:destroy(choice)
    if "physics" then
        player.leftSide:destroy()
        player.rightSide:destroy()
        player.f:destroy()
        player.b:destroy()
        player.b = nil
        player.s = nil 
        player.f = nil 
    else
        storedX = self.x
        storedY = self.y
        player.leftSide:destroy()
        player.rightSide:destroy()
        player.f:destroy()
        player.b:destroy()
        player.b = nil
        player.s = nil 
        player.f = nil 
    end
    if choice == "justPhysicsBody" then
        died = true
        deathFrame = activeFrame
        Timer.script(function(wait)
            wait(0.8)
            player = nil
            orientation = 0
            test = true
            died = false
            DataHandler:add_death()
        end)
    else
        player = nil
        orientation = 0
        test = true
    end
    runing = false
    runingFast = false
    idle = true 
    jumping = false

    controlsAvailable = false
    Timer.script(function(wait)
        wait(1.4)
        controlsAvailable = true
    end)
end

function Player:animation(dt)
    if player.b == nil then
        blinkTime = blinkTime + dt
        if blinkTime > 0.02 then
            if Blink then
                blink = blink + 0.1
            elseif Blink ~= true then
                blink = blink - 0.1
            end
            if blink > 0.9 then
                blink = blink - 0.1
                BlinkReset = true
            end
            if blink < 0.1 then
                blink = blink + 0.1
                BlinkReset = false
            end
            if BlinkReset then
                blink = blink - 0.1
                Blink = false
            elseif BlinkReset == false then
                blink = blink + 0.1
                Blink = true
            end
            blinkTime = 0
        end
    end
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
    if wallTouchRight then
        activeFrame = frames[12]
        offsetx = -26
        offsety = 10
        directiony = 2.2
        directionx = -2.5
        offsetx2 = 26
        directionx2 = 2.5
    elseif wallTouchLeft then
        activeFrame = frames[12]
        offsetx = 10
        offsety = 10
        directiony = 2.2
        directionx = 2.5
        offsetx2 = -8
        directionx2 = -2.5
    end
end

function Player:draw(minigame)
    if died == true then
        g.setColor(0, 0, 0, blink)
    elseif LevelHandler:colors(1) ~= nil and minigame ~= true then
        g.setColor(LevelHandler:colors(1))
    end
    if debug == true then
        for _, body in pairs(w:getBodies()) do
            for _, fixture in pairs(body:getFixtures()) do
                local shape = fixture:getShape()
                love.graphics.polygon("line", body:getWorldPoints(shape:getPoints()))
            end
        end
    end
    if player.b ~= nil then
        if orientation == 0 then
            love.graphics.draw(imageFile, activeFrame, self.x - offsetx, self.y - offsety, 0, directionx, directiony)
        elseif orientation ~= 0 then
            love.graphics.draw(imageFile, activeFrame, self.x + offsetx2, self.y - offsety2, 160.2, directionx2, directiony2)
        end
    else
        if orientation == 0 then
            love.graphics.draw(imageFile, deathFrame, self.x - offsetx, self.y - offsety, 0, directionx, directiony)
        elseif orientation ~= 0 then
            love.graphics.draw(imageFile, deathFrame, self.x + offsetx2, self.y - offsety2, 160.2, directionx2, directiony2)
        end
    end
    g.setColor(1, 1, 1)
end

function Player:lostLife()
    if SpeedRun == false then
        lives = lives - 1
    end
end

function Player:bonusLives()
    lives = lives + 5
    SoundHandler:PlaySound("5up")
end

function Player:checkLives()
    return lives
end

function Player:drawLives()
    g.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.printf(tostring(lives), 1280/2 - 200, 670, 300, "center", 0, 1.25)
end

function Player:track()
    if player ~= nil then
        if player.b ~= nil then
            local cx, cy = player.b:getWorldPoints(player.s:getPoints())
            self.x = cx
            self.y = cy
        end
    end
end

function Player:limitSpeed()
    if player.b ~= nil then
        local x, y = player.b:getLinearVelocity()
        if x > 1400 and fixedSpeed then
            fixedSpeed = false
            player.b:setLinearVelocity( 1400, y )
        end
        if x < -1400 and fixedSpeed then
            fixedSpeed = false
            player.b:setLinearVelocity( -1400, y )
        end
        if y < -3000 and fixedSpeed then
            fixedSpeed = false
            player.b:setLinearVelocity( x, -3000 )
        end
    end
end

function Player:bounce(forceX, forceY, dir, small)
    if dir ~= nil then
        bouncedX = true
    end
    fixedSpeed = true
    Timer.script(function(wait)
        wait(1)
        bouncedX = false
    end)
    if dir == "right" then
        offsetx = 10
        offsety = 10
        directiony = 2.2
        directionx = 2.5
        offsetx2 = -8
        directionx2 = -2.5
        runing = true
        idle = false
    elseif dir == "left" then
        offsetx = -26
        offsety = 10
        directiony = 2.2
        directionx = -2.5
        offsetx2 = 26
        directionx2 = 2.5
        runing = true
        idle = false
    end
    if dir ~= "right" and dir ~= "left" then
        if small then
            player.b:setLinearVelocity( x, -1200 )
        else
            player.b:setLinearVelocity( x, -2100 )
        end
    elseif dir == "right" then
        player.b:setLinearVelocity( 2100, y )
    else
        player.b:setLinearVelocity( -2100, y )
    end
    SoundHandler:PlaySound("bounce")
end

function Player:teleport(x, y)
    if player ~= nil then
        if x ~= nil then
            self.x = x
        end
        if y ~= nil then
            self.y = y
        end
    end
end

function Player:getPositionX()
    if player ~= nil then
        local x = self.x
        local playerInWorld = push:toGame(x, 100)
        return x 
    else
        return nil
    end
end

function Player:getPositions()
    if player ~= nil then
        local x = self.x
        local y = self.y
        return self.x, self.y
    else
        return nil
    end
end

function Player:slowDown()
    if player ~= nil then
        if player.b ~= nil then
            x, y = player.b:getLinearVelocity()
            if x > 0 then
                if x ~= 0 then
                    x = x - 3.5
                end
            elseif x < 0 then
                if x ~= 0 then
                    x = x + 3.5
                end
            end
            player.b:setLinearVelocity(x, y)
        end
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
local wallJump = true
local test1 = false
local test2 = false
function Player:controls(dt, miniGame)
    if player ~= nil then
        if player.b ~= nil then
            if controlsAvailable then
                local type = CollisionHandler:getType()
                local isColliding = CollisionHandler:getStatus()
                local x, y = player.b:getLinearVelocity()

                if CollisionHandler:checkIfPlayerTouchGround() == true or type ~= "right" then
                    test1 = true
                end
                if CollisionHandler:checkIfPlayerTouchGround() == true or type ~= "left" then
                    test2 = true
                end
                if type == "right" then
                    wallTouchRight = true
                end
                if type == "left" then
                    wallTouchLeft = true
                end

                if x > 1 or x < -1 or CollisionHandler:checkIfPlayerTouchGround() or CollisionHandler:getWallCol() == false then
                    wallTouchRight = false
                    wallTouchLeft = false
                end
                if type == "right" then
                    if love.keyboard.isDown("up") and JumpKeyUp == true or TouchControls:getEvent("Y")== "up" and JumpKeyUp == true then
                        wallJump = false
                        if CollisionHandler:checkIfPlayerTouchGround() == false then
                            if orientation == 0 then
                                player.b:setLinearVelocity( -210, -500 )
                            elseif orientation ~= 0 then
                                player.b:setLinearVelocity( -210, 500 )
                            end
                            test1 = false
                        else
                            if orientation == 0 then
                                player.b:setLinearVelocity( x, -550 )
                            elseif orientation ~= 0 then
                                player.b:setLinearVelocity( x, 550 )
                            end
                        end
                        wallTouchRight = false
                        JumpKeyUp = false
                    end
                end
                if type == "left" then
                    if love.keyboard.isDown("up") and JumpKeyUp == true or TouchControls:getEvent("Y")== "up" and JumpKeyUp == true then
                        wallJump = false
                        if CollisionHandler:checkIfPlayerTouchGround() == false then
                            if orientation == 0 then
                                player.b:setLinearVelocity( 210, -500 )
                            elseif orientation ~= 0 then
                                player.b:setLinearVelocity( 210, 500 )
                            end
                            test2 = false                   
                        else
                            if orientation == 0 then
                                player.b:setLinearVelocity( x, -550 )
                            elseif orientation ~= 0 then
                                player.b:setLinearVelocity( x, 550 )
                            end
                        end
                        wallTouchLeft = false
                        JumpKeyUp = false
                    end   
                end         
                if love.keyboard.isDown("right") and bouncedX == false and wallTouchLeft == false or TouchControls:getEvent("X") == "right" and bouncedX == false and wallTouchLeft == false then
                    if wallTouchRight ~= true then
                        offsetx = 10
                        offsety = 10
                        directiony = 2.2
                        directionx = 2.5
                        offsetx2 = -8
                        directionx2 = -2.5
                    end
                    runing = true
                    idle = false
                    if miniGame then
                        player.b:applyForce(150, 0)
                    elseif x < 400 then
                        player.b:applyForce(50, 0)
                    end
                elseif love.keyboard.isDown("left") and bouncedX == false and wallTouchRight == false or TouchControls:getEvent("X") == "left" and bouncedX == false and wallTouchRight == false then
                    if wallTouchLeft ~= true then
                        offsetx = -26
                        offsety = 10
                        directiony = 2.2
                        directionx = -2.5
                        offsetx2 = 26
                        directionx2 = 2.5
                    end
                    runing = true
                    idle = false
                    if miniGame then
                        player.b:applyForce(-150, 0)
                    elseif x > -400 then
                        player.b:applyForce(-50, 0)
                    end
                end
                if love.keyboard.isDown("up") == false and TouchControls:getEvent("Y") == "" then
                    JumpKeyUp = true
                end
                
                if isColliding or CollisionHandler:checkIfPlayerTouchGround() then
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
                            wallTouch = false
                        end
                        jumping = false
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
                if jump == false or wallJump == false then
                    SoundHandler:PlaySound("jump")
                end

                CollisionHandler:resetCollision()
                if type == "none" or isColliding == false or CollisionHandler:checkIfPlayerTouchGround() == false then
                    jump = true
                    wallJump = true
                end
            end
        end
        if player.b == nil then
            jump = true
            wallJump = true
        end
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

function Player:getJump()
    return jump
end

function Player:getWallJump()
    return wallJump
end

function Player:pushPlayer(direction, first)
    if player.b ~= nil then
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
end



