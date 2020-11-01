 --[[
        Copyright Oliver Kjellén 2020
    ]]--

--Shortening some keywords--
p = love.physics
g = love.graphics
k = love.keyboard
jit.off()
--Setting font
font = g.newFont("resources/jackeyfont.ttf", 64)
g.setFont(font)

--Global variables--
SpeedRun = false
mouseMoved = false
mouseX = 0
mouseY = 0
mouseDown = false
width = g.getWidth()
osString = love.system.getOS()

--Local variables--
local screenChangeValue = 1
local rw, rh, rf = love.window.getMode()
local mobile 
if osString == "Android" or osString == "iOS" then
    mobile = true
end

--Great library for handling scaling for different screen sizes (desktop, mobile and so on)
push = require "TLFres"
-----------------Push setup------------------------------------------------------
local gameWidth, gameHeight = 1280, 720
local screenWidth, screenHeight = love.window.getDesktopDimensions()
local dpi_scale = love.window.getDPIScale()
screenWidth = screenWidth/dpi_scale
screenHeight = screenHeight/dpi_scale
push:setupScreen(gameWidth, gameHeight, screenWidth, screenHeight, {fullscreen = true, resizable = true, canvas = false, pixelperfect = false, highdpi = true, stretched = true})
---------------Push setup end-----------------------------------------------------

--Requiring modules--
require("scripts.player")
require("scripts.transition")
require("state.introTutorial")
require("state.stateHandler")
require("state.menu")
require("state.game")
require("state.pause")
require("state.gameOver")
require("scripts.soundHandler")
require("scripts.touchControls")
require("scripts.text")
require("scripts.dataHandler")
require("scripts.settingsChanger")
require("Levels.LevelHandler")
require("scripts.menuSystem")
require("scripts.diamonds")
require("scripts.grass")
require("state.miniGameVVVVV")
require("scripts.collisionHandler")
--Great library, using it for timers and tweening--
Timer = require("hump.timer")
--Great library to handle camera emulation--
Camera = require "gamera"


--[[Great library, using it as I haven't learned any shader coding yet
    Includes lots of shaders free to use]]--
local moonshine = require ("moonshine")

--If playing for the first time init a save file--
if DataHandler:loadGame() == nil then
    DataHandler:init()
    DataHandler:initSettings()
end

--Start at the menu state--
States.menu = true
State:menuStart()

--Loading various things at startup--
function love.load()
    effect = moonshine(moonshine.effects.chromasep).chain(moonshine.effects.crt).chain(moonshine.effects.pixelate).chain(moonshine.effects.posterize)
    if mobile then
        effect.chromasep.radius = 2
    else
        effect.chromasep.radius = 2
    end
    effect.pixelate.size = {2,2}
    effect.pixelate.feedback = 0.4
    effect.posterize.num_bands = 10
    camera = Camera()
    camera.scale = 1.20
    camera:setFollowStyle('PLATFORMER')
end
DataHandler:initVVVVV()
--Main update function--
function love.update(dt)
    Timer.update(dt)
    State:stateChanger(dt)
    camera:update(dt)
    if mobile then
        camera:follow(Player:getPositionX() - 200 , Player:getPositionY() - 180)
    else
        camera:follow(Player:getPositionX(), Player:getPositionY())
    end
    --love.window.setTitle(tostring(love.timer.getFPS()))
end

--Main draw function--
function love.draw()
    push:start()
    effect(function()
        if States.change == false then
            if States.game == true then
                camera:attach()
                    Game:draw()
                camera:detach()
            elseif States.intro == true then
                introTutorial:draw()
            elseif States.menu == true then
                Menu:draw()
            elseif States.paused == true then
                Pause:draw()
            elseif States.gameOver == true then
                GameOver:draw()
            elseif States.miniGame1 == true then
                MiniGameVVVVV:draw()
            end
            if States.game == true and Game:isLevelChange() == false then
                TouchControls:draw()
                Diamonds:drawCount()
            end
        end
        if Transition:getState() then
            Transition:draw()
        end
        push:finish()
    end)
end

--This is used to resize the screen filters correctly
function love.resize(rw, rh)
    effect.disable("crt", "chromasep", "fastgaussianblur")
    effect.resize(rw, rh)
    effect.enable("crt", "chromasep", "fastgaussianblur")
    push:resize(rw, rh)
end

--Change from fullscreen to windowed mode on desktop--
function love.keyreleased(key)
    if key == "f" then
        if screenChangeValue % 2 ~= 0 then
            love.window.setFullscreen(false, "desktop")
        else
            love.window.setFullscreen(true, "desktop")
        end
        screenChangeValue = screenChangeValue + 1
    end
end
