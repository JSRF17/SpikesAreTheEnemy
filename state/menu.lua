--[[
    Calls different functions in the menuSystem file
]]--

Menu = {}

function Menu:loadMenu()
    World = 0
    MenuSystem:init(1)
    LevelHandler:loadLevels()
    LevelHandler:loadCurrentLevel()
    Player:init(LevelHandler:playerSpawnLocation())
    Player:pushPlayer("justUp")
    alive = true
    died = false
    hit = false
    returned = false
    test = true
    paused = false
    cameraScale = 0
    initCamera = false
    camerScaleGoal = 0.8
    levelChange = false
    levelChangeDone = true
end

function Menu:update(dt)
    MenuSystem:update(dt)
    MenuSystem:Animate()
    w:update(dt)
    if alive then
        Player:track(dt)
        Player:animation(dt)
        Player:limitSpeed()
        if initCamera then
            camera.follow_style = 'LOCKON'
            initCamera = false
            camera.follow_style = 'PLATFORMER'
        end
        if CollisionHandler:getType() == "bounceRight" then
            Player:bounce(4200, -120, "right")
        end
        if CollisionHandler:getType() == "bounceLeft" then
            Player:bounce(-4200, -120, "left")
        end
        if CollisionHandler:getType() == "bounceUp" then
            Player:bounce(0, -5200, nil)
        end
    end
    if alive == false and levelChange == false then
        died = false
        Timer.script(function(wait)
            wait(0.4)
            alive = true
        end)
        if LevelHandler:playerReturnSpawnLocation() ~= nil and returned then
            Player:init(LevelHandler:playerReturnSpawnLocation())
            returned = false
        else
            Player:init(LevelHandler:playerSpawnLocation())
        end
    end

    if k.isDown( "escape" ) and levelChange == false and Transition:getState() == false 
    or TouchControls:getEvent("P") == "pause" and levelChange == false and Transition:getState() == false then
        if paused == false then
            SoundHandler:PlaySound("pause")
            Transition:init()
            Transition:activate()
            Timer.script(function(wait)
                wait(1.5)
                State:pause("menu")
                paused = false
                Transition:down()
            end)
        end
        paused = true
    end   
    if died == false and CollisionHandler:getSpikeTouch() then
        CollisionHandler:reset()
        Hit = true
        alive = false
        died = true
        w:setGravity( 0, 1280 )
        if test then
            Transition:deathTransition()
            Player:destroy("justPhysicsBody")
        end
        test = false
        Timer.script(function(wait)
            wait(0.8)
            Hit = false
            alive = false
            
        end)
        Timer.script(function(wait)
            wait(0.2)
            died = false
            test = true
        end)
        SoundHandler:PlaySound("dead")
    end

    if levelChange == false and CollisionHandler:getGoalTouch() then
        --SoundHandler:StopSound("all1")
        levelChange = true
        initCamera = true
        Transition:init()
        Transition:activate(true)
        levelChangeDone = false
        alive = false
        if test then
            Player:destroy()
        end
        test = false
        Timer.script(function(wait)
            wait(2.3)
            LevelHandler:next()
            Transition:down()
            levelChange = false
            test = true
        end)
        Timer.script(function(wait)
            wait(3)
            levelChangeDone = true
        end)
        SoundHandler:PlaySound("next")
    elseif levelChange == false and CollisionHandler:getReturnTouch() then
        levelChange = true
        initCamera = true
        Transition:init()
        Transition:activate(true)
        levelChangeDone = false
        alive = false
        returned = true
        if test then
            Player:destroy()
        end
        test = false
        Timer.script(function(wait)
            wait(2.3)
            LevelHandler:next(true)
            Transition:down()
            levelChange = false
            test = true
        end)
        Timer.script(function(wait)
            wait(3)
            levelChangeDone = true
        end)
        SoundHandler:PlaySound("next")
    end
    for i = 0, 13, 1 do
        if levelChange == false and CollisionHandler:getType() == "goal"..tostring(i) then
            levelChange = true
            World = i
            alive = false
            if test then
                Player:destroy()
            end
            test = false
            Transition:init()
            Transition:activate(true)   
            Timer.script(function(wait)
                wait(2.3)
                State:allFalse()
                State:gameStart()
                Diamonds:countReset()
                Transition:down()
            end)
            break
        end
    end
    if MenuSystem:StartedMenuGame() then
        Grass:animate(dt)
        Grass:update()
        TouchControls:update()
        if levelChangeDone then
            Player:controls(dt)
        end
        if Player:getPositionX() ~= nil and camerScaleGoal < 1.18 then
            if mobile then
                camera.x = Player:getPositionX() - 160
                camera.y = Player:getPositionY() - 10
            else
                camera.x = Player:getPositionX() + 20
                camera.y = Player:getPositionY() - 10
            end
        end
        cameraScale = cameraScale + dt
        if cameraScale > 0.01 then
            if camerScaleGoal < 1.18 then
                camerScaleGoal = camerScaleGoal + 0.01
                camera.scale = camerScaleGoal 
            end
            cameraScale = 0
        end
    end
end

function Menu:draw()
    if MenuSystem:StartedMenuGame() then
        camera:attach()
            LevelHandler:drawLevel()
            --MenuSystem:draw()
            if alive then
                Player:draw()
            end
            Grass:draw()
        camera:detach()
    else
        LevelHandler:drawLevel()
        MenuSystem:draw()
        if alive then
            Player:draw()
        end
    end
    if died == true then
        local dx = love.math.random(-0, 0)
        local dy = love.math.random(-10, 10)
        love.graphics.translate(dx, dy) 
    end
end

function Menu:dispose()
    alive = nil
    hit = nil
    died = nil
    levelChange = nil
    CollisionHandler:reset()
    Player:destroy()
end