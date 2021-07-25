--[[ This script will handle the stalactites from rooms 3 and 5, which will act like platforms.

I may delete them from room 5. ]]
Stalactite = Class{}

-- This stores the stalactite sprite
local STALACTITE_IMAGE = love.graphics.newImage('graphics/stalactite.png')

--[[ These are the initial properties of the stalactites ]]
function Stalactite:init(stalactite_x, stalactite_y)
	self.width = STALACTITE_IMAGE:getWidth()
	self.height = STALACTITE_IMAGE:getHeight()

	self.x = stalactite_x
    self.y = stalactite_y 
end

--[[ This will make the stalactites fall and respawn once they fall to the bottom of the screen.

I will add a constant fall velocity for the stalactites instead of using gravity since, if I use gravity, the stalactites would 
fall too quickly, and it would be difficult for the player to jump on top of the stalactite.

At first, I will try to use the speed stored in GRAVITY to see if it’s appropriate as a falling speed. Otherwise, I will 
use another number.

I don’t know if I should use “dy” (as I did when creating the gravity for the player with the variable “self.dy”).  

]]
function Stalactite:update()
	self.y = self.y + 1
end


--[[ This will render the stalactites.

They will only render in rooms 3 and 5.

]]
function Stalactite:render()
	if currentRoom == 3 then
		love.graphics.draw(STALACTITE_IMAGE, self.x, self.y)
	end
end