--[[
    Calls different functions in the menuSystem file
]]--

Menu = {}

function Menu:loadMenu()
    World = 0
    MenuSystem:init(1)
    LevelHandler:loadLevels()
    LevelHandler:loadCurrentLevel()
    Player:pushPlayer("justUp")
    Player:init(LevelHandler:playerSpawnLocation())
    alive = true
    died = false
    hit = false
    test = true
    cameraScale = 0
    camerScaleGoal = 0.8
    levelChange = false
end

function Menu:update(dt)
    MenuSystem:update(dt)
    MenuSystem:Animate()
    w:update(dt)
    if alive then
        Player:track(dt)
        Player:animation(dt)
    end
    if alive == false and levelChange == false then
        died = false
        alive = true
        Player:init(LevelHandler:playerSpawnLocation())
    end
    if died == false and CollisionHandler:getSpikeTouch() then
        CollisionHandler:reset()
        Hit = true
        alive = false
        died = true
        w:setGravity( 0, 1280 )
        if test then
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
    if levelChange == false and CollisionHandler:getType() == "goal" then
        --SoundHandler:StopSound("all1")
        levelChange = true
        Transition:init()
        Transition:activate(true)
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
        SoundHandler:PlaySound("next")
    end
    for i = 0, 12, 1 do
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
        Player:controls(dt)
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
            MenuSystem:draw()
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
    CollisionHandler:reset()
end