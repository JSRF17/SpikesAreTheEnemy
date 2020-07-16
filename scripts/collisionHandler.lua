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
    if Player:getStatus() then
        function checkCombinations(type1,type2)
            return a:getUserData() == type1 and b:getUserData() == type2
                   or
                   a:getUserData() == type2 and b:getUserData() == type1
        end
        function waitF(time, spike)
            return function(wait)
                wait(time)
                collisionType = "none"
                if spike ~= nil then
                    touchedSpike = spike
                end
            end
        end
        if checkCombinations("spike","player") then
            isColliding = true
            collisionType = "spike"
            touchedSpike = true
            Timer.script(waitF(0.2, false))
        end
        if checkCombinations("spike","left") then
            isColliding = true
            collisionType = "spike"
            touchedSpike = true
            Timer.script(waitF(0.2, false))
        end
        if checkCombinations("spike","right") then
            isColliding = true
            collisionType = "spike"
            touchedSpike = true
            Timer.script(waitF(0.2, false))
        end
        if checkCombinations("goal","player") then
            isColliding = true
            collisionType = "goal"
            --Since I'm destroying the physics object player during collision it seems to persist sometimes,
            --this fixes it.
            Timer.script(waitF(0.3))
        end
        if checkCombinations("goal","left") then
            isColliding = true
            collisionType = "goal"
            Timer.script(waitF(0.3))
        end
        if checkCombinations("goal","right") then
            isColliding = true
            collisionType = "goal"
            Timer.script(waitF(0.3))
        end
        if checkCombinations("secret","player") then
            isColliding = true
            collisionType = "secret"
            Timer.script(waitF(0.3))
        elseif checkCombinations("secret","right") then
            isColliding = true
            collisionType = "secret"
            Timer.script(waitF(0.3))
        end
        if checkCombinations("normal","left") then
            isColliding = true
            wallCol = true
            collisionType = "left"

        elseif checkCombinations("normal","right") then
            isColliding = true
            wallCol = true
            collisionType = "right"

        elseif checkCombinations("normal","player") then
            if not wallCol then
                isColliding = true
                collisionType = "normal"
            end
        end
    end
    if not Player:getStatus() then
        isColliding = false
        collisionType = "none"
    end
end
--Gets called when a contact has ended
function endContact(a, b, coll)
    ended = true
    if Player:getStatus() then
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
    if not wallCol and collisionType ~= "spike" then
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


