--[[ This is the script for thar class that creates the levers which will allow you to unlock treasures that are locked 
in a cage. ]]
Lever = Class{}

-- This stores the deactivated and activated lever sprites, and the cage sprite
local DEACTIVATED_LEVER_IMAGE = love.graphics.newImage('graphics/deactivated-lever.png')
local ACTIVATED_LEVER_IMAGE = love.graphics.newImage('graphics/activated-lever.png')

local CAGE_IMAGE = love.graphics.newImage('graphics/cage.png')


--[[ This will have the initial properties of the deactivated lever.

Since the levers will have different positions, I need to specify the x and y coordinates of each lever in main.lua for each 
time that I instantiate a lever. 

I will use the width and the height of the deactivated lever sprite, since the player will only be able to interact with the 
deactivated lever. I don’t need to get the exact width and height of the activated lever, nor of the cage sprite.

I need a variable that will tell the game whether to render the deactivated lever sprite or the activated one for the current 
instance of the lever. 
	
I will use "self." so that only the current instance of the lever will be activated after pressing “E”. That is, “self.” 
will prevent the multiple levers from opening at the same time if I activate 1 lever.

I will also add a variable that will keep track on whether or not to render a cage on top of a chest. The cage will prevent 
the player from opening a chest. So, to open that chest, the player should activate a lever to remove the cage that is locking 
that chest. By default, that cage will be rendered. It will stop being rendered once the player activates its respective lever.

Some of the chests, like the one on Room 2, will be locked. So, I will create global variables that store which chests 
will be locked by default. Then, after activating the lever from that room, its corresponding chest will be unlocked.

I will create a global variable that will tell the game whether room 4's lever has been pulled, which, if it is, 
a falling stalactite will spawn.

For room 5, I ned to be able to differentiate between each of the 4 levers that will be used for the room's puzzle.
So, to differentiate between the "ring", "armor", "ruby", and "gold" levers, I will pass a 3rd parameter to each
lever from main.lua. If the lever's not located in room 5, the parameter will have a default value of "regular".
]]
function Lever:init(lever_x, lever_y, leverType)
	self.width = DEACTIVATED_LEVER_IMAGE:getWidth()
	self.height = DEACTIVATED_LEVER_IMAGE:getHeight()

	self.x = lever_x
    self.y = lever_y 

	self.activatedLever = false

	self.showCage = true

	unlockChest_2 = false
	unlockChest_3 = false
	unlockChest_5 = false

	-- This will spawn a stalactite in room 4 once it changes to "true"
	spawnStalactite_Room4 = false

	--[[ This will check whether the lever belongs to room 5 or not, and if so, it will check if the 
	treasure icon associated with the lever is "ring", "armor", "ruby" or "gold". ]]
	self.leverType = leverType
end

--[[ The update() function will make the lever change from being deactivated to being activated, and will make its 
respective cage disappear from the chest that is locking. To do so, update() will make the user activate a lever by 
pressing the “E” key.

It will accept a parameter from main.lua that should have the value "true". If this function receives that value, it means that 
the player is touching a lever, and that, if they press the "E" key, the lever should become activated.

I will modify the "self." variable that keeps track of whether the lever is activated or not so that only the current instance 
of the lever will be activated in the Lever:render() function (that is, so that the rest of the levers remain deactivated if 
I only activate 1 lever.)

The parameter inside of lever:update() tells me if the player is touching the lever.

This is also where I need to specify that the variable that keeps track on whether or not to render the cage should be 
deactivated to make the cage disappear.

Also, I will change the global variable that keeps track of the locked chests so that, if the player pulls the lever, 
the corresponding treasure of that room becomes unlocked.

If the player pulls the lever in room 4, a stalactite will spawn in that room.

In Room 5, the player will only be able to open the chest if the 4 levers are pulled in a specific order. That is, after solving
the lever puzzle, the "unlock chest 5" variable will be set to "true".

The variable that makes the cage appear should change to "false" (that is, the cage should disappear) ONLY if their 
respective lever has been pulled. I shouldn't make the cages disappear immediately after pulling a lever, since the player
needs to pull 4 levers in room 5 to make the cage around chest 5 disappear. If I make any cage disappear immediately after
pulling just 1 lever, this will render 4 cages on top of chest 5 (which would be a bug.)
--]]
function Lever:update(isTouchingLever)
	if love.keyboard.wasPressed('e') then
		if isTouchingLever == true then
			if self.activatedLever == false then
			    self.activatedLever = true
				
				if currentRoom == 2 then
					unlockChest_2 = true
					self.showCage = false
				elseif currentRoom == 3 then
					unlockChest_3 = true
					self.showCage = false
				elseif currentRoom == 4 then
					spawnStalactite_Room4 = true
				elseif currentRoom == 5 then
					unlockChest_5 = true
					self.showCage = false
				end
		    end
		end
	end
end

--[[ This will render the lever sprite and the cage sprites. 

The levers will work differently on room 5 than on the other rooms. In room 5, I will need to activate 4 or 5 levers in a 
specific order to make the cage disappear. Otherwise, all 4 or 5 levers will be reset.

Meanwhile, in the rest of the rooms, by activating a lever, the cage locking a chest will immediately disappear. The cage 
should be rendered by default when entering rooms such as room 2 or 5.

The cages will be rendered on different positions depending on the room number (they will be rendered on top of the chests 
of their respective rooms.)

Rooms 2, 3 and 5 will have levers.

Each room needs to have its own lever. However, I think that needs to be done in main.lua with an “if” statement. 
I need to check main.lua and the code for chest.lua to see what I did in order to prevent all chests from opening 
whenever I opened 1 chest. 
]]
function Lever:render()
	-- This renders the lever
	if self.activatedLever == false then
		love.graphics.draw(DEACTIVATED_LEVER_IMAGE, self.x, self.y)
	else
		love.graphics.draw(ACTIVATED_LEVER_IMAGE, self.x - 25, self.y + 10)
	end

	-- This renders the cage on top of a chest
	if self.showCage == true then
		if currentRoom == 2 then
			love.graphics.draw(CAGE_IMAGE, VIRTUAL_WIDTH - (141 * 3) - 60, VIRTUAL_HEIGHT - 368)
		elseif currentRoom == 3 then
			love.graphics.draw(CAGE_IMAGE, VIRTUAL_WIDTH - (141 * 3) - 60, VIRTUAL_HEIGHT - 180)
		elseif currentRoom == 5 then
			love.graphics.draw(CAGE_IMAGE, VIRTUAL_WIDTH - (141 * 3) + 180, VIRTUAL_HEIGHT - 180)
		end
	end
end
