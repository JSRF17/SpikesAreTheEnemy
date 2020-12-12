 --[[
        Copyright Oliver Kjellén 2020
    ]]--

--jit.off()
math.randomseed(os.time())
--Global variables--
--Shortening some keywords--
p = love.physics
g = love.graphics
k = love.keyboard
SpeedRun = false
mouseMoved = false
mouseX = 0
mouseY = 0
mouseDown = false
width = g.getWidth()
osString = love.system.getOS()
mobile = false
gameWidth, gameHeight = 1280, 720
push = require "push"
Timer = require("hump.timer")
Camera = require "gamera"
--Setting font
font = g.newFont("resources/jackeyfont.ttf", 64)
g.setFont(font)
--Local variables--
local screenChangeValue = 1
local rw, rh, rf = love.window.getMode()
local screenWidth, screenHeight = love.window.getDesktopDimensions()
local dpi_scale = love.window.getDPIScale()
local fullScreen = true
--Shaders loaded--
crtShader = love.graphics.newShader("shaders/crt.shader")
scanlines = love.graphics.newShader("shaders/scanlines.shader")
chromasep = love.graphics.newShader("shaders/chromasep.shader")
----------------
if osString == "Android" or osString == "iOS" then
    mobile = true
end
--Push setup--
deviceWidth, deviceHeight = love.window.getDesktopDimensions()
iOSwidth = love.graphics.getWidth()

if deviceWidth > 2020 or iOSwidth > 850 then
    gameWidth, gameHeight = 1480, 720
end

if mobile then
    screenWidth, screenHeight = screenWidth, screenHeight
    screenWidth = screenWidth/dpi_scale
    screenHeight = screenHeight/dpi_scale
    screenHeight = screenHeight/dpi_scale
else
    screenWidth, screenHeight = screenWidth*0.7, screenHeight*0.7
    screenWidth = screenWidth/dpi_scale
    screenHeight = screenHeight/dpi_scale
end
push:setupScreen(gameWidth, gameHeight, screenWidth, screenHeight, {fullscreen = true, resizable = true, canvas = true, pixelperfect = false, highdpi = true, stretched = false})
--Push setup end--
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
require("scripts.artGallery")
require("scripts.speedRunTimer")
require("state.splashScreen")
--If playing for the first time init a save file--
if DataHandler:loadGame() == nil or DataHandler:getScoreInit() == nil then
    DataHandler:init()
    DataHandler:initVVVVV()
    DataHandler:initSettings()
end
--Loading various things at startup--
function love.load()
    --Start at the splash state--
    States.menu = true
    State:menuStart()
    --Camera stuff--
    local winWidth, winHeight = love.graphics.getWidth(), love.graphics.getHeight()
    camera_offset_x = (winWidth - gameWidth) / 2 
    camera_offset_y = (winHeight - gameHeight) / 2
    camera = Camera()
    camera.scale = 0.78
    camera:setFollowStyle('PLATFORMER')
    --Shader stuff--
    push:setShader({ crtShader, chromasep, scanlines })
    phase = 0
    complete = false
    angle = 0.005
    completeChroma = false
    scanlines:send("time", 1)
    scanlines:send("setting1", 640.0)
    scanlines:send("setting2", 640.0)
    crtShader:send("feather", 0.02)
    crtShader:send("distortionFactor", {1.06, 1.065})
    crtShader:send("scaleFactor", 1)
    --init Touchscreen controls--
    TouchControls:init(1)
end
--Main update function--
function love.update(dt)
    Timer.update(dt)
    State:stateChanger(dt)
    camera:update(dt)
    SoundHandler:updateVolumes()
    if Player:getPositionX() ~= nil then
        camera:follow(Player:getPositionX() + camera_offset_x, Player:getPositionY() + camera_offset_y)
        local moveX = k.isDown("left")
        local moveX2 = k.isDown("right")
        if moveX == false and moveX2 == false and TouchControls:getEvent("X") ~= "right" and TouchControls:getEvent("X") ~= "left" then
            Player:slowDown() 
        end
    end
    love.window.setTitle(tostring(love.timer.getFPS()))
end
--Main draw function--
function love.draw()
    push:apply("start")
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
                TouchControls:draw()
            elseif States.splash == true then
                SplashScreen:draw()
            end
            if States.game and Game:isLevelChange() == false or States.menu and MenuSystem:StartedMenuGame() then
                TouchControls:draw()
            end
            Transition:draw()
            if Text:getStatus() ~= nil and States.game then
                Text:draw()
                Text:dialogDraw()
                Diamonds:drawCount()
                if SpeedRun then 
                    SpeedRunTimer:draw()
                end
            end
            if Player:getPositionX() ~= nil then
    
            end
        end
    push:apply("end")
end
--This is used to resize the screen filters correctly
function love.resize(rw, rh)
    push:resize(rw, rh)
    if fullScreen then
        camera_offset_x = (rw - gameWidth) / 2 
        camera_offset_y = (rh - gameHeight) / 2
    end
end
--Change from fullscreen to windowed mode on desktop--
function love.keyreleased(key)
    if key == "f" then
        if screenChangeValue % 2 ~= 0 then
            fullScreen = false
            love.window.setFullscreen(false, "desktop")
        else
            fullScreen = true
            love.window.setFullscreen(true, "desktop")
        end
        screenChangeValue = screenChangeValue + 1
    end
end
