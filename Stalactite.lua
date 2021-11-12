--[[ This script will handle the stalactites from rooms 3 and 5, which will act like platforms.

I may delete them from room 5. ]]
Stalactite = Class{}

-- This stores the stalactite sprite
local STALACTITE_IMAGE = love.graphics.newImage('graphics/stalactite.png')

-- This will store the stalactite's grvity.
local STALACTITE_GRAVITY = 150

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

	--[[ Temporary variables. These are used for resetting the stalactite's position after the user exits and 
	reenters the rooms with stalactites ]]
	self.initial_y = stalactite_y
	self.initial_x = stalactite_x
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

I don't want the stalactite to respawn immediately after it falls below the bottom of the screen. I want a delay of at least
a second before it respawns at the top of the screen. So, I will make it so that the stalactite needs to fall some pixels
below the bottom of the screen before respawning (that way, I won't have to use a timer, so I won't have to worry too much
about possible bugs.)

BUG FIX: I will check the current room number here, not in main.lua. Then, if I'm on Room 3 or any other room with a 
stalactite, I will render the stalactite and make it fall. Otherwise, I will render the stalactite below the height
of the screen. This way, even though the stalactite will be invisible on rooms where there shouldn't be any stalactite,
the player will never be able to touch them nor be on top of them. This is a similar approach that the Paper Mario devs
did while mking the game.

The reason why I'm modifiying the x position is because some rooms have a bottomless pit. If the user falls down a 
pit, and there's an invisible stalactite below them, the player will never re-spawn, since the will be on top
of a stalactite. Also, I want the player to fall for a few seconds before re-spawning, so the player will have 
to fall a long distance below the screen. Since I won't have any bottomless pit that is at the left edge of the 
screen, the user will never fall on top of a stalactite ifthe stalactite has an x coordinate of 0 in rooms without
stalactites.

]]
function Stalactite:update(dt)
	if currentRoom == 3 then
		self.dy = STALACTITE_GRAVITY * dt

		self.y = self.y + self.dy
		self.x = self.initial_x

		if self.y > (VIRTUAL_HEIGHT + 100) then
			self.y = self.initial_y
		end
	else 
		self.y = VIRTUAL_HEIGHT + 100
		self.x = 0
	end
end

--[[ This will render the stalactites.

They will only render in rooms 3, 4 and 5.

I have a BUG in which, if I'm on rooms that aren't supposed to have stalactites, the stalactites will be invisible, and 
the player will be able to jump on top of them, even if they are invisible.

To fix this bug, I will render the stalactites to the lower left corner of the rooms without stalactites, that is, 
below the floor. THIS DIDN'T WORK, since the stalactite is still invisible and I can still jump on top of it 
while it's invisible.

]]
function Stalactite:render()
	if currentRoom == 3 or currentRoom == 4 or currentRoom == 5  then
		love.graphics.draw(STALACTITE_IMAGE, self.x, self.y)
	-- else
	-- 	love.graphics.draw(STALACTITE_IMAGE, 0, 0)
	end
end