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

In the end, I think I will end up using tables. In this case, I will create 2 tables: a list of levers, and each lever. Each 
lever will be a separate table. Then, each of those levers will be inserted in a list of levers (or list of tables). That way, 
even though I will always be overwriting the table that has all of the lever’s properties in Lever.lua, each lever created will 
be inserted in the list of levers. That way, I will have the 1st lever in list[1], the 2nd lever in list[2], and so on and so 
forth.

However, something to keep in mind is that, to use this method, I will have to insert ALL OF THE LEVERS inside of the list of 
levers. That means that the levers from rooms 2, 3 and 4 will also have to be included in the lever list table. So, in total, 
I will have 7 levers inside of the lever list table. So, to get the 4 levers from room 5, I will have to use the levers from 
list[4] to list[7].

The table with the list of levers will have to go on the load() function of main.lua, whereas the table where each
individual lever will be created will be here in the init() function of Lever.lua. (source: 
https://sheepolution.com/learn/book/8)
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

	-- individualLever = {}
    -- individualLever.x = self.x
    -- individualLever.y = self.y

    -- individualLever.activatedLever = self.activatedLever
    -- individualLever.showCage = self.showCage
    -- individualLever.leverType = self.leverType

    -- Insert the new instance of the lever in the list of levers
    -- table.insert(listOfLevers, Lever(lever_x, lever_y, leverType))

    --[[ This is the counter that will keep track of the number of levers that I have activated in room 5 ]]
    roomFiveLeverCounter = 0

    --[[ This 2nd counter will keep track of the levers that have been activated in the correct order for Room 5’s puzzle. 
	If this counter reaches 4 by the time the player pulls the 4th lever, the player will solve the puzzle, so Room 5’s 
	chest will open, and the cage will disappear.

    Otherwise, all 4 levers will reset. ]]
    roomFiveCorrectOrderLeverCounter = 0

    --[[ This is the reset variable that will tell the game to reset all 4 levers if the player gets the lever order wrong 
	in Room 5’s puzzle ]]
    resetLevers = false
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

To make any operations using tables, like saying whether I want to activate or reset any of the 4 levers in room 4, I’ll use notation like 
“listOfLevers[4].activatedLever = false”, “listOfLevers[7].activatedLever = false”, etc. Same goes for rendering the cage 
in room 5.

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

				--[[ If I’m in Room 5, and I activate a lever, I will add “+1” to a counter to keep track of 
				how many levers I have activated. If I activate 4 levers, the counter should reach 4. Then, if I reset all 
				4 levers, the counter should go back to 0.

				For the time being, I will make it so that all 4 levers always reset once the player activates all 4 levers 
				in Room 5.

				To check if the player activates all levers in the correct order, I will use the counter that keeps track of 
				the correct order. The order is “ring”, “armor”, “ruby”, “gold”. 

				If the 1st lever that the player pulls is the ring lever, the order counter will get a +1. If the order counter 
				reaches 4 by the time the user activates the 4th lever, the chest will be unlocked and the cage will disappear. 
				Otherwise, the reset variable will become true, and all 4 levers will reset. ]]

				--[[ I will have a variable that will check if I need to reset Room 5’s levers (in case the player gets the 
				lever order wrong). If the  reset variable is “true”, then I will deactivate all 4 levers in Room 5 by changing 
				the “activatedLever” property of the last 4 levers in the listOfLevers[] table to “false”. The Room 5 levers will 
				have to be activated by iterating over the array that contains all of the game’s levers (source: 
				https://sheepolution.com/learn/book/7). I will add a “+3” since I want to start from the 4th element (which is 
				the 1st lever in Room 5). I assume that the loop will stop at the 7th and final element (Room 5’s last lever.) 

				Then, I will deactivate the reset variable by turning it to “false” so that the player is able to activate the 
				levers once again. I will also reset both lever counters back to 0. ]]
				elseif currentRoom == 5 then
					roomFiveLeverCounter = roomFiveLeverCounter + 1

					if roomFiveLeverCounter == 1 and self.leverType == 'ring' then
						roomFiveCorrectOrderLeverCounter = roomFiveCorrectOrderLeverCounter + 1
					end
					if roomFiveLeverCounter == 2 and self.leverType == 'armor' then
						roomFiveCorrectOrderLeverCounter = roomFiveCorrectOrderLeverCounter + 1
					end
					if roomFiveLeverCounter == 3 and self.leverType == 'ruby' then
						roomFiveCorrectOrderLeverCounter = roomFiveCorrectOrderLeverCounter + 1
					end
					if roomFiveLeverCounter == 4 and self.leverType == 'gold' then
						roomFiveCorrectOrderLeverCounter = roomFiveCorrectOrderLeverCounter + 1
					end
				
					if roomFiveLeverCounter == 4 then
						if roomFiveCorrectOrderLeverCounter == 4 then
							unlockChest_5 = true
							-- self.showCage = false

							--[[ This will make the cage disappear from Room 5's chest. Currently, my code renders
							a cage per lever. So, since I have 4 levers in Room 5, I have 4 cage sprites on the exact
							same position in Room 5, but they all look like a single cage sprite. So, if I deactivate
							the "showCage" property for the 4 levers in Room 5, the cage sprite should disappear
							from Room 5's chest. ]]
							for i=4,#listOfLevers do
								listOfLevers[i].showCage = false
							end
						else
							resetLevers = true
						end
					end

					if resetLevers == true then
						--[[ I will try to use a loop without using ipairs (source: https://sheepolution.com/learn/book/7)]]
						for i=4,#listOfLevers do
							listOfLevers[i].activatedLever = false
						end
						resetLevers = false
						roomFiveLeverCounter = 0
						roomFiveCorrectOrderLeverCounter = 0
					end
				end	-- End of Room 5's code
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
			love.graphics.draw(CAGE_IMAGE, VIRTUAL_WIDTH - (141 * 3) - 170, VIRTUAL_HEIGHT - 180)
		elseif currentRoom == 3 then
			love.graphics.draw(CAGE_IMAGE, VIRTUAL_WIDTH - (141 * 3) - 60, VIRTUAL_HEIGHT - 180)
		elseif currentRoom == 5 then
			love.graphics.draw(CAGE_IMAGE, VIRTUAL_WIDTH - (141 * 3) + 180, VIRTUAL_HEIGHT - 180)
		end
	end
end
