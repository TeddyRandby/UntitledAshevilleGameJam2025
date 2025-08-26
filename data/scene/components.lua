local Word = require("ui.word")
local M = {}

local HealthbarSpritesheet = love.graphics.newImage("resources/HealthbarSpritesheet.png")
local HealthbarSpritesheetPixelW = 32
local HealthbarSpritesheetPixelH = 32

local HealthbarFull = love.graphics.newQuad(
	HealthbarSpritesheetPixelW * 0,
	0,
	HealthbarSpritesheetPixelW,
	HealthbarSpritesheetPixelH,
	HealthbarSpritesheet
)
local HealthbarTwoThirds = love.graphics.newQuad(
	HealthbarSpritesheetPixelW * 1,
	0,
	HealthbarSpritesheetPixelW,
	HealthbarSpritesheetPixelH,
	HealthbarSpritesheet
)
local HealthbarOneThird = love.graphics.newQuad(
	HealthbarSpritesheetPixelW * 2,
	0,
	HealthbarSpritesheetPixelW,
	HealthbarSpritesheetPixelH,
	HealthbarSpritesheet
)
local HealthbarEmpty = love.graphics.newQuad(
	HealthbarSpritesheetPixelW * 3,
	0,
	HealthbarSpritesheetPixelW,
	HealthbarSpritesheetPixelH,
	HealthbarSpritesheet
)

local DepthCounter = love.graphics.newImage("resources/DepthCounter.png")
local DepthCounterPixelW = 64
local DepthCounterPixelH = 64

function M.depth_counter(x, y)
	return function()
		local depthx, depthy = UI.realize_xy(x, y)
		local depth = Engine.room.depth
		depth = tostring(depth)
		View:sprite(DepthCounter, depthx, depthy)
		local cx = depthx + DepthCounterPixelW * UI.sx() / 3
		local cy = depthy + DepthCounterPixelH * UI.sy() / 3
		View:text(depth, cx, cy)
	end
end

function M.alphabet(x, y)
	---@type Component
	return function()
		local thisx, thisy = UI.realize_xy(x, y)
		for i = 1, #Engine.player_alphabet do
			local letter = Engine.player_alphabet:sub(i, i)
			View:text(letter, thisx, thisy, 0.8)
			thisx = thisx + Font:getWidth(letter) * (UI.sx() * 0.8)
		end
	end
end

---@param f fun(): number -- A function which returns how relatively healthy this bar should be
function M.healthbar(x, y, f)
	---@type Component
	return function()
		local relative_health = f()
		if relative_health >= 1 then
			View:spriteOf(HealthbarFull, HealthbarSpritesheet, x, y)
		elseif relative_health >= 0.65 then
			View:spriteOf(HealthbarTwoThirds, HealthbarSpritesheet, x, y)
		elseif relative_health >= 0.32 then
			View:spriteOf(HealthbarOneThird, HealthbarSpritesheet, x, y)
		else
			View:spriteOf(HealthbarEmpty, HealthbarSpritesheet, x, y)
		end
	end
end

local function getSpread(n)
	local minSpread = math.rad(5)
	local maxSpread = math.rad(30)
	return minSpread + (maxSpread - minSpread) * ((n - 1) / 4)
end

---@param x integer
---@param y integer
---@param f fun(): Spell
function M.spell_in_progress(x, y, f)
	---@type Component
	return function()
		local spellx, spelly = UI.realize_xy(x, y)

		local spell = f()
		local thisy = spelly

		print("LOADING " .. #spell.phrases .. " PHRASES")
		for _, v in ipairs(spell.phrases) do
			local thisx = spellx

			for _, adv in ipairs(v.adverbs) do
				View:spellword(adv, thisx, thisy)
				thisx = thisx + Font:getWidth(adv.synonym) * (UI.sx() * Word.spellword_scale())
			end

			if v.verb then
				View:spellword(v.verb, thisx, thisy)
				thisx = thisx + Font:getWidth(v.verb.synonym) * (UI.sx() * Word.spellword_scale())
			end

			if v.subject then
				View:spellword(v.subject, thisx, thisy)
				thisx = thisx + Font:getWidth(v.subject.synonym) * (UI.sx() * Word.spellword_scale())
			end

			thisy = thisy + UI.sy() * 16 * Word.spellword_scale()
		end
	end
end

---@param x integer
---@param y integer
---@param f fun(): number, number
function M.battle_info(x, y, f)
	---@type Component
	return function()
		local infox, infoy = UI.realize_xy(x, y)
		local damage, shield = f()

		local txt = damage .. "DAMAGE\n" .. shield .. "SHIELD"
		View:text(txt, infox, infoy, 0.5)
	end
end

---@param x integer
---@param y integer
---@param page_ueh? fun(i: integer, v: Page): UserEventHandler
function M.hand(x, y, page_ueh)
	---@type Component
	return function()
		local handx = UI.realize_x(x)
		local handy = UI.realize_y(y)

		local w, h = UI.page.getRealizedDim()

		local pages = Engine.player_hand

		local n = #pages
		local spread = getSpread(n)
		local spacing = -(h / 5)

		local anglestep = n == 1 and 0 or spread / math.max(n - 1, 1)
		local startAngle = -spread / 2

		for i, v in ipairs(pages) do
			local angle = startAngle + (i - 1) * anglestep

			-- Dip based on rotation: more rotated pages are lower
			local dip = math.pow(angle, 2) * h * 2

			local thisx = handx + (spacing * (i - 1)) + (w * (i - 1))
			local thisy = handy + dip

			if View:is_hovering(v) then
				View:bringtotop(v)
				thisy = thisy - h / 4 - dip
				angle = 0
			end

			View:page(v, thisx, thisy, angle, nil, nil, 0.4)

			if page_ueh then
				View:register(v, page_ueh(i, v))
			end
		end
	end
end

function M.room()
	---@type Component
	return function()
		local room = Engine.room
		local map_width = #room.tiles[1]
		local map_height = #room.tiles

		local scale = UI.sx() * 32

		local totalw = scale * map_width
		local totalh = scale * map_height
		local startX = (love.graphics.getWidth() - totalw) / 2
		local startY = (love.graphics.getHeight() - totalh) / 2
		for y = 1, map_height do
			for x = 1, map_width do
				View:tile(room.tiles[y][x], startX + (x - 1) * scale, startY + (y - 1) * scale)
			end
		end

		for _, entity in reversedipairs(room.entities) do
			if entity.anim then
				View:anim(
					entity.anim,
					startX + (entity.position_x - 1) * scale,
					startY + (entity.position_y - 1) * scale
				)
			else
				View:entity(entity, startX + (entity.position_x - 1) * scale, startY + (entity.position_y - 1) * scale)
			end
		end
	end
end

return M
