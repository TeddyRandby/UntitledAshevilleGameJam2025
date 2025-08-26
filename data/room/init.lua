local M = {}

local RoomTypes = require("data.room.types")
local Tiles = require("data.tiles")

local room_width = 10
local room_height = 8
local room_keys = {}

for _, v in pairs(RoomTypes) do
	M[v.type] = v
  room_keys[#room_keys+1] = v.type
end

local function new_grid(layout)
  local grid = {}
  for y = 1, room_height  do
    grid[y] = {}
    for x = 1, room_width do
      grid[y][x] = Tiles.create_from_char(string.sub(layout[y], x, x), x, y, room_height, room_width)
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

function M.move_through_door(room, going, coming, entity)
  if room.neighbors[going] then
    Engine.room = room.neighbors[going]
  else

    local found  = false
    local potential_type = nil

    while not found do 
      potential_type = room_keys[math.random(1, #room_keys)]
      local potential_room = M[potential_type]
      if potential_room.connects[coming] then
        found = true
      end
    end

    local next_room = M.create(potential_type, entity, room.depth + 1)
    room.neighbors[going] = next_room
    next_room.neighbors[coming] = room
    Engine.room = next_room
  end
end

function M.check_collision_tile(entity, dx, dy, room)
  local new_x  = entity.position_x + dx
  local new_y  = entity.position_y + dy


  local tile_x, tile_y = math.floor(new_x+sign(dx)), math.floor(new_y+sign(dy))
  local tile = room.tiles[tile_y][tile_x]

  if tile.kind == "door" and entity.type == "player" then
      if new_x < 3 then
        M.move_through_door(room, "left", "right", entity)
        entity.position_x = room_width - 2
      elseif new_y < 3 then
        M.move_through_door(room, "up", "down", entity)
        entity.position_y = room_height - 2
      elseif new_x > room_width - 2 then
        M.move_through_door(room, "right", "left", entity)
        entity.position_x = 3
      elseif new_y > room_height - 2 then
        M.move_through_door(room, "down", "up", entity)
        entity.position_y = 3
      end
  end

  return tile.walkable
end

local epsilon = 0.1

function M.check_collision_entity(entity, dx, dy, room)
  local new_x  = entity.position_x + dx
  local new_y  = entity.position_y + dy

  for _, other in ipairs(room.entities) do
    if other ~= entity then
      if math.abs(new_x - other.position_x) < 1 - epsilon and math.abs(new_y - other.position_y) < 1 - epsilon then
        if other.collision then
          other.collision(other)
        end
        if not other.walkable then
          return false
        end
      end
    end
  end
  return true
end

function M.insert_into_room(room, entity)
  table.insert(room.entities, entity)
  entity.id = #room.entities
end 

function M.remove_from_room(room, entity)
  table.remove(room.entities, entity.id)
end

function M.create(type, player, depth)

  local connects = {}

  for k, v in pairs(M[type].connects) do
    connects[k] = v
  end

  local new_room = {
    tiles = new_grid(M[type].layout),
    entities = {player},
    neighbors = {},
    connects = connects,
    depth = depth or 1
  }

  if M[type].entities  then
    for _, entity_type in ipairs(M[type].entities) do
      for i = 1, entity_type[1] do
        local entity = require("data.entity").create(entity_type[2])

        local placed = false
        while not placed do
          entity.position_x = math.random(2, room_width - 1)
          entity.position_y = math.random(2, room_height - 1)

          local tile = new_room.tiles[math.floor(entity.position_y)][math.floor(entity.position_x)]
          if tile.walkable then
            placed = true
          end
        end

        M.insert_into_room(new_room, entity)
      end
    end
  end

  return new_room
end


return M