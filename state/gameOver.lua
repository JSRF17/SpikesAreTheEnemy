--[[
    Calls different functions in the menuSystem file
]]--

GameOver = {}

function GameOver:loadMenu()
   SoundHandler:StopSound("all")
   SoundHandler:PlaySound("gameOver")
   MenuSystem:init(3)
end

function GameOver:update(dt)
   MenuSystem:update(dt)
   MenuSystem:Animate()
end

function GameOver:draw()
   g.setColor(LevelHandler:colors(2))
   g.rectangle("fill", -3000, -1200, 9180, 9020)
   g.setColor(LevelHandler:colors(1))
   MenuSystem:draw()
end
