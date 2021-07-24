--[[ This script will handle the stalactites from rooms 3 and 5, which will act like platforms.

I may delete them from room 5.
]]
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

--[[ This will render the stalactites.

They will only render in rooms 3 and 5.
]]
function Stalactite:render()
	if currentRoom == 3 then
		love.graphics.draw(STALACTITE_IMAGE, self.x, self.y)
	end
end