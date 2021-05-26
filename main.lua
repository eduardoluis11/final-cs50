-- TODO
--[[ BEGINNING OF COMMENT
Step 1: Adding gravity to the game world
	In this step, I will render Room 1 without using its respective sprites yet, and I will add gravity so that the character will be able to fall after jumping.
	I will use code similar to the one found in here: https://sheepolution.com/learn/book/24

END OF COMMENT --]]
--[[ Source of most of this code: https://sheepolution.com/learn/book/24 --]]

function love.load()
    -- "require classic" needs to be the 1st required file to prevent errors.
    Object = require "classic"

    --[[ "require entity" needs to be the 2nd required file to prevent errors. Most other files will take the
    properties from entity.lua --]]
    require "entity"
    require "player"
    require "block"
    require "wall"
    

    player = Player(100, 100)
    block = Block(400, 150)

    objects = {}
    table.insert(objects, player)
    table.insert(objects, block)


    -- This will create a table that creates the walls.
    walls = {}

    --[[ This will render the walls, platforms, and floor of Room 1. However, I will have to make the left and right walls invisible. I don’t want the player to see the walls to the side of the room but I don’t want the player falling of to the side of the screen if they walk past the edges of the screen. 

I don’t need a ceiling. --]]


    map = {
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1},
        {1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1},
        {1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1},
        {1,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1},
        {1,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
    }


--[[ This “for” loop will convert the above map into walls by converting the 1s into walls, and the 0s into empty space, and insert them into the “walls” table. --]]
    for i,v in ipairs(map) do
        for j,w in ipairs(v) do
            if w == 1 then
	        -- I may need to change this later. 
                -- This will add each wall into the “walls” table.
                table.insert(walls, Wall((j-1)*50, (i-1)*50))
            end
        end
    end
end	-- End of the load() function.


-- update() function. This will make the game run if it gets executed.
function love.update(dt)
    for i,v in ipairs(objects) do
        v:update(dt)
    end
    

    -- This should render the walls.
    for i,v in ipairs(walls) do
        v:update(dt)
    end

--[[ I will use these two variables to execute a “while” loop. “loop” will allow me to start the loop, and “limit” is the counter that will stop the loop once it reaches a value. --]]
    local loop = true
    local limit = 0

    -- “while” loop.
    while loop do

	--[[ This will make the condition that started the “while” disappear, so that the loop stops once “limit” reaches the specified value. --]]
        loop = false


	--[[ Once this counter reaches 100, the “while” loop will stop. This will add 1 to the “limit” counter during each iteration. --]]
        limit = limit + 1
        if limit > 100 then
            break
        end

 --[[ This will add collision detection to the walls and floor. That is, if the player touches a wall or the floor, they will stop. --]]
        for i=1,#objects-1 do
            for j=i+1,#objects do
                local collision = objects[i]:resolveCollision(objects[j])
                if collision then
                    loop = true
                end
            end
        end


--[[ This will check any collision between each wall and each object --]]
        for i,wall in ipairs(walls) do
            for j,object in ipairs(objects) do
                local collision = object:resolveCollision(wall)
                if collision then
                    loop = true
                end
            end
        end
    end
end	-- End of update() function



-- draw() function. This will render all of the graphics

function love.draw()

    -- This will render every non-wall object
    for i,v in ipairs(objects) do
        v:draw()
    end

    -- This will render every wall (and floor tile)
    for i,v in ipairs(walls) do
        v:draw()
    end
end	-- End of the draw() function.



-- This function will make the player jump
function love.keypressed(key)

    --[[ The key “space” will make the player to jump if they press the space bar. Source: https://love2d.org/wiki/KeyConstant  --]]
    if key == "space" then
        player:jump()
    end
end
