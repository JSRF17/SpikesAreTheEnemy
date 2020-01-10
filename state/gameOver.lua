--Handles logic for when the player dies and game restarts--

GameOver = {}

function GameOverLoad()
    SoundHandler:StopSound("all")
    SoundHandler:PlaySound("gameOver")
    local selectedButton = 1
    font = love.graphics.newFont("resources/jackeyfont.ttf", 64)
    love.graphics.setFont(font)
   
    function GameOver:update()
        function love.keypressed( key )
            if key == "down" and selectedButton > -1 then
                selectedButton = selectedButton + 1
            end
            if key == "down" and selectedButton > 2 then
                selectedButton = 1
            end
            if key == "up" and selectedButton < 3 then
                selectedButton = selectedButton - 1
            end
            if key == "up" and selectedButton < 1 then
                selectedButton = 2
            end
            if key == "space" and selectedButton == 1 then
                Game:dispose()
                LevelHandler:dispose()
                State:gameStart()
            end
            if key == "space" and selectedButton == 2 then
                Game:dispose()
                LevelHandler:dispose()
                State:menuStart()
            end
        end
    end

    function GameOver:draw()
        love.graphics.setColor(1,1,1, 1) 
        
        if selectedButton == 1 then
            love.graphics.rectangle("fill", width/2 + 60, 300, 350, 80)
            love.graphics.setColor(0,0,0, 1) 
            love.graphics.printf("retry", width/2 + 130, 310, 400, "center", 0, 0.5)
            love.graphics.setColor(1,1,1, 1) 
            love.graphics.printf("quit", width/2 + 130, 425, 400, "center", 0, 0.5)
        end
        if selectedButton == 2 then
            love.graphics.rectangle("fill", width/2 + 60, 400, 350, 80)
            love.graphics.setColor(0,0,0, 1) 
            love.graphics.printf("quit", width/2 + 130, 425, 400, "center", 0, 0.5)
            love.graphics.setColor(1,1,1, 1) 
            love.graphics.printf("retry", width/2 + 130, 310, 400, "center", 0, 0.5)
        end
        love.graphics.print("game over", width/2 + 90 , 150, 0, 1)
        love.graphics.rectangle("line", width/2 + 60, 300, 350, 80)
        love.graphics.rectangle("line", width/2 + 60, 400, 350, 80)
    end
end

