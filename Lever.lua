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
]]
function Lever:init(lever_x, lever_y)
	self.width = DEACTIVATED_LEVER_IMAGE:getWidth()
	self.height = DEACTIVATED_LEVER_IMAGE:getHeight()

	self.x = lever_x
    self.y = lever_y 

	self.activatedLever = false
end

--[[ The update() function will make the lever change from being deactivated to being activated. To do so, update() will make
the user activate a lever by pressing the “E” key.

It will accept a parameter from main.lua that should have the value "true". If this function receives that value, it means that 
the player is touching a lever, and that, if they press the "E" key, the lever should become activated.

I will modify the "self." variable that keeps track of whether the lever is activated or not so that only the current instance 
of the lever will be activated in the Lever:render() function (that is, so that the rest of the levers remain deactivated if 
I only activate 1 lever.)

The parameter inside of lever:update() tells me if the player is touching the lever.
--]]
function Lever:update(isTouchingLever)
	if love.keyboard.wasPressed('e') then
		if isTouchingLever == true then
			if self.activatedLever == false then
			    self.activatedLever = true
		    end
		end
	end
end

--[[ This will render the lever sprite. ]]
function Lever:render()
	if self.activatedLever == false then
		love.graphics.draw(DEACTIVATED_LEVER_IMAGE, self.x, self.y)
	else
		love.graphics.draw(ACTIVATED_LEVER_IMAGE, self.x - 25, self.y + 10)
	end
end
