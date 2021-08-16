--[[ This script will handle the stalactites from rooms 3 and 5, which will act like platforms.

I may delete them from room 5. ]]
Stalactite = Class{}

-- This stores the stalactite sprite
local STALACTITE_IMAGE = love.graphics.newImage('graphics/stalactite.png')

-- This will store the stalactite's grvity.
local STALACTITE_GRAVITY = 90

--[[ These are the initial properties of the stalactites.

I want to store the initial position of the stalactites so that, after they fall below the screen, I can reset 
their position to their original position. To do that, I’ll use a temporary global variable. It’s only the y coordinate 
that I want to store in the temporary variable (the x position never changes.)

I need to use “self.” for the temporary variable since that variable will be a global variable, and I want each stalactite 
to have their own y coordinates and fall at different times.

I will also store the initial value for the speed for the current instance of the stalactite (it will also be a temporary 
variable, which will be reset once the stalactite respawns.)

I will also specify the stalactite’s acceleration in a variable. This way, the stalactite’s “gravity” will be reset after 
it respawns. 

After further consideration, I decided that the stalactite should have a constant speed. Therefore, it won’t 
have any acceleration whatsoever (the gravity will be equal to the stalactite's speed. The stalactite's gravity won't be 
an acceleration).
]]
function Stalactite:init(stalactite_x, stalactite_y)
	self.width = STALACTITE_IMAGE:getWidth()
	self.height = STALACTITE_IMAGE:getHeight()

	self.x = stalactite_x
    self.y = stalactite_y 

	self.dy = 0

	-- Temporary variable
	self.initial_y = stalactite_y
end

--[[ This will make the stalactites fall and respawn once they fall to the bottom of the screen.

I will add a constant fall velocity for the stalactites instead of using gravity since, if I use gravity, the stalactites would 
fall too quickly, and it would be difficult for the player to jump on top of the stalactite.

At first, I will try to use the speed stored in GRAVITY to see if it’s appropriate as a falling speed. Otherwise, I will 
use another number.

I don’t know if I should use “dy” (as I did when creating the gravity for the player with the variable “self.dy”).

I will use “dt” as a parameter, and multiply that by the current speed of self.dy, so that the stalactite falls at the same
speed, regardless of whether the player’s computer is a powerful or a weak one.

Also, I will put "NUMBER * dt" instead of "self.dy + NUMBER * dt", because that would add gravity (that is, acceleration, or
a velocity that is constantly increasing), and I want the stalactite to fall at a constant speed so that the player
is easily able to jump on top of the stalactite and use it as a platform.

At really slow speeds (like "1 * dt"), the top of the stalactite sprite looks like it's shrinking, and then stretches again if
I use "dt". However, at faster speeds, this visual bug isn't noticeable.

If a stalactite falls below the bottom of the screen, I will respawn that stalactite to its original position. I 
will also reset that stalactite’s gravity (so it doesn’t fall way too fast after respawning.)

]]
function Stalactite:update(dt)
	self.dy = STALACTITE_GRAVITY * dt

	self.y = self.y + self.dy

	if self.y > VIRTUAL_HEIGHT then
		self.y = self.initial_y
	end
end


--[[ This will render the stalactites.

They will only render in rooms 3 and 5.

]]
function Stalactite:render()
	if currentRoom == 3 then
		love.graphics.draw(STALACTITE_IMAGE, self.x, self.y)
	end
end