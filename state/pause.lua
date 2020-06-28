--Handles pause menu logic
Pause = {}

function PauseLoad()
    local selectedButton = 1
    font = love.graphics.newFont("resources/jackeyfont.ttf", 64)
    love.graphics.setFont(font)

    function Pause:update()
        function love.keypressed(key)
            konami.keypressed(key)
            if key == "space" then
                SoundHandler:PlaySound("select")
            end
            if key == "down" and selectedButton > -1 then
                selectedButton = selectedButton + 1
            end
            if key == "down" and selectedButton > 2 then
                selectedButton = 1
            end
            if key == "up" then
                if selectedButton < 3 then
                    selectedButton = selectedButton - 1
                end
                if selectedButton < 1 then
                    selectedButton = 2
                end
            end
            if key == "space" then
                if selectedButton == 2 then
                    selectedButton = 3
                    Game:dispose()
                    LevelHandler:dispose()
                    State:menuStart()
                end
                if selectedButton == 1 then
                    startGame()
                    font = g.newFont(20)
                    g.setFont(font)
                    State:resume()
                end
            end
        end
    end

    function Pause:state(height)
        local y = 325
        height = height

        pauseButtonsText = {
            {},
            {},
            {}
        }
        pauseButtonsText[1] = "Resume game"
        pauseButtonsText[2] = "To menu"


        love.graphics.rectangle("fill", width/2 + 60, height, 350, 80)
        love.graphics.rectangle("line", width/2 + 60, 300, 350, 80)
        love.graphics.rectangle("line", width/2 + 60, 400, 350, 80)

        Titel = love.graphics.print("Paused", width/2 + 130 , 150, 0, 1)
        for i = 1, #pauseButtonsText, 1 do
            if i == selectedButton then
                love.graphics.setColor(0, 0, 0, 1)
            end
            if i == 1 then
                y = y - 20
            end
            love.graphics.printf(pauseButtonsText[i], width/2 + 130, y, 400, "center", 0, 0.5)
            if i == 1 then
                y = y + 20
            end
            y = y + 100
            love.graphics.setColor(1,1,1, 1)
        end
        y = 325
    end

    function Pause:draw()
        love.graphics.setColor(1,1,1, 1)

        if selectedButton == 1 then
            Pause:state(300)
        end
        if selectedButton == 2 then
            Pause:state(400)
        end
        if selectedButton == 3 then
            Pause:state(500)
        end

        Speedrun:drawTime()
    end
end

