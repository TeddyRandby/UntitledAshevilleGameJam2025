local Shaders = require("util.shaders")
local Page = require("data.page")
local M = {}

love.graphics.setDefaultFilter("nearest", "nearest")
local PageImage = love.graphics.newImage("resources/Page.png")
--Because the page image isn't a spritesheet, we can do this
M.pixelw = PageImage:getPixelWidth()
M.pixelh = PageImage:getPixelHeight()

function M.getRealizedDim()
  return UI.realize_xy(M.getNormalizedDim())
end

function M.getNormalizedDim()
  return UI.normalize_xy(M.getPixelDim())
end

function M.getPixelDim()
  return M.pixelw, M.pixelh
end

-- local PageBG = love.graphics.newQuad(PageImageWidth * 0, 0, PageImageWidth, PageImageHeight, PageSpritesheet)
-- local PageHL = love.graphics.newQuad(PageImageWidth * 1, 0, PageImageWidth, PageImageHeight, PageSpritesheet)
-- local PageRECRUIT = love.graphics.newQuad(PageImageWidth * 2, 0, PageImageWidth, PageImageHeight, PageSpritesheet)
-- local PageREFINE = love.graphics.newQuad(PageImageWidth * 3, 0, PageImageWidth, PageImageHeight, PageSpritesheet)
-- local PageDISCOVER = love.graphics.newQuad(PageImageWidth * 4, 0, PageImageWidth, PageImageHeight, PageSpritesheet)
-- local PagePILLAGE = love.graphics.newQuad(PageImageWidth * 5, 0, PageImageWidth, PageImageHeight, PageSpritesheet)
-- local PageBD = love.graphics.newQuad(PageImageWidth * 6, 0, PageImageWidth, PageImageHeight, PageSpritesheet)

local meshargs = {
  { 0,        0,        0, 0 }, -- top-left
  { M.pixelw, 0,        1, 0 }, -- top-right
  { M.pixelw, M.pixelh, 1, 1 }, -- bottom-right
  { 0,        M.pixelh, 0, 1 }, -- bottom-left
}

-- Define 4 mesh vertices in clockwise order: top-left, top-right, bottom-right, bottom-left
-- Draw the page as a mesh so that we can perform better operations on it!
local PageMesh = love.graphics.newMesh(meshargs, "fan", "static")
local PageMeshHL = love.graphics.newMesh(meshargs, "fan", "static")
PageMesh:setTexture(PageImage)

local function deform_verts(verts, page, x, y, w, h, depth)
  -- Deform one corner by pushing it inward
  if View:is_hovering(page) then
    local ox, oy = love.mouse.getPosition()

    local cx = x + w / 2
    local cy = y + h / 2

    local dx = (ox - cx) / (w / 2)
    local dy = (oy - cy) / (w / 2)

    local function push(x, y, fx, fy)
      return x + fx * depth * dx, y + fy * depth * dy
    end

    if dx < 0 and dy < 0 then -- top-left
      verts[1][1], verts[1][2] = push(verts[1][1], verts[1][2], -1, -1)
      verts[3][1], verts[3][2] = push(verts[3][1], verts[3][2], 1, 1)
    elseif dx > 0 and dy < 0 then -- top-right
      verts[2][1], verts[2][2] = push(verts[2][1], verts[2][2], -1, -1)
      verts[4][1], verts[4][2] = push(verts[4][1], verts[4][2], 1, 1)
    elseif dx > 0 and dy > 0 then -- bottom-right
      verts[3][1], verts[3][2] = push(verts[3][1], verts[3][2], -1, -1)
      verts[1][1], verts[1][2] = push(verts[1][1], verts[1][2], 1, 1)
    elseif dx < 0 and dy > 0 then -- bottom-left
      verts[4][1], verts[4][2] = push(verts[4][1], verts[4][2], -1, -1)
      verts[2][1], verts[2][2] = push(verts[2][1], verts[2][2], 1, 1)
    end
  end

  return verts
end

---@param page Page
---@param x integer
---@param y integer
---@param r? integer
function M.draw(page, x, y, r)
  local w, h = M.getRealizedDim()

  local depth = 2
  local skew = depth / 100
  local FontHeight = love.graphics.getFont():getHeight()

  local sx, sy = UI.scale_xy()
  local fsy = View.normalize_y(View.getFontSize()) / FontHeight

  -- Update mesh vertices
  local verts = {
    { 0, 0, 0, 0 },
    { w, 0, 1, 0 },
    { w, h, 1, 1 },
    { 0, h, 0, 1 },
  }

  local cx, cy = w / 2, h / 2

  love.graphics.translate(x + cx, y + cy)
  love.graphics.rotate(r or 0)
  love.graphics.translate(-cx, -cy)

  if View:is_hovering(page) then
    love.graphics.setColor(1, 1, 1, 1)
  else
    love.graphics.setColor(28 / 255, 26 / 255, 48 / 255, 1)
  end

  deform_verts(verts, page, x, y, w, h, depth)

  PageMeshHL:setVertices(verts)
  PageMesh:setVertices(verts)

  Shaders.pixel_scanline(x, y, w, h, sx, sy, r or 0)

  if Engine:playable_page(page) then
    love.graphics.draw(
      PageMeshHL,
      -UI.realize_x(UI.normalize_x(1)),
      -UI.realize_y(UI.normalize_y(1)),
      0,
      (M.pixelw + 2) / M.pixelw,
      (M.pixelh + 2) / M.pixelh
    )
  end

  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(PageMesh)
  Shaders.reset()

  local xshear, yshear = nil, nil
  local ox, oy = love.mouse.getPosition()

  if View:is_hovering(page) then
    xshear, yshear = 0, 0

    local cx = x + w / 2
    local cy = y + h / 2

    local dx = (ox - cx) / (w / 2)
    local dy = (oy - cy) / (w / 2)

    if dx < 0 and dy < 0 then
      xshear = skew * dx
      yshear = skew * dy
    elseif dx < 0 and dy > 0 then
      xshear = skew * -dx * dy
      yshear = skew * dy
    elseif dx > 0 and dy < 0 then
      xshear = skew * dx
      yshear = skew * -dy * dx
    else
      xshear = skew * -dx
      yshear = skew * -dy
    end
  end

  if xshear and yshear then
    love.graphics.translate(ox - x, oy - y)

    -- Apply skew and scale
    love.graphics.shear(xshear, yshear)

    -- Move back so sprite is drawn in correct position
    love.graphics.translate(-(ox - x), -(oy - y))
  end

  local _, realh = M.getRealizedDim()

  love.graphics.setColor(0, 0, 0)
  UI.text.draw(10, h / 4, Page.describe(page), 30)

  if xshear and yshear then
    love.graphics.translate(ox - x, oy - y)

    -- Apply skew and scale
    love.graphics.shear(xshear, yshear)

    -- Move back so sprite is drawn in correct position
    love.graphics.translate(-(ox - x), -(oy - y))
  end

  love.graphics.setColor(1, 0, 0)
  UI.text.draw(10, h / 4, Page.describe(page), 30)
end

return M
