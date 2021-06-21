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

VIRTUAL_WIDTH = 800
VIRTUAL_HEIGHT = 600

--[[ This global variable will store the current room where the player currently is. Temporarily, for debugging 
purposes, the current room will be Room 1. --]]
currentRoom = 1


--[[ BEGINNING OF COMMENT
	These two local variables will contain the sprites for the floor and the background (source: https://youtu.be/3IdOCxHGMIo)
END OF COMMENT --]]
-- I may DELETE this later, since the sprite will now be called from the Floor class.
-- local floor = love.graphics.newImage('graphics/floor_room_1.png')
local background = love.graphics.newImage('graphics/background_room_1.png')

-- This variable will call the player script
local player = Player()

-- This will store my floors
local floor = Floor()

-- This will call the platform script
local platform = Platform()

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

	--[[ This will update the Floor class. This MAY GIVE ME AN ERROR, since I’m not storing my floors on a 
	table, and I’m not rendering using “pairs” nor a “for” loop. 
	
	I HAVEN'T CREATED THE Floor:update() function yet--]]
	-- floor:update(dt)




	--[[ This will detect if there’s collision between the player and the floor. I will DELETE the debugging message later. 
	
	The playerCollision variable will keep track of whether or not the player hast touched the floor. 
	
	I will add a variable called “canJump”, which will prevent the player from jumping infinitely. That is, the player will 
	only be able to jump once they land on the floor (source: https://sheepolution.com/learn/book/24 ).--]]
	if player:collides(floor) then
		-- DEBUGGING MESSAGE. DELETE LATER
		-- print("There is collision")

		playerCollision = true
		player.canJump = true
		
		--[[ This will call the resolveCollision() function to check if the player touched the floor. If yes, the 
		player will go back to their previous position. (source: https://sheepolution.com/learn/book/23 )]]
		player:resolveCollision(floor)
	else
		playerCollision = false
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

	-- This will render the floor
	floor:render()

    --[[ This calls the variable where the Player class is being called, and it will render it into the game. --]]
	player:render()

	-- This will render the platforms
	platform:render()

end
