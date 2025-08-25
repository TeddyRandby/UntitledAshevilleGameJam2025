local M = {}

love.graphics.setDefaultFilter("nearest", "nearest")
local font = love.graphics.newImageFont("resources/Font.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")

---@param x integer
---@param y integer
---@param word Word
---@param r? number
---@param limit? integer
---@param align? "center" | "justify" | "left" | "right"
---@param cx? integer -- An offset around which to rotate
---@param cy? integer -- An offset around which to rotate
function M.draw(x, y, word, r, limit, align, cx, cy)
  local depth = 2
  local skew = depth / 100

  local str = ""
  for i = 1, #word.synonym do
    local c = word.synonym:sub(i, i)
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
  love.graphics.setColor(1, 0, 0)

  local w, h = font:getWidth(str), font:getHeight()
  w, h = w * sx, h * sy
  cx = cx or (w / 2)
  cy = cy or (h / 2)
  love.graphics.translate(cx, cy)
  love.graphics.rotate(r or 0)
  love.graphics.translate(x - cx, y - cy)

  local xshear, yshear = nil, nil
  local ox, oy = love.mouse.getPosition()

  local c = table.pop(View:contains(ox, oy))

  local hovered_my_page = false

  if c and c.type == "page" then
    local page = c.target

    if not not table.find(page.words, function(w)
          return w == word
        end) then
      hovered_my_page = true
    end
  end

  if hovered_my_page then
    xshear, yshear = 0, 0

    local cx = x + w / 2
    local cy = y + h / 2

    local dx = (ox - cx) / (w / 2)
    local dy = (oy - cy) / (w / 2)

    if dx < 0 and dy < 0 then
      xshear = skew * dx
      yshear = skew * dy
    elseif dx < 0 and dy > 0 then
      xshear = skew * -dx * dy
      yshear = skew * dy
    elseif dx > 0 and dy < 0 then
      xshear = skew * dx
      yshear = skew * -dy * dx
    else
      xshear = skew * -dx
      yshear = skew * -dy
    end
  end

  if xshear and yshear then
    love.graphics.translate(ox - x, oy - y)

    -- Apply skew and scale
    love.graphics.shear(xshear, yshear)

    -- Move back so sprite is drawn in correct position
    love.graphics.translate(-(ox - x), -(oy - y))
  end

  love.graphics.setColor(0, 0, 0)
  love.graphics.printf(str, 0, 0, sx * (limit or 1000), align or "left", 0, sx, sy)

  if xshear and yshear then
    love.graphics.translate(ox - x, oy - y)

    -- Apply skew and scale
    love.graphics.shear(xshear, yshear)

    -- Move back so sprite is drawn in correct position
    love.graphics.translate(-(ox - x), -(oy - y))
  end

  love.graphics.setColor(1, 0, 0)
  love.graphics.printf(str, 0, 0, sx * (limit or 1000), align or "left", 0, sx, sy)

  love.graphics.pop()
  love.graphics.setColor(1, 1, 1)
end

return M
