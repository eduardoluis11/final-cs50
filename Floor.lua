--[[ This class will store all of the properties of the floor, including its sprite (source: https://youtu.be/3IdOCxHGMIo?t=3412 ).
	I created a separate floor class to add collision detection between the floor and the player, so that the player doesn’t 
    fall through the floor, but the player could still be able to fall from a bottomless pit.
--]]
  Floor = Class{}

  --[[ I will use one sprite for the floor for most rooms, so I can just reuse the same sprite for the floor on many rooms. It doesn’t matter if the size of the floor is different for each room, since I can simply resize the floor, but I could still use the same sprite. --]]
  local FLOOR_IMAGE = love.graphics.newImage('graphics/floor.png')
  
  --[[ This will have the initial properties of the floor.
  
  The y property pretty much won’t change. The x coordinate will change depending on the room, since some rooms will 
  have narrower floors to make room for bottomless pits. Remember that its height is of 121 pixels. 
  
  I put the negative 121 pixels before adding the constant with the virtual height because, otherwise, 
  I would get an error message. --]]
  function Floor:init()
      self.y = -121 + VIRTUAL_HEIGHT
  
      --[[ I have mixed feelings about adding the initial width of the floor here. Sure, I need to have the initial 
      width somewhere. However, as I sad, some rooms will have the floor narrower than others. 
  
      What I could to is to add a variable that keeps track of the current room. If the room changes (I will only have 
      6 rooms), I will change the x position and the width of the floor sprite. 
  
      Then, I would use an “if” statement. --]]
      if currentRoom == 1 then
          self.x = 0
          self.width = FLOOR_IMAGE:getWidth()
      end
  end
  
  --[[ I WON’T add the update() function for the floor yet since I don’t want to change the room nor make the floor 
  scroll horizontally yet. --]]
  
  
  --[[ This will render the floor sprite each time that I call this on main.lua. 
  
  I DON’T need to put any conditionals in here depending on the room that the player’s currently in since the x 
  coordinate and the width of the floor will be taken from the Floor:update() function (where both parameters will 
    be stored in variables.) --]]
  function Floor:render()
      love.graphics.draw(FLOOR_IMAGE, self.x, self.y)
  end
  