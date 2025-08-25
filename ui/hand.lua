local M = {}

love.graphics.setDefaultFilter("nearest", "nearest")
local CursorSpritesheet = love.graphics.newImage("resources/Hand.png")

M.pixelw = 16
M.pixelh = 16

function M.getRealizedDim()
  return UI.realize_xy(M.getNormalizedDim())
end

function M.getNormalizedDim()
  return UI.normalize_xy(M.getPixelDim())
end

function M.getPixelDim()
  return M.pixelw, M.pixelh
end

local CursorDefault = love.graphics.newQuad(M.pixelw * 0, 0, M.pixelw, M.pixelh, CursorSpritesheet)
local CursorPointer = love.graphics.newQuad(M.pixelw * 1, 0, M.pixelw, M.pixelh, CursorSpritesheet)

---@param open? boolean
---@param r? number
---@param x integer
---@param y integer
function M.draw(open, x, y, r)
  local sx, sy = UI.scale_xy()
  love.graphics.setColor(1, 1, 1)

  if open then
    love.graphics.draw(CursorSpritesheet, CursorDefault, x, y, r, sx, sy)
  else
    love.graphics.draw(CursorSpritesheet, CursorPointer, x, y, r, sx, sy)
  end
end

return M
