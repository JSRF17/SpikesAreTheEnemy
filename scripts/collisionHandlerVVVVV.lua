--[[
    Handles collsion in the physics world, using love.physics and different callback functions
]]--

CollisionHandlerVVVVV = {}

local isColliding = false
local collisionType
local touchedSpike
local ended 
local playerDestroyed
local wallCol = false
local print, print2
local playerTouchGround = true

function CollisionHandlerVVVVV:getPlayerStatus()
    playerDestroyed = Player:getStatus()
end

function CollisionHandlerVVVVV:getWorld(w)
    w = w
end

--Runs when contact between objects start
function beginContact(a, b, coll)
    local ended = false
    if Player:getStatus() == true then
       
        if a:getUserData() == "spike" and b:getUserData() == "player" or b:getUserData() == "spike" and a:getUserData() == "player" 
        or a:getUserData() == "spike" and b:getUserData() == "left" or b:getUserData() == "spike" and a:getUserData() == "left" 
        or a:getUserData() == "spike" and b:getUserData() == "right" or b:getUserData() == "spike" and a:getUserData() == "right" then
            isColliding = true
            collisionType = "spike"
            touchedSpike = true
            Timer.script(function(wait)
                wait(0.2)
                collisionType = "none"
                touchedSpike = false
            end)
        end
        if a:getUserData() == "Roof" and b:getUserData() == "player" or b:getUserData() == "Roof" and a:getUserData() == "player" then
            collisionType = "Roof"
        elseif a:getUserData() == "Ground" and b:getUserData() == "player" or b:getUserData() == "Ground" and a:getUserData() == "player" then
            collisionType = "Ground"
        end
    end
    if Player:getStatus() == false then
        isColliding = false
        collisionType = "none"
    end
    print = a:getUserData()
    print2 = b:getUserData()
end

function CollisionHandlerVVVVV:print(tt)
    if tt == 1 then
        return collisionType
    else
        return print2
    end
end
--Gets called when a contact has ended
function endContact(a, b, coll)
    ended = true
    if Player:getStatus() == true then
        if a:getUserData() == "player" or b:getUserData() == "player" then
            playerTouchGround = false 
        end
        x, y = Player:getVelocity()
        if collisionType ~= "spike" and collisionType ~= "goal" and collisionType ~= "secret" then
            if wallCol ~= true then
                if y > 0.001 or y < -0.001 then
                    persisting = 0 
                    isColliding = false
                    collisionType = "none"
                end
            end
            if a:getUserData() == "left" or b:getUserData() == "left" or a:getUserData() == "right" or b:getUserData() == "right" then
                collisionType = "special" 
                wallCol = false
            end
        end 
    end
end
--Resets the collision type and isColliding variable when player is in the air
function CollisionHandlerVVVVV:resetCollision()
    local x, y = Player:getVelocity()
    if wallCol == false and collisionType ~= "spike" and collisionType ~= "goal" and collisionType ~= "secret" then
        if y > 0.001 or y < -0.001 then
            isColliding = false
            collisionType = "none"
            return true
        end
    end
end

function CollisionHandlerVVVVV:getStatus()
    return isColliding
end

function CollisionHandlerVVVVV:getType()
    return collisionType
end

function CollisionHandlerVVVVV:getSpikeTouch()
    return touchedSpike
end

function CollisionHandlerVVVVV:checkIfPlayerTouchGround()
    return playerTouchGround
end


