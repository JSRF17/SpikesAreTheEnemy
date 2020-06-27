--[[
    These functions gets called when the player makes a choice in the settings menu
]]

SettingsChanger = {}


function SettingsChanger:turnOffScanlines()
    effect.disable("scanlines")
end

function SettingsChanger:turnOnScanlines()
    effect.enable("scanlines")
end

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


