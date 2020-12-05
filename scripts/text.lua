--[[Everything related to text while playing the main game (text relevant
    to menus etc will be defined in the menu file)]]--

Text = {}

local font = love.graphics.newFont("resources/jackeyfont.ttf", 25.5)

if gameWidth > 1280 then
    textBoxWidth = 1480
    TextOffsetX = 1350
else
    textBoxWidth = 1280
    TextOffsetX = 1150
end
--Initilize the textbox--
function Text:init(x, y)
    self.x = x
    self.y = y
    textbox = {}
   
    if mobile then
        textbox[1] = {width = textBoxWidth, height = 119, x = self.x, y = self.y}
    else
        textbox[1] = {width = textBoxWidth, height = 85, x = self.x, y = self.y}
    end
end

function Text:getStatus()
    return textbox 
end

function Text:getPosition()
    return textbox[1].x, textbox[1].y
end

function Text:draw()
    g.setColor(0,0,0, 1)
    g.rectangle("fill", textbox[1].x, textbox[1].y, textbox[1].width, textbox[1].height)
    g.setColor(0,0,0, 1)
end

function Text:moveUp()
    if mobile then
        TextTimer1 = Timer.tween(1, textbox[1], {y = 600}, 'in-out-quad')
    else
        TextTimer1 = Timer.tween(1, textbox[1], {y = 645}, 'in-out-quad')
    end
end

function Text:moveDown()
    TextTimer2 = Timer.tween(1.2, textbox[1], {y = 1400}, 'in-out-quad')
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
            wait(1)
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
        g.printf(message1:sub(1, letters1), textbox[1].x + TextOffsetX, textbox[1].y , 800)
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
        "1-1: Stairway to the start."..LivesInit,
        "1-2: The walljump.",
        "1-3: An introduction to spikes.",
        "1-4: Floating platforms.",
        "1-5: Two pillars two spikes.",
        "2-1: Pyramid."..LivesInit,
        "2-2: Do fall down.",
        "2-3: Jumping required.",
        "2-4: 6 spikes in a row, pass twice. ",
        "2-5: Remember to let go.",
        "3-1: Narrow corridor, dive."..LivesInit,
        "3-2: Falldown, go right.",
        "3-3: Back, forth and down.",
        "3-4: Two and eight.",
        "3-5: Under and over. ",
        "4-1: Falldown, go right, but more difficult."..LivesInit,
        "4-2: Jump 4 dive 2",
        "4-3: The easy one.",
        "4-4: Over and under make no blunder.",
        "4-5: Middle pillar with spikes. ",
        "5-1: The gap."..LivesInit,
        "5-2: The up and then down and back up again.",
        "5-3: The long jump with a dive.",
        "5-4: The walljump, but more difficult.",
        "5-5: Land in between. ",
        "6-1: Land in between, many times."..LivesInit,
        "6-2: The floor is spikes.",
        "6-3: Narrow dive.",
        "6-4: 3 pillars with one spike each.",
        "6-5: The gravity switch. ",
        "7-1: Ahhh! There are spikes on the roof."..LivesInit,
        "7-2: Do it upside down.",
        "7-3: Doing it upside down again.",
        "7-4: Collecting diamonds?",
        "7-5: The easy one nr:2. ",
        "8-1: 3 platforms."..LivesInit,
        "8-2: The small tower ladder.",
        "8-3: Narrow gravity change.",
        "8-4: The walljump with narrow dive.",
        "8-5: Technically more than 1 spike. ",
        "9-1: Can you even land on those?"..LivesInit,
        "9-2: Can you even land on those? Upside down.",
        "9-3: No room for error.",
        "9-4: Do fall down again.",
        "9-5: Take a breather, and some diamonds.",
        "10-1: The climb. "..LivesInit,
        "10-2: Jumping skills.",
        "10-3: 3 mountains with spikes.",
        "10-4: Gravity switcher 2000. ",
        "11-1: The frustration."..LivesInit,
        "11-2: Above the spikes.",
        "11-3: Climb high. ",
        "11-4: Nine then switch", 
        "12-1: No room for error, but more difficult."..LivesInit, 
        "12-2: Easy to the top.", 
        "12-3: Overdimensioned.",
        "12-4: The Cave.",
        "13-1: Staircase."..LivesInit,
        "13-2: Narrow corridor, dive, but more difficult.",
        "13-3: Trampoline!",
        "13-4: Three trampolines.",
        "14-1: Three trampolines, but more difficult"..LivesInit,
        "14-2: Need for Speed.",
        "14-3: Trampolines in abundance.",
        "14-4: Main menu, but more difficult.",
        "15-1: Jumping with precision."..LivesInit,
        "15-2: Landing with precision.",
        "15-3: A long jump.",
        "15-4: A long jump, but reversed.",
        "15-5: Leap of fate.",
        "16-1: The End.",
        "16-2: No really, it is The End.",
        "16-3: You have reached the last level.",
        "16-4: Okay then.",
        "16-5: One last challenge, just for you.",
        "16-6: This should suffice.",
        "16-7: Still here huh.",
        "16-8: One last easy level.",
        "16-9: Thanks for playing!",
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
        "4-S: Hi there.",
        "7-S: HELLO person playing this game.",
        "9-S: Get some gems dude.",
        "10-S: HEJ pa dig!.",
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
  


