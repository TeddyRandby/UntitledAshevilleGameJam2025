local TileTypes = require("data.tiles.types")

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

local M = {}
local by_char = {}

for _, v in ipairs(TileTypes) do
	M[v.type] = v
	by_char[v.char] = v.type
  v.image = translate(v)
end

function M.create_from_char(c)
	local kind = by_char[c]
	return M.create(kind)
end

function M.create(type)
	return table.copy(M[type])
end

return M
