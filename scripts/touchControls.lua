--[[
    Handles creation, drawing, detection and such of on screen touch controls
]]--

TouchControls = {}

local directionY = ""
local directionX = ""
local invert = false
local pause = ""
local Vissible = true
local dPad = true
local imageFile = love.graphics.newImage("resources/buttons2.png")
local imageFile2 = love.graphics.newImage("resources/buttons2INV.png")
local activeFrame
local currentFrame = 1
local frameCoordinates = {
    {141, 0, 135, 134},{0, 141, 134, 135},{141, 141, 134, 135},{283, 141, 134, 135}
}
local frames = {}
for i = 1, #frameCoordinates, 1 do
    frames[i] = g.newQuad(frameCoordinates[i][1],frameCoordinates[i][2],frameCoordinates[i][3],frameCoordinates[i][4], imageFile:getDimensions())
end
local globalX1 = 0.0
local globalY1 = 0.0
local activeFrame2
local currentFrame2 = 1
local frameCoordinates2 = {
    {141, 0, 135, 134},{0, 141, 134, 135},{141, 141, 134, 135},{283, 141, 134, 135}
}
local frames2 = {}
for i = 1, #frameCoordinates2, 1 do
    frames2[i] = g.newQuad(frameCoordinates2[i][1],frameCoordinates2[i][2],frameCoordinates2[i][3],frameCoordinates2[i][4], imageFile2:getDimensions())
end
--Initilize the textbox--
function TouchControls:init(controlScheme)
    controlScheme = controlScheme
    button = {
        {},
        {},
        {},
        {}
    }
    if controlScheme == 2 then
        button[1] = {width = 630, height = 720, x = -250, y = 100, id = "left", axis = "x"}
        button[2] = {width = 650, height = 720, x = 900, y = 100, id = "right", axis = "x"}
        button[3] = {width = 500, height = 350, x = 390, y = 400, id = "up", axis = "y"}
        button[4] = {width = 500, height = 170, x = 390, y = 220, id = "down", axis = "y"}
        button[5] = {width = 500, height = 365, x = 390, y = -50, id = "invert", axis = "i"}
        dPad = false
    end
    if controlScheme == 1 then
        button[1] = {width = 130, height = 130, x = 20, y = 450, id = "left", axis = "x", text = "<-"}
        button[2] = {width = 130, height = 130, x = 200, y = 450, id = "right", axis = "x", text = "->"}
        button[3] = {width = 130, height = 130, x = 1100, y = 500, id = "down", axis = "y", text = "down"}
        button[4] = {width = 130, height = 130, x = 1100, y = 350, id = "up", axis = "y", text = "up"}
        button[5] = {width = 130, height = 130, x = 900, y = 400, id = "invert", axis = "i", text = "inv"}
        dPad = true
    end
    if controlScheme == 3 then
        button[1] = {width = 230, height = 430, x = 50, y = 500, id = "left", axis = "x", text = "<-"}
        button[2] = {width = 230, height = 430, x = 1120, y = 500, id = "right", axis = "x", text = "->"}
        dPad = true
    else
        button.pause = {width = 70, height = 70, x = 80, y = 40}
        button.pauseL = {width = 9, height = 32, x = 102, y = 58}
        button.pauseR = {width = 9, height = 32, x = 120, y = 58}
    end
end

function TouchControls:destroy()
    button = nil 
end

function TouchControls:getEvent(XorYorP)
    if XorYorP == "X" then
        return directionX
    end
    if XorYorP == "Y" then
        return directionY
    end
    if XorYorP == "P" then
        return pause
    end
    if XorYorP == "invert" then
        return invert
    end
end

local idTouchX
local idTouchY
local idTouchInv
function TouchControls:update()
    local down = love.mouse.isDown(1)
    if osString == "Android" or osString == "iOS" then
        function love.touchpressed( id, x, y, dx, dy, pressure )
            local globalX, globalY = push:toGame(x, y)
            if globalX ~= nil and globalY ~= nil then
                if button[1] ~= nil then
                    for i = 1, #button, 1 do 
                        if button[i].x ~= nil then
                            if globalX >= button[i].x and globalX <= button[i].x + button[i].width and globalY >= button[i].y and globalY <= button[i].y + button[i].height then
                                if button[i].axis == "x" then
                                    directionX = button[i].id
                                    idTouchX = id
                                elseif button[i].axis == "y" then
                                    directionY = button[i].id
                                    idTouchY = id
                                elseif button[i].axis == "i" then
                                    invert = true
                                    idTouchInv = id
                                end
                            end
                        end
                    end
                end
                if button.pause ~= nil then
                    if globalX >= button.pause.x and globalX <= button.pause.x + button.pause.width and globalY >= button.pause.y and globalY <= button.pause.y + button.pause.height then
                        pause = "pause"
                    end
                end
            end
        end
        function love.touchreleased( id, x, y, dx, dy, pressure )
            local globalX, globalY = push:toGame(x, y)
            if globalX ~= nil and globalY ~= nil then
                if globalX ~= nil and globalY ~= nil then
                    if button[1] ~= nil then
                        for i = 1, #button, 1 do 
                            if button[i].x ~= nil then
                                if globalX >= button[i].x and globalX <= button[i].x + button[i].width and globalY >= button[i].y and globalY <= button[i].y + button[i].height then
                                    if button[i].axis == "x" then
                                        directionX = ""
                                    elseif button[i].axis == "y" then
                                        directionY = ""
                                    elseif button[i].axis == "i" then
                                        invert = false
                                    end
                                end
                            end
                        end
                    end
                    pause = ""
                end
            end
        end
        function love.touchmoved( id, x, y, dx, dy, pressure )
            local globalX, globalY = push:toGame(x, y)
            if globalX ~= nil and globalY ~= nil then
                if globalX ~= nil and globalY ~= nil then
                    if button[1] ~= nil then
                        for i = 1, #button, 1 do 
                            if button[i].x ~= nil then                           
                                if directionX == "left" then
                                    if id == idTouchX then 
                                        if globalX < 29 or globalX > 155 or globalY < 455 or globalY > 570 then
                                            if button[i].axis == "x" then
                                                directionX = ""
                                            end
                                        end
                                    end
                                end
                                if directionX == "right" then
                                    if id == idTouchX then
                                        if globalX < 208 or globalX > 333 or globalY < 455 or globalY > 570 then
                                            if button[i].axis == "x" then
                                                directionX = ""
                                            end
                                        end
                                    end
                                end
                                if directionY == "down" then
                                    if id == idTouchY then
                                        if globalX < 1100 or globalX > 1213 or globalY < 510 or globalY > 620 then
                                            if button[i].axis == "y" then
                                                directionY = ""
                                            end
                                        end
                                    end
                                end
                                if directionY == "up" then
                                    if id == idTouchY then
                                        if globalX < 1104 or globalX > 1228 or globalY < 358 or globalY > 470 then
                                            if button[i].axis == "y" then
                                                directionY = ""
                                            end
                                        end
                                    end
                                end
                                if invert then
                                    if id == idTouchInv then
                                        if globalX < 902 or globalX > 1026 or globalY < 407 or globalY > 529 then
                                            if button[i].axis == "i" then
                                                invert = false
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    pause = ""
                end
            end
        end
    end
    --Just here temporarely to prvent mousepresses on menu to trigger on mobile
    function love.mousepressed(x, y)
    end
end

function TouchControls:draw()
    if osString == "Android" or osString == "iOS" then
        if Vissible then
            for i = 1, #button, 1 do
                if dPad == true then
                    --Check if level is of colour blue or yellow to make buttons less transparent
                    local ActiveLevel = LevelHandler:getCurrentLevel()
                    if SessionColour ~= nil then
                        g.setColor(0, 0, 0, 0.5)
                    else
                        g.setColor(0, 0, 0, 0.6)
                    end
                    if button[i].id == "left" then
                        if directionX == "left" then
                            g.setColor(1, 1, 1, 0.8)
                        end
                        love.graphics.draw(imageFile, frames[2], button[i].x, button[i].y, 0, 1, 1)
                    elseif button[i].id == "right" then
                        if directionX == "right" then
                            g.setColor(1, 1, 1, 0.8)
                        end
                        love.graphics.draw(imageFile, frames[4], button[i].x, button[i].y, 0, 1, 1)
                    elseif button[i].id == "up" then
                        if directionY == "up" then
                            g.setColor(1, 1, 1, 0.8)
                        end
                        love.graphics.draw(imageFile, frames[1], button[i].x, button[i].y, 0, 1, 1)
                    elseif button[i].id == "down" then
                        if directionY == "down" then
                            g.setColor(1, 1, 1, 0.8)
                        end
                        love.graphics.draw(imageFile, frames[3], button[i].x, button[i].y, 0, 1, 1)
                    elseif button[i].id == "invert" then
                        if invert == true then
                            g.setColor(1, 1, 1, 0.8)
                        end
                        if LevelHandler:returnGravityChange() then
                            love.graphics.draw(imageFile2, frames[1], button[i].x, button[i].y, 0, 1, 1)
                        end
                    end
                else
                    g.rectangle("line", button[i].x, button[i].y, button[i].width, button[i].height)
                end
            end
            g.setColor(0, 0, 0, 0.5)
            if button.pause ~= nil then
                g.rectangle("fill", button.pause.x, button.pause.y, button.pause.width, button.pause.height)
                g.setColor(1, 1, 1, 0.8)
                g.rectangle("fill", button.pauseL.x, button.pauseL.y, button.pauseL.width, button.pauseL.height)
                g.rectangle("fill", button.pauseR.x, button.pauseR.y, button.pauseR.width, button.pauseR.height)
            end
        end
    end
end

function TouchControls:Vissible(setting)
    if setting == false then
        Vissible = false
    elseif setting == true then
        Vissible = true
    end
end

function TouchControls:moveDown()
    function move()
        Timer.tween(2, button[1], {y = 0}, 'in-out-quad')
    end
    move()
end

function TouchControls:moveUp()
    function move()
        Timer.tween(2, button[1], {y = -300}, 'in-out-quad')
    end
    move()
end
