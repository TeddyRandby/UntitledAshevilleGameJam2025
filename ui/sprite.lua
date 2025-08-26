local M = {}

---@param image love.Drawable
---@param x integer
---@param y integer
---@param scale? integer
function M.draw(image, x, y, scale)
  local sx, sy = UI.scale_xy()
  sx = sx * (scale or 1)
  sy = sy * (scale or 1)
	love.graphics.draw(image, x, y, 0, sx, sy)
end

---@param sprite love.Quad
---@param spritesheet love.Drawable
---@param x integer
---@param y integer
function M.drawof(sprite, spritesheet, x, y)
  local sx, sy = UI.scale_xy()
	love.graphics.draw(spritesheet, sprite, x, y, 0, sx, sy)
end

return M
