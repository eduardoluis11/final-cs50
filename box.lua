--[[ This is the box that the user will be able to throw and climb
by jumping.

Source of most of this code: https://sheepolution.com/learn/book/23 --]]

Box = Entity:extend()

function Box:new(x, y)
    Box.super.new(self, x, y, "graphics/box.png")
end