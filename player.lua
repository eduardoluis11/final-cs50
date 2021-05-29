--[[ BEGINNING OF COMMENT
	This script will have the code for the main character. It starts with an uppercase letter since it’s a class, and classes are 
    written beginning with capital letters.
	
    I will use class.lua to make a class in Lua, and I will create the playable character’s properties by creating a class. To do this, 
    
    I will use a good portion of the code shown from Colton’s 2018 Game Dev class which can be found here: 
    https://www.youtube.com/watch?v=3IdOCxHGMIo&t=2006s .
END OF COMMENT --]]
-- This creates the class that will create the main character
Player = Class{}

-- This adds the value for gravity
local GRAVITY = 21

-- Initializing function, which will contain many of the properties of the main character’s class.
function Player:init()
	self.image = love.graphics.newImage('graphics/player.png')

	-- This automatically obtains the width of the player’s sprite
	self.width = self.image:getWidth()
	self.height = self.image:getHeight()

	--[[ X and y coordinates of the player. Initially, I will put him on the (100, 100) coordinates.  --]]
	self.x = 100
	self.y = 100

	--[[ This is the player's initical vertical speed. If I don't initialize it here, I will get an error
	once I try to apply gravity to the player. --]]
	self.dy = 0
end

--[[ This will make the player do any actions (run, throw blocks, fall due to gravity, etc) --]]
function Player:update(dt)
	-- This is the speed that the player will gain due to gravity
	self.dy = self.dy + GRAVITY * dt

	--[[ This will make the player fall due to gravity (by updating his y coordinate) --]]
	self.y = self.y + self.dy
end

-- This will render the player’s sprite onscreen
function Player:render()
	love.graphics.draw(self.image, self.x, self.y)
end
