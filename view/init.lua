local flux = require("util.flux")

---@alias UserEvent "click" | "dragstart" | "dragend" | "receive"

---@alias UserEventHandler table<UserEvent, function>

---@class Dragging
---@field ox integer
---@field oy integer
---@field target RenderCommandTarget

---@class RenderPosition
---@field x integer
---@field y integer
---@field r number
---@field scale number
---@field tween? unknown
---@field cx? integer
---@field cy? integer

---@class View
---@field user_event_handlers table<RenderCommandTarget, UserEventHandler>
---@field last_frame_commands RenderCommand[]
---@field commands RenderCommand[]
---@field dragging Dragging?
---@field command_target_positions table<RenderCommandTarget, RenderPosition>
local M = {
	user_event_handlers = {},
	last_frame_commands = {},
	last_frame_deferred = {},
	command_target_positions = {},
	commands = {},
	deferred = {},
}

---@param o RenderCommandTarget
---@param x integer
---@param y integer
---@param ox? integer
---@param oy? integer
--- Begin dragging game object o, with offset ox and oy into the sprite.
function M:begin_drag(o, x, y, ox, oy)
	self.dragging = {
		target = o,
		ox = ox or 0,
		oy = oy or 0,
	}

	self:__fire(o, "dragstart", x, y)
end

function M.getFontSize()
	return 0.03
end

---@param x integer
---@param y integer
function M:end_drag(x, y)
	assert(self.dragging ~= nil)

	self:__fire(self.dragging.target, "dragend", x, y)

	local dragged_to = self:hover(x, y, function(rc)
		return self:receivable(rc.target)
	end)

	if dragged_to then
		self:__fire(dragged_to.target, "receive", x, y, self.dragging.target)
	end

	self.dragging = nil
end

---@param t RenderCommandTarget
---@param x integer
---@param y integer
function M:click(t, x, y)
	self:__fire(t, "click", x, y)
end

---@param o? RenderCommandTarget
---@return boolean
function M:is_dragging(o)
	-- print("DRAGGING " .. tostring(o) .. "?")
	if o then
		return self.dragging ~= nil and self.dragging.target == o
	else
		return self.dragging ~= nil
	end
end

---@param id? unknown
---@return boolean, boolean
function M:is_hovering(id)
	local x, y = love.mouse.getPosition()

	local hover = self:contains(x, y)

	local hovered_at_all = not not table.find(hover, function(t)
		return t.id == id
	end)

	local hovered_on_top = hovered_at_all and table.pop(hover).target == id

	return hovered_on_top, hovered_at_all
end

local UI = require("ui")

---@alias RenderCommandTarget any

---@param id unknown
---@param hs? table<UserEvent, function>
function M:register(id, hs)
	assert(self.user_event_handlers ~= nil)
	self.user_event_handlers[id] = hs
end

---@param id unknown
---@param e UserEvent
---@param x integer
---@param y integer
---@param data? any
function M:__fire(id, e, x, y, data)
	local hs = self.user_event_handlers[id]

	if not hs or not hs[e] then
		return
	end

	print("[USEREVENT]", id.type, e, x, y, data)
	hs[e](x, y, data)
end

---@alias RenderCommandType "button" | "text" | "page" | "word"

---@param id unknown
function M:draggable(id)
	---@return boolean
	local hs = self.user_event_handlers[id]
	return hs and not not (hs["dragstart"] or hs["dragend"])
end

---@param id unknown
---@return boolean
function M:clickable(id)
	local hs = self.user_event_handlers[id]
	return hs and not not hs["click"]
end

---@param id unknown
---@return boolean
function M:receivable(id)
	local hs = self.user_event_handlers[id]
	return hs and not not hs["receive"]
end

---@param id unknown
function M:bringtotop(id)
	self.deferred[id] = true
end

---@class RenderCommand
---@field type RenderCommandType
---@field target unknown
---@field id unknown
---@field contains? fun(self: RenderCommand, x: integer, y: integer): boolean

---@param n number
---@param max integer
---@return integer
local function normalize_dim(n, max)
	if n > 1 then
		return n
	end

	if n < -1 then
		return n
	end

	if n >= 0 then
		return math.floor(n * max)
	end

	return max * (1 + n)
end

function M.normalize_x(x)
	return normalize_dim(x, love.graphics.getWidth())
end

function M.normalize_y(y)
	return normalize_dim(y, love.graphics.getHeight())
end

---@param x number
---@param y number
---@return integer, integer
function M.normalize_xy(x, y)
	return M.normalize_x(x), M.normalize_y(y)
end

local function rect_collision(x, y, rx, ry, rw, rh)
	local l, r, b, t = rx, rx + rw, ry, ry + rh
	return x > l and x < r and y > b and y < t
end

---@param self RenderCommand
---@param x integer
---@param y integer
local function text_contains(self, x, y)
	local h = love.graphics.getFont():getHeight()
	local w = love.graphics.getFont():getWidth(self.target)
	local pos = M.command_target_positions[self.id]
	assert(pos ~= nil)
	return rect_collision(x, y, pos.x, pos.y, w, h)
end

---@param self RenderCommand
---@param x integer
---@param y integer
local function button_contains(self, x, y)
	local w, h = UI.button.getRealizedDim()
	local ops = M.command_target_positions[self.id]
	assert(ops ~= nil)
	return rect_collision(x, y, ops.x, ops.y, w, h)
end

---@param self RenderCommand
---@param x integer
---@param y integer
local function page_contains(self, x, y)
	local ops = M.command_target_positions[self.id]
	assert(ops ~= nil)
	local pagew, pageh = UI.page.getRealizedDim()

	local cx = ops.x + pagew / 2
	local cy = ops.y + pageh / 2
	local dx = x - cx
	local dy = y - cy

	local angle = ops.r or 0
	local cos_r = math.cos(-angle)
	local sin_r = math.sin(-angle)

	local localx = cos_r * dx - sin_r * dy + pagew / 2
	local localy = sin_r * dx + cos_r * dy + pageh / 2
	return rect_collision(localx, localy, 0, 0, pagew, pageh)
end

---@class RenderableOptions
---@field drag? fun(x: integer, y: integer)
---@field click? fun(x: integer, y: integer)

---@param type RenderCommandType
---@param target unknown
---@param id unknown
---@param contain_f? function
---@param x integer
---@param y integer
---@param r? integer
---@param ox? integer
---@param oy? integer
---@param time? number
---@param delay? number
---@param scale? number
function M:push_renderable(type, target, id, contain_f, x, y, r, ox, oy, time, delay, scale)
	local existing = self.command_target_positions[id]

	scale = scale or 1
	time = time or 0.2
	delay = delay or 0
	r = r or 0

	x, y = M.normalize_xy(x, y)

	if not existing then
		existing = { x = ox and M.normalize_x(ox) or x, y = oy and M.normalize_y(oy) or y, r = r or 0, scale = scale }
		self.command_target_positions[id] = existing
	else
		-- This version fixes card bug but creates slow-feeling ui
		if not existing.tween then
			if existing.x ~= x or existing.y ~= y or existing.r ~= r or existing.scale ~= scale then
				-- if existing.x ~= x then
				-- 	print("[TWEENX]", existing.x, x)
				-- end
				--
				-- if existing.y ~= y then
				-- 	print("[TWEENY]", existing.y, y)
				-- end
				--
				-- if existing.r ~= r then
				-- 	print("[TWEENR]", existing.r, r)
				-- end
				--
				-- if existing.scale ~= scale then
				-- 	print("[TWEENS]", existing.scale, scale)
				-- end

				existing.tween = flux
					.to(existing, time, { x = x, y = y, r = r, scale = scale })
					:ease("sineinout") -- Experiement with the easing function
					:delay(delay)
					:oncomplete(function()
						print("[COMPLETETWEEN]", id, x, y, r, scale)
						existing.tween = nil
					end)
			end
		end

		-- This version feels faster but creates visual bug issues
		-- if existing.tween then
		--   existing.tween:stop()
		-- end
		--
		-- existing.tween = flux.to(existing, time or 0.14, { x = x, y = y, r = r or 0 }):ease("cubicout") -- Experiement with the easing function
	end

	table.insert(self.commands, {
		type = type,
		target = target,
		id = id,
		contains = contain_f,
	})
end

---@param id unknown
function M:cancel_tween(id)
	local existing = self.command_target_positions[id]
	if existing and existing.tween then
		existing.tween:stop()
		existing.tween = nil
	end
end

---@param x integer
---@param y integer
---@patam t string
---@param f function
---@param id? unknown
function M:button(x, y, t, f, id)
	self:push_renderable("button", t, id or f, button_contains, x, y)
	self:register(t, { click = f })
end

---@param text string
---@param x integer
---@param y integer
function M:text(text, x, y)
	self:push_renderable("text", text, {}, text_contains, x, y)
end

---@param word Word
---@param x integer
---@param y integer
---@param r? integer
---@param ox? integer
---@param oy? integer
---@param t? number
---@param delay? number
function M:word(word, x, y, r, ox, oy, t, delay)
  assert(word ~= nil)
  self:push_renderable("word", word, word, nil, x, y, r, ox, oy, t, delay)
end

---@param page Page
---@param x integer
---@param y integer
---@param r? integer
---@param ox? integer
---@param oy? integer
---@param t? number
---@param delay? number
function M:page(page, x, y, r, ox, oy, t, delay)
	-- Is there a better way to do this, with meta tables?
	self:push_renderable("page", page, page, page_contains, x, y, r, ox, oy, t, delay)
  local thisx, thisy = x, y
  local pagew, pageh = UI.page.getRealizedDim()
	for _, word in ipairs(page.words) do
    self:word(word, thisx, thisy, r, ox, oy, t, delay)
    self:bringtotop(word)
    -- The scuffed nature of this causes the words to look jumpy
    -- on the page as they move.
    self.command_target_positions[word].cx = x + pagew / 2
    self.command_target_positions[word].cy = y + pageh / 2
    thisy = thisy + 40
	end
end

function M:tile(tile, x, y)
	self:push_renderable("tile", tile, {}, nil, x, y)
end

---@param x integer
---@param y integer
---@param f? fun(c: RenderCommand): boolean
---@return RenderCommand?
function M:hover(x, y, f)
	return table.pop(self:contains(x, y, f))
end

---@param x integer
---@param y integer
---@param f? fun(c: RenderCommand): boolean
---@return RenderCommand[]
function M:contains(x, y, f)
	if f then
		return table.filter(self.last_frame_commands, function(v)
			if v.contains then
				return v:contains(x, y) and f(v)
			else
				return false
			end
		end)
	else
		return table.filter(self.last_frame_commands, function(v)
			if v.contains then
				return v:contains(x, y)
			else
				return false
			end
		end)
	end
end

---@param c RenderCommand
function M:pos(c)
	return self.command_target_positions[c.id]
end

---@param id RenderCommandTarget
function M:post(id)
	return self.command_target_positions[id]
end

function M:__drawcommand(v)
	local t = v.type

	love.graphics.push()
	if t == "text" then
		---@type string
		local text = v.target
		assert(text ~= nil)
		local pos = self.command_target_positions[v.id]
		UI.text.draw(pos.x, pos.y, text)
  	elseif t == "page" then
		local pos = self.command_target_positions[v.id]
		UI.page.draw(v.target, pos.x, pos.y, pos.r)
  	elseif t == "tile" then
		local pos = self.command_target_positions[v.id]
		UI.tile.draw(v.target, pos.x, pos.y)
	elseif t == "page" then
		local pos = self.command_target_positions[v.id]
		UI.page.draw(v.target, pos.x, pos.y, pos.r)
	elseif t == "word" then
		---@type Word
		local word = v.target
		local pos = self.command_target_positions[v.id]
		UI.text.draw(pos.x, pos.y, word.synonym, pos.r, nil, nil, pos.cx, pos.cy)
	elseif t == "button" then
		local pos = self.command_target_positions[v.id]
		UI.button.draw(pos.x, pos.y, v.target)
	else
		assert(false, "Unhandled case")
	end

	love.graphics.pop()
end

-- TODO: Updating dragging positions *here* causes some real confusing behavior.
function M:draw()
	-- Update position of dragged elements to match mouse
	if View:is_dragging() then
		assert(View.dragging ~= nil)

		local pos = View.command_target_positions[View.dragging.target]
		assert(pos ~= nil)

		local mousex, mousey = love.mouse.getPosition()
		local x = mousex - View.dragging.ox
		local y = mousey - View.dragging.oy
		pos.x = x
		pos.y = y
	end

	local deferred = {}

	for _, v in ipairs(self.commands) do
		if self.deferred[v.id] then
			table.insert(deferred, v)
		else
			self:__drawcommand(v)
		end
	end

	for _, v in ipairs(deferred) do
		self:__drawcommand(v)
	end

	self.last_frame_commands = self.commands
	table.append(self.last_frame_commands, deferred)
	self.commands = {}
	self.deferred = {}
end

return M
