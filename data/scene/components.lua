local M = {}

local function getSpread(n)
  local minSpread = math.rad(5)
  local maxSpread = math.rad(30)
  return minSpread + (maxSpread - minSpread) * ((n - 1) / 4)
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

return M
