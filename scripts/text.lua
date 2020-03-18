--[[Everything related to text while playing the main game (text relevant
    to menus etc will be defined in the menu file)]]--

Text = {}

--Initilize the textbox--
function Text:init(x, y)
    self.x = x
    self.y = y
    textbox = {}
    textbox[1] = {width = 330, height = 230, x = self.x, y = self.y}
end

function Text:destroy()
    textbox = nil 
end

function Text:draw()
    g.setColor(0.8,0.8,0.8, 0.5)
    g.rectangle("fill", textbox[1].x, textbox[1].y, textbox[1].width, textbox[1].height)
end

function Text:moveDown()
    function move()
        Timer.tween(2, textbox[1], {y = 0}, 'in-out-quad')
    end
    move()
end

function Text:moveUp()
    function move()
        Timer.tween(2, textbox[1], {y = -300}, 'in-out-quad')
    end
    move()
end

function Text:reset()
    levelstart = true
    message = ""
end

--Setting up a new message, thanks to the Löve2d forum for some help--
function Text:dialogSetup(msg)
    font = g.newFont(20)
    g.setFont(font)
    message = msg
    elapsed = 0
    letters = 0
    dialog_finished = false
end

--Updating the dialog based on delta time, results in the type out effect, 
--thanks to the Löve2d forum for some help--
function Text:dialogUpdate(dt)
    if levelstart == true then
        Timer.script(function(wait)
            wait(2.0)
            levelstart = false
        end)
    end
    if levelstart == false then
        elapsed = elapsed + 0.15
        letters = math.min(math.floor(elapsed), #message)
        if elapsed > #message then
            dialog_finished = true
            SoundHandler:StopSound("typing")
        end
        if dialog_finished ~= true then
            SoundHandler:PlaySound("typing")
        end
    end
end
  
function Text:dialogDraw(x, y)
    g.setColor(0, 0, 0)
    love.graphics.printf(message:sub(1, letters), x, y, 300)
end

--Takes input value depending on active level then returns the message relevant to that level--
function Text:storyline(select)
    texts = {
        "5 levels 10 lives! Move using the arrow keys, good luck!",
        "Good! You reached Level_1-2. See those spikey things? Yeah, try not to touch them alright.",
        "Level_1-3 loaded. Wall jumping is certainly possible, just jump again when touching a wall to initialize a walljump.",
        "Level_1-4 loaded. Tip: You can press the down arrow while in mid air to dive",
        "Level_1-5 loaded. Let's make things a bit more difficult shall we?",
        "Level_2-1 loaded. Lives initialized",
        "Level_2-2 loaded. You'll need to dive to avoid those spikes. Do your best, no shame in losing",
        "Level_2-3 loaded. You're doing well so far!",
        "Level_2-4 loaded. One in ten players fail on this level, will you be the one?",
        "Level_2-5 loaded. You made it! Don't fail now and you'll reach level 3.",
        "Level_3-1 loaded. This level even I struggled with when making the game",
        "Level_3-2 loaded. Those spikes leaves no room for error",
        "Level_3-3 loaded. I have to say, we are rather impressed by your progress",
        "Level_3-4 loaded. This level is easy! You can't possibly fail here",
        "Level_3-5 loaded. That's a lot of spikes! Don't step on them",
        "Level_4-1 loaded. Wall jumps are rather simple to perform",
        "Level_4-2 loaded. Do you want to know a secret?",
        "Level_4-3 loaded. Jump and dive, jump and dive",
        "Level_4-4 loaded. How long can you jump?",
        "Level_4-5 loaded. I like wall jumping, do you?",
        "Level_5-1 loaded.",
        "Level_5-2 loaded.",
        "Level_5-3 loaded.",
        "Level_5-4 loaded.",
        "Level_5-5 loaded.",
        "Level_6-1 loaded. GravityChange = active. Press the spacebar to change your local gravity",
        "Level_6-2 loaded. GravityChange = active.",
        "Level_6-3 loaded. GravityChange = active.",
        "Level_6-4 loaded. GravityChange = active.",
        "Level_6-5 loaded. GravityChange = active.",
        "Level_7-1 loaded.",
        "Level_7-2 loaded. GravityChange = active.",
        "Level_7-3 loaded.",
        "Level_7-4 loaded. GravityChange = active.",
        "Level_7-5 loaded.",
        "Level_8-1 loaded. GravityChange = active.",
        "Level_8-2 loaded.",
        "Level_8-3 loaded.",
        "Level_8-4 loaded.",
        "End. Thanks for playing! More levels might eventually at some point in the future actually get created if I feel like I have the time to create those levels and if I feel like actually creating the levels as well, bye!",
    }
    for i = 1, #texts, 1 do
        if select == i then
            return texts[i]
        end
    end
end

function Text:storylineSecret(select)
    texts = {
        "Secret Level num 1. Something should be implemented here but it seems like I didn't have the time.",
    }
    for i = 1, #texts, 1 do
        if select == i then
            return texts[i]
        end
    end
end
  


