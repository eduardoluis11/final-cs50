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

	--[[ This will store the current position of the player into a table, and set 
	it as their last position. I will use this to reset the player’s position once they collide with the floor so that 
	they don’t clip through the floor (source: https://sheepolution.com/learn/book/23 ). ]]
	self.last = {}
	self.last.x = self.x
	self.last.y = self.y

end

--[[ This will check collision between 2 bodies (source: https://youtu.be/3IdOCxHGMIo?t=5867 ). More specifically, 
it will check collision between the player and the floor. 

I’m not using a constant to get the width and the height of the floor (unlike Colton), so I will get the width and the height by 
using getWidth() and getHeight() from Floor.lua. 

I don't need (for the time being) to check if I'm touching on the x axis the floor. 

I NEED TO MODIFY THIS TO COMPARE THE CENTER OF THE FLOOR SPRITE AND OF THE PLAYER’S SPRITE TO USE RESOLVECOLLISION(). 

I will use a simplified code that will check if the player and the floor are touching each other. I technically don’t 
need to check if they’re horizontally aligned, so I will only check if they touch each other on the y coordinates 
(source: https://sheepolution.com/learn/book/23 )--]]
function Player:collides(floor)
	return self.y + self.height > floor.y and self.y < floor.y + floor.height
end


--[[ This will make the player do any actions (run, throw blocks, fall due to gravity, etc) --]]
function Player:update(dt)
	-- This is the speed that the player will gain due to gravity
	self.dy = self.dy + GRAVITY * dt

	--[[ This makes the player jump. This is where the keysPressed table from main.lua is being used. --]]
	if love.keyboard.wasPressed('space') then
		self.dy = -6 
	end
	
	--[[ DEBUGGING CODE. This will make the player move downwards if the user presses the down arrow key
	(source: https://sheepolution.com/learn/book/23 )]]
    if love.keyboard.isDown("down") then
        self.y = self.y + 200 * dt
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

	--[[ This will store the previous position of the player into the last{} table (source: 
	-- https://sheepolution.com/learn/book/23 ) ]]
	self.last.x = self.x
	self.last.y = self.y
end

--[[ This function will make it so that, if the player touches the floor (or a wall,) that they won’t clip 
through the floor, since they will go back to their previous position (source: https://sheepolution.com/learn/book/23 .) ]]
function Player:resolveCollision(floor)
    if self:collides(floor) then
        self.x = self.last.x
        self.y = self.last.y
    end
end

-- This will render the player’s sprite onscreen
function Player:render()
	love.graphics.draw(self.image, self.x, self.y)
end
