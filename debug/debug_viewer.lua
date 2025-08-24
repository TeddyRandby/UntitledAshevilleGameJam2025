local M = {}

local font = love.graphics.getFont()
local tileSize = font:getHeight()

local function get_screen_coords(x, y)
  local screenX = (x + love.graphics.getWidth() / tileSize / 2) * tileSize
  local screenY = (y + love.graphics.getHeight() / tileSize / 2) * tileSize
  return screenX, screenY
end

function M.draw(room)
  local map_width = #room.tiles[1]
  local map_height = #room.tiles
  local screenWidth = love.graphics.getWidth()
  local screenHeight = love.graphics.getHeight()
  local scale = math.min(screenWidth / map_width, screenHeight / map_height)
  local startX = (screenWidth - map_width * scale) / 2
  local startY = (screenHeight - map_height * scale) / 2
  for y = 1, map_height do
    for x = 1, map_width do
      local screenX, screenY  = get_screen_coords(x, y)
      love.graphics.print(room.tiles[y][x].char, screenX, screenY )
    end
  end

  for _, entity in ipairs(room.entities) do
    local screenX, screenY  = get_screen_coords(entity.position.x, entity.position.y)
    love.graphics.print(entity.char, screenX, screenY )
  end
end

return M