--[[
    Handles sound files, loading, playing and stopping of said files.
]]

SoundHandler = {}

music = love.audio.newSource("resources/backgroudMusic.mp3", "static")
menuMusic = love.audio.newSource("resources/menuMusic.mp3", "static")
jumpSound = love.audio.newSource("resources/jump.wav", "static")
nextSound = love.audio.newSource("resources/nextLevel.wav", "static")
selectSound = love.audio.newSource("resources/buttonSelect.wav", "static")
gameOverSound = love.audio.newSource("resources/gameOver.wav", "static")
backSound = love.audio.newSource("resources/buttonBack.wav", "static")
dieSound = love.audio.newSource("resources/dead.wav", "static")
typeSound = love.audio.newSource("resources/Typing.wav", "static")
diveSound = love.audio.newSource("resources/dive.wav", "static")
pauseSound = love.audio.newSource("resources/pause.wav", "static")
jumpSound:setVolume(0.3) -- 30% of ordinary volume
jumpSound:setPitch(0.6)  -- 60% of ordinary pitch
typeSound:setVolume(0.5) -- 50% of ordinary volume
music:setPitch(0.6)      -- 60% of ordinary pitch
music:setVolume(0.3)     -- 30% of ordinary volume
menuMusic:setVolume(0.3) -- 30% of ordinary volume

local soundChoice = true
local soundChoiceMusic = true
--Gets called in the settingsHandler, gives soundChoice another value
function SoundHandler:ChangeSoundChoice(choice)
    soundChoice = choice
end
--Gets called in the settingsHandler, gives soundChoiceMusic another value
function SoundHandler:ChangeSoundChoiceMusic(choice)
    soundChoiceMusic = choice
end
--Plays a sound based on what value is given when calling the function
function SoundHandler:PlaySound(type)
    if soundChoice then
        if type == "jump" then
            jumpSound:play()
        end
        if type == "next" then
            nextSound:play()
        end
        if type == "dead" then
            dieSound:play()
        end
        if type == "typing" then
            typeSound:play()
        end
        if type == "pause" then
            pauseSound:play()
        end
        if type == "dive" then
            diveSound:play()
        end
        if type == "select" then
            selectSound:play()
        end
        if type == "back" then
            backSound:play()
        end
        if type == "gameOver" then
            gameOverSound:play()
        end
    end
end
--Same as above but for music
function SoundHandler:backgroundMusic(type)
    if soundChoice then
        if soundChoiceMusic then
            if type == "game" and not music:isPlaying() then
                music:play()
            end
            if type == "menu" and not menuMusic:isPlaying() then
                menuMusic:play()
            end
        end
    end
end
--Stops a sound depending on what value is passed when calling the function
function SoundHandler:StopSound(type)
    if type == "typing" then
        typeSound:stop()
    end
    if type == "dive" then
        diveSound:stop()
    end
    if type == "all" then
        typeSound:stop()
        music:stop()
        menuMusic:stop()
    end
    if type == "all1" then
        typeSound:stop()
    end
end


