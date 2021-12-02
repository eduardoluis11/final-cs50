--[[ CS50's Introduction to Computer Science Final Project by Eduardo Salinas.

	This is a videogame made in Lua and Love2D. The game's currently called "Untitled Treasure Adventure 
	Game."

	Most of the code was written by Eduardo Salinas. The class.lua file and the sprites used are copyright of
	their respective owners. See the "references.txt" file to check this project's references, that is, to
	learn more about the sources cited for this project.

	Copyright (c) 2021 Eduardo Salinas.

	This time, I will be using class.lua to create the classes (source: 
    http://cdn.cs50.net/games/2018/spring/lectures/1/src1.zip  , 
    which comes from https://cs50.harvard.edu/games/2018/weeks/1/ )
	
    I will redo my code by using Colton Ogden’s 2018 GD50 Game Dev’s class from Harvard.
	
    I will start by using Fifty Bird as the basis for my code (source: https://youtu.be/3IdOCxHGMIo ).
	
    First, I will put the floor and the background. For this, first I need to create main.lua, and add the love.load(), 
    love.update(dt), and love.draw(dt) functions.
	
    And even before that, I want to add some constants in order to grab the resolution from Love2D’s game screen, which, 
    by default, is 800x600 pixels (source: 
    https://love2d.org/forums/viewtopic.php?t=8995#:~:text=Re%3A%20Default%20Screen%20Size&text=With%20no%20config%20file%20specifying,is%20the%201344x768%20widescreen%20variant. )
	
    So, my first 2 constants will be “VIRTUAL_WIDTH = 800” and “VIRTUAL_HEIGHT = 600”.
--]]
-- This will allow Lua to use classes
Class = require 'class'

-- Player’s script
require 'Player'

-- Floor’s script
require 'Floor'

-- Platform’s script
require 'Platform'

-- Chest’s script
require 'Chest'

-- Treasure’s script
require 'Treasure'

-- Script that contains the bubble UI
require 'TreasureList'

-- Lever’s script
require 'Lever'

-- Stalactite’s script
require 'Stalactite'

-- Door's script
require 'Door'

VIRTUAL_WIDTH = 800
VIRTUAL_HEIGHT = 600

--[[ This is a boolean variable that checks if the 5 chests have 
been opened. I will put it here since I don’t have a specific 
script for checking if the victory conditions are met. The boolean 
victory variable should start off as “false”. To update it from 
“false” to “true”, this would be best put into the update() 
function of main.lua. ]]
victoryState = false


--[[ This global variable will store the current room where the player currently is. Temporarily, for debugging 
purposes, the current room will be Room 1. --]]
currentRoom = 5

--[[ This is a variable that will tell the game whether to render the closed chest sprite or the opened one.

It would be better if this variable were located on chest.lua, so that not all treasure chests open at the same 
time if I open the 1st treasure chest. That is, each instance of the chest will have their own associated “closedChest” 
variable. ]]
-- closedChest = true

--[[ This variable will check if the user is touching the treasure chests, so that they will be able to open 
the chest only if they are touching them. ]]
--canOpenChest = false

--[[ This variable will tell a timer when to start running and when to stop. I will use the timer to make a treasure 
disappear after a few seconds of spawning on top of a chest after opening the chest. ]]
timerOn = false


--[[ BEGINNING OF COMMENT
	These two local variables will contain the sprites for the floor and the background (source: https://youtu.be/3IdOCxHGMIo)
END OF COMMENT --]]
-- I may DELETE this later, since the sprite will now be called from the Floor class.
-- local floor = love.graphics.newImage('graphics/floor_room_1.png')
local background = love.graphics.newImage('graphics/background_room_1.png')

-- This variable will call the player script
local player = Player()

-- These variables will store my floors
local floor1 = Floor(0, -80 + VIRTUAL_HEIGHT)

local room3_leftFloor = Floor(-460, -80 + VIRTUAL_HEIGHT)
local room3_rightFloor = Floor(620, -80 + VIRTUAL_HEIGHT)

--[[ This will call each instance of the platform script. I will assign its x and y coordinates to specify the 
position of each platform I create. 

For platform1, I will make it the tallest and furthermost platform. Since it’s width is of 211 px, I will subtract 
211 to the width of the screen to locate it to the furthest part of the screen in the x axis.

For the y axis, I need to subtract the height of the platform sprite nd of the floor sprite (121) from the 
height of the screen.

Now, it's 600 px tall (as tall as the screen size.) So, I will manually adjust the height until I get the desired
height.

I want to show the tresure inside of the chest on the highest platform. So, I won't make the platform too tall.

I use the “* 2” multiplier so that platforms 1 and 2 are touching each other horizontally.]]
local platform1 = Platform(VIRTUAL_WIDTH - 141, VIRTUAL_HEIGHT - 430)

local platform2 = Platform(VIRTUAL_WIDTH - (141 * 2) - 20, VIRTUAL_HEIGHT - 350)
local platform3 = Platform(VIRTUAL_WIDTH - (141 * 3) - 40, VIRTUAL_HEIGHT - 270)

--[[ This will create each instance of the chests. I need to specify their x and y coordinates in here as parameters. ]]
local chest1 = Chest(VIRTUAL_WIDTH - 120, VIRTUAL_HEIGHT - 490)
local chest2 = Chest(VIRTUAL_WIDTH - (141 * 3) - 150, -80 + VIRTUAL_HEIGHT - 62)
local chest3 = Chest(VIRTUAL_WIDTH - (141 * 3) - 150, -80 + VIRTUAL_HEIGHT - 62)
local chest4 = Chest(VIRTUAL_WIDTH - 120, VIRTUAL_HEIGHT - 490)
local chest5 = Chest(VIRTUAL_WIDTH - 120, VIRTUAL_HEIGHT - 490)

--[[ I will call the instances of the treasures here rather than on chest.lua. I will have to repeat the x and y 
coordinates of the chest for their corresponding treasures, but, right now, I don’t know a more efficient way of doing this.

In the treasure.lua script, I’m already subtracting a number of pixels to the y coordinate to put the treasure above its 
respective chest, so I don’t need to modify the y coordinate in here. ]]
local treasure1 = Treasure(VIRTUAL_WIDTH - 120, VIRTUAL_HEIGHT - 490)
local treasure2 = Treasure(VIRTUAL_WIDTH - (141 * 3) - 150, -80 + VIRTUAL_HEIGHT - 62)
local treasure3 = Treasure(VIRTUAL_WIDTH - (141 * 3) - 150, -80 + VIRTUAL_HEIGHT - 62)
local treasure4 = Treasure(VIRTUAL_WIDTH - 120, VIRTUAL_HEIGHT - 490)
local treasure5 = Treasure(VIRTUAL_WIDTH - 120, VIRTUAL_HEIGHT - 490)

--[[ This will create the levers by calling the lever{} class ]]
local leverRoom_2 = Lever(VIRTUAL_WIDTH - (141 * 3) + 270, -80 + VIRTUAL_HEIGHT - 90, 'regular')
local leverRoom_3 = Lever(VIRTUAL_WIDTH - (141 * 3) + 350, -80 + VIRTUAL_HEIGHT - 90, 'regular')
local leverRoom_4 = Lever(110, -80 + VIRTUAL_HEIGHT - 90, 'regular')

--[[ These are Room 5's four levers ]]
local leverRoom_5_1 = Lever(120, -80 + VIRTUAL_HEIGHT - 90, 'armor')
local leverRoom_5_2 = Lever(200, -80 + VIRTUAL_HEIGHT - 90, 'ring')
local leverRoom_5_3 = Lever(280, -80 + VIRTUAL_HEIGHT - 90, 'gold')
local leverRoom_5_4 = Lever(360, -80 + VIRTUAL_HEIGHT - 90, 'ruby')

--[[ This will create the stalactites. ]]
local stalactiteRoom_3 = Stalactite(475, 0)
local stalactiteRoom_4 = Stalactite(550, 0)
local stalactiteRoom_5 = Stalactite(550, 0)

--[[ This will render the bubble UI that contains the treasure icons ]]
local treasure_list = TreasureList()

--[[ Next, I would have to create each of the 6 instances of the door class ]]
local door1 = Door(100, -80 + VIRTUAL_HEIGHT - 110, 1)
local door2 = Door(200, -80 + VIRTUAL_HEIGHT - 110, 2)
local door3 = Door(300, -80 + VIRTUAL_HEIGHT - 110, 3)
local door4 = Door(400, -80 + VIRTUAL_HEIGHT - 110, 4)
local door5 = Door(500, -80 + VIRTUAL_HEIGHT - 110, 5)
local hubDoor = Door(0, -80 + VIRTUAL_HEIGHT - 110, 0)

--[[ I will create a table where I will store every sprite or object that’s not the player. This will be called in a 
“for” loop so that I can check collision for the floor and all of the platforms (so that I can reuse the collides() 
and resolveCollision() functions efficiently) (source: https://sheepolution.com/learn/book/23 .) 

Remember to insert each instance of the floor in here to prevent the player from falling through the floor.

I will add the stalactite so that the player is able to jump on top of them and use them as a platform.

"objects" will be the table with the platforms for Room 1.

Each room will have its own table with its own platforms and stalactites. This way, there won't be invisible
platforms on rooms that shouldn't have platforms (so the player won't float in the air.)
]]
objects = {}	-- This creates Room 1's table
table.insert(objects, floor1)	-- This inserts the floor into Room 1's table
table.insert(objects, platform1)
table.insert(objects, platform2)
table.insert(objects, platform3)
-- table.insert(objects, stalactiteRoom_3)

roomTwosCollisionTable = {}	-- Room 2's table
table.insert(roomTwosCollisionTable, floor1)	

roomThreesCollisionTable = {}	-- Room 3's table
table.insert(roomThreesCollisionTable, room3_leftFloor)
table.insert(roomThreesCollisionTable, room3_rightFloor)
table.insert(roomThreesCollisionTable, stalactiteRoom_3)

roomFoursCollisionTable = {}	-- Room 4's table
table.insert(roomFoursCollisionTable, floor1)
table.insert(roomFoursCollisionTable, platform1)
table.insert(roomFoursCollisionTable, stalactiteRoom_4)

roomFivesCollisionTable = {}	-- Room 5's table
table.insert(roomFivesCollisionTable, floor1)
table.insert(roomFivesCollisionTable, platform1)
table.insert(roomFivesCollisionTable, stalactiteRoom_5)

HubsCollisionTable = {}	-- Hub's table
table.insert(HubsCollisionTable, floor1)



-- Here’s the love.load() function, which will load the variables.
function love.load()
	--[[ This table will store all of the game's 7 levers ]]
	listOfLevers = {}

	--[[ I will insert all 7 levers into the "listOfLevers" table here in the load() function. Otherwise, 
	I will get an error saying that I'm isnerting "nil" into the listOfLevers{} table, and the game won't run. ]]
	table.insert(listOfLevers, leverRoom_2)
	table.insert(listOfLevers, leverRoom_3)
	table.insert(listOfLevers, leverRoom_4)
	table.insert(listOfLevers, leverRoom_5_1)
	table.insert(listOfLevers, leverRoom_5_2)
	table.insert(listOfLevers, leverRoom_5_3)
	table.insert(listOfLevers, leverRoom_5_4)

	--[[ This will give a name to the window that runs my game (source: https://youtu.be/3IdOCxHGMIo )  --]]
	love.window.setTitle('Final Project')

	--[[ Now that the console is finally printing the victory message after finding all of 
	the treasure, I need to actually print in-game the message.

    The victory message will be “Congrats! You have found all of the treasure in the 
	castle!”, “Press Esc to exit the game”.

    If the default font in Love is hard to read on any of the Rooms’ background, I will 
	have to add and render a background that contrasts with the default font’s color to 
	make the text easy to read.

    To render the text in-game, I’ll have to add a code snippet in the draw() function in 
	main.lua. Also, if I want 
	to insert the text in variables, I should ideally put those variables in the load() 
	function in main.lua.

	If I want to store the 2 lines of text into variables, I would need to first insert 
	them into main.lua’s load() function (source: https://sheepolution.com/learn/book/7 )
		
		I want the "Congrats!" message to be divided into two lines. So, I will separate
	that initial message into two variables, and I will manually specify the position
	of the 2nd half of the message so that it appears right below the 1st half of it. 
	]]
	-- These variables will store the custom font sizes 
    largeFontSize = love.graphics.newFont(24)
	smallFontSize = love.graphics.newFont(20)

	congratsMessagePart1FirstHalf = "Congrats! You have found all of the"
	congratsMessagePart1SecondHalf = "treasure in the castle!"
    congratsMessagePart2 = "Press Esc to exit the game."

	--[[ These variables contain the game's controls and the game's objective. ]]
	controlsTitleText = "Controls:"
	controlsTextFirstLine = "Left and right arrows: Move around."
	controlsTextSecondLine = "Space: Jump."
	controlsTextThirdLine = "E: Enter through a door, open chest,"
	controlsTextFourthLine = "activate lever."
	controlsTextFifthLine = "Esc: Exit game."

	--[[ This will prevent the screen from becoming black once the victory message 
	renders (source: https://sheepolution.com/learn/book/12) ]]
	love.graphics.setBackgroundColor(1, 1, 1)

    -- This table will detect all of my previous inputs from the keyboard
	love.keyboard.keysPressed = {}
end



--[[ This will check if the user has pressed any keys on their keyboard (source: https://youtu.be/3IdOCxHGMIo) --]]
function love.keypressed(key)
    --[[ This will keep track of all of my previous keystrokes on the keysPressed table --]]
	love.keyboard.keysPressed[key] = true

	-- This will close the game if the user presses the escape key
	if key == 'escape' then
		love.event.quit()
	end
end

function love.keyboard.wasPressed(key)
	--[[ This is a debugging function that will return true each time that the user presses a key on their keyboard --]]
	if love.keyboard.keysPressed[key] then
		return true
	else
		return false
	end
end

--[[ This is the love.update() function, which will make changes on the “backend” of the game. That is, if I change sprites 
or the rooms, I need ot first call this function, and then I will render it with love.draw().

I use dt so that, if 2 computers can run the game at 60 FPS, that both computers can make the player run at 200 px/s horizontally. 
That is, a faster computer won’t make the player run at 600 px/s. 

BUG FIX: I put the line "dt = math.min(dt, 0.07)" at the top of the update() function to fix a bug which made the 
player character's sprite to disappear if I dragged the game's Window on PCs. What this does is that the game 
will only be updated if the game's running at above 15 FPS. If it pauses (such as when the user drags the game's
window,) the game will stop updating, preventing the player's sprite to disappear  (source: Jasoco's reply on 
https://love2d.org/forums/viewtopic.php?t=8740)
--]]
function love.update(dt)
	dt = math.min(dt, 0.07)
	--[[ This will update any changes on the player’s script (before rendering them into player:render().) --]]
	player:update(dt)

	--[[ This will update the treasure so that it appears for only a few seconds after opening a chest, and then
	disappears.]]
	treasure1:update(dt)
	treasure2:update(dt)
	treasure3:update(dt)
	treasure4:update(dt)
	treasure5:update(dt)

	--[[ This will update the Floor class. This MAY GIVE ME AN ERROR, since I’m not storing my floors on a 
	table, and I’m not rendering using “pairs” nor a “for” loop. 
	
	I HAVEN'T CREATED THE Floor:update() function yet--]]
	-- floor:update(dt)

	--[[ This will detect if there’s collision between the player and the floor. I will DELETE the debugging message later. 
	
	The playerCollision variable will keep track of whether or not the player hast touched the floor. 
	
	I will add a variable called “canJump”, which will prevent the player from jumping infinitely. That is, the player will 
	only be able to jump once they land on the floor (source: https://sheepolution.com/learn/book/24 ).
	
	Now, since I also want the platforms to have the same collision detection as the floor, I will use a generic 
	variable (“e”) instead of “floor” in both collides() and in resolveCollision().
	
	I will use a “for” loop for both the resolveCollision() and the collides() function. This way, I will be able to use 
	a generic variable to check if the player is colliding against any object (like the floor or any of the platforms) 
	instead of manually checking collision for the floor and every platform separately (source: 
	https://sheepolution.com/learn/book/23 .)
	
	Since I can only use (key, value) pairs for “for” loops in Lua (as far as I’m aware), I need to specify where does 
	the loop begin and where does it end. So, I will begin at 1, and end it at the last object (source: 
	https://sheepolution.com/learn/book/23 .)
	
	To make it so that the collision detection for the platforms and floors only work for the floors and platforms 
	of their respective rooms, I will only detect for collision detection for each specific room. Also, each room
	will have their own table with the platforms and floors for that specific room. Then, I will execute the 
	"for" loop for the table of each specific room.

	For the time being, "objects" is the table with the platforms for Room 1. The rest of the rooms will have 
	more intuitive names.
	--]]
	if currentRoom == 1 then	-- Room 1's collision check
		for i=1,#objects do
			if player:collides(objects[i]) then
				-- DEBUGGING MESSAGE. DELETE LATER
				-- print("There is collision")

				playerCollision = true
				player.canJump = true
				
				--[[ This will call the resolveCollision() function to check if the player touched the floor. If yes, the 
				player will go back to their previous position. (source: https://sheepolution.com/learn/book/23 )]]
				player:resolveCollision(objects[i])
			else
				playerCollision = false
			end
		end -- End of Room 1's "for" loop
	end

	if currentRoom == 2 then	-- Room 2's collision check
		for i=1,#roomTwosCollisionTable do
			if player:collides(roomTwosCollisionTable[i]) then
				playerCollision = true
				player.canJump = true
				
				player:resolveCollision(roomTwosCollisionTable[i])
			else
				playerCollision = false
			end
		end -- End of Room 2's "for" loop
	end

	if currentRoom == 3 then -- Room 3's collision check
		for i=1,#roomThreesCollisionTable do
			if player:collides(roomThreesCollisionTable[i]) then
				playerCollision = true
				player.canJump = true
				
				player:resolveCollision(roomThreesCollisionTable[i])
			else
				playerCollision = false
			end
		end -- End of Room 3's "for" loop
	end

	if currentRoom == 4 then
		for i=1,#roomFoursCollisionTable do
			if player:collides(roomFoursCollisionTable[i]) then
				playerCollision = true
				player.canJump = true
			
				player:resolveCollision(roomFoursCollisionTable[i])
			else
				playerCollision = false
			end
		end -- End of Room 4's "for" loop
	end

	if currentRoom == 5 then
		for i=1,#roomFivesCollisionTable do
			if player:collides(roomFivesCollisionTable[i]) then
				playerCollision = true
				player.canJump = true
				player:resolveCollision(roomFivesCollisionTable[i])
			else
				playerCollision = false
			end
		end -- End of Room 5's "for" loop
	end

	-- This detects collision for the main hub
	if currentRoom == 0 then
		for i=1,#HubsCollisionTable do
			if player:collides(HubsCollisionTable[i]) then
				playerCollision = true
				player.canJump = true
				player:resolveCollision(HubsCollisionTable[i])
			else
				playerCollision = false
			end
		end -- End of the hub's "for" loop
	end

	--[[ This will check if the user is touching a treasure chest.
	
	It seems that I will have to call this function 5 times (one for each instance of the Chest{} class.)
		
	Or I could to a separate table (something like chestList{}), and then I would use a "for" loop to see
	if I'm touching any of the 5 chests without needing to call this function 5 times.
		
	I'm now inserting the update() function for the chests inside the player:collides() function since chests
	will (for the time being) only be updated once the player touches them. That is, they will change from closed 
	to opened only of the user touches them (and also presses "E"). 
	
	I will send a "true" value to the chest:render() function to indicate the chest.lua script that the player is touching
	the chest. So, if the player touches "E" right now, the chest should be opened.
	
	I will specify that, in order to be able to open a chest (by updating it), I need to be in that chest's respective
	room (as well as be colliding with that chest). THIS FIXED THE BUG THAT ALLOWED ME TO OPEN ALL CHESTS IN A SINGLE
	ROOM.
	]]
	if currentRoom == 1 and player:collides(chest1) then
		chest1:update(true)
		-- canOpenChest = true
	else
		chest1:update(false)
	end
	
	if currentRoom == 2 and player:collides(chest2) then
		chest2:update(true)
	else
		chest2:update(false)
	end
	if currentRoom == 3 and player:collides(chest3) then
		chest3:update(true)
	else
		chest3:update(false)
	end
	if currentRoom == 4 and player:collides(chest4) then
		chest4:update(true)
	else
		chest4:update(false)
	end
	if currentRoom == 5 and player:collides(chest5) then
		chest5:update(true)
	else
		chest5:update(false)
	end

	--[[ This will check if the player is touching a lever. If they do, the player will be able to activate the lever 
	by pressing E.
	
	I will add the extra condition that the player needs to be in a specific room to make a specific lever appear 
	(for instance, the lever for room 2 will only render in room 2.)]]
	if currentRoom == 2 and player:collides(leverRoom_2) then
		leverRoom_2:update(true)
	else
		leverRoom_2:update(false)
	end

	if currentRoom == 3 and player:collides(leverRoom_3) then
		leverRoom_3:update(true)
	else
		leverRoom_3:update(false)
	end
	if currentRoom == 4 and player:collides(leverRoom_4) then
		leverRoom_4:update(true)
	else
		leverRoom_4:update(false)
	end

	--[[ This will check the player has pulled any of room 5's levers ]]
	if currentRoom == 5 and player:collides(leverRoom_5_1) then
		leverRoom_5_1:update(true)
	else
		leverRoom_5_1:update(false)
	end
	if currentRoom == 5 and player:collides(leverRoom_5_2) then
		leverRoom_5_2:update(true)
	else
		leverRoom_5_2:update(false)
	end
	if currentRoom == 5 and player:collides(leverRoom_5_3) then
		leverRoom_5_3:update(true)
	else
		leverRoom_5_3:update(false)
	end
	if currentRoom == 5 and player:collides(leverRoom_5_4) then
		leverRoom_5_4:update(true)
	else
		leverRoom_5_4:update(false)
	end

	--[[ This will make the stalactites fall and respawn after they fall to the bottom of the screen. This should ideally 
	only be executed if I’m on Room 3 or 5 (where the stalactites should be.)
	
	To fix a bug, I will make it so that the stalactites are ALWAYS being updated. This way, I will be able to make
	the stalatite render offscreen (or to the lower left corner of the screen) so that the player isn't able
	to jump on top of the stalactite in rooms where the stalactite isn't supposed to be rendered. 
	
	I will check the current room where I'm located in the stalactite script, NOT here in main.lua.
	
	I will stop updating Room 5's stalatite once the player finds all of the treasures since the
	animation of the stalactite is too distracting. ]]
	if currentRoom == 3 and victoryState == false then
		stalactiteRoom_3:update(dt)

	elseif currentRoom == 4 and victoryState == false then
		stalactiteRoom_4:update(dt)

	elseif currentRoom == 5 and victoryState == false then
		stalactiteRoom_5:update(dt)
	end

	--[[ Next, I would have to insert this code to update the door class script. 
	Here, I would check for collisions between the player and the doors. If the 
	player touches any of the door sprites, I will send a true or false value to 
	Door.lua. Otherwise, it would tell Door.lua that there’s no collision.
	]]
	if currentRoom == 0 then
		if player:collides(door1) then 
				door1:update(true)
		else
			door1:update(false)
		end
		
		if player:collides(door2) then 
				door2:update(true)
		else
			door2:update(false)
		end

		if player:collides(door3) then 
			door3:update(true)
		else
			door3:update(false)
		end

		if player:collides(door4) then 
			door4:update(true)
		else
			door4:update(false)
		end

		if player:collides(door5) then 
			door5:update(true)
		else
			door5:update(false)
		end
			
	else
		if player:collides(hubDoor) then 
			hubDoor:update(true)
		else
			hubDoor:update(false)
		end
	end

	--[[ Now, this will check if the 5 chests have been opened. 
	If it does, I will change the victory state to “true”. This 
	will go in the update() function of main.lua.  ]]
	if treasureCounter == 5 then
		victoryState = true
	end

	--[[ This is a DEBUGGING message that tells me if the 
	player has obtained all of the game's treasure. To show the 
	text that congratulates the player for finding all of the 
	game’s treasure, I will first print the victory message on 
	Love’s console after opening all 5 chests. After that, I will 
	print the text in the game itself. ]]
	if victoryState == true then
		print("Victory!")
	end		
	
    --[[ This will reset the table that keeps track of all of the keys pressed by the user on their keyboard, 
    so that it becomes empty. --]]
	love.keyboard.keysPressed = {}
end


-- This is the function that renders everything onscreen.
function love.draw()
	--[[ This will render the background and the floor. Since the background will be rendered from top to bottom, I will 
    render it at the (0, 0) coordinates. 
	
    Meanwhile, since I want to render the floor at the bottom of the screen, I will help myself with the constant that stores 
    the height of Love2D’s screen size. Then, I will subtract the height of the floor sprite from the screen height (which 
    is 121 px). Source: https://youtu.be/3IdOCxHGMIo 
	
	I MAY DELETE THIS for the floor, since I will be using a class for the floor. --]]
	love.graphics.draw(background, 0, 0)
	-- love.graphics.draw(floor, 0, VIRTUAL_HEIGHT - 121)

	--[[ This will render the platforms and the floors. I will render them 1st so that they are in a layer behind the player and the 
	floor sprite. I will render each platform on their respective room. ]]
	if currentRoom == 1 then
		platform1:render()
		platform2:render()
		platform3:render()

	elseif currentRoom == 4 or currentRoom == 5 then
		platform1:render()
	end

	-- This will render all of the floors
	if currentRoom ~= 3 then	-- For all rooms except room 3
		floor1:render()

	else	-- For room 3
		room3_leftFloor:render()
		room3_rightFloor:render()
	end



	--[[ This will render the levers and the chests. Only rooms 2, 3, 4 and 5 have levers. Each one of those rooms 
	should have their own levers. 
	
	I rendered the chests first so that they are on a layer below the cage if the 
	chest is locked. This happens because the cages are being rendered by the Lever() class. So, the levers
	should be rendered AFTER the chests so that the chests are on a layer behind the levers and theri respective 
	cages. ]]
	if currentRoom == 1 then
		chest1:render()

	elseif currentRoom == 2 then
		chest2:render()
		leverRoom_2:render()

	elseif currentRoom == 3 then
		chest3:render()
		leverRoom_3:render()

	elseif currentRoom == 4 then
		chest4:render()
		leverRoom_4:render()

	elseif currentRoom == 5 then
		chest5:render()
		leverRoom_5_1:render()
		leverRoom_5_2:render()
		leverRoom_5_3:render()
		leverRoom_5_4:render()		
	end
	

	--[[ This will render the bubble UI for the treasure icons. I need to render this on a layer behind the treasure sprites
	from treasure.lua. ]]
	treasure_list:render()

	--[[ This will render the treasures. 
	
	I need to specify the room number with an "if" statement so that each treasure only renders in its corresponding
	room. Or in other words, that if I open a chest in a room, the treasure won't render on top of all 5 chests at the 
	same time. ]]
	if currentRoom == 1 then
		treasure1:render()
	elseif currentRoom == 2 then
		treasure2:render()
	elseif currentRoom == 3 then
		treasure3:render()
		--[[ This renders the stalactites ]]
		stalactiteRoom_3:render()
	elseif currentRoom == 4 then
		treasure4:render()
		stalactiteRoom_4:render()
	elseif currentRoom == 5 then
		treasure5:render()
		stalactiteRoom_5:render()
	else
		treasure1:render()
		treasure2:render()
		treasure3:render()
		treasure4:render()
		treasure5:render()	
	end

	--[[ This will render all doors.
	
	If the user is at the hub, 5 doors will render. Meanwhile, if the user is at any treasure room, 
	only the exit door will be avialable, that is, only the door towards the hub will be visible. ]]
	if currentRoom == 0 then
		door1:render()
		door2:render()
		door3:render()
		door4:render()
		door5:render()
	else
		hubDoor:render()
	end
	
    --[[ This calls the variable where the Player class is being called, and it will render it into the game. --]]
	player:render()

	--[[ This will print the game's controls and the game's objective in the main hub. ]]
	if currentRoom == 0 then
		love.graphics.setColor(229/255, 211/255, 211/255) -- Rectangle’s color

        love.graphics.rectangle("fill", -50 + VIRTUAL_WIDTH / 4, VIRTUAL_HEIGHT / 4, 500, 200) -- Draws rectangle

		--[[ Sets color to black. This caused a bug that made msot of the screen to go black, with the exception
		of the background rectangle, so I commented it out. I fixed the bug by setting the color back to
		(1, 1, 1) at the end of the draw() function. ]]
        love.graphics.setColor(0, 0, 0) 

        -- Prints text
		love.graphics.setFont(largeFontSize)
		love.graphics.print(controlsTitleText, -15 + VIRTUAL_WIDTH / 4, 30 + VIRTUAL_HEIGHT / 4)
		love.graphics.setFont(smallFontSize) 
		love.graphics.print(controlsTextFirstLine, -15 + VIRTUAL_WIDTH / 4, 45 + 100 + VIRTUAL_HEIGHT / 4) 

		-- Prevents the screen from becoming black or having a pinkish tint.
		love.graphics.setColor(1, 1, 1)
	end

	--[[ This will print the victory message once the player opens the five chests (source: 
	https://love2d.org/wiki/love.graphics.setFont).
	
	I will add a rectangle that will serve as a background to the victory message text so that the text is easier 
	to read. The text will be black and the rectangle will be of a skin / pinkish color. The color of the rectangle 
	will be of e5d3d3 in hex or (229, 211, 211) in RGB. I need to use the RGB values since that’s how Love displays 
	colors.

    First, I will set the color for the rectangle. I need to divide each number of each RGB value by 255 (source: 
	https://sheepolution.com/learn/book/12 ).

	Next, I will draw a rectangle (source: https://sheepolution.com/learn/book/5 ).

	Then, I will set the color to black, which will serve as the font’s color.

	Finally, I will print the text.

	I needed to make some changes to my code snippet for specifying the font size since 
	it would eat up too much memory after a while. I need to insert the font size (be it 
	20 or 24, or large or small) into a variable in main.lua’s load() function, NOT in 
	the draw() function (or the memory consumption bug would occur) (source: 
	https://love2d.org/wiki/love.graphics.setFont ). Then, I would call that 
	variable in the draw() function using setFont to change the font size.

		The parameters of the function that draws the rectangle are x, y, width, and height (source: 
	https://love2d.org/wiki/love.graphics.rectangle .)
	]]
	if victoryState == true then
		love.graphics.setColor(229/255, 211/255, 211/255) -- Rectangle’s color

        love.graphics.rectangle("fill", -50 + VIRTUAL_WIDTH / 4, VIRTUAL_HEIGHT / 4, 500, 200) -- Draws rectangle

		--[[ Sets color to black. This caused a bug that made msot of the screen to go black, with the exception
		of the background rectangle, so I commented it out. I fixed the bug by setting the color back to
		(1, 1, 1) at the end of the draw() function. ]]
        love.graphics.setColor(0, 0, 0) 

        -- Prints text
		love.graphics.setFont(largeFontSize)
		love.graphics.print(congratsMessagePart1FirstHalf, -15 + VIRTUAL_WIDTH / 4, 30 + VIRTUAL_HEIGHT / 4)
		love.graphics.print(congratsMessagePart1SecondHalf, -15 + VIRTUAL_WIDTH / 4, 30 + 30 + VIRTUAL_HEIGHT / 4)
		love.graphics.setFont(smallFontSize) 
		love.graphics.print(congratsMessagePart2, -15 + VIRTUAL_WIDTH / 4, 45 + 100 + VIRTUAL_HEIGHT / 4) 

		-- Prevents the screen from becoming black or having a pinkish tint.
		love.graphics.setColor(1, 1, 1)
	end
end
