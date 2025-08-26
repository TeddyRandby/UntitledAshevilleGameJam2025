
local M = {}

  function M.draw(tile, x, y)
    local image = tile.image
	local scale = UI.sx()

    if image then
        local w = image:getPixelWidth()*scale
        local h = image:getPixelHeight()*scale

        local cx, cy = w / 2, h / 2
        love.graphics.push()
        love.graphics.translate(x + cx, y + cy)
        love.graphics.rotate(math.rad(tile.rotate))
        love.graphics.translate(-cx, -cy)
        love.graphics.scale(scale, scale)
        love.graphics.draw(image)
        love.graphics.pop()
    end
  end
return M