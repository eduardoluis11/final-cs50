--[[ This script will handle the stalactites from rooms 3 and 5, which will act like platforms.

I may delete them from room 5. ]]
Stalactite = Class{}

-- This stores the stalactite sprite
local STALACTITE_IMAGE = love.graphics.newImage('graphics/stalactite.png')

-- This will store the stalactite's grvity.
local STALACTITE_GRAVITY = 90

--[[ These are the initial properties of the stalactites ]]
function Stalactite:init(stalactite_x, stalactite_y)
	self.width = STALACTITE_IMAGE:getWidth()
	self.height = STALACTITE_IMAGE:getHeight()

	self.x = stalactite_x
    self.y = stalactite_y 

	self.dy = 0
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

]]
function Stalactite:update(dt)
	self.dy = STALACTITE_GRAVITY * dt
	self.y = self.y + self.dy
end


--[[ This will render the stalactites.

They will only render in rooms 3 and 5.

]]
function Stalactite:render()
	if currentRoom == 3 then
		love.graphics.draw(STALACTITE_IMAGE, self.x, self.y)
	end
end