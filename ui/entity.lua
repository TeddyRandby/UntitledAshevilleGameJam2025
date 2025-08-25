
local M = {}

local PlayerImage = love.graphics.newImage("resources/ButterEnemy.png")

local function translate(tile)
    if tile.type == "player" then
        return PlayerImage 
    else 
        return PlayerImage
    end 
end

  function M.draw(tile, x, y)
    local image = translate(tile)

	local map_width = 16
	local map_height = 12

    local pixelw = image:getPixelWidth()
    local pixelh = image:getPixelHeight()
	local screenWidth = love.graphics.getWidth()
	local screenHeight = love.graphics.getHeight()
	local scale = math.min(screenWidth / map_width , screenHeight / map_height)
	love.graphics.draw(
		image,
		x,
		y,
        0,
        scale/pixelw,
        scale/pixelh
	)

    love.graphics.rectangle("line", x, y, scale,  scale)
  end
return M