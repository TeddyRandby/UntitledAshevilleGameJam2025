local M = {}

M.pixelw = 16
M.pixelh = 8

function M.getRealizedDim()
	return UI.realize_xy(M.getNormalizedDim())
end

function M.getNormalizedDim()
	return UI.normalize_xy(M.getPixelDim())
end

function M.getPixelDim()
	return M.pixelw, M.pixelh
end

---@param x integer
---@param y integer
---@param text string
---@param limit? integer
function M.draw(x, y, text, limit)
	love.graphics.push()

	love.graphics.translate(x, y)

  local sx, sy = UI.scale_xy()
  sx = sx * 0.3
  sy = sy * 0.3

	local w, h = M.getRealizedDim()

	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.rectangle("line", 0, 0, w, h)

  love.graphics.printf(text:upper(), 1, 1, limit or w / sx, "center", 0, sx, sy)

	love.graphics.pop()
end

return M
