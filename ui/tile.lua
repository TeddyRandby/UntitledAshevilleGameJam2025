local M = {}

local FloorImage = love.graphics.newImage("resources/tiles/FloorTile.png")
local WallImage = love.graphics.newImage("resources/tiles/WallTile.png")

local function translate(tile)
  if tile.type == "floor" then
    return FloorImage
  elseif tile.type == "wall" then
    return WallImage
  else
    return WallImage
  end
end

function M.draw(tile, x, y)
  local image = translate(tile)
  love.graphics.draw(image, x, y)
end

return M

