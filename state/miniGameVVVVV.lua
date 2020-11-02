--[[
    MiniGame tribute to the great game VVVVV.
    Very messy code here....
]]--


MiniGameVVVVV = {}

local alive
local died
local LevelChange
local debug
local first
local gravityChangeKeyPress
local paused = false
local firstGravityChange = true
local Hit = false

local BackgroundColor = {}
local ForegroundColor = {}

local stonesR, stonesL, stonesRBig, stonesLBig

local stoneSpawnTime = 0

function start()
    SoundHandler:PlaySound("select")
    alive = true
    MiniGameVVVVV:animate(true)
    display = true
    displayR = true
end

local function gameOver()
    SoundHandler:PlaySound("dead")
    alive = false
    DataHandler:VVVVVSave(TimeKeeper)
    Timer.script(function(wait)
        wait(1.2)
        pressed = false
        lost = true
        Player:destroy()
        stonesR = nil
        stonesL = nil
        stonesRBig = nil
        stonesLBig = nil
        AllStones = nil
        MiniGameVVVVV:init()
    end)
end

function MiniGameVVVVV:dispose()
    SoundHandler:PlaySound("select")
    stonesFromLeft = nil
    stonesFromRight = nil
    stoneSpawnTime = nil
    batchen = nil
    batchenR = nil
    done = nil
    doneR = nil
    ForegroundColor = nil
    BackgroundColor = nil
    colourChangeTime = nil
    Roof = nil
    Ground = nil
    alive = nil
    lost = nil
    buttonsToTween = nil
    Time = nil
    TimeKeeper = nil
    Highscore = nil
end

local function ResetStoneLocationsFromLeft()
    Random1 = math.random(1,3)
    Random3 = math.random(1,3)
    Random4 = math.random(1,4)
    if Random1 == 1 then
        y1 = 250
        y2 = 280
        y3 = 310
        y4 = 340
    elseif Random1 == 2 then
        y1 = 300
        y2 = 330
        y3 = 360
        y4 = 390
    elseif Random1 == 3 then
        y1 = 280
        y2 = 310
        y3 = 340
        y4 = 370
    end

    if Random3 == 1 then
        y3_1 = 250
        y3_2 = 450
    elseif Random3 == 2 then
        y3_1 = 200
        y3_2 = 400
    elseif Random3 == 3 then
        y3_1 = 210
        y3_2 = 410
    end

    if Random4 == 1 then
        y4_1 = 250
        y4_2 = y4_1 + 100
    elseif Random4 == 2 then
        y4_1 = 250
        y4_2 = 250
    elseif Random4 == 3 then
        y4_1 = 300
        y4_2 = y4_1 - 100
    elseif Random4 == 4 then
        y4_1 = 400
        y4_2 = 400
    end

    stonesOriginalFromLeft = {
        ---x
        ----x 1
        -----x
        ------x
        {x=-10,y=y1,w=25,h=25,batch=1},{x=10,y=y2,w=25,h=25,batch=1},
        {x=30,y=y3,w=25,h=25,batch=1},{x=50,y=y4,w=25,h=25,batch=1},
        -----
        ----x 2
        ----x
        -----
        {x=-10,y=y2,w=25,h=25,batch=2},{x=-10,y=y3,w=25,h=25,batch=2},
        {x=-210,y=y2,w=25,h=25,batch=2},{x=-210,y=y3,w=25,h=25,batch=2},
        {x=-410,y=y2,w=25,h=25,batch=2},{x=-410,y=y3,w=25,h=25,batch=2},
        ----x
        ----- 3
        -----
        ----x
        {x=-10,y=y3_1,w=25,h=25,batch=3},{x=-10,y=y3_2,w=25,h=25,batch=3},
         ----x-----x------x-------x
        -----4
        -----
        -----
        {x=-450,y=y4_1,w=25,h=25,batch=4},{x= -250,y=y4_2,w=25,h=25,batch=4},
        {x= -50,y=y4_1,w=25,h=25,batch=4},{x= 150,y=y4_2,w=25,h=25,batch=4},
        -----x--------
        -----------x--5
        -----------x--
        -----x--------
        {x=-10,y=285,w=25,h=25,batch=5},{x=-10,y=315,w=25,h=25,batch=5},
        {x=-210,y=400,w=25,h=25,batch=5},{x=-210,y=200,w=25,h=25,batch=5},
         -----x--
        ------x--6
        ------x--
        ----- x--
        {x=-10,y=300,w=25,h=25,batch=6},{x=-10,y=330,w=25,h=25,batch=6},
        {x=-10,y=360,w=25,h=25,batch=6},{x=-10,y=390,w=25,h=25,batch=6},
        {x=-10,y=270,w=25,h=25,batch=6},{x=-10,y=240,w=25,h=25,batch=6},
    }
end

local function ResetStoneLocationsFromRight()
    RRandom1 = math.random(1,3)
    RRandom3 = math.random(1,3)
    RRandom4 = math.random(1,4)
    if RRandom1 == 1 then
        if y1 == 250 then
            Ry1 = 300
            Ry2 = 330
            Ry3 = 360
            Ry4 = 390
        else
            Ry1 = 250
            Ry2 = 280
            Ry3 = 310
            Ry4 = 340
        end
    elseif RRandom1 == 2 then
        if y1 == 300 then
            Ry1 = 250
            Ry2 = 280
            Ry3 = 310
            Ry4 = 340
        else
            Ry1 = 300
            Ry2 = 330
            Ry3 = 360
            Ry4 = 390
        end
    elseif RRandom1 == 3 then
        if y1 == 400 then
            Ry1 = 300
            Ry2 = 330
            Ry3 = 360
            Ry4 = 390
        else
            Ry1 = 280
            Ry2 = 310
            Ry3 = 340
            Ry4 = 370
        end
    end

    if RRandom3 == 1 then
        if y3_1 == 250 then
            Ry3_1 = 200
            Ry3_2 = 400
        else
            Ry3_1 = 210
            Ry3_2 = 410
        end
    elseif RRandom3 == 2 then
        if y3_1 == 200 then
            Ry3_1 = 240
            Ry3_2 = 440
        else
            Ry3_1 = 200
            Ry3_2 = 400
        end
    elseif RRandom3 == 3 then
        if y3_1 == 210 then
            Ry3_1 = 250
            Ry3_2 = 450
        else
            Ry3_1 = 210
            Ry3_2 = 410
        end
    end

    if RRandom4 == 1 then
        if y4_1 == 250 then
            Ry4_1 = 250
            Ry4_2 = 250
        else
            Ry4_1 = 250
            Ry4_2 = Ry4_1 + 100
        end
    elseif RRandom4 == 2 then
        if y4_1 == 250 then
            Ry4_1 = 250
            Ry4_2 = Ry4_1 + 100
        else
            Ry4_1 = 250
            Ry4_2 = 250
        end
    elseif RRandom4 == 3 then
        if y4_1 == 300 then
            Ry4_1 = 250
            Ry4_2 = 250
        else
            Ry4_1 = 300
            Ry4_2 = Ry4_1 - 100
        end
    elseif RRandom4 == 4 then
        if y4_1 == 400 then
            Ry4_1 = 300
            Ry4_2 = Ry4_1 - 100
        else
            Ry4_1 = 400
            Ry4_2 = 400
        end
    end

    stonesOriginalFromRight = {
        ---x
        ----x 1
        -----x
        ------x
        {x=1400,y=Ry1,w=25,h=25,batch=1},{x=1370,y=Ry2,w=25,h=25,batch=1},
        {x=1340,y=Ry3,w=25,h=25,batch=1},{x=1310,y=Ry4,w=25,h=25,batch=1},
        -----
        ----x 2
        ----x
        -----
        {x=1400,y=Ry2,w=25,h=25,batch=2},{x=1400,y=Ry3,w=25,h=25,batch=2},
        {x=1600,y=Ry2-100,w=25,h=25,batch=2},{x=1600,y=Ry3+100,w=25,h=25,batch=2},
        ----x
        ----- 3
        -----
        ----x
        {x=1200,y=Ry3_1,w=25,h=25,batch=3},{x=1200,y=Ry3_2,w=25,h=25,batch=3},
        {x=1400,y=Ry3_1,w=25,h=25,batch=3},{x=1400,y=Ry3_2,w=25,h=25,batch=3},
        {x=1600,y=Ry3_1,w=25,h=25,batch=3},{x=1600,y=Ry3_2,w=25,h=25,batch=3},
         ----x-----x------x-------x
        -----4
        -----
        -----
        {x=1750,y=Ry4_1,w=25,h=25,batch=4},{x=1550,y=Ry4_2,w=25,h=25,batch=4},
        {x=1350,y=Ry4_1,w=25,h=25,batch=4},{x=1150,y=Ry4_2,w=25,h=25,batch=4},
        -----x--------
        -----------x--5
        -----------x--
        -----x--------
        {x=-10,y=330,w=25,h=25,batch=5},{x=-10,y=350,w=25,h=25,batch=5},
        {x=-210,y=400,w=25,h=25,batch=5},{x=-210,y=200,w=25,h=25,batch=5},
    }
end

function MiniGameVVVVV:init()
    math.randomseed(os.time())
    --setup world-----
    p.setMeter(140)
    w = p.newWorld(0, 12.8*p.getMeter(), true)
    w:setCallbacks(beginContact, endContact)
    persisting = 0
    -------------------
    ---setup stones----
    ResetStoneLocationsFromLeft()
    ResetStoneLocationsFromRight()
    stonesFromLeft = stonesOriginalFromLeft
    stonesFromRight = stonesOriginalFromRight
    stoneSpawnTime = 0
    batchen = math.random(1,6)
    batchenR = math.random(1,5)
    done = false
    doneR = false
    -------------------
    ---Colour setup----
    ForegroundColor = {0.459, 0.863, 0.106}
    BackgroundColor = {0.278, 0.424, 0.153} 
    colourChangeTime = 0
    -------------------
    ---Setup physics objects---
    Roof = {}
    Ground = {}
    Roof.b = p.newBody(w, 600, 160, "static")
    Roof.s = p.newRectangleShape(1380, 1)
    Roof.f = p.newFixture(Roof.b, Roof.s)
    Roof.f:setUserData("Roof")

    Ground.b = p.newBody(w, 600, 550, "static")
    Ground.s = p.newRectangleShape(1380, 1)
    Ground.f = p.newFixture(Ground.b, Ground.s)
    Ground.f:setUserData("Ground")
    Player:init(300, 300)
    Player:pushPlayer("justUp")
    alive = false
    lost = false
    --------------------------
    ---Objects to tween (buttons)-------
    buttonsToTween = {}
    buttonsToTween.button = {x = -300, y = -540, width = 300, height = 100}
    buttonsToTween.buttonText = {x = -300, y = -540}
    buttonsToTween.button2 = {x = -300, y = -540, width = 300, height = 100}
    buttonsToTween.buttonText2 = {x = -300, y = -540}
    buttonsToTween.Header = {x = 700, y = -540}
    ------------------------------------
    MiniGameVVVVV:animate()
    ----Timer-----
    Time = 0
    TimeKeeper = 0.0
    -------------
    ---Highscore---
    Highscore = DataHandler:VVVVVLoad()
    ---------------
    pressed = false
    TouchControls:init(3)
end

function MiniGameVVVVV:update(dt)
    function love.mousepressed(x, y)
        local globalX, globalY = push:toGame(x, y)
        if pressed == false then
            if globalX >= buttonsToTween.button.x and globalX <= buttonsToTween.button.x + buttonsToTween.button.width and globalY >= buttonsToTween.button.y and globalY <= buttonsToTween.button.y + buttonsToTween.button.height then
                pressed = true
                start()
            end
            if globalX >= buttonsToTween.button2.x and globalX <= buttonsToTween.button2.x + buttonsToTween.button2.width and globalY >= buttonsToTween.button2.y and globalY <= buttonsToTween.button2.y + buttonsToTween.button2.height then
                pressed = true
                Transition:activate()
                Timer.script(function(wait)
                    wait(2.3)
                    State:menuStart()
                    Player:destroy()
                    MiniGameVVVVV:dispose()
                    w:destroy()
                end)
            end
        end
    end

    if lost then
        alpha = alpha + 0.0001
    end

    if alive then
        --Update Time---
        Time = Time + dt
        if Time > 0.1 then
            TimeKeeper = TimeKeeper + 0.1
            Time = 0
        end
        -----------------
        --Update world and player--
        w:update(dt)
        Player:track()
        Player:animation(dt)
        Player:controls(dt, true)
        PlayerX = Player:getPositionX() 
        PlayerY = Player:getPositionY()
        if PlayerX > 1100 then
            Player:destroy("physics")
            Player:teleport(205)
            Player:init(205, PlayerY)
        end
        if PlayerX < 195 then
            Player:destroy("physics")
            Player:teleport(1090)
            Player:init(1090, PlayerY)
        end
        if CollisionHandler:getType() == "Roof" then
            w:setGravity( 0, 1280 )
        elseif CollisionHandler:getType() == "Ground" then
            w:setGravity( 0, -1280 )
        end
        ------End of player and world update stuff-----------
        ---Colour stuff-----
        randRGB = math.random(1,5)
        if colourChangeTime > 1.5 then
            if randRGB == 1 then
                ForegroundColor = {0.459, 0.863, 0.106}
                BackgroundColor = {0.278, 0.424, 0.153} --Background
            elseif randRGB == 2 then
                ForegroundColor = {0.863, 0.863, 0.106}
                BackgroundColor = {0.416, 0.424, 0.153} --Background
            elseif randRGB == 3 then
                ForegroundColor = {0.862, 0.105, 0.63}
                BackgroundColor = {0.42, 0.152, 0.325}
            elseif randRGB == 4 then
                ForegroundColor = {0.10, 0.86, 0.219}
                BackgroundColor = {0.149, 0.415, 0.156}
            elseif randRGB == 5 then
                ForegroundColor = {0.105, 0.862, 0.611}
                BackgroundColor = {0.149, 0.415, 0.392}
            end
            colourChangeTime = 0
        end
        colourChangeTime = colourChangeTime + dt
        ------End of colour stuff----------
        ---Stone stuff-----
        if done then
            stonesFromLeft = stonesOriginalFromLeft
            batchen = math.random(1,6)
            done = false
            display = true
        end
        if doneR then
            stonesFromRight = stonesOriginalFromRight
            batchenR = math.random(1,5)
            if batchen == batchenR then
                if batchenR == 1 then
                    batchenR = batchenR + 1
                elseif batchenR == 5 then
                    batchenR = batchenR - 1
                else
                    batchenR = batchenR + 1
                end
            end
            doneR = false
            display = true
        end
        stoneSpawnTime = stoneSpawnTime + dt
        if stoneSpawnTime > 1 then
            for i = 1, #stonesFromLeft, 1 do            
                if stonesFromLeft[i].x < 1750 and stonesFromLeft[i].batch == batchen then
                    stonesFromLeft[i].x = stonesFromLeft[i].x + 12
                end
                if stonesFromLeft[i].x > 1730 then
                    done = true
                    ResetStoneLocationsFromLeft()
                end
            end
        end
        if stoneSpawnTime > 1 then
            for i = 1, #stonesFromRight, 1 do          
                if stonesFromRight[i].x > -750 and stonesFromRight[i].batch == batchenR then
                    stonesFromRight[i].x = stonesFromRight[i].x - 12
                end
                if stonesFromRight[i].x < -730 then
                    doneR = true
                    ResetStoneLocationsFromRight()
                end
            end
        end
        for i = 1, #stonesFromLeft, 1 do
            if stonesFromLeft[i].x ~= nil then
                if PlayerX + 5 >= stonesFromLeft[i].x and PlayerX - 5 <= stonesFromLeft[i].x + stonesFromLeft[i].w
                and PlayerY + 5 >= stonesFromLeft[i].y and PlayerY - 5 <= stonesFromLeft[i].y + stonesFromLeft[i].h then
                    gameOver()
                end
            end
        end
        for i = 1, #stonesFromRight, 1 do
            if stonesFromRight[i].x ~= nil then
                if PlayerX + 5 >= stonesFromRight[i].x and PlayerX - 5 <= stonesFromRight[i].x + stonesFromRight[i].w 
                and PlayerY + 5 >= stonesFromRight[i].y and PlayerY - 5 <= stonesFromRight[i].y + stonesFromRight[i].h then
                    gameOver()
                end
            end
        end
    end
end

function MiniGameVVVVV:draw()
    g.setColor(BackgroundColor)
    g.rectangle("fill", 1, 1, 1280, 1280)
    g.setColor(ForegroundColor)
    for i = 1, #stonesFromLeft, 1 do
        if stonesFromLeft[i].x ~= nil then
            g.rectangle("line", stonesFromLeft[i].x, stonesFromLeft[i].y, stonesFromLeft[i].w, stonesFromLeft[i].h)
        end
    end
    for i = 1, #stonesFromRight, 1 do
        if stonesFromRight[i].x ~= nil then
            g.rectangle("line", stonesFromRight[i].x, stonesFromRight[i].y, stonesFromRight[i].w, stonesFromRight[i].h)
        end
    end
    if lost ~= true then
        Player:draw(true)
    end
    if alive then
        for i = 1, #stonesOriginalFromLeft, 1 do
            if stonesOriginalFromLeft[i].batch == batchen then
                if display then
                    g.printf("!", 110, stonesOriginalFromLeft[i].y, 400, "center", 0, 0.5)
                end
            end
        end

        for i = 1, #stonesOriginalFromRight, 1 do
            if stonesOriginalFromRight[i].batch == batchenR then
                if displayR then
                    g.printf("!", 1000, stonesOriginalFromRight[i].y, 400, "center", 0, 0.5)
                end
            end
        end
    end

    g.setColor(ForegroundColor)
    g.rectangle("line", 1, 160, 1280, 1)
    g.rectangle("line", 1, 550, 1280, 1)

    g.rectangle("fill", 1, 0, 200, 900)
    g.rectangle("fill", 1100, 0, 200, 900)

    g.rectangle("fill", 1, 0, 1280, 150)
    g.rectangle("fill", 10, 560, 1280, 300)
   
    if alive == false then
        g.setColor(ForegroundColor)
        g.printf("DaVVVVVe", buttonsToTween.Header.x, buttonsToTween.Header.y, 400, "center", 0, 1)
        g.printf("play",  buttonsToTween.buttonText.x, buttonsToTween.buttonText.y, 400, "center", 0, 0.6)
        g.rectangle("line", buttonsToTween.button.x, buttonsToTween.button.y, 300, 100)
        g.printf("quit", buttonsToTween.buttonText2.x, buttonsToTween.buttonText2.y, 400, "center", 0, 0.6)
        g.rectangle("line", buttonsToTween.button2.x, buttonsToTween.button2.y, 300, 100)
    end
    g.setColor(1,1,1)
    g.printf("Score:"..TimeKeeper, 300, 50, 400, "left", 0, 0.5)
    g.printf("High:"..Highscore, 900, 50, 400, "left", 0, 0.5)
end

function MiniGameVVVVV:animate(away)
    if away then
        Timer.tween(2, buttonsToTween.Header, {x = 700 }, 'in-out-quad')
        Timer.tween(2, buttonsToTween.Header, {y = -540}, 'in-out-quad')
        Timer.tween(2, buttonsToTween.buttonText, {x = -300}, 'in-out-quad')
        Timer.tween(2, buttonsToTween.buttonText, {y = -540}, 'in-out-quad')
        Timer.tween(2, buttonsToTween.button, {x = -300}, 'in-out-quad')
        Timer.tween(2, buttonsToTween.button, {y = -540}, 'in-out-quad')
        Timer.tween(2, buttonsToTween.buttonText2, {x = -300}, 'in-out-quad')
        Timer.tween(2, buttonsToTween.buttonText2, {y = -540}, 'in-out-quad')
        Timer.tween(2, buttonsToTween.button2, {x = -300}, 'in-out-quad')
        Timer.tween(2, buttonsToTween.button2, {y = -540}, 'in-out-quad')
    else
        Timer.tween(2, buttonsToTween.Header, {x = 465}, 'in-out-quad')
        Timer.tween(2, buttonsToTween.Header, {y = 170}, 'in-out-quad')
        Timer.tween(2, buttonsToTween.buttonText, {x = 535}, 'in-out-quad')
        Timer.tween(2, buttonsToTween.buttonText, {y = 300}, 'in-out-quad')
        Timer.tween(2, buttonsToTween.button, {x = 500}, 'in-out-quad')
        Timer.tween(2, buttonsToTween.button, {y = 270}, 'in-out-quad')
        Timer.tween(2, buttonsToTween.buttonText2, {x = 535}, 'in-out-quad')
        Timer.tween(2, buttonsToTween.buttonText2, {y = 410}, 'in-out-quad')
        Timer.tween(2, buttonsToTween.button2, {x = 500}, 'in-out-quad')
        Timer.tween(2, buttonsToTween.button2, {y = 380}, 'in-out-quad')
    end
end


