local M = {}
local anim = require("util.anim")

local function table_of_n(n)
	return table.of(n, function(thisn)
		return thisn
	end)
end

function M.create_player()
	local spritesheet = love.graphics.newImage("resources/player_anim.png")
	return anim.new(spritesheet, 32, 32, {
		idle_right = {
			frames = { {
				linha = 1,
				frames = table_of_n(28),
			} },
			frameDuration = 200 / 1000,
		},
		idle_left = {
			frames = { {
				linha = 2,
				frames = table_of_n(28),
			} },
			frameDuration = 200 / 1000,
		},
		walk_right = {
			frames = { {
				linha = 3,
				frames = table_of_n(29),
			} },
			frameDuration = 30 / 1000,
		},
		walk_left = {
			frames = { {
				linha = 4,
				frames = table_of_n(29),
			} },
			frameDuration = 30 / 1000,
		},
	})
end

---@param anima any
---@param x integer
---@param y integer
---@param scale? number
function M.draw(anima, x, y, scale)
	scale = scale or 1

	local sx, sy = UI.scale_xy()
	sx = sx * scale
	sy = sy * scale

	anima:draw(x, y, sx, sy)
end

return M
