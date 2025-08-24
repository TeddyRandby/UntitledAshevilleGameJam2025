local M = {}

love.graphics.setDefaultFilter("nearest", "nearest")
local font = love.graphics.newImageFont("resources/Font.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")

---@param x integer
---@param y integer
---@param text string
---@param limit? integer
---@param align? "center" | "justify" | "left" | "right"
function M.draw(x, y, text, limit, align)
  local str = ""
  for i = 1, #text do
    local c = text:sub(i, i)
    if Engine.player_dictionary[c] ~= nil then
      str = str .. string.upper(c)
    else
      str = str .. c
    end
  end

  local sx, sy = UI.scale_xy()

  sx, sy = sx * 0.4, sy * 0.4

  love.graphics.push()

  love.graphics.setFont(font)

  love.graphics.translate(x, y)
  love.graphics.printf(str, x, y, sx * (limit or 1000), align or "left", 0, sx, sy)
  love.graphics.pop()
end

return M
