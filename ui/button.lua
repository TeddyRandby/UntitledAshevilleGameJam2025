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

	local w, h = M.getRealizedDim()

	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.rectangle("line", 0, 0, w, h)

	UI.text.draw(1, 1, text, limit)

	love.graphics.pop()
end

return M
