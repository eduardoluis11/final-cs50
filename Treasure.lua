--[[ This script handles the treasures that are inside each chest.  ]]
-- This creates the class for the treasures
Treasure = Class{}

-- This stores the treasures’ sprites
local TREASURE_1_IMAGE = love.graphics.newImage('graphics/treasures/bronze-ring.png')
local TREASURE_2_IMAGE = love.graphics.newImage('graphics/treasures/bronze-armor.png')
local TREASURE_3_IMAGE = love.graphics.newImage('graphics/treasures/ruby.png')
local TREASURE_4_IMAGE = love.graphics.newImage('graphics/treasures/gold-ingot.png')
local TREASURE_5_IMAGE = love.graphics.newImage('graphics/treasures/diamond.png')


--[[ This will have the initial properties of the treasures.

Each treasure will have the same x coordinate as each chest containing them. The y coordinate of each treasure will 
be similar to the chests, but I will subtract a few pixels so that they appear above their respective chest.

So, I may need to call the treasure() function from the Chest{} class.

The height and width of all of the treasures are the same. So, I can use any of the 5 sprites to get the width and 
height using getWidth() and getHeight(). 

The x and y coordinate of each treasure will be obtained from the Chest{} class whenever the chest() function is called, 
so there’s no point in specifying the room number to get the treasure position in here. ]]
function Treasure:init(treasure_x, treasure_y)
	self.width = TREASURE_1_IMAGE:getWidth()
	self.height = TREASURE_1_IMAGE:getHeight()

    self.y = treasure_y - 80
    self.x = treasure_x + 20

    -- I need to start the timer at 0 here, or else the timer will have a nil value, and I'll get an error message.
    self.timer = 0

    --[[ This variable will keep track on whether or not to permanently render the treasure on the bubble UI at the 
    top of the screen. By default, the treasure won’t be rendered.  ]]
    self.showTreasure = false
end

--[[ The update() function will make each treasure disappear after a few seconds of appearing (that is, after a few seconds 
of opening a chest). 

To do this, I will start running the timer here, and I will stop it after reaching, for instance, 5 seconds. 

I will start the timer at 0. Otherwise, it will start at a NULL value, and I’ll get errors.

Then, if the timer is activated from the timerOn variable, I will start running the timer.

Finally, if I reach a certain number of seconds (like 5), I will deactivate the 
timer, and reset it back to 0.

I need to add "dt" as a parameter inside of the parenthesis, or the dt value will be nil, and I won't be able
to add every second of the timer and I'll get an error message.

I need to keep track of which treasure has been picked up to know which treasure to render above the chest and 
on the treasure bubble UI. So, I will use the “treasureNUMBER_Obtained” variable from main.lua, and change it to “true” 
depending on the room where the player opened a chest.

That is, my code will check the number of the room where the player is. If they’re in, for instance, room 1, and the 
chest has been opened, treasure 1 should be rendered. I will need to do this 5 times (once for each treasure.)

I will add a new variable (which I will include in the init() function with the suffix “self.”) which will keep track 
whether to render the treasure or not (BESIDES timerOn), which I will use for permanently rendering the treasure on 
the UI once the user finds a treasure.

If the timer gets activated at least once, the variable that keeps track on whether or not to render the treasure 
will be permanently activated (turned to “true”.)
--]]
function Treasure:update(dt)
    if timerOn == true and self.timer < 2 then
        self.timer = self.timer + dt

        self.showTreasure = true
        --print("The timer is on.")   -- DEBUGGING MESSAGE. DELETE LATER.
    else
        timerOn = false
        self.timer = 0
    end
end
    
--[[ This will render each treasure sprite.

The treasures will only be rendered when the sprite of the opened treasure chest is rendered.

Here is where I need to specify the room number to decide which treasure to render. 

I will also only render the treasure for a few seconds, and then make it disappear. To make that, I will make the 
treasure to only render if the timer is running, that is, if I’m not at the 0th second.

I simplified my code, and I will check which of the 5 treasures I should render. Instead of checking the room number 
and if the chest has been opened, I will check if the variable from the update() function (treasureNUMBER_Obtained) 
is set to “true”. 

If it is, I will render the corresponding treasure above its respective chest temporarily, and on the bubble UI permanently.

I will tell my script that it should check for a parameter from the chest.lua. If I get the parameter “false” in 
treasure:render() from chest.lua, that means that the current chest is opened, so I should render the treasure. 

I may need to delete the treasure:render() function from main.lua, and put it only in chest.lua.

I will only render the treasure above its respective chest for 2 seconds (with the timer), BUT I will permanently render 
the treasure on the bubble UI at the top of the screen.

I don’t know right now where to permanently render the treasures to put them in the bubble UI, but that’s not important 
for the time being. ]]
function Treasure:render()
    if currentRoom == 1 and self.showTreasure == true then
        love.graphics.draw(TREASURE_1_IMAGE, 100, 20)
        
        if timerOn == true then
            love.graphics.draw(TREASURE_1_IMAGE, self.x, self.y)
        end
    end    
end
