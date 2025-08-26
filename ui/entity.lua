
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

  function M.draw(entity, x, y)
    local image = translate(entity)

    local scale = UI.sx()
	love.graphics.draw(
		image,
		x,
		y,
        0,
        scale,
        scale
	)

    love.graphics.rectangle("line", x, y, scale*32*entity.w,  scale*32*entity.h)
  end
return M