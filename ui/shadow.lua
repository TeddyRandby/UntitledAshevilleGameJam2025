local image = love.graphics.newImage("resources/shadow.png")

local M = {}

function M.draw(enity,x,y,scale)
    local scale_new = UI.sx() * scale
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.scale(scale_new, scale_new)
    love.graphics.draw(image)
    love.graphics.pop()
end

return M
