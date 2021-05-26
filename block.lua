--[[ This is the box that the user will be able to throw and climb
by jumping.

Source of most of this code: https://sheepolution.com/learn/book/23 --]]

Block = Entity:extend()

function Block:new(x, y)
    Block.super.new(self, x, y, "graphics/block.png")
end