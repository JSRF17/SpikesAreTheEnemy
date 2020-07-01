--[[
    Functions to run the game when state.game =
    of importance are the update and draw functions.
    The update function updates the physics world,
    player controls and text printout and some other
    things. This is all done in delta time (dt).
    Draw function draws the game.
]]--

require("scripts.collisionHandler")

Game = {}

local Alive
local died
local LevelChange
local debug
local gravityChangeKeyPress

--[[This function runs when the state changes to game]]--
function startGame()
    SoundHandler:StopSound("all")
    function love.keypressed(key)
    end
    --[[Initilize game values]]--
    function Game:load()
        LevelHandler:loadLevels()
        Player:initLives()
        Alive = true
        died = false
        LevelChange = false
        debug = false
        gravityChange = true
        gravityChangeKeyPress = true
        Text:init(0, -300)
        LevelHandler:loadCurrentLevel()
        Player:pushPlayer("justUp")
    end
    --Disposes of certain values and resets them
    function Game:dispose()
        Alive = nil
        died = nil
        LevelChange = nil
        debug = nil
        Player:destroy()
    end

    --[[
        Updates various things depending on which level is active. Uses the collisionhandler to
        update certain things depending on collisions in the world. Also uses input functions from the player
        file, also updates text dialogs and more
    ]]--
    function Game:update(dt)
        SoundHandler:backgroundMusic("game")
        w:update(dt)
        if Alive then
            Player:controls(dt)
            Player:track(dt)
            Text:dialogUpdate(dt)
            Player:animation(dt)
        end

        if not Alive and not LevelChange then
            Player:die(dt)
            Player:init(LevelHandler:playerSpawnLocation())
            Alive = true
        end

        if love.keyboard.isDown("escape") and not LevelChange then
            SoundHandler:PlaySound("pause")
            State:pause()
            SoundHandler:StopSound("all")
        end
        if LevelHandler:returnGravityChange() and love.keyboard.isDown("space") and CollisionHandler:getStatus() and CollisionHandler:getType() ~= "left" and CollisionHandler:getType() ~= "right" then
            if gravityChangeKeyPress then
                gravityChangeKeyPress = false
                if gravityChange then
                    Player:pushPlayer("down")
                    w:setGravity(0, -1280)
                    gravityChange = false
                elseif not gravityChange then
                    Player:pushPlayer("up")
                    w:setGravity(0, 1280)
                    gravityChange = true
                end
                SoundHandler:PlaySound("jump")
                Timer.script(function(wait)
                    wait(0.03)
                    gravityChangeKeyPress = true
                end)
            end
        end

        if Player:checkLives() == 0 then
            State:gameover()
        end

        if not died and CollisionHandler:getSpikeTouch() then
            Alive = false
            died = true
            Player:destroy()
            Player:lostLife()
            w:setGravity(0, 1280)
            Timer.script(function(wait)
                wait(0.2)
                died = false
            end)
            SoundHandler:PlaySound("dead")
        elseif not LevelChange and CollisionHandler:getType() == "goal" then
            SoundHandler:StopSound("all1")
            Text:moveUp()
            Text:reset()
            if LevelList[9] then
                Curtain:moveUp()
            elseif LevelList[15] or LevelList[22] or LevelList[23] or LevelList[28] or LevelList[38] then
                Curtain:moveFromLeft()
            else
                Curtain:move()
            end
            Alive = false
            LevelChange = true
            Player:destroy()
            Timer.script(function(wait)
                wait(2.0)
                LevelHandler:next()
                LevelChange = false
            end)
            SoundHandler:PlaySound("next")
        elseif not LevelChange and CollisionHandler:getType() == "secret" then
            Text:moveUp()
            Text:reset()
            if LevelList[9] then
                Curtain:moveUp()
            elseif LevelList[15] then
                Curtain:moveFromLeft()
            else
                Curtain:move()
            end
            Alive = false
            LevelChange = true
            Player:destroy()
            Timer.script(function(wait)
                wait(2.0)
                LevelHandler:loadCurrentLevel(true)
                LevelChange = false
            end)
        end
    end
    --Gives acces to the world w in case it's needed in the collisionhandler--
    CollisionHandler:getWorld(w)
    --[[Draws everything relevant to the game, different levels get drawn depending on the LevelList value]]--
    function Game:draw()
        if died then
            local dx = love.math.random(-0, 0)
            local dy = love.math.random(-10, 10)
            love.graphics.translate(dx, dy)

            Timer.script(function(wait)
                wait(0.15)
            end)
        end
        LevelHandler:drawLevel()
        LevelHandler:drawGravityIcon()
        if Alive then
            Player:draw()
        end
        Text:dialogDraw(20, 20)
        Text:draw()
        if debug then
            love.graphics.print(tostring(CollisionHandler:getType()), 100, 400, 0, 1)
            love.graphics.print(tostring(CollisionHandler:getStatus()), 300, 400, 0, 1)
        end
        Curtain:draw()
        Player:drawDead()
        Player:drawLives()
        Speedrun:drawTime()
    end
end