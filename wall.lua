--[[ BEGINNING OF COMMENT
	This is the script for the walls and the floor.
	Most (if not all) of this code comes from: https://sheepolution.com/learn/book/24 
END OF COMMENT --]]

-- This will create the walls and the floor by using the Entity() function 
Wall = Entity:extend()


--[[ This function will assign the walls and the floor their respective sprite. At 1st, I will give both the floor and the walls the same sprite. However, since I want different sprites for the floor and the walls, I will have to modify this later on. --]]
function Wall:new(x, y)


--[[ This will obtain the PATH to the image file that contains the sprite for the walls. --]]
    Wall.super.new(self, x, y, "graphics/wall.png", 1)


--[[ This will make it so that the player won’t be able to easily fall through the floor (while gravity remains weak enough). --]]
    self.strength = 100



--[[ The floor and the walls don’t need gravity, so I won’t give any gravity to them. --]]
    self.weight = 0
end

