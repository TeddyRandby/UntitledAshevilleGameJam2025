local M = {}

---@param x integer
---@param y integer
---@param text string
---@param limit? integer
---@param align? "center" | "justify" | "left" | "right"
function M.draw(x, y, text, limit, align)
  local sx, sy = UI.scale_xy()

  love.graphics.push()

  love.graphics.translate(x, y)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf(text, x, y, limit or 1000, align or "left", 0, sx, sy)
  love.graphics.pop()
end

return M
