--[[ This script handles the treasure chests. Each of the 5 main rooms will have a chest with a different treasure on it. The player will need to find the game’s 5 treasures to beat the game. ]]
-- This creates the class for the chest
Chest = Class{}

-- This stores the opened and closed chest sprites
local CLOSED_CHEST_IMAGE = love.graphics.newImage('graphics/chest-closed.png')
local OPENED_CHEST_IMAGE = love.graphics.newImage('graphics/chest-opened.png')

--[[ This will have the initial properties of the chest.

Since most of the chests will have different positions, I need to specify the x and y coordinates of each chest from main.lua 
for each time that I instantiate a chest. 

The height and width of all chests will be the same, so there’s no point in obtaining the width and height of each chest 
inside of an “if” statement.

I can use the width and the height of either the closed or the opened chest sprite, since both of them have the same 
width and height anyways.]]
function Chest:init(chest_x, chest_y)
	self.width = CLOSED_CHEST_IMAGE:getWidth()
	self.height = CLOSED_CHEST_IMAGE:getHeight()

	--[[ The position of each chest will be rendered depending on the room where the player is currently located. ]]
	if currentRoom == 1 then
		self.y = chest_y 
		self.x = chest_x
	end
end

--[[ I will add the update() function later to make the chest to change from being closed to being opened. --]]

--[[ This will render the chest sprite.

To be able to change the chest from closed to open, I will render the closed chest on a layer on top of the opened 
chest sprite. Then, I will create a variable that will store whether the chest should be opened or closed, and use an 
“if” statement to tell the game whether to show or remove the closed chest sprite.

If that variable says that the chest should be closed (by default), the chest will remain closed. Otherwise, the closed 
chest sprite will disappear, and will reveal the opened chest sprite underneath it.

I will render the closed chest on top of the opened chest sprite.

In the end, I decided just to use an "else" statement to render the opened chest if the closedChest variable is equal
to "false". ]]
function Chest:render()
	if closedChest == true then
		love.graphics.draw(CLOSED_CHEST_IMAGE, self.x, self.y)
	else
		love.graphics.draw(OPENED_CHEST_IMAGE, self.x, self.y)
	end
end
