--[[
    Handles collsion in the physics world, using love.physics and different callback functions
]]--

CollisionHandler = {}

local isColliding = false
local collisionType
local touchedSpike
local ended 
local playerDestroyed
local wallCol = false
local print, print2
local playerTouchGround = true
local hitGoal = false
local hitReturn = false
local hitSecret = false

function CollisionHandler:getPlayerStatus()
    playerDestroyed = Player:getStatus()
end

function CollisionHandler:getWorld(w)
    w = w
end

--Runs when contact between objects start
function beginContact(a, b, coll)
    local ended = false
    if Player:getStatus() == true then
        for i = 0, 13, 1 do
            if a:getUserData() == "goal"..tostring(i) and b:getUserData() == "player" or b:getUserData() == "goal"..tostring(i) and a:getUserData() == "player" then
                collisionType = "goal"..tostring(i)
                break
            end
        end
        if a:getUserData() == "goal" and b:getUserData() == "left" or b:getUserData() == "goal" and a:getUserData() == "left" 
        or a:getUserData() == "goal" and b:getUserData() == "right" or b:getUserData() == "goal" and a:getUserData() == "right" then
            isColliding = true
            hitGoal = true
            --Since I'm destroying the physics object player during collision it seems to persist sometimes,
            --this fixes it.
            Timer.script(function(wait)
                wait(0.3)
                hitGoal = false
                collisionType = "none"
            end)
        elseif a:getUserData() == "secret" and b:getUserData() == "right" or b:getUserData() == "secret" and a:getUserData() == "right" 
        or a:getUserData() == "secret" and b:getUserData() == "left" or b:getUserData() == "secret" and a:getUserData() == "left" then
            isColliding = true
            hitSecret = true
            Timer.script(function(wait)
                wait(0.3)
                hitSecret = false
                collisionType = "none"
            end)
        end
        if a:getUserData() == "return" and b:getUserData() == "left" or b:getUserData() == "return" and a:getUserData() == "left" 
        or a:getUserData() == "return" and b:getUserData() == "right" or b:getUserData() == "return" and a:getUserData() == "right" then
            isColliding = true
            hitReturn = true
            --Since I'm destroying the physics object player during collision it seems to persist sometimes,
            --this fixes it.
            Timer.script(function(wait)
                wait(0.3)
                hitReturn = false
                collisionType = "none"
            end)
        end
        if a:getUserData() == "goal" and b:getUserData() == "player" or b:getUserData() == "goal" and a:getUserData() == "player" then
            isColliding = true
            hitGoal = true
            --Since I'm destroying the physics object player during collision it seems to persist sometimes,
            --this fixes it.
            Timer.script(function(wait)
                wait(0.3)
                hitGoal = false
                collisionType = "none"
            end)
        elseif a:getUserData() == "secret" and b:getUserData() == "player" or b:getUserData() == "secret" and a:getUserData() == "player" then
            isColliding = true
            hitSecret = true
            Timer.script(function(wait)
                wait(0.3)
                hitSecret = false
                collisionType = "none"
            end)
        end
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
        if a:getUserData() == "normal" and b:getUserData() == "player" or a:getUserData() == "player" and a:getUserData() == "normal" then
            if wallCol == false then
                isColliding = true
                collisionType = "normal"
            end
            playerTouchGround = true
        elseif a:getUserData() == "normal" and b:getUserData() == "left" or a:getUserData() == "left" and a:getUserData() == "normal" then
            isColliding = true
            wallCol = true
            collisionType = "left"
        elseif a:getUserData() == "normal" and b:getUserData() == "right" or a:getUserData() == "right" and a:getUserData() == "normal" then
            isColliding = true
            wallCol = true
            collisionType = "right"
        end
       
        if a:getUserData() == "bounceRight" and b:getUserData() == "left" or b:getUserData() == "bounceRight" and a:getUserData() == "left" then
            collisionType = "bounceRight"
        elseif  a:getUserData() == "bounceLeft" and b:getUserData() == "right" or b:getUserData() == "bounceLeft" and a:getUserData() == "right" then
            collisionType = "bounceLeft"
        elseif  a:getUserData() == "bounceUp" and b:getUserData() == "player" or b:getUserData() == "bounceUp" and a:getUserData() == "player" then
            collisionType = "bounceUp"
        elseif  a:getUserData() == "bounceUpSmall" and b:getUserData() == "player" or b:getUserData() == "bounceUpSmall" and a:getUserData() == "player" then
            collisionType = "bounceUpSmall"
        end
    end
    if Player:getStatus() == false then
        isColliding = false
        collisionType = "none"
    end
    print = a:getUserData()
    print2 = b:getUserData()
end

function CollisionHandler:print(tt)
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
function CollisionHandler:resetCollision()
    local x, y = Player:getVelocity()
    if wallCol == false and collisionType ~= "spike" and collisionType ~= "goal" and collisionType ~= "secret" then
        if y > 0.001 or y < -0.001 then
            isColliding = false
            collisionType = "none"
            return true
        end
    end
end

function CollisionHandler:getStatus()
    return isColliding
end

function CollisionHandler:getType()
    return collisionType
end

function CollisionHandler:getSpikeTouch()
    return touchedSpike
end

function CollisionHandler:getGoalTouch()
    return hitGoal
end

function CollisionHandler:getReturnTouch()
    return hitReturn
end

function CollisionHandler:getSecretTouch()
    return hitSecret
end

function CollisionHandler:getWallCol()
    return wallCol
end

function CollisionHandler:checkIfPlayerTouchGround()
    return playerTouchGround
end

function CollisionHandler:reset()
    persisting = 0 
    isColliding = true
    collisionType = "none"
    playerTouchGround = true
end


