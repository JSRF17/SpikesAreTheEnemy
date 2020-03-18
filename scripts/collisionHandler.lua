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

function checkCombinations(a,b,type1,type2)
    return a:getUserData() == type1 and b:getUserData() == type2
           or
           a:getUserData() == type2 and b:getUserData() == type1
end

--Runs when contact between objects start
function beginContact(a, b, coll)
    ended = false
    if Player:getStatus() == true then
        if checkCombinations(a,b,"spike","player") then
            isColliding = true
            collisionType = "spike"
            touchedSpike = true
            Timer.script(function(wait)
                wait(0.2)
                collisionType = "none"
                touchedSpike = false
            end)
        end
        if checkCombinations(a,b,"spike","left") then
            isColliding = true
            collisionType = "spike"
            touchedSpike = true
            Timer.script(function(wait)
                wait(0.2)
                collisionType = "none"
                touchedSpike = false
            end)
        end
        if checkCombinations(a,b,"spike","right") then
            isColliding = true
            collisionType = "spike"
            touchedSpike = true
            Timer.script(function(wait)
                wait(0.2)
                collisionType = "none"
                touchedSpike = false
            end)
        end
        if checkCombinations(a,b,"goal","player") then
            isColliding = true
            collisionType = "goal"
            --Since I'm destroying the physics object player during collision it seems to persist sometimes,
            --this fixes it.
            Timer.script(function(wait)
                wait(0.3)
                collisionType = "none"
            end)
        end
        if checkCombinations(a,b,"goal","left") then
            isColliding = true
            collisionType = "goal"
            Timer.script(function(wait)
                wait(0.3)
                collisionType = "none"
            end)
        end
        if checkCombinations(a,b,"goal","right") then
            isColliding = true
            collisionType = "goal"
            Timer.script(function(wait)
                wait(0.3)
                collisionType = "none"
            end)
        end
        if checkCombinations(a,b,"goal","left") then
            isColliding = true
            collisionType = "goal"
            Timer.script(function(wait)
                wait(0.3)
                collisionType = "none"
            end)
        end
        if checkCombinations(a,b,"goal","right") then
            isColliding = true
            collisionType = "goal"
            Timer.script(function(wait)
                wait(0.3)
                collisionType = "none"
            end)
        elseif checkCombinations(a,b,"secret","player") then
            isColliding = true
            collisionType = "secret"
            Timer.script(function(wait)
                wait(0.3)
                collisionType = "none"
            end)
        elseif checkCombinations(a,b,"secret","right") then
            isColliding = true
            collisionType = "secret"
            Timer.script(function(wait)
                wait(0.3)
                collisionType = "none"
            end)
        end
        if checkCombinations(a,b,"normal","left") then
            isColliding = true
            wallCol = true
            collisionType = "left"
        
        elseif checkCombinations(a,b,"normal","right") then
            isColliding = true
            wallCol = true
            collisionType = "right"
        
        elseif checkCombinations(a,b,"normal","player") then
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


