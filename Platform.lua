--[[ This class will create some additional platforms and obstacles for every room in the dungeon. 
It will work more or less like the Floor class. ]]

Platform = Class{}

--[[ For debugging purposes, I will first use a single image to render the 3 platforms in the 1st room. I will LATER 
CHANGE this by reusing a single image 3 times in the 1st room to make my code more efficient.

Now, I will use the real base sprite for all of the platforms (1 image with 1 platform sprite.)

I will first only render the top part of the platforms, since they are the sprites which will have collision detection.
The bottom part will be used only for decoration.
--]]
local PLATFORM_IMAGE = love.graphics.newImage('graphics/platform-top.png')

--[[ This will have the initial properties of the platforms.

The x coordinate will change depending on the room, since some rooms will have 3 platforms, while others will have only 1.  
The height will vary (since some platforms will be taller than others,) but the y coordinate will always be the same, since 
all of the platforms will touch the floor at the same height in all of the rooms.

For the y coordinate, I will subtract the height of the floor times 2 to try to get the platforms on top of the floor 
(121 px * 2 = 242 px.) 

However, due to the way that I edited the image with the 3 sprites in Photoshop, the height of the image for room 1 
is 600px. Therefore, if I put “-600 + Virtual Height”, the platforms will render perfectly on top of the floor.

Now I’m using the real platform sprite, which is 150x150 px in size. Here in the init() function, I will be able to modify 
the size of the sprite. 

However, since I will use 3 different sizes, I will have to specify later the size of each platform that I want to spawn 
by inserting parameters from the main.lua file.

I will specify between the parentheses of the init() function the height and the width of the platform, which will be 
taken from each time I instantiate a platform from main.lua.

Self.y and self.x will take the value taken from the x and y coordinates that I specify at main.lua from each time 
that I instantiate a platform.--]]
function Platform:init(platform_width, platform_height)
	self.y = platform_height

	--[[ I will add 3 platforms in the 1st room. I need to find out how to change the size of the platforms within the same 
    room and in an efficient way. 
    
    I need to put a value for self.x, or I’ll get an error when trying to render the sprite in the Platform:render() function.
    
    For the image with the 3 platform sprites, the platforms render perfectly in plce at self.x = 0 px.  
	
	I will get rid of this code, since I need to get the platform's positions from parameters taken from main.lua, 
	NOT from putting the room number. Besides, I think this is causing me the bug where the whole game crashes 
	if I start at any room other than Room 1.--]]
	self.x = platform_width
	self.width = PLATFORM_IMAGE:getWidth()
	self.height = PLATFORM_IMAGE:getHeight()
end

--[[ I will add the update() function later to make the platforms scroll horizontally if the user moves past the 
screen (in large enough rooms). --]]

--[[ This will render the floor sprite each time that I call this on main.lua. --]]
function Platform:render()
	love.graphics.draw(PLATFORM_IMAGE, self.x, self.y)
end
