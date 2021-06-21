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

	--[[ Initially, the player won’t be able to jump (source: https://sheepolution.com/learn/book/24 ). ]]
	self.canJump = false

end

--[[ This will check collision between 2 bodies (source: https://youtu.be/3IdOCxHGMIo?t=5867 ). More specifically, 
it will check collision between the player and the floor. 

I’m not using a constant to get the width and the height of the floor (unlike Colton), so I will get the width and the height by 
using getWidth() and getHeight() from Floor.lua. 

I don't need (for the time being) to check if I'm touching on the x axis the floor. 

I NEED TO MODIFY THIS TO COMPARE THE CENTER OF THE FLOOR SPRITE AND OF THE PLAYER’S SPRITE TO USE RESOLVECOLLISION(). 

I will use a simplified code that will check if the player and the floor are touching each other. I technically don’t 
need to check if they’re horizontally aligned, so I will only check if they touch each other on the y coordinates 
(source: https://sheepolution.com/learn/book/23 )

I changed the player's y position to "last.y" to get the previous y position from the last{} table. --]]
function Player:collides(floor)
	return self.last.y + self.height > floor.y and self.last.y < floor.y + floor.height
end


--[[ This will make the player do any actions (run, throw blocks, fall due to gravity, etc) --]]
function Player:update(dt)
	-- This is the speed that the player will gain due to gravity
	self.dy = self.dy + GRAVITY * dt

	--[[ This makes the player jump. This is where the keysPressed table from main.lua is being used. 
	
	I will also prevent the player from jumping again mid-jump (source: https://sheepolution.com/learn/book/24 ).
	I need to specify that, besides pressing the spacebar, you also need the canJump variable to be “true” to be able to jump. --]]
	if love.keyboard.wasPressed('space') and self.canJump then
		self.dy = -6
		self.canJump = false 
	end
	
	--[[ DEBUGGING CODE. This will make the player move downwards if the user presses the down arrow key
	(source: https://sheepolution.com/learn/book/23 )]]
    -- if love.keyboard.isDown("down") then
    --     self.y = self.y + 200 * dt
    -- end

	--[[ This will make the player move left or right by pressing the arrow keys. ]]
	if love.keyboard.isDown("left") then
        self.x = self.x - 200 * dt
	elseif love.keyboard.isDown("right") then
		self.x = self.x + 200 * dt
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
through the floor, since they will go back to their previous position (source: https://sheepolution.com/learn/book/23 .) 

After further reading, it turns out that I shouldn’t return the player to their previous position (by using last{}). 
Instead, I should create a variable which will subtract the distance in which the player falls through the floor. 

This way, the player will only touch the floor, NOT fall through it (source: https://sheepolution.com/learn/book/23 .)

I will now check if the center of the player's sprite is higher than the center of the floor's sprite. If so, I will
push the player upwards, so that they don't fall through the floor. After that, I subtract the player's height to the floor's 
y coordinate, and push them upwards at exactly that distance so that the player's feet never fall through the floor.

IT WORKS, but the player will fall through the floor once their weight due to gravity becomes large enough.

I added some code to reset the gravity back to 0 for the player if they touch the floor (source: 
https://sheepolution.com/learn/book/24 ). In my case, “self.dy” stores the player’s weight due to gravity.  ]]
function Player:resolveCollision(floor)
    if self:collides(floor) then
		if self.y + self.height/2 < floor.y + floor.height/2 then
			local pushback = self.y + self.height - floor.y
			self.y = self.y - pushback
			self.dy = 0
		end

		-- local pushback = self.y + self.height - floor.y
		-- self.y = self.y + pushback
		
		-- self.x = self.last.x
		-- self.y = self.last.y
    end
end

-- This will render the player’s sprite onscreen
function Player:render()
	love.graphics.draw(self.image, self.x, self.y)
end
