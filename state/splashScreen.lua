--[[
    Calls different functions in the menuSystem file
]]--

SplashScreen = {}

local font = love.graphics.newFont("resources/splashFont.ttf", 62)
love.graphics.setFont(font)

local COLOR_MUL = love._version >= "11.0" and 1 or 255
 
function gradientMesh(dir, ...)
    -- Check for direction
    local isHorizontal = true
    if dir == "vertical" then
        isHorizontal = false
    elseif dir ~= "horizontal" then
        error("bad argument #1 to 'gradient' (invalid value)", 2)
    end
 
    -- Check for colors
    local colorLen = select("#", ...)
    if colorLen < 2 then
        error("color list is less than two", 2)
    end
 
    -- Generate mesh
    local meshData = {}
    if isHorizontal then
        for i = 1, colorLen do
            local color = select(i, ...)
            local x = (i - 1) / (colorLen - 1)
 
            meshData[#meshData + 1] = {x, 1, x, 1, color[1], color[2], color[3], color[4] or (1 * COLOR_MUL)}
            meshData[#meshData + 1] = {x, 0, x, 0, color[1], color[2], color[3], color[4] or (1 * COLOR_MUL)}
        end
    else
        for i = 1, colorLen do
            local color = select(i, ...)
            local y = (i - 1) / (colorLen - 1)
 
            meshData[#meshData + 1] = {1, y, 1, y, color[1], color[2], color[3], color[4] or (1 * COLOR_MUL)}
            meshData[#meshData + 1] = {0, y, 0, y, color[1], color[2], color[3], color[4] or (1 * COLOR_MUL)}
        end
    end
 
    -- Resulting Mesh has 1x1 image size
    return love.graphics.newMesh(meshData, "strip", "static")
end

local color1 = { 0.9, 0.1, 0}
local color2 = { 0.6, 0.3, 0.7}
local mesh = gradientMesh( "vertical", color1, color2 )
local radius = 110
local fadeIn = 0
local start = false

local circles = {}
for i = 0, 250, 1 do
    circles[i] = {}
end
for i = 1, 70, 1 do
    circles[i].radius = radius
    circles[i].x = 640
    circles[i].y = 270
    radius = radius + 1
end

function SplashScreen:update(dt)
    fadeIn = fadeIn + 0.01
    if start == false and fadeIn > 2 then
        start = true
        Transition:activate()
        Timer.script(function(wait)
            wait(1.5)
            State:menuStart()
        
            Transition:down()
        end)
    end
end

function SplashScreen:draw()
    love.graphics.draw( mesh, 515, 145, 0, 250, 250)
    g.setColor(0,0,0)
    love.graphics.rectangle("fill", 500, 240, 400, 8 )
    love.graphics.rectangle("fill", 500, 270, 400, 8 )
    love.graphics.rectangle("fill", 500, 300, 400, 8 )
    love.graphics.rectangle("fill", 500, 330, 400, 8 )
    love.graphics.rectangle("fill", 500, 360, 400, 75 )
    for i = 1, 70, 1 do
        g.circle("line", circles[i].x, circles[i].y, circles[i].radius)
    end
    g.setColor(0.3,0.3,0.3, fadeIn)
    g.printf("squiden", 528, 320, 2500)
end