--[[
    Calls different functions in the menuSystem file
]]--

GameOver = {}

function GameOver:loadMenu()
   SoundHandler:StopSound("all")
    SoundHandler:PlaySound("gameOver")
   MenuSystem:init(3)
  --MenuSystem:state()
end

function GameOver:update()
   MenuSystem:update()
   MenuSystem:Animate()
end

function GameOver:draw()
   MenuSystem:draw()
end
