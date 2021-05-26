--[[ BEGINNING COMMENT
Step 2: Adding the chests with treasure

	I need to create this script in order to create chests, add their sprites, and be able to open them.
	It will be another subclass from the Entity base class, so that they don’t clip through the floor, and to be able to render their sprites without having to reuse code (among other things).
	I need to add a button (like “Z” or “X”) to open them.
	I will need to call this script from main.lua via a “require”.
	I also need to specify that the chests will be a subclass from the Entity base class using “extend”. 
END OF COMMENT --]]

-- This gets the properties from Entity, and transfers it to the chest.
Chest = Entity:extend()

--[[ This creates a new instance of chest. --]]
function Chest:new(x, y)
    Chest.super.new(self, x, y, "graphics/chest-closed.png")
end
