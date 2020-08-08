--[[Handles the logic for different states. This gamw has four (three) states
    Game, Menu, Pause, Resume. Using booleans to handle state changes. If one
    state is active the other ones are false and so on. State.change is used
    when a state is changing]]--
State = {
    game = false,
    change = false,
    menu = false,
    game2 = false,
    paused = false,
    gameOver = false,
    isPlaying = false
}

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
    if State.menu then
        if State.change then
            loadMenu()
            State.change = false
        else
            Menu:update(dt)
        end
    end

    if State.game then
        if State.change then
            startGame()
            Game:load()
            State.change = false
        else
            Game:update(dt)
        end
    end

    if State.paused then 
        if State.change then
            PauseLoad()
            State.change = false
        else
            Pause:update(dt)
        end
    end

    if State.gameOver then
        if State.change then
            GameOverLoad()
            State.change = false
        else
            GameOver:update(dt)
        end
    end
end

