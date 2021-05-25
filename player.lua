--[[ BEGINNING OF COMMENT
This is the script for the player. 
	This is the continuation of the code to make the gravity work.
	Source of most of this code: https://sheepolution.com/learn/book/24 
END OF COMMENT --]]
--[[ This will give the player the properties from the “entity” base class, and will give the player their sprite. The “canJump” variable will prevent the user from jumping twice in a row (I need to set it to true to make the player jump).
Also, the player will have some strength, but less strength than the walls and the floor so that the user doesn’t clip through them. --]]
Player = Entity:extend()

function Player:new(x, y)
    Player.super.new(self, x, y, "graphics/player.png")
    self.strength = 10

    self.canJump = false
end



--[[ The update() function for the player. This will render each frame (like 60 frames each second) for the player. --]]
function Player:update(dt)


--[[ This will transfer to the player the same properties as the “entity” base class. --]]
    Player.super.update(self, dt)



--[[ This will make the player to move to the left and to the right if they press the right and left arrow keys. --]]
    if love.keyboard.isDown("left") then
        self.x = self.x - 210 * dt
    elseif love.keyboard.isDown("right") then
        self.x = self.x + 210 * dt
    end
end	-- End of Player:update


--[[ This function will be called once the space bar is pressed from main.lua to make the player jump. In this case, I will briefly cancel gravity to make the player jump. --]]
function Player:jump()

--[[ This will prevent the player from jumping twice or more times in a row after “canJump” becomes false. --]]
    if self.canJump then
	self.gravity = -290
	self.canJump = false
    end
end


--[[ This will check if the player has touched the floor, and if they do, the player will be able to jump. This is done to prevent the player to jump twice in a row.  --]]
function Player:collide(e, direction)
    Player.super.collide(self, e, direction)
    if direction == "bottom" then
        self.canJump = true
    end
end

