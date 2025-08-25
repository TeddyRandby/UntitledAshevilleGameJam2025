local M = {}

local RoomTypes = require("data.room.types")
local Tiles = require("data.tiles")

local room_width = 16
local room_height = 12

local function deep_print(tbl, indent, visited) --TODO Gross, for debug
  indent = indent or 0
  visited = visited or {}

  if visited[tbl] then
    print(string.rep("  ", indent) .. "*recursive reference*")
    return
  end
  visited[tbl] = true

  for k, v in pairs(tbl) do
    local keyStr = tostring(k)
    if type(v) == "table" then
      print(string.rep("  ", indent) .. keyStr .. " = {")
      deep_print(v, indent + 1, visited)
      print((string.rep("  ", indent) .. "}"))
    else
      print((string.rep("  ", indent) .. keyStr .. " = " .. tostring(v)))
    end
  end
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

local function sign(n)
  if n > 0 then
    return 1
  else
    return 0
  end
end 

function M.check_collision_tile(entity, dx, dy, room)
  local new_x  = entity.position_x + dx
  local new_y  = entity.position_y + dy


  local tile_x, tile_y = math.floor(new_x+sign(dx)), math.floor(new_y+sign(dy))
  local tile = room.tiles[tile_y][tile_x]

  if tile.type == "door" and entity.type == "player" then
  if new_x < 2 then
    if room.neighbors.left then
      Engine.room = room.neighbors.left
    else
      local next_room = M.create("basic", entity)
      room.neighbors.left = next_room
      next_room.neighbors.right = room
      Engine.room = next_room
    end
    entity.position_x = room_width - 2
    entity.position_y = room_height / 2

  elseif new_y < 2 then
    if room.neighbors.up then
      Engine.room = room.neighbors.up
    else
      local next_room = M.create("basic", entity)
      room.neighbors.up = next_room
      next_room.neighbors.down = room
      Engine.room = next_room
    end
    entity.position_x = room_width / 2
    entity.position_y = room_height - 2

  elseif new_x > room_width - 1 then
    if room.neighbors.right then
      Engine.room = room.neighbors.right
    else
      local next_room = M.create("basic", entity)
      room.neighbors.right = next_room
      next_room.neighbors.left = room
      Engine.room = next_room
    end
    entity.position_x = 2
    entity.position_y = room_height / 2

  elseif new_y > room_height - 1 then
    if room.neighbors.down then
      Engine.room = room.neighbors.down
    else
      local next_room = M.create("basic", entity)
      room.neighbors.down = next_room
      next_room.neighbors.up = room
      Engine.room = next_room
    end
    entity.position_x = room_width / 2
    entity.position_y = 2
  end


  end
  return tile.walkable
end

function M.check_collision_entity(entity, dx, dy, room)
  local new_x  = entity.position_x + dx
  local new_y  = entity.position_y + dy

  for _, other in ipairs(room.entities) do
    if other ~= entity then
      if math.abs(new_x - other.position_x) < 1 and math.abs(new_y - other.position_y) < 1 then
        if other.collision then
          other.collision()
        end
        if not other.walkable then
          return false
        end
      end
    end
  end
  return true
end

function M.create(type, player)
  local room = {
    tiles = new_grid(M[type].layout),
    entities = {player},
    neighbors = table.copy(M[type].neighbors)
  }

  if M[type].entities  then
    for _, entity_type in ipairs(M[type].entities) do
      for i = 1, entity_type[1] do
        local entity = require("data.entity").create(entity_type[2])
        entity.position_x = math.random(2, room_width - 1)
        entity.position_y = math.random(2, room_height - 1)
        table.insert(room.entities, entity)
      end
    end
  end

  return room
end


return M