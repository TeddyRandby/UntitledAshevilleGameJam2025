local Scene = require("data.scene")
local Page = require("data.page")
local Room = require("data.room")
local Entity = require("data.entity")

---@class SpellPhrase
---@field type "damage" | "shield" | "status"
---@field value number

---@class Spell
---@field subjects SubjectType[]
---@field phrases SpellPhrase[]
---@field element? "fire" | "water" | "nature"

---@class Engine
---@field scenes Scene[]
---@field scene_buffer Scene[]
---@field rng love.RandomGenerator
---@field time integer
---@field player_spell Spell
---@field player_hand Page[]
local M = {
  time = 0,
  --- The actual stack of scenes.
  scene_stack = {},
  --- A temporary buffer of scenes, queued by components, to be entered
  --- after processing this frame.
  scene_buffer = {},

  --- The list of pages in the players hand
  player_hand = {},

  player_spell = {
    subjects = {},
    phrases = {},
  },

  room = {},
  player = {},
}

---@param f fun(phrase: SpellPhrase)
function M:_modifyphrases(f)
  for _, p in ipairs(self.player_spell.phrases) do
    f(p)
  end
end

---@param word WordType
function M:play_word(word)
  if word == "player" or word == "enemy" then
    table.insert(self.player_spell.subjects, word)
  elseif word == "strong" then
    self:_modifyphrases(function(p)
      print("[ADVERB]", word, p.type, p.value, "=>", p.value * 2)
      p.value = p.value * 2
    end)
  elseif word == "weak" then
    self:_modifyphrases(function(p)
      print("[ADVERB]", word, p.type, p.value, "=>", p.value / 2)
      p.value = p.value / 2
    end)
  elseif word == "damage" then
    ---@type SpellPhrase
    local phrase = { type = "damage", value = 10 }

    table.insert(self.player_spell.phrases, phrase)
  elseif word == "shield" then
    ---@type SpellPhrase
    local phrase = { type = "shield", value = 10 }

    table.insert(self.player_spell.phrases, phrase)
  elseif word == "fire" then
    self.player_spell.element = "fire"

    ---@type SpellPhrase
    local phrase = { type = "status", value = 1 }

    table.insert(self.player_spell.phrases, phrase)
  elseif word == "water" then
    self.player_spell.element = "water"

    ---@type SpellPhrase
    local phrase = { type = "status", value = 1 }

    table.insert(self.player_spell.phrases, phrase)
  elseif word == "nature" then
    self.player_spell.element = "nature"

    ---@type SpellPhrase
    local phrase = { type = "status", value = 1 }

    table.insert(self.player_spell.phrases, phrase)
  end
end

---Play the page for the player.
---@param page Page
function M:play_page(page)
  for _, word in ipairs(page.words) do
    self:play_word(word)
  end
  print("[PAGE]", table.unpack(page.words))
end

---@param phrase SpellPhrase
---@param subjects SubjectType[]
function M:cast_phrase(phrase, subjects)
  if phrase.type == "damage" then
    print("[INCANT]", "damage", phrase.value, "=>", table.unpack(subjects))
  elseif phrase.type == "shield" then
    print("[INCANT]", "shield", phrase.value, "=>", table.unpack(subjects))
  elseif phrase.type == "status" then
    print("[INCANT]", "status", phrase.value, "=>", table.unpack(subjects))
  end
end

---@param spell Spell
function M:cast(spell)
  for _, p in ipairs(spell.phrases) do
    M:cast_phrase(p, spell.subjects)
  end
end

--- Play the ith page in the players hand.
---@param i integer
function M:play(i)
  local page = table.remove(self.player_hand, i)
  assert(page ~= nil, "invalid page index")

  self:play_page(page)
end

---@param scene SceneType
---@param data any
function M:scene_push(scene, data)
  local template = Scene[scene]
  assert(template ~= nil, "Unknown scene: " .. scene)
  template = table.copy(template)
  template.data = data
  table.insert(self.scene_buffer, template)
end

---@return Scene
function M:current_scene()
  local scene = table.peek(self.scene_stack)
  assert(scene ~= nil, "Missing scene")
  return scene
end

--- Rewind to the previous scene.
function M:scene_rewind()
  local scene = table.pop(self.scene_stack)

  if scene ~= nil then
    print("REWIND OVER .. ", scene)
  end

  if scene ~= "settling" then
    -- self:__enterscene(self:current_scene())
  end
end

---@param scene SceneType
function M:scene_rewindto(scene)
  repeat
    local popped_scene = table.pop(self.scene_stack)

    if popped_scene ~= nil then
      print("REWINDTO OVER .. ", popped_scene)
      -- self:__exitscene(popped_scene)
    end
  until self:current_scene() == scene

  -- self:__enterscene(self:current_scene())
end


function M:load()
  self.rng = love.math.newRandomGenerator(os.clock())
  table.insert(self.scene_stack, Scene.main)
  for _ = 0, 4 do
    table.insert(self.player_hand, Page.create(1, 1, 1))
  end

    self.player = Entity.create("player")
  self.room = Room.create("basic", self.player)

end

---@param dt number
function M:update(dt)
  self.time = self.time + dt

  local scene = table.peek(self.scene_stack)

  assert(scene ~= nil, "No scene found!")
  assert(#scene.layout ~= 0, "No components in scene")

  for _, component in ipairs(scene.layout) do
    component()
  end

  if #self.scene_buffer > 0 then
    table.append(self.scene_stack, self.scene_buffer)
    self.scene_buffer = {}
  end
end

return M
