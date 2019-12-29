--[[Menu logic
    Need to leave more comments!]]--

Menu = {}

function loadMenu()
    SoundHandler:StopSound("all")
    local selectedButton = 1
    local menuState = 1
    local scanlinesChange = 0
    local soundChange = 0
    local musicChange = 0
    --Used to check wether a level is unlocked or not
    local unlockedWorld = tonumber(DataHandler:loadGame())
    --Table that contains three more tables, used to store text for buttons
    local stateButtonsText = {
        {},
        {},
        {},
        {}
    }

    stateButtonsText[1][1] = "start game"
    stateButtonsText[1][2] = "settings"
    stateButtonsText[1][3] = "about"
    stateButtonsText[1][4] = "quit"

    stateButtonsText[2][1] = "Level 1"
    stateButtonsText[2][2] = "Level 2"
    stateButtonsText[2][3] = "Level 3"
    stateButtonsText[2][4] = "Level 4"
    stateButtonsText[2][5] = "Level 5"
    stateButtonsText[2][6] = "Level 6"
    stateButtonsText[2][7] = "Level 7"
    stateButtonsText[2][8] = "Level 8"

    stateButtonsText[3][1] = "scanlines On/Off"
    stateButtonsText[3][2] = "sound On/Off"
    stateButtonsText[3][3] = "music On/Off"

    stateButtonsText[4][1] = "A game by Oliver Kjellen 2019"
    --[[Maybe this function shouldn't bee called update, however it does reflect changes as in
        when a key is pressed a change is reflected to the screen. Also changes the current state of the menu.
        Lots of if statements, I should probably look through this again if I have the time.
    ]]--
    
    function Menu:update()
        --Handles user input while the menu is active 
        function love.keypressed( key )
            if key == "space" then
                SoundHandler:PlaySound("select")
            end

            if key == "down" and selectedButton > 0 then
                selectedButton = selectedButton + 1
            end
            if key == "down" and selectedButton > #stateButtonsText[menuState] then
                selectedButton = 1
            end
            if key == "up" and selectedButton < #stateButtonsText[menuState] or key == "up" and selectedButton == #stateButtonsText[menuState] then
                selectedButton = selectedButton - 1
            end
            if key == "up" and selectedButton < 1 then
                selectedButton = #stateButtonsText[menuState]
            end

            if menuState == 2 then
                if key == "space" and selectedButton == 1 then
                    World = 1
                    State:gameStart()
                end
                if key == "space" and selectedButton == 2 and unlockedWorld > 0 then
                    World = 2
                    State:gameStart()
                end
                if key == "space" and selectedButton == 3 and unlockedWorld > 1 then
                    World = 3
                    State:gameStart()
                end
                if key == "space" and selectedButton == 4 and unlockedWorld > 2 then
                    World = 4
                    State:gameStart()
                end
                if key == "space" and selectedButton == 5 and unlockedWorld > 3 then
                    World = 5
                    State:gameStart()
                end
                if key == "space" and selectedButton == 6 and unlockedWorld > 4 then
                    World = 6
                    State:gameStart()
                end
                if key == "space" and selectedButton == 7 and unlockedWorld > 5 then
                    World = 7
                    State:gameStart()
                end
                if key == "space" and selectedButton == 8 and unlockedWorld > 6 then
                    World = 8
                    State:gameStart()
                end
            end
            if menuState == 1 then
                if key == "space" and selectedButton == 1 then
                    menuState = 2
                end
                if key == "space" and selectedButton == 2 then
                    menuState = 3
                end
                if key == "space" and selectedButton == 3  then
                    menuState = 4
                end
                if key == "space" and selectedButton == 4  then
                    love.event.quit(0)
                end
            end
            if menuState == 3 then
                if key == "space" and selectedButton == 1 then
                    if scanlinesChange % 2 ~= 0 then
                        SettingsChanger:turnOffScanlines()
                    else
                        SettingsChanger:turnOnScanlines()
                    end
                    scanlinesChange = scanlinesChange + 1
                    
                end
                if key == "space" and selectedButton == 2 then
                    if soundChange % 2 ~= 0 then
                        SettingsChanger:turnOffSound()
                    else
                        SettingsChanger:turnOnSound()
                    end
                    soundChange = soundChange + 1
                end
                if key == "space" and selectedButton == 3 then
                    if musicChange % 2 ~= 0 then
                        SettingsChanger:turnOffSoundMusic()
                    else
                        SettingsChanger:turnOnSoundMusic()
                    end
                    musicChange = musicChange + 1
                end
            end
            if menuState == 4 then
                selectedButton = 2 
            end
            if key == "escape" then
                selectedButton = 1
                menuState = 1
                SoundHandler:PlaySound("back")
            end
        end
    end

    --Handles the different states the menu can be in
    --Main menu, settings, and level selector
    function Menu:state(height)
        SoundHandler:backgroundMusic("menu")
        local height = height
        local y = 325
        local base = 300
        --Draws the next box lower if the index is larger then 4
        for i = 4, 10, 1 do
            if selectedButton > i or selectedButton == i then
                y = y - 100
                base = base - 100
            else
                break
            end
        end
        if menuState ~= 4 then
            love.graphics.rectangle("fill", width/2 + 60, height, 350, 80) 
        end
        --Creates a rectangle for each word in stateButtonsText[menustate][number of words] depending on active menustate
        for i = 1, #stateButtonsText[menuState], 1 do
            if menuState == 4 then
                love.graphics.rectangle("line", width/2 + 60, base, 350, 120)
            else
                if i == 1 then
                    love.graphics.rectangle("line", width/2 + 60, base, 350, 80)
                else
                    love.graphics.rectangle("line", width/2 + 60, base + 100, 350, 80)
                    base = base + 100
                end
            end
        end
        --Prints text in each previously drawn box
        if menuState == 1 then
            Titel = love.graphics.print("5/10", width/2 + 160 , y - 150, 0, 1)
            for i = 1, #stateButtonsText[1], 1 do
                if i == selectedButton then
                    love.graphics.setColor(0, 0, 0, 1) 
                end        
                love.graphics.printf(stateButtonsText[1][i], width/2 + 130, y, 400, "center", 0, 0.5)
                y = y + 100
                love.graphics.setColor(1,1,1, 1) 
            end
        end
        if menuState == 2 then
            for i = 1, #stateButtonsText[2], 1 do
                if i == selectedButton then
                    love.graphics.setColor(0, 0, 0, 1) 
                end     
                if unlockedWorld == 0 then
                    if i > 1 then
                        love.graphics.setColor(0.3, 0.3, 0.3, 1) 
                    end
                end
                if unlockedWorld == 1 then
                    if i > 2 then
                        love.graphics.setColor(0.3, 0.3, 0.3, 1) 
                    end
                end
                if unlockedWorld == 2 then
                    if i > 3 then
                        love.graphics.setColor(0.3, 0.3, 0.3, 1) 
                    end
                end
                if unlockedWorld == 3 then
                    if i > 4 then
                        love.graphics.setColor(0.3, 0.3, 0.3, 1) 
                    end
                end
                if unlockedWorld == 4 then
                    if i > 5 then
                        love.graphics.setColor(0.3, 0.3, 0.3, 1) 
                    end
                end
                if unlockedWorld == 5 then
                    if i > 6 then
                        love.graphics.setColor(0.3, 0.3, 0.3, 1) 
                    end
                end
                if unlockedWorld == 6 then
                    if i > 7 then
                        love.graphics.setColor(0.3, 0.3, 0.3, 1) 
                    end
                end
                love.graphics.printf(stateButtonsText[2][i], width/2 + 130, y, 400, "center", 0, 0.5)
                y = y + 100
                love.graphics.setColor(1,1,1, 1) 
            end
        end
        if menuState == 3 then
            y = y - 20
            for i = 1, #stateButtonsText[3], 1 do
                if i == selectedButton then
                    love.graphics.setColor(0, 0, 0, 1) 
                end       
                love.graphics.printf(stateButtonsText[3][i], width/2 + 130, y, 400, "center", 0, 0.5)
                y = y + 100
                love.graphics.setColor(1,1,1, 1) 
            end
        end
        if menuState == 4 then
            y = y - 20
            for i = 1, #stateButtonsText[4], 1 do
                if i == selectedButton then
                    love.graphics.setColor(0, 0, 0, 1) 
                end       
                love.graphics.printf(stateButtonsText[4][i], width/2 + 130, y, 400, "center", 0, 0.5)
                y = y + 100
                love.graphics.setColor(1,1,1, 1) 
            end
        end
    end
    --This function gets called in the main love.draw call
    function Menu:draw()
        love.graphics.setColor(1,1,1, 1)     
        if selectedButton == 1 then
            Menu:state(300)
        end
        if selectedButton == 2 then
            Menu:state(400)
        end
        if selectedButton == 3 then
            Menu:state(500)
        end
        if selectedButton > 3 then
            Menu:state(500)
        end    
    end
end

