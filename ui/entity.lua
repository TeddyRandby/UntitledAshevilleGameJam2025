local M = {}

local PlayerImage = love.graphics.newImage("resources/ButterEnemy.png")
local ShrineImage = love.graphics.newImage("resources/Shrine.png")

local function translate(tile)
	if tile.type == "player" then
		return PlayerImage
	elseif string.find(tile.type, "shrine") then
		return ShrineImage
	else
		return PlayerImage
	end
end

function M.draw(entity, x, y, scale)
	local image = translate(entity)

	scale = UI.sx() * scale
	love.graphics.draw(image, x, y, 0, scale, scale)
end

return M