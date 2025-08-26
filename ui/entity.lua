local M = {}

function M.draw(entity, x, y, scale)
	local image = entity.sprite
  assert(image, "No sprite for entity: " .. entity.type)

	scale = UI.sx() * scale
	love.graphics.draw(image, x, y, 0, scale, scale)
end

return M