--[[ This script handles the treasure chests. Each of the 5 main rooms will have a chest with a different treasure on it. The player will need to find the game’s 5 treasures to beat the game. ]]
-- This creates the class for the chest
Chest = Class{}

-- This stores the closed chest sprite
local CHEST_IMAGE = love.graphics.newImage('graphics/chest-closed.png')

--[[ This will have the initial properties of the chest.

Since most of the chests will have different positions, I need to specify the x and y coordinates of each chest from main.lua 
for each time that I instantiate a chest. 

The height and width of all chests will be the same, so there’s no point in obtaining the width and height of each chest 
inside of an “if” statement. ]]
function Chest:init(chest_x, chest_y)
	self.width = CHEST_IMAGE:getWidth()
	self.height = CHEST_IMAGE:getHeight()

	--[[ The position of each chest will be rendered depending on the room where the player is currently located. ]]
	if currentRoom == 1 then
		self.y = chest_y 
		self.x = chest_x
	end
end

--[[ I will add the update() function later to make the chest to change from being closed to being opened. --]]

-- This will render the chest sprite
function Chest:render()
	love.graphics.draw(CHEST_IMAGE, self.x, self.y)
end
