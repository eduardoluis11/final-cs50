--[[ BEGINNING OF COMMENT 
	This script will have the code for gravity, and it will be used as a base class (or object) to make the player, the walls, the floor, and most of the objects in my game world. 
That is, once the user starts falling, they will fall at a faster speed throughout time. They won’t wall at a constant speed.
	Source of most of this code: https://sheepolution.com/learn/book/24 
END OF COMMENT --]]
--[[ This creates a new function called Entity.new(Entity, x, y, image_path). It will be called to activate gravity and create the player, the walls, the floor, and some other object. 

It will also get the x and y coordinates of the object to which gravity will be applied to, and it will obtain the sprite of the object using “image_path”. 

This is a generic function for a generic base class. I will create player.lua, wall.lua, and floor.lua, and give different sprites to each of them. To give them the different sprites, I will insert the PATH to the sprite on the “image_path” parameter. --]]
Entity = Object:extend()

function Entity:new(x, y, image_path)
    self.x = x
    self.y = y


--[[ This will obtain the desired sprite from an image file in the specified PATH. This will also obtain the x and y coordinates of that sprite. --]]
    self.image = love.graphics.newImage(image_path)
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()



--[[ This will create a table called “last”. This will store the last position of the player (or a block). This will be used for preventing the player from walking through walls (by pushing them back to the edge of the wall), and preventing them from falling through the floor. --]]
    self.last = {}


--[[ This will store the current x and y positions of the current instance of the entity base class (like the player), and then they will be inserted into the “last” table. --]]
    self.last.x = self.x
    self.last.y = self.y


--[[ These 2 variables will be used in a function called resolveCollision() to reset the gravity to 0 after the player touches the floor, and to be able to call that function for any other object other than the player (like the walls or blocks). 

This way, I could push or throw blocks against walls, and the player wouldn’t clip through the blocks if they throw them against a wall. --]]
    self.strength = 0
    self.tempStrength = 0



--[[ This will create the initial value for gravity, and it will add a weight to the object that is being influenced by gravity (like the player). --]]
    self.gravity = 0
    self.weight = 400

end




--[[ This will update every frame of the Entity() function. It has a “dt” as a parameter so that the game will be updated depending on the user’s computer performance. That is, that the game will run pretty much the same, regardless of whether they have a powerful computer or a weak one. --]]
function Entity:update(dt)


--[[ This should obtain the x and y coordinates from the “last” parameter, which was created on “Entity:new” --]]
    self.last.x = self.x
    self.last.y = self.y



-- This will store the current value of “strength”
    self.tempStrength = self.strength


--[[ This will take the value of the object’s weight to increase the acceleration of gravity, so that the object falls faster. --]]
    self.gravity = self.gravity + self.weight * dt


--[[ This will change the y position of the object affected by gravity, so that it falls downwards. --]]
    self.y = self.y + self.gravity * dt
end




--[[ This will fix the bug that if enough time passes, the gravity would make the player to fall through the floor, and prevents the player from walking through walls. THIS IS AN IMPORTANT FUNCTION.

This will reset the gravity to 0 for the player once they touch the ground. --]]
function Entity:resolveCollision(e)


--[[ This will check if the strength for the current instance of entity (like the player) is bigger than the strength of the other object that is being touched (for instance, to check if the player has more strength than the wall, if the player is touching a wall.) --]]
    if self.tempStrength > e.tempStrength then
        return e:resolveCollision(self)
    end


--[[ This will check if 2 objects (like the player and the floor) are touching each other. --]]
--[[ This will transfer the strength for the current instance of entity to the other object that is being touched (for instance, it would transfer the strength of the wall to a block if the block is touching the wall). --]]

    if self:checkCollision(e) then
        self.tempStrength = e.tempStrength



--[[ This will check if both instances of the entity base class (the current one and the object being touched) are at the same height. This is done so that, for instance, if a wall is on the upper part of the room, and the player is at the bottom of the room, the player will be able to move freely at the bottom of the room, but they will be stopped by the wall if they decide to go to the upper part of the room.

The reason why this code from Sheepolution is dividing width by 2 is to calculate the center of the sprite of the current instance of entity (like the player) and the center of the sprite of the object being touched (like a wall). If the center of the current instance of entity is horizontally farther than the center of the object being touched, the two objects are colliding with each other.  

To prevent the player from clipping through walls, I will use the self:collide() function. 

If the center of the player’s sprite isn’t farther than the wall’s center, the player will be able to briefly walk through the wall (until it reaches the center of the wall.)

wasHorizontallyAligned will check if the current instance of the entity and the object being touched (like the player and the wall) are touching each other horizontally (that are touching each other at the bottom).

The height divided by 2 will also calculate the center of the sprite of the two entity instances that are touching each other (like the player and the wall.) The self:collide() function will prevent the player from falling through the floor.  

The “else” statement below “wasHorizontallyAligned”  will let the player to fall through the floor until it reaches the center of the floor’s 
sprite.

Now, I want to walk through the box. I don’t want the player to push the box. So, I will create a function called “checkResolve()”. If the 
player and the box touch each other, they won’t push each other nor block each other, that is, the collision won’t be resolved.

So, I will create 2 variables (a and b) to check if both objects call the checkResolve() function. If yes, then the object with the 
highest strength will bloeck the weaker object (i.e. the wall will block the player.)

If not, one of the objects will be able to walk through the other (i.e. the player will be able to walk through the box). However, if the
former object (like the player) jumps on top of the 2nd object (like the block), they will be able to stay on top of the other object 
(the player won’t fall through the block.) --]]
        if self:wasVerticallyAligned(e) then
            if self.x + self.width/2 < e.x + e.width/2 then
                local a = self:checkResolve(e, "right")
                local b = e:checkResolve(self, "left")

                if a and b then
                    self:collide(e, "right")
                end
            else
                local a = self:checkResolve(e, "left")
                local b = e:checkResolve(self, "right")
                if a and b then
                    self:collide(e, "left")
                end
            end
        elseif self:wasHorizontallyAligned(e) then
            if self.y + self.height/2 < e.y + e.height/2 then
                local a = self:checkResolve(e, "bottom")
                local b = e:checkResolve(self, "top")
                if a and b then
                    self:collide(e, "bottom")
                end
            else
                local a = self:checkResolve(e, "bottom")
                local b = e:checkResolve(self, "top")
                if a and b then
                    self:collide(e, "top")
                end
            end
        end

-- This will stop the function, and give the value “true”.
        return true
    end

--[[ This will stop the function, and, since there was no collision detected between objects if the function reaches this block of code, it will return the value “false”. --]]

    return false
end	-- End of Entity:resolveCollision().




--[[ This function will be called if the player (or other subclass from entity) hits something from the right.

The “pushback” variable will push the player away from the wall or the floor if they try to walk through a wall, or if they try to fall through a floor. That is, it will prevent the player from clipping through walls and floors. 

With “self.gravity = 0”, if the player touches the floor, I will reset the gravity back to 0. Otherwise, the player would get too much acceleration from gravity, and they would fall through the floor. --]]
function Entity:collide(e, direction)
    if direction == "right" then
        local pushback = self.x + self.width - e.x
        self.x = self.x - pushback
    elseif direction == "left" then
        local pushback = e.x + e.width - self.x
        self.x = self.x + pushback
    elseif direction == "bottom" then
        local pushback = self.y + self.height - e.y
        self.y = self.y - pushback
        self.gravity = 0
    elseif direction == "top" then
        local pushback = e.y + e.height - self.y
        self.y = self.y + pushback
    end
end
    

--[[ This adds the collision detection. That is, it detects if 2 objects (like the player and the wall)
are touching each other. Without this function, I will get a "nil" error when trying to call checkCollision
from resolveCollision.
    
Source of this code: https://sheepolution.com/learn/book/23 --]]
function Entity:checkCollision(e)
    return self.x + self.width > e.x
    and self.x < e.x + e.width
    and self.y + self.height > e.y
    and self.y < e.y + e.height
end

--[[ This renders the sprites and makes "love.draw" work in main.lua.

Source: https://sheepolution.com/learn/book/23 --]]
function Entity:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

--[[ This adds the wasVerticallyAligned() and wasHorizontallyAligned() functions.

This is to check for collision on the sides of each object (be it the player or the walls) 
for wasHorizontallyAligned, and to check for collision on the top and bottom for 
wasVerticallyAligned.

Source: https://sheepolution.com/learn/book/23 --]]
function Entity:wasVerticallyAligned(e)
    return self.last.y < e.last.y + e.height and self.last.y + self.height > e.last.y
end

function Entity:wasHorizontallyAligned(e)
    return self.last.x < e.last.x + e.width and self.last.x + self.width > e.last.x
end

--[[ This is the checkResolve() function. This function will allow me to walk through throwable blocks, and let the player jump 
and stay on top of these blocks/boxes.  

Source: https://sheepolution.com/learn/book/24  --]]
function Entity:checkResolve(e, direction)
    return true
end
