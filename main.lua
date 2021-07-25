--[[ BEGINNING OF COMMENT
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

END OF COMMENT --]]
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

VIRTUAL_WIDTH = 800
VIRTUAL_HEIGHT = 600

--[[ This global variable will store the current room where the player currently is. Temporarily, for debugging 
purposes, the current room will be Room 1. --]]
currentRoom = 3

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

-- This will store my floors
local floor1 = Floor(0, -80 + VIRTUAL_HEIGHT)

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
local chest2 = Chest(VIRTUAL_WIDTH - (141 * 3) - 40, VIRTUAL_HEIGHT - 330)
local chest3 = Chest(VIRTUAL_WIDTH - (141 * 3) - 40, -80 + VIRTUAL_HEIGHT - 62)
local chest4 = Chest(VIRTUAL_WIDTH - (141 * 3) + 90, -80 + VIRTUAL_HEIGHT - 62)
local chest5 = Chest(VIRTUAL_WIDTH - (141 * 3) + 200, -80 + VIRTUAL_HEIGHT - 62)

--[[ I will call the instances of the treasures here rather than on chest.lua. I will have to repeat the x and y 
coordinates of the chest for their corresponding treasures, but, right now, I don’t know a more efficient way of doing this.

In the treasure.lua script, I’m already subtracting a number of pixels to the y coordinate to put the treasure above its 
respective chest, so I don’t need to modify the y coordinate in here. ]]
local treasure1 = Treasure(VIRTUAL_WIDTH - 120, VIRTUAL_HEIGHT - 490)
local treasure2 = Treasure(VIRTUAL_WIDTH - (141 * 3) - 40, VIRTUAL_HEIGHT - 330)
local treasure3 = Treasure(VIRTUAL_WIDTH - (141 * 3) - 40, -80 + VIRTUAL_HEIGHT - 62)
local treasure4 = Treasure(VIRTUAL_WIDTH - (141 * 3) + 90, -80 + VIRTUAL_HEIGHT - 62)
local treasure5 = Treasure(VIRTUAL_WIDTH - (141 * 3) + 200, -80 + VIRTUAL_HEIGHT - 62)

--[[ This will create the levers by calling the lever{} class ]]
local leverRoom_2 = Lever(100, -80 + VIRTUAL_HEIGHT - 90)
local leverRoom_3 = Lever(110, -80 + VIRTUAL_HEIGHT - 90)
local leverRoom_5_1 = Lever(120, -80 + VIRTUAL_HEIGHT - 90)

--[[ This will create the stalactites. ]]
local stalactiteRoom_3 = Stalactite(200, -80 + VIRTUAL_HEIGHT - 90)

--[[ This will render the bubble UI that contains the treasure icons ]]
local treasure_list = TreasureList()

--[[ I will create a table where I will store every sprite or object that’s not the player. This will be called in a 
“for” loop so that I can check collision for the floor and all of the platforms (so that I can reuse the collides() 
and resolveCollision() functions efficiently) (source: https://sheepolution.com/learn/book/23 .) 

Remember to insert each instance of the floor in here to prevent the player from falling through the floor.

I will add the stalactite so that the player is able to jump on top of them and use them as a platform.
]]
objects = {}
table.insert(objects, floor1)
table.insert(objects, platform1)
table.insert(objects, platform2)
table.insert(objects, platform3)
table.insert(objects, stalactiteRoom_3)


-- Here’s the love.load() function, which will load the variables.
function love.load()
	--[[ This will give a name to the window that runs my game (source: https://youtu.be/3IdOCxHGMIo )  --]]
	love.window.setTitle('Final Project')

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
That is, a faster computer won’t make the player run at 600 px/s. --]]
function love.update(dt)
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
	https://sheepolution.com/learn/book/23 .)--]]
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
	end -- End of "for" loop

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
	if currentRoom == 5 and player:collides(leverRoom_5_1) then
		leverRoom_5_1:update(true)
	else
		leverRoom_5_1:update(false)
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

	--[[ This will render the platforms. I will render them 1st so that they are in a layer behind the player and the 
	floor sprite. ]]
	platform1:render()
	platform2:render()
	platform3:render()

	-- This will render the floor
	floor1:render()

	-- This will render the chests
	chest1:render()
	chest2:render()
	chest3:render()
	chest4:render()
	chest5:render()

	--[[ This will render the levers. Only rooms 2, 3, and 5 have levers. Each one of those rooms should have their own lever. ]]
	if currentRoom == 2 then
		leverRoom_2:render()
	elseif currentRoom == 3 then
		leverRoom_3:render()
	elseif currentRoom == 5 then
		leverRoom_5_1:render()		
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
	elseif currentRoom == 4 then
		treasure4:render()
	elseif currentRoom == 5 then
		treasure5:render()
	else
		treasure1:render()
		treasure2:render()
		treasure3:render()
		treasure4:render()
		treasure5:render()	
	end
	
	--[[ This renders the stalactites ]]
	stalactiteRoom_3:render()

    --[[ This calls the variable where the Player class is being called, and it will render it into the game. --]]
	player:render()

end
