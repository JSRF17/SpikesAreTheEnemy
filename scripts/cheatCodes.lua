local godMode = false
local speedrunMode = false
local infiniteLives = false

CheatCodes = {}

function CheatCodes:updatePlayerLifes()
    Player:setLifes()
end

function CheatCodes:invertInfiniteLifes(v)
    if type(v) == "boolean" then
        infiniteLives = v
    else
        infiniteLives = not infiniteLives
    end
    CheatCodes:updatePlayerLifes()
end

function CheatCodes:getGodMode()
    return godMode
end

function CheatCodes:getSpeedrunMode()
    return speedrunMode
end

function CheatCodes:setSpeedrunMode(v)
    speedrunMode = v
end

function CheatCodes:getInfiniteLives()
    return infiniteLives
end

konami.setWaitTime(0)

konami.newCode(
    {"g","o","d","m","o","d","e"},
    function()
        godMode = not godMode
    end
)

konami.newCode(
    {"s","p","e","e","d","r","u","n"},
    function()
        speedrunMode = not speedrunMode
        CheatCodes:invertInfiniteLifes(speedrunMode)
    end
)

konami.newCode(
    {"up","up","down","down","left","right","left","right","b","a"},
    function()
        CheatCodes:invertInfiniteLifes()
    end
)

konami.newCode(
    {"s","t","o","p"},
    function()
        godMode = false
        Speedrun:destroy()
        CheatCodes:invertInfiniteLifes(false)
    end
)

konami.newCode(
    {"e","f","f","o","f","f"},
    function()
        activeMoonshineFilters = {"dmg"}
        effect.disable(unpack(moonshineFilters))
        effect.enable(unpack(activeMoonshineFilters))
    end
)

konami.newCode(
    {"e","f","f","o","n"},
    function()
        activeMoonshineFilters = moonshineFilters
        effect.enable(unpack(activeMoonshineFilters))
    end
)
