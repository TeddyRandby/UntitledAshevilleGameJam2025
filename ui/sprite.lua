local M = {}

---@param image love.Drawable
---@param x integer
---@param y integer
function M.draw(image, x, y)
	love.graphics.draw(image, x, y)
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
