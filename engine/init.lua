local Scene = require("data.scene")
local Page = require("data.page")
local Word = require("data.word")

---@class SpellPhrase
---@field adverbs AdverbType[]
---@field subject SubjectType
---@field verb VerbType

---@class Spell
---@field subjects SubjectType[]
---@field phrases SpellPhrase[]

---@class Enemy
---@field spell Spell

local empty_spell = {
  adverb_exponent = 1,
  subjects = {},
  phrases = {},
  words = {},
}

---@class Engine
---@field scenes Scene[]
---@field scene_buffer Scene[]
---@field rng love.RandomGenerator
---@field time integer
---@field enemy Enemy
---@field player_spell_state "start" | "adverb" | "verb"
---@field player_spell_queue WordType[]
---@field player_spell Spell
---@field player_hand Page[]
---@field player_dictionary table<string, boolean>
local M = {
  time = 0,
  --- The actual stack of scenes.
  scene_stack = {},
  --- A temporary buffer of scenes, queued by components, to be entered
  --- after processing this frame.
  scene_buffer = {},

  enemy = {
    spell = empty_spell,
  },

  --- The list of pages in the players hand
  player_hand = {},

  --- The spell being incanted by the player
  player_spell = empty_spell,

  --- A list of letters the player has learned
  player_dictionary = {},

  player_spell_queue = {},
  player_spell_state = "start",
}

---@param f fun(phrase: SpellPhrase)
function M:_modifyphrases(f)
  for _, p in ipairs(self.player_spell.phrases) do
    f(p)
  end
end

--@param charset string
function M:learn(charset)
  for i = 1, #charset do
    local c = charset:sub(i, i)
    self.player_dictionary[c] = true
  end
end

---@param word WordType
function M:play_word(word)
  if self.player_spell_state == "start" then
    assert(Word.isVerb(word) or Word.isAdverb(word))

    if Word.isAdverb(word) then
      table.insert(self.player_spell.phrases, {
        adverbs = { word },
      })

      self.player_spell_state = "adverb"
    elseif Word.isVerb(word) then
      table.insert(self.player_spell.phrases, {
        adverbs = {},
        verb = word,
      })

      self.player_spell_state = "verb"
    end
  elseif self.player_spell_state == "adverb" then
    local phrase = table.peek(self.player_spell.phrases)
    assert(phrase ~= nil)

    if Word.isSubject(word) then
      local verb = table.pop(phrase.adverbs)
      assert(verb ~= nil and Word.isVerb(verb))

      ---@diagnostic disable-next-line: assign-type-mismatch
      phrase.verb = verb
      ---@diagnostic disable-next-line: assign-type-mismatch
      phrase.subject = word
      self.player_spell_state = "start"
    elseif Word.isAdverb(word) then
      table.insert(phrase.adverbs, word)
    elseif Word.isVerb(word) then
      ---@diagnostic disable-next-line: assign-type-mismatch
      phrase.verb = word

      self.player_spell_state = "verb"
    end
  elseif self.player_spell_state == "verb" then
    assert(Word.isSubject(word))
    local phrase = table.peek(self.player_spell.phrases)
    assert(phrase ~= nil)

    ---@diagnostic disable-next-line: assign-type-mismatch
    phrase.subject = word

    self.player_spell_state = "start"
  else
    assert(false, "Invalid state")
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
function M:cast_phrase(phrase)
  print(table.concat(phrase.adverbs, "-"), phrase.verb, phrase.subject)
end

function M:enemy_cast()
  for _, p in ipairs(self.enemy.spell.phrases) do
    M:cast_phrase(p)
  end
end

function M:player_cast()
  if self.player_spell_state ~= "start" then
    -- Pop the incomplete spell
    table.pop(self.player_spell.phrases)
  end

  for _, p in ipairs(self.player_spell.phrases) do
    M:cast_phrase(p)
  end

  self.player_spell = {
    adverb_exponent = 1,
    subjects = {},
    phrases = {},
  }
end

--- Play the ith page in the players hand.
---@param i integer
function M:play(i)
  local page = table.remove(self.player_hand, i)
  assert(page ~= nil, "invalid page index")

  self:play_page(page)
end

---@param page Page
function M:playable_page(page)
  local word = page.words[1]

  if self.player_spell_state == "start" then
    return Word.isAdverb(word) or Word.isVerb(word)
  elseif self.player_spell_state == "adverb" then
    local prev = table.peek(table.peek(self.player_spell.phrases).adverbs)
    return prev and Word.isVerb(prev) or not Word.isSubject(word)
  elseif self.player_spell_state == "verb" then
    return Word.isSubject(word)
  else
    assert(false, "Invalid player spell state")
  end
end

function M:playable(i)
  local page = self.player_hand[i]
  assert(page ~= nil, "invalid page index")
  return M:playable_page(page)
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

  self:learn("abcdefghijklmnopqrstuvwxyz")

  table.insert(self.player_hand, Page.create(1, 0, 0))
  table.insert(self.player_hand, Page.create(1, 1, 0))
  table.insert(self.player_hand, Page.create(0, 1, 1))
  table.insert(self.player_hand, Page.create(0, 1, 1))
  table.insert(self.player_hand, Page.create(1, 1, 0))
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
