--[[Functions to run the game when state.game = 
    of importance are the update and draw functions.
    The update function updates the physics world, 
    player controls and text printout and some other
    things. This is all done in delta time (dt).
    Draw function draws the game.]]--

Game = {}

local Alive
local died
local LevelChange
local debug
local first
local gravityChangeKeyPress
local paused = false
local firstGravityChange = true
local Hit = false
local pauseText = false

--Initilize game values--
function Game:load()
    LevelHandler:loadLevels()
    Player:initLives(SpeedRun)
    Alive = true
    initCamera = true
    died = false
    LevelChange = false
    debug = false
    gravityChange = true
    gravityChangeKeyPress = true
    paused = false
    pauseText = false
    Text:init(0, 1500)
    LevelHandler:loadCurrentLevel()
    Player:pushPlayer("justUp")
    Grass:init()
end

--Disposes of certain values and resets them--
function Game:dispose()
    Alive = nil
    initCamera = nil
    died = nil
    LevelChange = nil
    debug = nil
    if Player:checkLives() ~= 0 then
        Player:destroy()
    end
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
    Diamonds:animate(dt)
    Grass:animate(dt)
    Grass:update()

    if pauseText then
        Text:moveUp()
        pauseText = false
    end
    if Alive then
        Player:controls(dt)
        Player:track(dt)
        Player:animation(dt)
        Player:limitSpeed()
        if initCamera then
            camera.follow_style = 'LOCKON'
            initCamera = false
            Timer.script(function(wait)
                wait(0.5)
                camera.follow_style = 'PLATFORMER'
            end)
        end
        if CollisionHandler:getType() == "bounceRight" then
            Player:bounce(4200, -120, "right")
        end
        if CollisionHandler:getType() == "bounceLeft" then
            Player:bounce(-4200, -520, "left")
        end
        if CollisionHandler:getType() == "bounceUp" then
            Player:bounce(0, -6200, nil)
        end
        if CollisionHandler:getType() == "bounceUpSmall" then
            Player:bounce(0, -3720, nil)
        end
    end

    if Hit == false then
        Text:dialogUpdate(dt)
    end

    if Alive == false and LevelChange == false and Player:checkLives() ~= 0 then
        Player:init(LevelHandler:playerSpawnLocation("x"),LevelHandler:playerSpawnLocation("y"),LevelHandler:getSpawnDirection())
        Alive = true
    end

    if k.isDown( "escape" ) and LevelChange == false and Transition:getState() == false 
    or TouchControls:getEvent("P") == "pause" and LevelChange == false and Transition:getState() == false then
        if paused == false then
            Text:moveDown()
            SoundHandler:PlaySound("pause")
            Transition:init()
            Transition:activate()
            Timer.script(function(wait)
                wait(1.5)
                State:pause()
                pauseText = true
                paused = false
                Transition:down()
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
            if gravityChange == true and Alive then
                if firstGravityChange then
                    Player:pushPlayer("down", true)
                    firstGravityChange = false
                else
                    Player:pushPlayer("down")
                end
                w:setGravity( 0, -1280 )
                gravityChange = false
            elseif gravityChange == false and Alive then
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
        CollisionHandler:reset()
        State:gameover()
    end

    if died == false and CollisionHandler:getSpikeTouch() and Player:checkLives() >= 1 then
        if Player:checkLives() ~= 0 then
            Transition:deathTransition()
        end
        CollisionHandler:reset()
        Hit = true
        Alive = false
        died = true
        Player:lostLife()
        w:setGravity( 0, 1280 )
        Player:destroy("justPhysicsBody")
        Timer.script(function(wait)
            wait(0.8)
            camera.follow_style = 'LOCKON'
            Hit = false
            Alive = false
            if Player:checkLives() ~= 0 then
                Text:dialogSetup1("Lives:"..Player:checkLives())
            end
        end)
        Timer.script(function(wait)
            wait(0.2)
            died = false
        end)
        Timer.script(function(wait)
            wait(1)
            camera.follow_style = 'PLATFORMER'
        end)
        SoundHandler:PlaySound("dead")
    elseif LevelChange == false and CollisionHandler:getGoalTouch() then
        --SoundHandler:StopSound("all1")
        Text:initMove()
        Text:moveDown()
        Transition:activate(true)
        Alive = false
        LevelChange = true
        Player:destroy()
        Timer.script(function(wait)
            wait(2.0)
            Text:reset()
            LevelHandler:next()
            LevelChange = false
            Transition:down()
        end)
        SoundHandler:PlaySound("next")
    elseif LevelChange == false and CollisionHandler:getSecretTouch() then
        Text:moveDown()
        Transition:activate(true)
        Alive = false
        LevelChange = true
        Player:destroy()
        initCamera = true
        Timer.script(function(wait)
            wait(2.0)
            Text:reset()
            LevelHandler:loadCurrentLevel(true)
            LevelChange = false
            Transition:down()
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
    end
    
    LevelHandler:drawLevel()

    if LevelHandler:getCurrentLevel() == 2 then
        if LevelHandler:getSecretLevel() then
            ArtGallery:draw()
        end
    end

    if Alive == true then
        Player:draw()
    end

    if debug == true then
        love.graphics.print(tostring(CollisionHandler:getType()), 100, 400, 0, 1)
        love.graphics.print(tostring(CollisionHandler:getStatus()), 300, 400, 0, 1)
    end
    Diamonds:draw()
    Grass:draw()
end

function Game:isLevelChange()
    return LevelChange
end