local M = {}

love.graphics.setDefaultFilter("nearest", "nearest")
local font = love.graphics.newImageFont("resources/Font.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")

---@param x integer
---@param y integer
---@param text string
---@param r? number
---@param limit? integer
---@param align? "center" | "justify" | "left" | "right"
---@param cx? integer -- An offset around which to rotate
---@param cy? integer -- An offset around which to rotate
function M.draw(x, y, text, r, limit, align, cx, cy)
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
	love.graphics.setColor(1, 0, 0)

	local w, h = font:getWidth(str), font:getHeight()
	w, h = w * sx, h * sy
	cx = cx or (w / 2)
	cy = cy or (h / 2)
	love.graphics.translate(cx, cy)
	love.graphics.rotate(r or 0)
	love.graphics.translate(x - cx, y - cy)

	love.graphics.printf(str, 0, 0, sx * (limit or 1000), align or "left", 0, sx, sy)
	love.graphics.pop()
	love.graphics.setColor(1, 1, 1)
end

return M
