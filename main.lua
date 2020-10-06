 --[[
        Copyright Oliver Kjellén 2020
    ]]--

--Shortening some keywords--
p = love.physics
g = love.graphics
k = love.keyboard
--Setting font
font = g.newFont("resources/jackeyfont.ttf", 64)
g.setFont(font)
--Global variables
mouseMoved = false
mouseX = 0
mouseY = 0
mouseDown = false
width = g.getWidth()
osString = love.system.getOS()
--Local variables
local screenChangeValue = 0
local rw, rh, rf = love.window.getMode()
--Great library for handling scaling and letterboxing
push = require "TLFres"
-----------------Push setup------------------------------------------------------
local gameWidth, gameHeight = 1280, 720
local screenWidth, screenHeight = love.window.getDesktopDimensions()
local dpi_scale = love.window.getDPIScale()
screenWidth = screenWidth/dpi_scale
screenHeight = screenHeight/dpi_scale
push:setupScreen(gameWidth, gameHeight, screenWidth, screenHeight, {fullscreen = true, resizable = true, canvas = false, pixelperfect = false, highdpi = true, stretched = true})
--Requiring modules--
require("scripts.player")
require("scripts.transition")
require("scripts.introTutorial")
require("state.stateHandler")
require("state.menu")
require("state.game")
require("state.pause")
require("state.gameOver")
require("scripts.soundHandler")
require("scripts.touchControls")
require("scripts.settingsChanger")
require("scripts.text")
require("scripts.dataHandler")
require("Levels.LevelHandler")
require("scripts.menuSystem")
--Great library, using it for timers and tweening--
Timer = require("hump.timer")
Camera = require "gamera"
--[[Great library, using it as I haven't learned any shader coding yet
    Includes lots of shaders free to use]]--
local moonshine = require ("moonshines")

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
    effect = moonshine(moonshine.effects.chromasep).chain(moonshine.effects.crt).chain(moonshine.effects.fastgaussianblur)
    if osString == "Android" or osString == "iOS" then
        effect.chromasep.radius = 2
        effect.fastgaussianblur.taps = 3
        effect.fastgaussianblur.offset = 0.5
    else
        effect.chromasep.radius = 2
        effect.fastgaussianblur.taps = 5
        effect.fastgaussianblur.offset = 0.7
    end
    camera = Camera()
    camera.scale = 1.20
    camera:setFollowStyle('PLATFORMER')
end

--Main update function--
function love.update(dt)
    IntroTutorial:update(dt)
    Timer.update(dt)
    State:stateChanger(dt)
    camera:update(dt)
    if Player:getPositionX() ~= nil then
        if osString == "Android" or osString == "iOS" then
            camera:follow(Player:getPositionX() - 200 , Player:getPositionY() - 180)
        else
            camera:follow(Player:getPositionX(), Player:getPositionY())
        end
    end
end

--Main draw function--
function love.draw()
    push:start()
    effect(function()
        if States.game == true and States.change == false then
            camera:attach()
                Game:draw()
            camera:detach()
        end
        if States.menu == true and States.change == false then
            Menu:draw()
        end
        if States.paused == true and States.change == false then
            Pause:draw()
        end
        if States.gameOver == true and States.change == false then
            GameOver:draw()
        end
        if States.game == true and Game:isLevelChange() == false then
            TouchControls:draw()
        end
        IntroTutorial:draw()
        Transition:draw()
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
