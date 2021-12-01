--[[ This algorithm could be similar to the Lever or the Chest class, but it would 
be simpler. Instead of activating a lever or opening a chest, the “currentRoom” 
variable would change, which would make the player change rooms.

First, I would declare the class in the Door.lua script.
]]
Door = Class{}

--[[ Next, I would declare a local variable that holds the sprites for the doors. I
think I may only use 2 sprites for the doors: a closed door sprite, and an open 
door one. The closed door sprite will be used for the 5 doors in the hub. Meanwhile, 
the opened door sprite will be used inside of the rooms that have chests. 
]]
local HUB_DOOR_IMAGE = love.graphics.newImage('graphics/doors/hub-door.png')
local TREASURE_ROOM_DOOR_IMAGE = love.graphics.newImage('graphics/doors/treasure-room-door.png')

--[[ Next comes the init() function. I will receive 3 parameters from main.lua: the 
x and y coordinates, and the number of the room in which the player will enter. I 
will get the width and height of the doors from the sprites (which will be stored 
in the “DOOR_IMAGE” variables). Since both door sprites have the same width and 
height, I will use either the hub or the treasure room door to get both the width 
and height. 

Then, I will get the x and y coordinates from 2 of the parameters obtained from 
main.lua. Finally, I will have to store the room number from the 3rd parameter in 
a “self.” variable. 
]]
function Door:init(door_x, door_y, roomNumber)
    self.width = HUB_DOOR_IMAGE:getWidth()
    self.height = HUB_DOOR_IMAGE:getHeight()
    self.y = door_y
    self.x = door_x

    self.roomNumber = roomNumber
end

--[[ Now, I need to make the update() function. Here, I will make it so that, if the 
player presses the up arrow key, they will be able to enter into a room. Then the 
current door sprite to disappear, and make the other door sprite to be rendered. 
However, this last thing can be done on the render() function by simply telling 
render() to render the hub door if currentRoom is 0, or a treasure room door 
if currentRoom is any number other than 0. Finally, I need to add collision 
detection here so that the player is only able to enter the doors if they are 
touching the door sprite while pressing the up arrow key.

I need to look at Love2D’s documentation to see how to access the arrow keys. After 
looking at it, it seems that I need to type ‘up’ to access the up arrow key (source: 
https://love2d.org/wiki/KeyConstant .)

To detect the collision detection to make sure the player is touching the door 
sprite, I will need to get a parameter from the update() function from main.lua that 
tells me whether or not the player is touching the door sprite. That parameter is a 
boolean. If it’s true, then that means that the player is touching the door. 
Otherwise, they aren’t. I will only allow the player to be able to enter a room if 
they press the up arrow key while they’re touching the door (while “isTouchingDoor” 
is true.)

If the player is able to touch the door and press the up arrow key at the same time, 
I will change the currentRoom global variable to the room number stored into the 
door that the player is touching. This way, the player will be able to change 
rooms.
]]
function Door:update(isTouchingDoor)
    if love.keyboard.wasPressed('up') then
        if isTouchingDoor == true then
            currentRoom = self.roomNumber
        end
    end
end

--[[ Finally, I will need to create the render() function. Here, I will put 2 
conditions. If the player is in the hub, I will render the hub door. Meanwhile, 
I will render the treasure room door if the player is in any of the treasure rooms.
]]
function Door:render()
    if currentRoom == 0 then
        love.graphics.draw(HUB_DOOR_IMAGE, self.x, self.y)
    else
        love.graphics.draw(TREASURE_ROOM_DOOR_IMAGE, self.x, self.y)
    end
end
    
