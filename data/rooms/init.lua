local M = {}

local RoomTypes = require("data.rooms.types")
local Tiles = require("data.tiles")

local room_width = 20
local room_height = 10


for _, v in pairs(RoomTypes) do
	M[v.type] = v
end

local function new_grid(layout)
  local grid = {}
  for y = 1, room_height  do
    grid[y] = {}
    for x = 1, room_width do
      grid[y][x] = Tiles.create_from_char(string.sub(layout[y], x, x))
    end
  end
  return grid
end

local function describe_room(room)
  for y = 1, room_height  do
    local str = ""
    for x = 1, room_width do
      str = str .. room.tiles[y][x].char
    end
    print(str)
  end
end

function M.create(type, player)
  local room = {
    tiles = new_grid(M[type].layout),
    entities = {player}
  }
  describe_room(room)
  return room
end


return M