--[[ This script handles the UI element that shows the player the total number of treasures that they’ve collected 
out of the five that they need to beat the game. ]]

-- This creates the class for the UI that contains the treasure list 
TreasureList = Class{}

--[[ This stores the sprites for the treasure list UI. After further consideration, I decided to only use 1 bubble sprite for 
the sprite (the one without the question mark). ]]
-- local NO_TREASURE_IMAGE = love.graphics.newImage('graphics/treasure-bubble-question.png')
local TREASURE_INCLUDED_IMAGE = love.graphics.newImage('graphics/treasure-bubble-empty.png')



--[[ This will have the initial properties of the treasure list sprites.

They will be located at a fixed position, regardless of the room where the player is in. I don’t need to specify the 
coordinates from main.lua. I can specify the coordinates for the 1st bubble in self.x and self.y, and I can draw the rest 
of the 4 bubbles in the render() function (by specifying different x coordinates in render() for the remaining 4 bubbles).

They will be at the top-center part of the screen. ]]
function TreasureList:init()
    self.width = TREASURE_INCLUDED_IMAGE:getWidth()
    self.height = TREASURE_INCLUDED_IMAGE:getHeight()

    self.x = 155
    self.y = 0
end

--[[ Since I won’t be changing any sprites for the treasure UI, I won’t include an update() function for this script. --]]

--[[ This will render each bubble sprite.

I will have to do this manually for each of the 5 bubbles. This may not be efficient, but it’s the only way that I know how 
to do it right now. I will only have to change the x coordinate of each bubble (since they are all at the same height.) ]]
function TreasureList:render()
    love.graphics.draw(TREASURE_INCLUDED_IMAGE, self.x, self.y)
    love.graphics.draw(TREASURE_INCLUDED_IMAGE, self.x + 100, self.y)
    love.graphics.draw(TREASURE_INCLUDED_IMAGE, self.x + 200, self.y)
    love.graphics.draw(TREASURE_INCLUDED_IMAGE, self.x + 300, self.y)
    love.graphics.draw(TREASURE_INCLUDED_IMAGE, self.x + 400, self.y)
end
