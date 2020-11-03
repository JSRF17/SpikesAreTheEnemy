--[[
    Handles the logic for the every menu (main, pause, game over)
]]--

MenuSystem = {}

local activeMenu, selectedButton, menuState, unlockedWorld, stateButtonsText, buttons, baseX, baseY, buttonsToTween, lenghtReached, rectangelFill, darkText
local font = love.graphics.newFont("resources/jackeyfont.ttf", 62)
--Loading current settings based on saved file---
SettingsChanger:loadSettings()
local vissibleControls = SettingsChanger:getSettings("vissibleControls")
--------------------------------------------------
local sound = SettingsChanger:getSettings("sound")
local music = SettingsChanger:getSettings("music")
local dPad = SettingsChanger:getSettings("dPad")

function MenuSystem:init(selectedMenu)
    ForegroundColor = {0.8, 0.8, 0.8}
    colourChangeTime = 0
    SpeedRun = false
    activeMenu = selectedMenu
    menuState = 1
    darkText = false
    --Used to check wether a level is unlocked or not
    unlockedWorld = tonumber(DataHandler:loadGame())
    worldtable = {}
    rectangleFill = "line"
    SpeedRun = false
    buttons = {}
    buttonBack = {}
    buttonNext = {}
    buttonSpeedRun = {}
    buttonMiniGame = {}
    love.graphics.setFont(font)
    MenuSystem:menuStateChange()
    --Tables that contain number of buttons and their text
    if activeMenu == 1 then
        if osString == "Android" or osString == "iOS" then
            menu = {
                {{"start game", "settings", "about", "quit"}},
                {{"Level 1", "Level 2", "Level 3", "Level 4", "Level 5", "Level 6", "Level 7", "Level 8"}},
                {{"sound", "music", "dPad", "invissible controls"}},
                {{"Use the on screen controls to control Dave and complete the levels.\nWatch out for spikes and don't waste those lives\n\nA game by Oliver Kjellen 2020\nSpecial thanks to SpeckyYT for support and testing"}},
                {{"Level 9", "Level 10", "Level 11", "Level 12"}},
                {{"DaVVVVVe", "Pixel", "Race"}}
            }
        else
            menu = {
                {{"start game", "settings", "about", "quit"}},
                {{"Level 1", "Level 2", "Level 3", "Level 4", "Level 5", "Level 6", "Level 7", "Level 8"}},
                {{"sound", "music"}},
                {{"Use the arrow keys to control Dave and complete the levels.\nWatch out for spikes and don't waste those lives\n\nA game by Oliver Kjellen 2020\nSpecial thanks to SpeckyYT for support and testing"}},
                {{"Level 9", "Level 10", "Level 11", "Level 12"}},
                {{"DaVVVVVe", "Pixel", "Race"}}
            }
        end
        menu.header = {"SUPER_Retro Dave"}
    elseif activeMenu == 2 then
        menu = {
            {{"resume game", "to menu"}}
        }
        menu.header = {"paused"}
    else
        menu = {
            {{"retry", "quit"}}
        }
        menu.header = {"game over"}
    end

    if activeMenu == 1 then
        activeHeader = 1
    elseif activeMenu == 2 then
        activeHeader = 2
    else
        activeHeader = 3
    end
    NonDTANIM = "yas"
    AnimateNonDT()
    SettingsChanger:loadSettings()
    sound = SettingsChanger:getSettings("sound")
    music = SettingsChanger:getSettings("music")
    dPad = SettingsChanger:getSettings("dPad")
end


function MenuSystem:update(dt)
     --Handles user input while the menu is active
    if States.menu == true or States.paused == true or States.gameOver == true then
        randRGB = math.random(1,5)
        if colourChangeTime > 3.5 then
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
        function love.mousepressed(x, y)
            local globalX, globalY = push:toGame(x, y)
            if globalX ~= nil and globalY ~= nil then
                for i = 1, #buttons, 1 do
                    if globalX >= buttons[i].x and globalX <= buttons[i].x + buttons[i].width and globalY >= buttons[i].y and globalY <= buttons[i].y + buttons[i].height then
                        if buttons[i].id == i then
                            SoundHandler:PlaySound("select")
                            if activeMenu == 1 then
                                if menuState == 1 then
                                    if i == 1 then
                                        menuState = 2
                                    elseif i == 2 then
                                        menuState = 3
                                    elseif i == 3 then
                                        menuState = 4
                                    elseif i == 4 then
                                       love.event.quit(0)
                                    end
                                elseif menuState == 2 then
                                    for f = 1, #buttons, 1 do 
                                        if f == buttons[i].id then
                                            if worldtable[f] == true or i == 1 then
                                                World = i
                                                if menuState == 5 then
                                                    local var = 9
                                                    local first = false
                                                    for i = 1, #worldtable, 1 do
                                                        if first == false then
                                                            worldtable[i] = var
                                                            first = true
                                                            World = var
                                                        else
                                                            var = var + 1
                                                            worldtable[i] = var
                                                            World = var
                                                        end
                                                    end
                                                end
                                                if World == 1 and tonumber(DataHandler:loadGame()) == 0 then
                                                    Timer.clear()
                                                    Transition:activate()
                                                    State:allFalse()
                                                    Timer.script(function(wait)
                                                        wait(2.3)
                                                        State:introStart()
                                                        Diamonds:countReset()
                                                    end)
                                                elseif worldtable[f] == true then
                                                    Timer.clear()
                                                    Transition:activate()
                                                    State:allFalse()
                                                    Timer.script(function(wait)
                                                        wait(2.3)
                                                        State:gameStart()
                                                        Diamonds:countReset()
                                                    end)
                                                end                    
                                            end
                                        end
                                    end
                                elseif menuState == 5 then
                                    for f = 1, #buttons, 1 do 
                                        if f == buttons[i].id then
                                            if worldtable[9] == true and f == 1 then
                                                World = 9
                                            elseif worldtable[10] == true and f == 2 then
                                                World = 10
                                            elseif worldtable[11] == true and f == 3 then
                                                World = 11
                                            elseif worldtable[12] == true and f == 4 then
                                                World = 12
                                            elseif worldtable[13] == true and f == 5 then
                                                World = 13
                                            elseif worldtable[14] == true and f == 6 then
                                                World = 14
                                            elseif worldtable[15] == true and f == 7 then
                                                World = 15
                                            elseif worldtable[16] == true and f == 8 then
                                                World = 16
                                            elseif worldtable[17] == true and f == 9 then
                                                World = 17
                                            end
                                            if World > 8 then
                                                Timer.clear()
                                                Transition:activate()
                                                State:allFalse()
                                                Timer.script(function(wait)
                                                    wait(2.3)
                                                    State:gameStart()
                                                    Diamonds:countReset()
                                                end)
                                            end                    
                                        end
                                    end
                                elseif menuState == 6 then
                                    for f = 1, #buttons, 1 do 
                                        for f = 1, #buttons, 1 do 
                                            if f == buttons[i].id then
                                                if f == 1 then
                                                    --Minigame VVVVV
                                                    Timer.clear()
                                                    Transition:activate()
                                                    State:allFalse()
                                                    Timer.script(function(wait)
                                                        wait(2.3)
                                                        State:miniGame1()
                                                    end)
                                                end                
                                            end
                                        end
                                    end
                                elseif menuState == 3 then
                                    if i == 1 then
                                        SettingsChanger:turnOnOffSound()
                                        sound = SettingsChanger:getSettings("sound")
                                    elseif i == 2 then
                                        SettingsChanger:turnOnOffMusic()
                                        music = SettingsChanger:getSettings("music")
                                    elseif i == 3 then
                                        SettingsChanger:changeControls()
                                        dPad = SettingsChanger:getSettings("dPad")
                                    elseif i == 4 then
                                        SettingsChanger:vissibleControlsOff()
                                        vissibleControls = SettingsChanger:getSettings("vissibleControls")
                                    end
                                end
                            elseif activeMenu == 2 then
                                if i == 1 then
                                    Timer.clear()
                                    Transition:activate()
                                    State:allFalse()
                                    Timer.script(function(wait)
                                        wait(2.3)
                                        State:resume()
                                    end)
                                elseif i == 2 then
                                    Game:dispose()
                                    LevelHandler:dispose()
                                    State:menuStart()
                                end
                            elseif activeMenu == 3 then
                                if i == 1 then
                                    Game:dispose()
                                    LevelHandler:dispose()
                                    Timer.clear()
                                    Transition:activate()
                                    State:allFalse()
                                    Timer.script(function(wait)
                                        wait(2.3)
                                        State:gameStart()
                                        Diamonds:countReset()
                                    end)
                                elseif i == 2 then
                                    Game:dispose()
                                    LevelHandler:dispose()
                                    State:menuStart()
                                end
                            end
                            MenuSystem:menuStateChange()
                        end
                    end
                end
                if buttonBack[1] ~= nil then
                    if globalX >= buttonBack[1].x and globalX <= buttonBack[1].x + buttonBack[1].width and globalY >= buttonBack[1].y and globalY <= buttonBack[1].y + buttonBack[1].height then
                        SoundHandler:PlaySound("select")
                        if menuState == 5 or menuState == 6 then
                            menuState = 2 
                        else
                            menuState = 1
                        end 
                        MenuSystem:menuStateChange()
                    end
                end
                if buttonNext[1] ~= nil then
                    if globalX >= buttonNext[1].x and globalX <= buttonNext[1].x + buttonNext[1].width and globalY >= buttonNext[1].y and globalY <= buttonNext[1].y + buttonNext[1].height then
                        SoundHandler:PlaySound("select")
                        menuState = 5
                        MenuSystem:menuStateChange()
                    end
                end
                if buttonSpeedRun[1] ~= nil then
                    if globalX >= buttonSpeedRun[1].x and globalX <= buttonSpeedRun[1].x + buttonSpeedRun[1].width and globalY >= buttonSpeedRun[1].y and globalY <= buttonSpeedRun[1].y + buttonSpeedRun[1].height then
                        SoundHandler:PlaySound("select")
                        Timer.clear()
                        Transition:activate()
                        State:allFalse()
                        World = 1
                        SpeedRun = true
                        Timer.script(function(wait)
                            wait(2.3)
                            State:gameStart()
                        end)
                    end
                end
                if buttonMiniGame[1] ~= nil then
                    if globalX >= buttonMiniGame[1].x and globalX <= buttonMiniGame[1].x + buttonMiniGame[1].width and globalY >= buttonMiniGame[1].y and globalY <= buttonMiniGame[1].y + buttonMiniGame[1].height then
                        SoundHandler:PlaySound("select")
                        menuState = 6
                    end
                end
            end
        end 
    end
end
--This function gets called in the main love.draw call
function MenuSystem:draw()
    if States.menu == true or States.paused == true or States.gameOver == true then
        love.graphics.setColor(ForegroundColor)    
        for i = 1, #menu, 1 do
            if i == menuState then
                for v = 1, #menu[i], 1 do
                    for y = 1, #menu[i][v], 1 do
                        if menuState == 2 and worldtable[y] ~= true and y ~= 1 then
                            love.graphics.setColor(0.5, 0.5, 0.5, 0.8)      
                        end
                        if menuState == 5 and worldtable[9] ~= true and y == 1 then
                            love.graphics.setColor(0.5, 0.5, 0.5, 0.8)
                        elseif menuState == 5 and worldtable[10] ~= true and y == 2 then
                            love.graphics.setColor(0.5, 0.5, 0.5, 0.8)
                        elseif menuState == 5 and worldtable[11] ~= true and y == 3 then
                            love.graphics.setColor(0.5, 0.5, 0.5, 0.8)
                        elseif menuState == 5 and worldtable[12] ~= true and y == 4 then
                            love.graphics.setColor(0.5, 0.5, 0.5, 0.8)
                        end
                        if menuState == 3 and sound == "off" and y == 1 or menuState == 3 and sound == "firstTime" and y == 1 then
                            rectangleFill = "fill"
                            darkText = true
                        end
                        if menuState == 3 and music == "off" and y == 2 or menuState == 3 and music == "firstTime" and y == 2 then
                            rectangleFill = "fill"
                            darkText = true
                        end
                        if menuState == 3 and dPad == "off" and y == 3 or menuState == 3 and dPad == "firstTime" and y == 3 then
                            rectangleFill = "fill"
                            darkText = true
                        end
                        if menuState == 3 and vissibleControls == "off" and y == 4 or menuState == 3 and vissibleControls == "firstTime" and y == 4 then
                            rectangleFill = "fill"
                            darkText = true
                        end
                        if y <= 8 then
                            love.graphics.setColor(ForegroundColor)   
                            g.rectangle(rectangleFill, buttonsToTween[y].x, buttonsToTween[y].y, buttonsToTween[y].width, buttonsToTween[y].height)
                            if darkText == true then
                                love.graphics.setColor(0.2, 0.2, 0.2, 0.8)
                                darkText = false
                            end   
                            if y == 1 and menuState == 4 then
                                g.printf(menu[i][v][y], buttonsToTween[y].x + 50, buttonsToTween[y].y + 25, 1000, "center", 0, 0.5)
                            else
                                g.printf(menu[i][v][y], buttonsToTween[y].x + 50, buttonsToTween[y].y + 25, 400, "center", 0, 0.5)
                            end
                            buttons[y] = {x = buttonsToTween[y].x, y = buttonsToTween[y].y, width = buttonsToTween[y].width, height = buttonsToTween[y].height, id = y}
                        end
                        rectangleFill = "line"
                        love.graphics.setColor(0.8,0.8,0.8)  
                    end
                end
            end
        end
    end
    love.graphics.setColor(ForegroundColor)   
    g.printf(menu.header, buttonsToTween.header.x, buttonsToTween.header.y, 400, "center", buttonsToTween.header.rotation, buttonsToTween.header.size)
    if menuState > 1 then
        g.printf("back", buttonsToTween.back.x - 40, buttonsToTween.back.y + 17, 400, "center", 0, 0.5)
        g.rectangle("line",  buttonsToTween.back.x,  buttonsToTween.back.y,  buttonsToTween.back.width,  buttonsToTween.back.height)
        buttonBack[1] = {x = buttonsToTween.back.x, y = buttonsToTween.back.y, width = buttonsToTween.back.width, height = buttonsToTween.back.height, id = "back"}
    end
    if tonumber(DataHandler:loadGame()) == 14 and menuState == 2 or menuState == 5 and tonumber(DataHandler:loadGame()) == 14 then
        g.printf("SpeedRun", buttonsToTween.speedRun.x - 17, buttonsToTween.speedRun.y + 17, 400, "center", 0, 0.5)
        g.rectangle("line",  buttonsToTween.speedRun.x,  buttonsToTween.speedRun.y,  buttonsToTween.speedRun.width,  buttonsToTween.speedRun.height)
        buttonSpeedRun[1] = {x = buttonsToTween.speedRun.x, y = buttonsToTween.speedRun.y, width = buttonsToTween.speedRun.width, height = buttonsToTween.speedRun.height, id = "speedRun"}

        g.printf("MiniGames", buttonsToTween.miniGames.x - 17, buttonsToTween.miniGames.y + 17, 400, "center", 0, 0.5)
        g.rectangle("line",  buttonsToTween.miniGames.x,  buttonsToTween.miniGames.y,  buttonsToTween.miniGames.width,  buttonsToTween.miniGames.height)
        buttonMiniGame[1] = {x = buttonsToTween.miniGames.x, y = buttonsToTween.miniGames.y, width = buttonsToTween.miniGames.width, height = buttonsToTween.miniGames.height, id = "miniGame"}
    end
    if menuState == 2 then
        g.printf("next", buttonsToTween.next.x - 40, buttonsToTween.next.y + 17, 400, "center", 0, 0.5)
        g.rectangle("line",  buttonsToTween.next.x,  buttonsToTween.next.y,  buttonsToTween.next.width,  buttonsToTween.next.height)
        buttonNext[1] = {x = buttonsToTween.next.x, y = buttonsToTween.next.y, width = buttonsToTween.next.width, height = buttonsToTween.next.height, id = "next"}
    end
end

function MenuSystem:menuStateChange()
    for i = 1, #buttons, 1 do
        buttons[i] = {x = -1000, y = -300, width = 300, height = 100, id = 0}
    end
    for i = 1, #buttonBack, 1 do
        buttonBack[i] = {x = -1000, y = -300, width = 300, height = 100, id = 0}
    end
    draw = true
    allTweened = false
    baseY = 150
    baseX = 640
    buttonsToTween = {}
    allTweened = false
    headerTweened = false
    headerTweenedAnim = false
    for i = 1, 8, 1 do
        if menuState == 4 then
            buttonsToTween[i] = {x = -300, y = -210, width = 620, height = 350}
        else
            buttonsToTween[i] = {x = -300, y = -210, width = 300, height = 100}
        end
    end
    buttonsToTween.back = {x = -300, y = -540, width = 110, height = 70}
    buttonsToTween.next = {x = 1400, y = -540, width = 110, height = 70}
    buttonsToTween.speedRun = {x = 1400, y = -540, width = 160, height = 70}
    buttonsToTween.miniGames = {x = 1400, y = -640, width = 160, height = 70}
    buttonsToTween.header = {x = -300, y = -540, rotation=320, size=1.3}
    for i = 1, unlockedWorld, 1 do
        worldtable[i] = true
    end
end

function MenuSystem:Animate()
    for i = 1, #buttonsToTween, 1 do
        if i % 2 == 0 then
            baseX = baseX + 310
        else
            baseX = baseX - 310
            baseY = baseY + 110
        end
        if allTweened == false then
            Timer.tween(2, buttonsToTween[i], {x = baseX}, 'in-out-quad')
            Timer.tween(2, buttonsToTween[i], {y = baseY}, 'in-out-quad')
        end
        if headerTweened == false then
            Timer.tween(2, buttonsToTween.header, {y = 190}, 'in-out-quad')
            Timer.tween(2, buttonsToTween.header, {x = 0}, 'in-out-quad')
            Timer.tween(2, buttonsToTween.back, {y = 620}, 'in-out-quad')
            Timer.tween(2, buttonsToTween.back, {x = 100}, 'in-out-quad')
            headerTweened = true
            Timer.script(function(wait)
                wait(0.5)
                headerTweenedAnim = true
            end)
            if menuState == 2 then
                Timer.tween(2, buttonsToTween.next, {y = 620}, 'in-out-quad')
                Timer.tween(2, buttonsToTween.next, {x = 1060}, 'in-out-quad')
            end
            if tonumber(DataHandler:loadGame()) == 14 then
                Timer.tween(2, buttonsToTween.speedRun, {y = 300}, 'in-out-quad')
                Timer.tween(2, buttonsToTween.speedRun, {x = 1060}, 'in-out-quad')
                Timer.tween(2, buttonsToTween.miniGames, {y = 450}, 'in-out-quad')
                Timer.tween(2, buttonsToTween.miniGames, {x = 1060}, 'in-out-quad')
            end
        end
        if i == #buttonsToTween then
            allTweened = true
        end
    end
end 

function AnimateNonDT()
    Timer.every(1, function()
        if headerTweenedAnim then
            if NonDTANIM == "yas" then
                --for i = 1, # buttonsToTween, 1 do
                    --Timer.tween(1, buttonsToTween[i], {height = 90}, 'in-out-quad')
                    --Timer.tween(1, buttonsToTween[i], {width = 290}, 'in-out-quad')
                    Timer.tween(1, buttonsToTween.header, {size = 1.3}, 'in-out-quad')
                --end
                NonDTANIM = "nas"
            elseif NonDTANIM == "nas" then 
                --for i = 1, # buttonsToTween, 1 do
                    --Timer.tween(1, buttonsToTween[i], {height = 100}, 'in-out-quad')
                --  Timer.tween(1, buttonsToTween[i], {width = 300}, 'in-out-quad')
                --end
                Timer.tween(1, buttonsToTween.header, {size = 1}, 'in-out-quad')
                NonDTANIM = "yas"
            end
        end
    end)
end