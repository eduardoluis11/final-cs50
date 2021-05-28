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
VIRTUAL_WIDTH = 800
VIRTUAL_HEIGHT = 600

--[[ BEGINNING OF COMMENT
	These two local variables will contain the sprites for the floor and the background (source: https://youtu.be/3IdOCxHGMIo)
END OF COMMENT --]]
local floor = love.graphics.newImage('graphics/floor_room_1.png')
local background = love.graphics.newImage('graphics/background_room_1.png')

-- Here’s the love.load() function, which will load the variables.
function love.load()
	--[[ This will give a name to the window that runs my game (source: https://youtu.be/3IdOCxHGMIo )  --]]
	love.window.setTitle('Final Project')
end

--[[ This will check if the user has pressed any keys on their keyboard (source: https://youtu.be/3IdOCxHGMIo) --]]
function love.keypressed(key)
	-- This will close the game if the user presses the escape key
	if key == 'escape' then
		love.event.quit()
	end
end

-- This is the function that renders everything onscreen.
function love.draw()
	--[[ This will render the background and the floor. Since the background will be rendered from top to bottom, I will 
    render it at the (0, 0) coordinates. 
	
    Meanwhile, since I want to render the floor at the bottom of the screen, I will help myself with the constant that stores 
    the height of Love2D’s screen size. Then, I will subtract the height of the floor sprite from the screen height (which 
    is 121 px). Source: https://youtu.be/3IdOCxHGMIo --]]
	love.graphics.draw(background, 0, 0)
	love.graphics.draw(floor, 0, VIRTUAL_HEIGHT - 121)
end
