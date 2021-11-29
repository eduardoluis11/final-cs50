--[[ BEGINNING OF COMMENT
	This script will have the code for the main character. It starts with an uppercase letter since it’s a class, and classes are 
    written beginning with capital letters.
	
    I will use class.lua to make a class in Lua, and I will create the playable character’s properties by creating a class. To do this, 
    
    I will use a good portion of the code shown from Colton’s 2018 Game Dev class which can be found here: 
    https://www.youtube.com/watch?v=3IdOCxHGMIo&t=2006s .
END OF COMMENT --]]
-- This creates the class that will create the main character
Player = Class{}

--[[ This adds the value for gravity. It seems that, by increasing gravity and self.dy, I can make the character 
fall faster and jump higher by using "self.dy = Number * dt" (that is, by using dt, so that the game runs
the same on fast and slow computers, with vsync actvated or not.) 

The original value for gravity was "19", and the original value for self.dy (without dt) was of "-6". ]]
local GRAVITY = 3300

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

I changed the player's y position to "last.y" to get the previous y position from the last{} table. 

Since I want to have the same collision detection on the platforms as in the floor, I will change “floor” by a 
generic variable.

I think I need to check for collision detection on the x axis as well so that the game checks that I’m both vertically 
and horizontally aligned to the floor or the platform before pushing me back upwards so that I don’t fall through 
the floor/platform, but I don’t float in the air either. Without checking collision on the x axis, the character will 
float if it’s at the same height as any of the platforms.--]]
function Player:collides(e)
	return self.last.y + self.height > e.y 
	and self.last.y < e.y + e.height
	and self.last.x + self.width > e.x
	and self.last.x < e.x + e.width
end


--[[ This will make the player do any actions (run, throw blocks, fall due to gravity, etc) --]]
function Player:update(dt)
	--[[ This is the speed that the player will gain due to gravity when falling

	It seems that the solution was using "dt / 2" (source: http://openarena.ws/board/index.php?topic=5100.0)

	IT DIDN'T WORK. FIX THIS BUG before continuing. 

	BUG: My character is falling too slow after jumping, and jumps lower and slower in powerful desktop computers, 
	instead of jumping and falling as they should like it does on my laptop. FIX THIS BUG.
	--]]

	self.dy = self.dy + GRAVITY * dt / 2

	--[[ Thsi will make the player rewspan if the fall into a bottomless pit. I would need to first check if the 
	player’s position is higher than the viewport’s height (that is, if the player has fallen below the bottom of 
	the screen). If it does, I would have to change the player’s position so that it reappears on the left side of 
	the screen (really close to the room’s door).

    I could put an “if” statement on either main.lua or Player.lua to check for the player’s position to check if they 
	are below the bottom of the screen.

    I may use the Player.lua script since it already has a table that stores each position of the player when the 
	player moves (each x and y coordinate). So, I could use that table to check if the last y position of the player 
	was way below the bottom of the screen (something like “VIRTUAL_WIDTH + 1000”). If it is, I would reset the player’s
	position to the left side of the room (something like “VIRTUAL_WIDTH - (141 * 3) - 150, -80 + VIRTUAL_HEIGHT - 62”, 
	which is where one of the treasure chests is located.)

    I would use something like the code that I’m using for collision detection on Player.lua, but, instead of preventing 
	the player from falling through the floor, it would make the player respawn at the beginning of the room. 
	]]
	if self.y > VIRTUAL_HEIGHT + 1500 then
        self.y = 300
        self.x = 100
    end


	--[[ This makes the player jump. This is where the keysPressed table from main.lua is being used. 
	
	I will also prevent the player from jumping again mid-jump (source: https://sheepolution.com/learn/book/24 ).
	I need to specify that, besides pressing the spacebar, you also need the canJump variable to be “true” to be able to jump.
	
	I added "+ dt" so the character jumps at the same height in every computer, be it a powerful one, a weak one, 
	or regardless of whether or not vsync is on (source: https://love2d.org/forums/viewtopic.php?t=76758 )
	
	I had to increase the values for the self.dy and the gravity so that I could use "dt" in the vertical speed calculation
	and I could still fall fast and jump high.
	--]]
	if love.keyboard.wasPressed('space') and self.canJump then
		self.dy = -1300
		self.canJump = false 
	end
	
	--[[ DEBUGGING CODE. This will make the player move downwards if the user presses the down arrow key
	(source: https://sheepolution.com/learn/book/23 )]]
    -- if love.keyboard.isDown("down") then
    --     self.y = self.y + 200 * dt
    -- end

	--[[ This will make the player move left or right by pressing the arrow keys. ]]
	if love.keyboard.isDown("left") then
        self.x = self.x - 260 * dt
	elseif love.keyboard.isDown("right") then
		self.x = self.x + 260 * dt
    end

	--[[ DEBUGGING CODE. DELETE LATER. This will change the room number if I press any of the number keys (between 0 and 5.) ]]
	if love.keyboard.wasPressed('1') then
		currentRoom = 1
		print("Room 1.")
	elseif love.keyboard.wasPressed('2') then
		currentRoom = 2
		print("Room 2.")
	elseif love.keyboard.wasPressed('3') then
		currentRoom = 3
		print("Room 3.")
	elseif love.keyboard.wasPressed('4') then
		currentRoom = 4
		print("Room 4.")
	elseif love.keyboard.wasPressed('5') then
		currentRoom = 5
		print("Room 5.")
	elseif love.keyboard.wasPressed('0') then
		currentRoom = 0
		print("Main Hub.")
	end


	--[[ This will make the player fall due to gravity (by updating his y coordinate).
	
	I added an "if" statement that will check whether the player is in the air (be it from
	jumping or by falling.) If the player is in the air, I will apply gravity to them.
	
	It works, but the player will sometimes get their feet deeper into the floor when junping too high. 
	They can still jump, but it's still a bug. However, I would need a better collision detector  
	to fix that, so I may leave that as is. 
	
	Now, I need to find a way to jump only once. Right now, I can jump infinitely.
	
	It seems that the solution was using "dt / 2" so that the character jumps at the same height
	in any computer, no matter how powerful lthe computer is or if vsync is on or off. (source: http://openarena.ws/board/index.php?topic=5100.0)
	
	I used "(self.dy * dt)" so that the vertical speed is calculated with "dt", and so that the character could
	fall fast and jump high on powerful computers, as well as in my laptop. SEE IF IT WORKS.
	
	--]]
	if playerCollision == false or love.keyboard.wasPressed('space') then
		self.y = self.y + (self.dy * dt)
		self.dy = self.dy + GRAVITY * dt / 2
	end

	--[[ This will store the previous position of the player into the last{} table (source: 
	-- https://sheepolution.com/learn/book/23 ) ]]
	self.last.x = self.x
	self.last.y = self.y
end

--[[ Besides the standard collision detection, I will also detect if the player and the object are one on top of the 
other, or in other words, if they have the same x coordinate (source: https://sheepolution.com/learn/book/23 ). 
This could also be called that they are horizontally aligned.

This will prevent the player from appearing on top of a platform if they walk below a platform.  ]]
function Player:sameHorizontalPosition(e)
    return self.last.x < e.x + e.width and self.last.x + self.width > e.x
end

--[[ For the time being, I WON'T check for horizontal collision detection, because, otherwise, my character will clip
through the floor.

I would have to create a different collision detection that is entirely separate for the floor. However, I don't need
that urgently for the time being.]]
-- function Player:sameVerticalPosition(e)
--     return self.last.y < e.y + e.height and self.last.y + self.height > e.y
-- end


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
https://sheepolution.com/learn/book/24 ). In my case, “self.dy” stores the player’s weight due to gravity.

I will change “floor” by a generic variable to let the player land on both the floor and the platforms.

I will add an extra condition to resolveCollision(): to check if the player and the object are in the same horizontal 
position (source: https://sheepolution.com/learn/book/23 ). This way, the player won’t spawn on top of a platform if 
they walk below the platforms.

I was able to more or less fix the bug where the player was spawning on top of the platforms if they walked below them
by changing "e.height/2" by "e.height/10" (or a smaller number). This is because the platform sprite is very tall, so 
the player was never walking below the vertical center of the platforms' sprites.  

In the end, I had to cut the platform sprite into 2 parts: the top part (the red rectangle), and the bottom blue base.
The top part will have collision detection. 

I will make my character to be pushed downwards if they jump below the platform. This will prevent the player 
from going to the top of platforms 1 and 2 if I jump high enough from below, and will prevnt the player from
getting stuck below platform 3 if they jump below it (source: https://sheepolution.com/learn/book/23).]]
function Player:resolveCollision(e)
    if self:collides(e) then
		if self:sameHorizontalPosition(e) then
			if self.y + self.height/2 < e.y + e.height/2 then
				local pushback = self.y + self.height - e.y
				self.y = self.y - pushback
				self.dy = 0
			else
                local pushback = e.y + e.height - self.y
                self.y = self.y + pushback
			end

			-- local pushback = self.y + self.height - floor.y
			-- self.y = self.y + pushback
			
			-- self.x = self.last.x
			-- self.y = self.last.y
		end
    end
end

-- This will render the player’s sprite onscreen
function Player:render()
	love.graphics.draw(self.image, self.x, self.y)
end
