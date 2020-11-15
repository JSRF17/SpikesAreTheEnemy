
--[[
    Handles logic for initializing, drawing art works for the art gallery hidden level
]]--

ArtGallery = {}

local font = love.graphics.newFont("resources/jackeyfont.ttf", 25)
local framesArt = {}
local art = g.newImage("resources/art2.png")
local frameCoordinates = {
    {0, 6, 21, 44},{24, 17, 35, 33},{62, 34, 16, 15},{81, 34, 16, 15},{99, 34, 16, 15},
    {118, 34, 16, 15},{136, 34, 16, 25},
}

for i = 1, #frameCoordinates, 1 do
    framesArt[i] = g.newQuad(frameCoordinates[i][1],frameCoordinates[i][2],frameCoordinates[i][3],frameCoordinates[i][4],art:getDimensions())
end

function ArtGallery:draw()
    g.setColor(LevelHandler:colors(1))
    g.draw(art, framesArt[1], 350, 365, 0, 4, 4)
    g.draw(art, framesArt[1], 700, 365, 0, 4, 4)
    g.draw(art, framesArt[2], 480, 530, 0, 2, 2)    
    g.draw(art, framesArt[3], 570, 550, 0, 2, 2)    
    g.draw(art, framesArt[4], 620, 550, 0, 2, 2)
    g.draw(art, framesArt[5], 620, 450, 0, 2, 2)   
    g.draw(art, framesArt[6], 520, 450, 0, 2, 2)   
    g.draw(art, framesArt[7], 570, 450, 0, 2, 2)           
end
