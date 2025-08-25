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

function M.depth_counter(x, y, depth)
	depth = tostring(depth)
	View:sprite(DepthCounter, x, y)
	local cx = x + DepthCounterPixelW / 2 - love.graphics.getFont():getWidth(depth) / 2
	local cy = y + DepthCounterPixelH / 2 - love.graphics.getFont():getHeight() / 2
	View:text(depth, cx, cy)
end

local alphabet = "abcdefghijklmnopqrstuvwxyz"

function M.alphabet(x, y)
	---@type Component
	return function()
    View:text(alphabet, x, y)
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

		for _, v in ipairs(spell.phrases) do
			-- TODO: FIgure out why the scaling here is not the same as in UI.text
			for _, adv in ipairs(v.adverbs) do
				View:spellword(adv, spellx, spelly)
				spellx = spellx + Font:getWidth(adv.synonym) * (UI.sx() * 0.5)
			end

			if v.verb then
				View:spellword(v.verb, spellx, spelly)
				spellx = spellx + Font:getWidth(v.verb.synonym) * (UI.sx() * 0.5)
			end

			if v.subject then
				View:spellword(v.subject, spellx, spelly)
				spellx = spellx + Font:getWidth(v.subject.synonym) * (UI.sx() * 0.5)
			end
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

    View:text(damage .. "DAMAGE", infox, infoy)
    View:text(shield .. "SHIELD", infox, infoy + 40)
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
		local screenWidth = love.graphics.getWidth()
		local screenHeight = love.graphics.getHeight()
		local scale = math.min(screenWidth / map_width, screenHeight / map_height)
		local startX = (screenWidth - map_width * scale) / 2
		local startY = (screenHeight - map_height * scale) / 2
		for y = 1, map_height do
			for x = 1, map_width do
				View:tile(room.tiles[y][x], startX + (x-1)*(scale), startY + (y-1)*(scale))
			end
		end

		for _, entity in ipairs(room.entities) do
			View:entity(entity, startX + (entity.position_x-1)*scale, startY + (entity.position_y-1)*scale)
		end

		M.depth_counter(10, 10, Engine.room.depth)
	end
end

return M
