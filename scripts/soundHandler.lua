--[[
    Handles sound files, loading, playing and stopping of said files.
]]

SoundHandler = {}


local sound = {volMenu=0, volLevelSel=0, volLevel=0 }
--Load files--
level = love.audio.newSource("resources/music/Level.mp3", "static")
levelSelect = love.audio.newSource("resources/music/Menu.mp3", "static")
menuMusic = love.audio.newSource("resources/music/LevelSelect.mp3", "static")
jumpSound = love.audio.newSource("resources/soundEffects/jump.wav", "static")
invertSound = love.audio.newSource("resources/soundEffects/jump.wav", "static")
nextSound = love.audio.newSource("resources/soundEffects/nextLevel.wav", "static")
selectSound = love.audio.newSource("resources/soundEffects/buttonSelect.wav", "static")
coinSound = love.audio.newSource("resources/soundEffects/buttonSelect.wav", "static")
gameOverSound = love.audio.newSource("resources/soundEffects/gameOver.wav", "static")
backSound = love.audio.newSource("resources/soundEffects/buttonBack.wav", "static")
dieSound = love.audio.newSource("resources/soundEffects/dead.wav", "static")
diveSound = love.audio.newSource("resources/soundEffects/dive.wav", "static")
pauseSound = love.audio.newSource("resources/soundEffects/pause.wav", "static")
fiveUp = love.audio.newSource("resources/soundEffects/5up.mp3", "static")
bounce = love.audio.newSource("resources/soundEffects/bounce.mp3", "static")

jumpSound:setVolume(0.2)
jumpSound:setPitch(0.8)

invertSound:setVolume(0.3) 
invertSound:setPitch(0.3)

nextSound:setPitch(0.8)
nextSound:setVolume(0.4)

coinSound:setPitch(1)
coinSound:setVolume(0.5)

selectSound:setPitch(0.7)
selectSound:setVolume(0.3)

menuMusic:setVolume( sound.volMenu )
menuMusic:setLooping( true )
levelSelect:setLooping( true )
level:setLooping( true )

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
    if soundChoice == true then
        if type == "jump" then
            jumpSound:play()
        end
        if type == "invert" then
            invertSound:play()
        end
        if type == "next" then
            nextSound:play()
        end
        if type == "dead" then
            dieSound:play()
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
        if type == "coin" then
            coinSound:play()
        end
        if type == "5up" then
            fiveUp:play()
        end
        if type == "bounce" then
            bounce:play()
        end
    end
end
--Same as above but for music
function SoundHandler:backgroundMusic(type)
    if soundChoiceMusic then
        if type == "game" and level:isPlaying() == false then
            level:play()
            Timer.tween(2.5, sound, {volLevel = 0.4}, 'in-out-quad')
        end
        if type == "menu" and menuMusic:isPlaying() == false then
            menuMusic:play()
            Timer.tween(2.5, sound, {volMenu = 0.7}, 'in-out-quad')
        end
        if type == "levelSelect" and levelSelect:isPlaying() == false then 
            levelSelect:play()
            Timer.tween(2.5, sound, {volLevelSel = 0.7}, 'in-out-quad')
        end
    end
end
--Stops a sound depending on what value is passed when calling the function
function SoundHandler:StopSound(type)
    if type == "jump" then
        jumpSound:stop()
    end
    if type == "dive" then
        diveSound:stop()
    end
end

function SoundHandler:updateVolumes()
    menuMusic:setVolume(sound.volMenu)
    levelSelect:setVolume(sound.volLevelSel)
    level:setVolume(sound.volLevel)
end

function SoundHandler:FadeOutFadeInSound(soundChoice)
   
    if soundChoice == "menu" then
        Timer.tween(2.5, sound, {volMenu = 0}, 'in-out-quad')
    elseif soundChoice == "levelSelect" then
        Timer.tween(2.5, sound, {volLevelSel = 0}, 'in-out-quad')
    elseif soundChoice == "level" then
        Timer.tween(2.5, sound, {volLevel = 0}, 'in-out-quad')
    elseif soundChoice == "all" then
        Timer.tween(2.5, sound, {volMenu = 0}, 'in-out-quad')
        Timer.tween(2.5, sound, {volLevelSel = 0}, 'in-out-quad')
        Timer.tween(2.5, sound, {volLevel = 0}, 'in-out-quad')
    end

    Timer.script(function(wait)
        wait(2)
        if soundChoice == "menu" then
            menuMusic:stop()
        elseif soundChoice == "levelSelect" then
            levelSelect:stop()
        elseif soundChoice == "level" then
            level:stop()
        elseif soundChoice == "all" then
            menuMusic:stop()
            levelSelect:stop()
            level:stop()
        end
    end)
end




