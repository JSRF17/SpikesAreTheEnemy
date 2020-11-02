--[[
    These functions gets called when the player makes a choice in the settings menu
]]--

SettingsChanger = {}

local soundToggle, musicToggle, vissibleControls, dPad

--Sound settingw--
function SettingsChanger:updateSoundSettings()
    local currentSettings = DataHandler:loadSettings()
    if currentSettings[1] == "sound" then
        soundToggle = "off"
    elseif currentSettings[1] == "deactivated" then
        soundToggle = "on"
    elseif currentSettings[1] ~= "sound" then
        soundToggle = "firstTime"
    end
end
function SettingsChanger:turnOnOffSound()
    SettingsChanger:updateSoundSettings()
    if soundToggle == "off" then
        SoundHandler:ChangeSoundChoice(false)
        SoundHandler:StopSound("all")
        DataHandler:saveSetting("deactivated", "sound")
    elseif soundToggle == "on" then
        SoundHandler:ChangeSoundChoice(true)
        DataHandler:saveSetting("sound", "sound")
    elseif soundToggle == "firstTime" then
        SoundHandler:ChangeSoundChoice(false)
        SoundHandler:StopSound("all")
        DataHandler:saveSetting("deactivated", "sound")
    end
    SettingsChanger:updateSoundSettings()
end
--Sound settings end--
--Music settings--
function SettingsChanger:updateMusicSettings()
    local currentSettings = DataHandler:loadSettings()
    if currentSettings[2] == "music" then
        musicToggle = "off"
    elseif currentSettings[2] == "deactivated" then
        musicToggle = "on"
    elseif currentSettings[2] ~= "music" then
        musicToggle = "firstTime"
    end
end
function SettingsChanger:turnOnOffMusic()
    SettingsChanger:updateMusicSettings()
    if musicToggle == "off" then
        SoundHandler:ChangeSoundChoiceMusic(false)
        SoundHandler:StopSound("all1")
        DataHandler:saveSetting("deactivated", "music")
    elseif musicToggle == "on" then
        SoundHandler:ChangeSoundChoiceMusic(true)
        DataHandler:saveSetting("music", "music")
    elseif musicToggle == "firstTime" then
        SoundHandler:ChangeSoundChoiceMusic(false)
        SoundHandler:StopSound("all1")
        DataHandler:saveSetting("deactivated", "music")
    end
    SettingsChanger:updateMusicSettings()
end
--Music settings end--
--dPad Settings--
function SettingsChanger:update_dPadSettings()
    local currentSettings = DataHandler:loadSettings()
    if currentSettings[3] == "dPad" then
        dPad = "off"
    elseif currentSettings[3] == "deactivated" then
        dPad = "on"
    elseif currentSettings[3] ~= "dPad" then
        dPad = "firstTime"
    end
end
function SettingsChanger:changeControls()
    SettingsChanger:update_dPadSettings()
    if dPad == "off" then
        TouchControls:init(2)
        DataHandler:saveSetting("deactivated", "dPad")
    elseif dPad == "on" then
        TouchControls:init(1)
        DataHandler:saveSetting("dPad", "dPad")
    elseif dPad == "firstTime" then
        TouchControls:init(2)
        DataHandler:saveSetting("deactivated", "dPad")
    end
    SettingsChanger:update_dPadSettings()
end
--dPad settings end--
--Vissible/ invissble controls setting--
function SettingsChanger:updateVissibleControlsSettings()
    local currentSettings = DataHandler:loadSettings()
    if currentSettings[4] == "vissibleControls" then
        vissibleControls = "off"
    elseif currentSettings[4] == "deactivated" then
        vissibleControls = "on"
    elseif currentSettings[4] ~= "vissibleControls" then
        vissibleControls = "firstTime"
    end
end
function SettingsChanger:vissibleControlsOff()
    SettingsChanger:updateVissibleControlsSettings()
    if vissibleControls == "off" then
        TouchControls:Vissible(false)
        DataHandler:saveSetting("deactivated", "vissibleControls")
    elseif vissibleControls == "on" then
        TouchControls:Vissible(true)
        DataHandler:saveSetting("vissibleControls", "vissibleControls")
    elseif vissibleControls == "firstTime" then
        TouchControls:Vissible(false)
        DataHandler:saveSetting("deactivated", "vissibleControls")
    end
    SettingsChanger:updateVissibleControlsSettings()
end
--Vissible/ invissble controls setting end--
function SettingsChanger:getSettings(type)
    if type == "sound" then
        return soundToggle
    elseif type == "music" then
        return musicToggle
    elseif type == "dPad" then
        return dPad
    elseif type == "vissibleControls" then
        return vissibleControls
    end
end

function SettingsChanger:loadSettings()
    SettingsChanger:updateSoundSettings()
    SettingsChanger:updateMusicSettings()
    SettingsChanger:update_dPadSettings()
    SettingsChanger:updateVissibleControlsSettings()
    if soundToggle == "on" then
        SoundHandler:ChangeSoundChoice(false)
        SoundHandler:StopSound("all")
        DataHandler:saveSetting("deactivated", "sound")
    end
    if musicToggle == "on" then
        SoundHandler:ChangeSoundChoiceMusic(false)
        SoundHandler:StopSound("all1")
        DataHandler:saveSetting("deactivated", "music")
    end
    if dPad == "firstTime" then
        TouchControls:init(1)
        DataHandler:saveSetting("deactivated", "dPad")
    elseif dPad == "on" then
        TouchControls:init(2)
        DataHandler:saveSetting("deactivated", "dPad")
    elseif dPad == "off" then
        TouchControls:init(1)
        DataHandler:saveSetting("deactivated", "dPad")
    end
    if vissibleControls == "on" then
        TouchControls:Vissible(false)
        DataHandler:saveSetting("deactivated", "vissibleControls")
    end
end

function SettingsChanger:print()
    currentSettings = DataHandler:loadSettings("sound")
    return tostring(currentSettings[1])
end
