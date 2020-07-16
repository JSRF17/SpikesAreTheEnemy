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

    --Is it better with upper case starting character?
    stateButtonsText[1][1] = "Start game"
    stateButtonsText[1][2] = "Settings"
    stateButtonsText[1][3] = "About"
    stateButtonsText[1][4] = "Quit"

    --This creates *all* 8 levels/worlds
    local levels = 8
    for i = 1, levels, 1 do
        stateButtonsText[2][i] = "Level "..i
    end

    stateButtonsText[3][1] = "Scanlines On/Off"
    stateButtonsText[3][2] = "Sound On/Off"
    stateButtonsText[3][3] = "Music On/Off"

    --No idea how you want it to be
    stateButtonsText[4][1] = "A game by Oliver Kjellen 2019/2020"

    --[[Maybe this function shouldn't bee called update, however it does reflect changes as in
        when a key is pressed a change is reflected to the screen. Also changes the current state of the menu.
        Lots of if statements, I should probably look through this again if I have the time.
    ]]--
    function Menu:update()
        --Handles user input while the menu is active
        function love.keypressed(key)
            if key == "down" then
                if selectedButton > 0 then
                    selectedButton = selectedButton + 1
                end
                if selectedButton > #stateButtonsText[menuState] then
                    selectedButton = 1
                end
            end
            if key == "up" then
                if selectedButton <= #stateButtonsText[menuState] then
                    selectedButton = selectedButton - 1
                end
                if selectedButton < 1 then
                    selectedButton = #stateButtonsText[menuState]
                end
            end

            if key == "space" then
                SoundHandler:PlaySound("select")
                if menuState == 3 then
                    if selectedButton == 1 then
                        if scanlinesChange then
                            SettingsChanger:turnOffScanlines()
                        else
                            SettingsChanger:turnOnScanlines()
                        end
                        scanlinesChange = not scanlinesChange
                    end
                    if selectedButton == 2 then
                        if soundChange then
                            SettingsChanger:turnOffSound()
                        else
                            SettingsChanger:turnOnSound()
                        end
                        soundChange = not soundChange
                    end
                    if selectedButton == 3 then
                        if musicChange then
                            SettingsChanger:turnOffSoundMusic()
                        else
                            SettingsChanger:turnOnSoundMusic()
                        end
                        musicChange = not musicChange
                    end
                end
                if menuState == 2 then
                    --This checks for every level if it's selected and if you unlocked
                    for i = 1, levels, 1 do
                        if selectedButton == i and unlockedWorld >= selectedButton-1 then
                            LevelHandler:setWorld(i)
                            State:gameStart()
                        end
                    end
                end
                if menuState == 1 then
                    if selectedButton == 1 then
                        menuState = 2
                    end
                    if selectedButton == 2 then
                        menuState = 3
                    end
                    if selectedButton == 3  then
                        menuState = 4
                    end
                    if selectedButton == 4  then
                        love.event.quit(0)
                    end
                end
            end
            if key == "escape" then
                selectedButton = 1
                menuState = 1
                SoundHandler:PlaySound("back")
            end
            if menuState == 4 then
                selectedButton = 2
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
            if selectedButton >= i then
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

