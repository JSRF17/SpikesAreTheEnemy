
--[[
    Draws a curtain when switching levels. This way the player can't
    see when the previous level gets deloaded and the next levels gets
    loaded. Also creates a cool transition effect!
]]--

IntroTutorial = {}

local active = false
local done = false
local close = false
local button = {x = 0, y = 0, width = 1280, height = 720}

function IntroTutorial:init()
    Text:init(1300, 700)
    Player:init(width/2 + 220, 300, true)
    active = true
    Text:dialogSetup(Text:intro())
    Text:moveTo(width/2 + 100, 370)
end

function IntroTutorial:done()
    if close then
        active = false
        done = false
        close = false
        Transition:activate()
        Timer.script(function(wait)
            wait(2.5)
            World = 1
            State:gameStart()
        end)
    end
end

function IntroTutorial:draw()
    if active == true then
        g.setColor(1, 1, 1)
        g.rectangle("fill", 0, 0, 1280, 720)
        Player:draw()
        g.setColor(1, 1, 1)
        Text:dialogDraw(true)
        Text:draw()
    end
end

function IntroTutorial:update(dt)
    if active == true then
        function love.mousepressed(x, y)
            local globalX, globalY = push:toGame(x, y)
            if done == true and globalX >= button.x and globalX <= button.x + button.width and globalY >= button.y and globalY <= button.y + button.height then
                close = true
                IntroTutorial:done()
            end
        end
        Player:animation(dt)
        Text:dialogUpdateIntro(dt)
        Timer.script(function(wait)
            wait(13)
            done = true
        end)
    end
end