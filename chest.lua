--[[ This script handles the treasure chests. Each of the 5 main rooms will have a chest with a different treasure on it. The player will need to find the game’s 5 treasures to beat the game. ]]
-- This creates the class for the chest
Chest = Class{}

-- This stores the opened and closed chest sprites
local CLOSED_CHEST_IMAGE = love.graphics.newImage('graphics/chest-closed.png')
local OPENED_CHEST_IMAGE = love.graphics.newImage('graphics/chest-opened.png')

--[[ DEBUGGING CODE: This will contain the sprites for the 5 treasures and of the treasure bubble to compare their 
sizes to the chest sprites.

DELETE LATER. ]]
local TREASURE_1_IMAGE = love.graphics.newImage('graphics/treasures/bronze-ring.png')
local TREASURE_2_IMAGE = love.graphics.newImage('graphics/treasures/bronze-armor.png')
local TREASURE_3_IMAGE = love.graphics.newImage('graphics/treasures/ruby.png')
local TREASURE_4_IMAGE = love.graphics.newImage('graphics/treasures/gold-ingot.png')
local TREASURE_5_IMAGE = love.graphics.newImage('graphics/treasures/diamond.png')

local BUBBLE_IMAGE = love.graphics.newImage('graphics/treasure-bubble-empty.png')



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

	--[[ The position of each chest will be rendered depending on the room where the player is currently located.
	However, that will be specified on the render() function, not here. ]]
	self.y = chest_y 
	self.x = chest_x

	--[[ This is a variable that will tell the game whether to render the closed chest sprite or the opened one for 
	the current instance of the chest. 
	
	I'm using "self." so that only the current instance of the chest will be closed. That is, if I open a chest, the 
	rest of the chests will remain closed, and if a chest is opened, it will remain opened once the player returns
	to the room. Or in other words, if I had 2 chests in the same room, this will prevent the 2 chests from opening 
	at the same time if I open 1 chest. ]]
	self.closedChest = true
end

--[[ The update() function makes the chest change from being closed to being opened.

It will accept a parameter from main.lua that should have the value "true". If this function receives that value, 
it means that the player is touching a chest, and that, if they press the "E" key, the chest should open.

I will modify the "self.closedChest" to "true" so that only the current instance of the chest will be opened 
in the Chest:render() function (that is, so that the rest of the chest remain closed if I only open 1 chest.)
	
I may remove the "timerOn" variable from here since, right now, it's a global variable, and it's affecting ALL instances
of the chest{} class (that is, the timer is affecting ALL the chests at the same time). --]]
function Chest:update(isChestOpen)
	--[[ This will make the user open a chest by pressing the “E” key.
	
	I will add an extra variable to check whether the player is colliding with the chest. This way, I’ll only be 
	able to open the chest if I’m touching it.]]
	if love.keyboard.wasPressed('e') then
		if isChestOpen == true then
			self.closedChest = false
			timerOn = true
		end
	end
end

--[[ This will render the chest sprite.

To be able to change the chest from closed to open, I will render the closed chest on a layer on top of the opened 
chest sprite. Then, I will create a variable that will store whether the chest should be opened or closed, and use an 
“if” statement to tell the game whether to show or remove the closed chest sprite (source: 
https://youtu.be/F86edI_EF3s).

If that variable says that the chest should be closed (by default), the chest will remain closed. Otherwise, the closed 
chest sprite will disappear, and will reveal the opened chest sprite underneath it.

I will render the closed chest on top of the opened chest sprite.

In the end, I decided just to use an "else" statement to render the opened chest if the closedChest variable is equal
to "false".

I decided to subtract 23 px to the height of the opened chest so that it doesn't clip through the floor (23 px is the 
height difference between the closed and opened chest sprites).

To fix the bug where all of the chest were being opened if I opened only 1 chest, I had to change "closedChest" to 
"self.closedChest" so that only the current instance of the chest changes from closed to opened. ]]
function Chest:render()
	if self.closedChest == true then
		love.graphics.draw(CLOSED_CHEST_IMAGE, self.x, self.y)
	else
		love.graphics.draw(OPENED_CHEST_IMAGE, self.x, self.y - 23)
	end

	--[[ DEBUGGING CODE. I will render the treasures to see their sizes compared to the size of the chest sprites.

	Also, I will render the treasure UI bubble to see if I need to modify the size of the sprite.
	
	DELETE LATER.
	]]
	-- love.graphics.draw(BUBBLE_IMAGE, self.x + 5, self.y - 90)

	-- love.graphics.draw(TREASURE_5_IMAGE, self.x + 20, self.y - 50)
end
