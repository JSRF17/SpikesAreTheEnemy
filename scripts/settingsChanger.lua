--[[
    These functions gets called when the player makes a choice in the settings menu
]]--

SettingsChanger = {}

local controlPreference = 1

function SettingsChanger:turnOffSound()
    SoundHandler:ChangeSoundChoice(false)
    SoundHandler:StopSound("all")
end

function SettingsChanger:turnOnSound()
    SoundHandler:ChangeSoundChoice(true)
end

function SettingsChanger:turnOffSoundMusic()
    SoundHandler:ChangeSoundChoiceMusic(false)
    SoundHandler:StopSound("all")
end

function SettingsChanger:turnOnSoundMusic()
    SoundHandler:ChangeSoundChoiceMusic(true)
end

function SettingsChanger:changeControls()
    TouchControls:init(1)
end

function SettingsChanger:changeControls2()
    TouchControls:init(2)
end

function SettingsChanger:vissibleControlsOff()
    TouchControls:Vissible(false)
end

function SettingsChanger:vissibleControlsOn()
    TouchControls:Vissible(true)
end
