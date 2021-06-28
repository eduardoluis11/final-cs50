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
--]]
function Treasure:update(dt)
    if timerOn == true and self.timer < 3 then
        self.timer = self.timer + dt
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
treasure to only render if the timer is running, that is, if I’m not at the 0th second. ]]
function Treasure:render()
    if currentRoom == 1 and timerOn == true then
        love.graphics.draw(TREASURE_1_IMAGE, self.x, self.y)
    end
end
