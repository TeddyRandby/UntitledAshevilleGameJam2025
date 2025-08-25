local M = {}

local Word = require("data.word")

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

    local phrase = table.concat(
      table.map(spell.phrases, function(p)
        return table.concat(p.adverbs, " ") .. (p.verb or "") .. (p.subject or "")
      end),
      ". "
    )

    View:text(phrase, spellx, spelly)
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
				View:tile(room.tiles[y][x], x*32, y*32)
			end
		end

		for _, entity in ipairs(room.entities) do
			--local screenX, screenY  = get_screen_coords(entity.position.x, entity.position.y)
			View:text("aaaaaaaaa", entity.position.x, entity.position.y)
		end
	end
end

return M
