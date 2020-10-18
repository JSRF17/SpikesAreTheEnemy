--[[
    Handles the logic for different states. This gamw has four (three) states
    Game, Menu, Pause, Resume. Using booleans to handle state changes. If one
    state is active the other ones are false and so on. State.change is used
    when a state is changing
]]--

State = {}
States = {game = false, change = false, menu = false, game2 = false, paused = false, gameOver = false, isPlaying = false, intro = false}
local function changeState(state)
   local bool = false
   for i,v in pairs(States) do
        States[i] = false
    end
end

function State:allFalse()
    changeState()
end

function State:gameStart()
    changeState()
    States.game = true
    States.change = true
    States.isPlaying = true
    SoundHandler:backgroundMusic("game")
end

function State:menuStart()
    changeState()
    States.menu = true
    States.change = true
end

function State:introStart()
    changeState()
    States.intro = true
    States.change = true
end

function State:pause()
    changeState()
    States.change = true
    States.paused = true
end

function State:resume()
    changeState()
    States.game = true
    SoundHandler:backgroundMusic("game")
end

function State:gameover()
    changeState()
    States.change = true
    States.gameOver = true
end
--Different states run depending on the value of before mentioned booleans--
function State:stateChanger(dt)
	if States.change then
        if States.menu == true then
            Menu:loadMenu()
        elseif States.game == true then
            startGame()
            Game:load()
        elseif States.paused == true then
            Pause:loadMenu()
        elseif States.gameOver == true then
            GameOver:loadMenu()
        elseif States.intro == true then
            IntroTutorial:init()
        end
        States.change = false
	end
    if States.change == false then
        if States.paused == true then
            Pause:update(dt)
        elseif States.gameOver == true then
            GameOver:update(dt)
        elseif States.menu == true then
            Menu:update(dt)
        elseif States.game == true then
            TouchControls:update()
            Game:update(dt)
        elseif States.intro == true then
            IntroTutorial:update(dt)
        end
	end
end
