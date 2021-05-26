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

    --[[ This will prevent the player from being able to jump right after falling of a ledge. --]]
    if self.last.y ~= self.y then
        self.canJump = false
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

--[[ This will call the checkResolve() function so that, if the player is on top of a throwable block, they will be able to stand on top of them (collision will be resolved). Otherwise, the player will be able to walk through the block (collision WON’T be resolved.)

This will only apply to throwable blocks, not the walls nor the floors. --]]
function Player:checkResolve(e, direction)
    if e:is(Block) then
        if direction == "bottom" then
            return true
        else
            return false
        end
    --[[ I will add another condition so that the player will be unable to push around chests. It will only be able to jump on top 
    of chests (just like with blocks.)

    I WON’T use the “or” operator, because off behavior may occur if the player touches both a block and a chest at the same 
    time (the chest may get pushed around.) --]]
    elseif e:is(Chest) then
        if direction == "bottom" then
            return true
        else
            return false
        end
    end
    return true
end
    