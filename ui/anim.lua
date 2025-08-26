local M = {}
local anim = require("util.anim")

local function table_of_n(n)
	return table.of(n, function(thisn)
		return thisn
	end)
end

local exp_ss = love.graphics.newImage("resources/Explosion.png")
---@param oncomplete  function
function M.create_explosion(oncomplete)
	local animation = anim.new(exp_ss, 32, 32, {
		explode = {
			frames = { {
				linha = 1,
				frames = table_of_n(6),
			} },
			frameDuration = 100 / 1000,
		},
	}, nil, oncomplete)

	animation:setAnimation("explode")

	return animation
end

local page_ss = love.graphics.newImage("resources/pageDrop.png")
function M.create_pagedrop()
	local animation = anim.new(page_ss, 16, 16, {
		idle = {
			frames = { {
				linha = 1,
				frames = table_of_n(16),
			} },
			frameDuration = 100 / 1000,
		},
	})

	animation:setAnimation("idle")

	return animation
end
local butter_ss = love.graphics.newImage("resources/ButterEnemy.png")
function M.create_butterenemy()
	local animation = anim.new(butter_ss, 32, 32, {
		idle = {
			frames = { {
				linha = 1,
				frames = table_of_n(5),
			} },
			frameDuration = 180 / 1000,
		},
	})

	animation:setAnimation("idle")

	return animation
end

local flour_ss  = love.graphics.newImage("resources/FlourEnemy.png")
function M.create_flourenemy()
	local animation = anim.new(flour_ss, 32, 32, {
		idle = {
			frames = { {
				linha = 1,
				frames = table_of_n(9),
			} },
			frameDuration = 180 / 1000,
		},
	})

	animation:setAnimation("idle")

	return animation
end

local milk_ss  = love.graphics.newImage("resources/MilkEnemy.png")
function M.create_milkenemy()
	local animation = anim.new(milk_ss, 32, 32, {
		idle = {
			frames = { {
				linha = 1,
				frames = table_of_n(5),
			} },
			frameDuration = 180 / 1000,
		},
	})

	animation:setAnimation("idle")

	return animation
end

local player_ss = love.graphics.newImage("resources/player_anim.png")
function M.create_player()
	return anim.new(player_ss, 32, 32, {
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
    cast = {
      frames = {{
        linha = 5,
        frames = table_of_n(27),
      }},
			frameDuration = 100 / 1000,
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
