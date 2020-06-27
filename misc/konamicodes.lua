godMode = false
speedrunMode = false

konami.newCode(
    {"g", "o", "d", "m", "o", "d", "e"},
    function()
        godMode = not godMode
    end
)

konami.newCode(
    {"s", "p", "e", "e", "d", "r", "u", "n"},
    function()
        speedrunMode = not speedrunMode
    end
)

konami.newCode(
    {"s", "t", "o", "p"},
    function()
        godMode = false
        speedrunMode = false
    end
)