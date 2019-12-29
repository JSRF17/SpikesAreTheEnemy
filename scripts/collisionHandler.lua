--

CollisionHandler = {}

local isColliding = false
local collisionType
local touchedSpike
local ended 
local playerDestroyed
local wallCol = false

function CollisionHandler:getPlayerStatus()
    playerDestroyed = Player:getStatus()
end

function CollisionHandler:getWorld(w)
    w = w
end

--Runs when contact between objects start
function beginContact(a, b, coll)
    ended = false
    if Player:getStatus() == true then
        if a:getUserData() == "spike" and b:getUserData() == "player" or b:getUserData() == "spike" and a:getUserData() == "player" then
            isColliding = true
            collisionType = "spike"
            touchedSpike = true
            Timer.script(function(wait)
                wait(0.2)
                collisionType = "none"
                touchedSpike = false
            end)
        end
        if a:getUserData() == "spike" and b:getUserData() == "left" or b:getUserData() == "spike" and a:getUserData() == "left" then
            isColliding = true
            collisionType = "spike"
            touchedSpike = true
            Timer.script(function(wait)
                wait(0.2)
                collisionType = "none"
                touchedSpike = false
            end)
        end
        if a:getUserData() == "spike" and b:getUserData() == "right" or b:getUserData() == "spike" and a:getUserData() == "right" then
            isColliding = true
            collisionType = "spike"
            touchedSpike = true
            Timer.script(function(wait)
                wait(0.2)
                collisionType = "none"
                touchedSpike = false
            end)
        end
        if a:getUserData() == "goal" and b:getUserData() == "player" or b:getUserData() == "goal" and a:getUserData() == "player" then
            isColliding = true
            collisionType = "goal"
            --Since I'm destroying the physics object player during collision it seems to persist sometimes,
            --this fixes it.
            Timer.script(function(wait)
                wait(0.3)
                collisionType = "none"
            end)
        end
        if a:getUserData() == "goal" and b:getUserData() == "left" or b:getUserData() == "goal" and a:getUserData() == "left" then
            isColliding = true
            collisionType = "goal"
            Timer.script(function(wait)
                wait(0.3)
                collisionType = "none"
            end)
        end
        if a:getUserData() == "goal" and b:getUserData() == "right" or b:getUserData() == "goal" and a:getUserData() == "right" then
            isColliding = true
            collisionType = "goal"
            Timer.script(function(wait)
                wait(0.3)
                collisionType = "none"
            end)
        end
        if a:getUserData() == "goal" and b:getUserData() == "left" or b:getUserData() == "goal" and a:getUserData() == "left" then
            isColliding = true
            collisionType = "goal"
            Timer.script(function(wait)
                wait(0.3)
                collisionType = "none"
            end)
        end
        if a:getUserData() == "goal" and b:getUserData() == "right" or b:getUserData() == "goal" and a:getUserData() == "right" then
            isColliding = true
            collisionType = "goal"
            Timer.script(function(wait)
                wait(0.3)
                collisionType = "none"
            end)
        elseif a:getUserData() == "secret" and b:getUserData() == "player" or b:getUserData() == "secret" and a:getUserData() == "player" then
            isColliding = true
            collisionType = "secret"
            Timer.script(function(wait)
                wait(0.3)
                collisionType = "none"
            end)
        elseif a:getUserData() == "secret" and b:getUserData() == "right" or b:getUserData() == "secret" and a:getUserData() == "right" then
            isColliding = true
            collisionType = "secret"
            Timer.script(function(wait)
                wait(0.3)
                collisionType = "none"
            end)
        end
        if a:getUserData() == "normal" and b:getUserData() == "left" or b:getUserData() == "left" and a:getUserData() == "normal" then
            isColliding = true
            wallCol = true
            collisionType = "left"
        
        elseif a:getUserData() == "normal" and b:getUserData() == "right" or b:getUserData() == "right" and a:getUserData() == "normal" then
            isColliding = true
            wallCol = true
            collisionType = "right"
        
        elseif a:getUserData() == "normal" and b:getUserData() == "player" or b:getUserData() == "player" and a:getUserData() == "normal" then
            if wallCol == false then
                isColliding = true
                collisionType = "normal"
            end
        end
    end
    if Player:getStatus() == false then
        isColliding = false
        collisionType = "none"
    end
end
--Gets called when a contact has ended
function endContact(a, b, coll)
    ended = true
    if Player:getStatus() == true then
        x, y = Player:getVelocity()
        if collisionType ~= "spike" then
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
    if wallCol == false and collisionType ~= "spike" then
        if y > 0.001 or y < -0.001 then
            isColliding = false
            ollisionType = "none"
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


