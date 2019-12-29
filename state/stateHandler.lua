--[[Handles the logic for different states. This gamw has four (three) states 
    Game, Menu, Pause, Resume. Using booleans to handle state changes. If one
    state is active the other ones are false and so on. State.change is used 
    when a state is changing]]-- 
State = { game = false, change = false, menu = false, game2 = false, paused = false, gameOver = false, isPlaying = false}

function State:gameStart()
    State.menu = false 
    State.gameOver = false
    State.game = true
    State.change = true
    State.isPlaying = true
end

function State:menuStart()
    State.paused = false
    State.gameOver = false
    State.game = false
    State.isPlaying = false
    State.menu = true
    State.change = true
end

function State:pause()
    State.menu = false 
    State.game = false
    State.paused = true
    State.change = true
end

function State:resume()
    State.menu = false 
    State.change = false
    State.paused = false
    State.game = true
end

function State:gameover()
    State.menu = false 
    State.game = false
    State.change = true
    State.isPlaying = false
    State.gameOver = true
end
--Different states run depending on the value of before mentioned booleans--
function State:stateChanger(dt)
    if State.menu == true and State.change == true then
        loadMenu()
        State.change = false
    end
    if State.game == true and State.change == true then
        startGame()
        Game:load()
        State.change = false
    end
    if State.menu == true and State.change == false then
        Menu:update(dt)
    end
    if State.game == true and State.change == false then
        Game:update(dt)
    end
    if State.paused == true and State.change == true then
        PauseLoad()
        State.change = false
    end
    if State.paused == true and State.change == false then
        Pause:update(dt)
    end
    if State.gameOver == true and State.change == true then
        GameOverLoad()
        State.change = false
    end
    if State.gameOver == true and State.change == false then
        GameOver:update(dt)
    end
end

