local TileTypes = require("data.tiles.types")

local FloorImage = love.graphics.newImage("resources/tiles/FloorTile.png")
local WallImage = love.graphics.newImage("resources/tiles/WallTile.png")
local DoorLeftimage = love.graphics.newImage("resources/tiles/DoorLeft.png")
local DoorRightImage = love.graphics.newImage("resources/tiles/DoorRight.png")
local CornerImage =  love.graphics.newImage("resources/tiles/CornerWall.png")
local function translate(tile)
    if tile.type == "floor" then
        return FloorImage   
    elseif tile.type == "corner" then
      return CornerImage
    elseif tile.type == "ldoor" then
        return DoorLeftimage
    elseif tile.type == "rdoor" then
        return DoorRightImage
    elseif tile.type == "wall" then
        return WallImage
    else 
        return nil
    end 
end


local M = {}
local by_char = {}

for _, v in ipairs(TileTypes) do
  M[v.type] = v
  by_char[v.char] = v.type
  v.image = translate(v)
end

function M.create_from_char(c, x, y, room_height, room_width)
  local kind = by_char[c]
  local tile = M.create(kind)

  tile.rotate = 0
  if x == room_width and tile.rotates and y ~= 1 then
	  tile.rotate = 90
  elseif y == room_height and tile.rotates then
	  tile.rotate = 180
  elseif x == 1 and tile.rotates then
	  tile.rotate = 270
  end

  
  return tile
end

function M.create(type)
  return table.copy(M[type])
end

return M
