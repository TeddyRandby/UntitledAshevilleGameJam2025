
local M = {}

local FloorImage = love.graphics.newImage("resources/tiles/FloorTile.png")
local WallImage = love.graphics.newImage("resources/tiles/WallTile.png")

local function translate(tile)
    if tile.type == "floor" then
        return FloorImage   
    elseif tile.type == "wall" then
        return WallImage
    else 
        return FloorImage
    end 
end

  function M.draw(tile, x, y)
    local image = translate(tile)
	local scale = UI.sx()

	love.graphics.draw(
		image,
		x,
		y,
        0,
        scale,
        scale

	)
  end
return M