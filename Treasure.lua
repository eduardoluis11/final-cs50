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
end

--[[ I will add the update() function later to make each treasure disappear after a few seconds of appearing (that is, 
after a few seconds of opening a chest). --]]

--[[ This will render each treasure sprite.

The treasures will only be rendered when the sprite of the opened treasure chest is rendered.

Here is where I need to specify the room number to decide which treasure to render. ]]
function Treasure:render()
	if currentRoom == 1 then
        if closedChest == false then
            love.graphics.draw(TREASURE_1_IMAGE, self.x, self.y)
        end
    end
end
