--[[Functions to run the game when state.game = 
    of importance are the update and draw functions.
    The update function updates the physics world, 
    player controls and text printout and some other
    things. This is all done in delta time (dt).
    Draw function draws the game.]]--

require("scripts.collisionHandler")

Game = {}

local Alive
local died
local LevelChange
local debug
local first
local gravityChangeKeyPress
local paused = false
local firstGravityChange = true

--This function runs when the state changes to game--
function startGame()
    SoundHandler:StopSound("all1")
    function love.keypressed( key )
    end
    --Initilize game values--
    function Game:load()
        LevelHandler:loadLevels()
        Player:initLives()
        Alive = true
        died = false
        LevelChange = false
        debug = false
        gravityChange = true
        gravityChangeKeyPress = true
        paused = false
        Text:init(-200, 2050)
        LevelHandler:loadCurrentLevel()
        Player:pushPlayer("justUp")
        --LevelHandler:initPlatformPositions()
        Grass:init()
    end
    --Disposes of certain values and resets them--
    function Game:dispose()
        Alive = nil
        died = nil
        LevelChange = nil
        debug = nil
        Player:destroy()
    end
    --[[Updates various things depending on which level is active. Uses the collisionhandler to
        update certain things depending on collisions in the world. Also uses input functions from the player
        file, also updates text dialogs and more]]--
    function Game:update(dt)

        if k.isDown("left") or k.isDown("right") or TouchControls:getEvent("X") == "right" or TouchControls:getEvent("X") == "left" then
            firstGravityChange = false
        end
        w:update(dt)
        Diamonds:update(dt)
        Grass:animate(dt)
        Grass:update()
        if Alive then
            Player:controls(dt)
            Player:track(dt)
            Text:dialogUpdate(dt)
            Player:animation(dt)
        end

        if Alive == false and LevelChange == false then
            Player:init(LevelHandler:playerSpawnLocation())
            Alive = true
        end

        if k.isDown( "escape" ) and LevelChange == false or TouchControls:getEvent("P") == "pause" and LevelChange == false then
            if paused == false then
                SoundHandler:PlaySound("pause")
                Transition:init()
                Transition:activate()                            
                Timer.script(function(wait)
                    wait(1.5)
                    State:pause()
                    paused = false
                end)
            end
            paused = true
        end
        
        if LevelHandler:returnGravityChange() and k.isDown("space") and CollisionHandler:getStatus() 
        and CollisionHandler:getType() ~= "left" and CollisionHandler:getType() ~= "right" 
        or LevelHandler:returnGravityChange() and TouchControls:getEvent("invert") == true 
        and CollisionHandler:getStatus() and CollisionHandler:getType() ~= "left" and CollisionHandler:getType() ~= "right" then
            if gravityChangeKeyPress then
                gravityChangeKeyPress = false
                if gravityChange == true then
                    if firstGravityChange then
                        Player:pushPlayer("down", true)
                        firstGravityChange = false
                    else
                        Player:pushPlayer("down")
                    end
                    w:setGravity( 0, -1280 )
                    gravityChange = false
                elseif gravityChange == false then
                    Player:pushPlayer("up")
                    w:setGravity( 0, 1280 )
                    gravityChange = true
                end
                SoundHandler:PlaySound("invert")
                Timer.script(function(wait)
                    wait(0.03)
                    gravityChangeKeyPress = true
                end)
            end
        end

        if Player:checkLives() == 0 then
            State:gameover()
        end

        if died == false and CollisionHandler:getSpikeTouch() then
            Alive = false
            died = true
            Player:destroy()
            Player:lostLife()
            w:setGravity( 0, 1280 )
            Timer.script(function(wait)
                wait(0.2)
                died = false
            end)
            SoundHandler:PlaySound("dead")
            Text:dialogSetup1("Lives:"..Player:checkLives())
        elseif LevelChange == false and CollisionHandler:getType() == "goal" then
            --SoundHandler:StopSound("all1")
            Text:reset()
            Text:moveAway()
            Transition:activate(true)
            Alive = false
            LevelChange = true
            Timer.script(function(wait)
                wait(2.0)
                LevelHandler:next()
                LevelChange = false
            end)
            SoundHandler:PlaySound("next")
        elseif LevelChange == false and CollisionHandler:getType() == "secret" then
            Text:reset()
            Text:moveAway()
            Transition:activate(true)
            Alive = false
            LevelChange = true
            Timer.script(function(wait)
                wait(2.0)
                LevelHandler:loadCurrentLevel(true)
                LevelChange = false
            end)
        end
    end
    --Gives acces to the world w in case it's needed in the collisionhandler--
    --CollisionHandler:getWorld(w)
    --Draws everything relevant to the game, different levels get drawn depending on the LevelList value--
    function Game:draw()

        if died == true then
            local dx = love.math.random(-0, 0)
            local dy = love.math.random(-10, 10)
            love.graphics.translate(dx, dy)
            
            Timer.script(function(wait)
                wait(0.15)
            end)
        end

        LevelHandler:drawLevel()

        if Alive == true then
            Player:draw()
        end
        
        if debug == true then
            love.graphics.print(tostring(CollisionHandler:getType()), 100, 400, 0, 1)
            love.graphics.print(tostring(CollisionHandler:getStatus()), 300, 400, 0, 1)
        end
        Text:draw()
        Text:dialogDraw()
        Diamonds:draw()
        Grass:draw()
    end

    function Game:isLevelChange()
        return LevelChange
    end
end