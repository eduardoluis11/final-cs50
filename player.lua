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

--[[ This will check collision between 2 bodies (source: https://youtu.be/3IdOCxHGMIo?t=5867 ). More specifically, 
it will check collision between the player and the floor. 

I’m not using a constant to get the width and the height of the floor (unlike Colton), so I will get the width and the height by 
using getWidth() and getHeight() from Floor.lua. --]]
function Player:collides(floor)
	if self.x + self.width >= floor.x and self.x <= floor.x + floor.width then 
		if self.y + self.height >= floor.y and self.y <= floor.y + floor.height then
			return true
		end
	end
	return false
end


--[[ This will make the player do any actions (run, throw blocks, fall due to gravity, etc) --]]
function Player:update(dt)
	-- This is the speed that the player will gain due to gravity
	self.dy = self.dy + GRAVITY * dt

	--[[ This makes the player jump. This is where the keysPressed table from main.lua is being used. --]]
	if love.keyboard.wasPressed('space') then
		self.dy = -6 
	end
	
	--[[ This will make the player fall due to gravity (by updating his y coordinate).
	
	I added an "if" statement that will check whether the player is in the air (be it from
	jumping or by falling.) If the player is in the air, I will apply gravity to them.
	
	It works, but the player will sometimes get their feet deeper into the floor when junping too high. 
	They can still jump, but it's still a bug. However, I would need a better collision detector  
	to fix that, so I may leave that as is. 
	
	Now, I need to find a way to jump only once. Right now, I can jump infinitely. --]]
	if playerCollision == false or love.keyboard.wasPressed('space') then
		self.y = self.y + self.dy
	end
end

-- This will render the player’s sprite onscreen
function Player:render()
	love.graphics.draw(self.image, self.x, self.y)
end
