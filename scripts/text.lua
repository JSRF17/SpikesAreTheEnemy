--[[Everything related to text while playing the main game (text relevant
    to menus etc will be defined in the menu file)]]--

Text = {}

local font = love.graphics.newFont("resources/jackeyfont.ttf", 23)
--Initilize the textbox--
function Text:init(x, y)
    self.x = x
    self.y = y
    textbox = {}
    textbox[1] = {width = 1280, height = 60, x = self.x, y = self.y}
end

function Text:getStatus()
    return textbox 
end

function Text:draw()
    g.setColor(0,0,0, 1)
    g.rectangle("fill", textbox[1].x, textbox[1].y, textbox[1].width, textbox[1].height)
    g.setColor(0,0,0, 1)
end

function Text:moveUp()
    TextTimer1 = Timer.tween(1, textbox[1], {y = 660}, 'in-out-quad')
end

function Text:moveDown()
    TextTimer2 = Timer.tween(0.8, textbox[1], {y = 800}, 'in-out-quad')
end

function Text:initMove()
    if TextTimer1 ~= nil then
        Timer.cancel(TextTimer1)
    elseif TextTimer2 ~= nil then
        Timer.cancel(TextTimer2)
    end
end

function Text:reset()
    levelstart = true
    message = ""
end

--Setting up a new message, thanks to the Löve2d forum for some help--
function Text:dialogSetup(msg)
    g.setFont(font)
    message = msg
    elapsed = 0
    letters = 0
    dialog_finished = false
end

function Text:dialogSetup1(msg)
    g.setFont(font)
    message1 = msg
    elapsed1 = 0
    letters1 = 0
    dialog_finished1 = false
end

--Updating the dialog based on delta time, results in the type out effect, 
--thanks to the Löve2d forum for some help--
function Text:dialogUpdate(dt)
    if levelstart == true then
        Timer.script(function(wait)
            wait(1.5)
            levelstart = false
        end)
    end
    if levelstart == false then
        elapsed = elapsed + 0.14
        letters = math.min(math.floor(elapsed), #message)
        if elapsed > #message then
            dialog_finished = true
            SoundHandler:StopSound("typing")
        end
        if dialog_finished ~= true then
            SoundHandler:PlaySound("typing")
        end
        elapsed1 = elapsed1 + 0.14
        letters1 = math.min(math.floor(elapsed1), #message1)
        if elapsed1 > #message1 then
            dialog_finished1 = true
            if dialog_finished == true then
                SoundHandler:StopSound("typing")
            end
        end
        if dialog_finished1 ~= true then
            SoundHandler:PlaySound("typing")
        end
    end
end

function Text:dialogUpdateIntro(dt)
    elapsed = elapsed + 0.14
    letters = math.min(math.floor(elapsed), #message)
    if elapsed > #message then
        dialog_finished = true
        SoundHandler:StopSound("typing")
    end
    if dialog_finished ~= true then
        SoundHandler:PlaySound("typing")
    end
end

function Text:dialogDraw()
    g.setFont(font)
    g.setColor(LevelHandler:colors(1))
    if message1 ~= nil then
        g.printf(message1:sub(1, letters1), textbox[1].x + 1150, textbox[1].y , 800)
    end
    g.printf(message:sub(1, letters), textbox[1].x + 20, textbox[1].y, 2500)
end

--Takes input value depending on active level then returns the message relevant to that level--
function Text:storyline(select)
    local LivesInit
    if LevelHandler:getUnder10Lives() then
        LivesInit = "\nLives initialized.\n"
    else
        LivesInit = ""
    end
    texts = {
        "1-1: Can't die here, literally impossible."..LivesInit,
        "1-2: Could die here, if you're no good.",
        "1-3: The walljump.",
        "1-4: Two pillars two spikes.",
        "1-5: Jumping required.",
        "2-1: 6 spikes in a row, pass twice. "..LivesInit,
        "2-2: Narrow corridor, dive.",
        "2-3: Falldown, go right.",
        "2-4: Back, forth and down.",
        "2-5: Two and eight.",
        "3-1: Under and over. "..LivesInit,
        "3-2: Falldown, go right, but more difficult.",
        "3-3: Jump 4 dive 2",
        "3-4: The easy one.",
        "3-5: Over and under make no blunder.",
        "4-1: Middle pillar with spikes. "..LivesInit,
        "4-2: The gap.",
        "4-3: The up and then down and back up again.",
        "4-4: The long jump with a dive.",
        "4-5: The walljump, but more difficult.",
        "5-1: Land in between. "..LivesInit,
        "5-2: Land in between, many times.",
        "5-3: The floor is spikes.",
        "5-4: Narrow dive.",
        "5-5: 3 pillars with one spike each.",
        "6-1: The gravity switch. "..LivesInit,
        "6-2: Ahhh! There's spikes on the roof.",
        "6-3: Do it upside down.",
        "6-4: Doing it upside down again.",
        "6-5: Collecting diamonds?",
        "7-1: The easy one nr:2. "..LivesInit,
        "7-2: 3 platforms.",
        "7-3: The small tower ladder.",
        "7-4: Narrow gravity change.",
        "7-5: The walljump with narrow dive.",
        "8-1: Technically more than 1 spike. "..LivesInit,
        "8-2: Can you even land on those?",
        "8-3: Can you even land on those? Upside down.",
        "8-4: No room for error.",
        "8-5: Take a breather, and some diamonds.",
        "9-1: The climb. "..LivesInit,
        "9-2: Jumping skills.",
        "9-3: 3 mountains with spikes.",
        "9-4: Gravity switcher 2000. ",
        "10-1: The frustration."..LivesInit,
        "10-2: Above the spikes.",
        "10-3: Climb high. ",
        "10-4: The one with a secret.", 
        "11-1: No room for error, but more difficult."..LivesInit, 
        "11-2: Easy to the top.", 
        "11-3: Overdimensioned",
        "11-4: The Cave.",
        "12-1: The filler."..LivesInit,
        "12-2: Narrow corridor, dive, but more difficult.",
        "12-3: Trampoline!",
        "12-4: Three trampolines.",
        "13-1: Three trampolines, but more difficult"..LivesInit,
        "13-2: Need for Speed.",
        "13-3: Trampolines in abundance.",
        "13-4: Main menu, but more difficult.",
        "The end.",
    }
    for i = 1, #texts, 1 do
        if select == i then
            return texts[i]
        end
    end
end

function Text:storylineSecret(select)
    texts = {
        "1-S: The art gallery.",
        "4-S: You had me at Hi!",
        "7-S: You had me at HELLO.",
        "10-S: You had me at HEJ.",
        "11-S: The OJOJ! room.",
    }
    for i = 1, #texts, 1 do
        if select == i then
            return texts[i]
        end
    end
end

function Text:intro(select)
    texts = {
        "This is Dave. He can run, jump, dive......and die. Luckily he got 10 lives....more than most of us. Make these 10 lives last, you'll need them. Good luck! Press anywhere on the screen to continue.",
    }
    
    return texts[1]
end
  


