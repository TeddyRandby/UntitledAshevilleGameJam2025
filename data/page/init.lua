local M = {}

local Word = require("data.word")

---@class Page
---@field words WordType[]
---@field name string

---@param n integer
---@param dst? table
---@return SubjectType[]
function M.subject(n, dst)
  return table.replacement_sample(Word.SubjectTypes, n, dst)
end

---@param n integer
---@param dst? table
---@return AdverbType[]
function M.adverb(n, dst)
  return table.replacement_sample(Word.AdverbTypes, n, dst)
end

---@param n integer
---@param dst? table
---@return VerbType[]
function M.verb(n, dst)
  return table.replacement_sample(Word.VerbTypes, n, dst)
end

---@param n integer
---@param dst? table
---@return WordType[]
function M.word(n, dst)
  return table.replacement_sample(Word.UniformWordTypes, n, dst)
end

---@param n integer
function M.create_uniform(n)
  local words = M.word(n)
  print(table.unpack(words))
  ---@type Page
  return {
    name = "",
    words = words,
  }
end

---@param sub integer
---@param adv integer
---@param vrb integer
function M.create(sub, adv, vrb)
  local subjects = M.subject(sub)
  local adverbs = M.adverb(adv)
  local verbs = M.verb(vrb)
  local words = {}
  table.append(words, subjects)
  table.append(words, adverbs)
  table.append(words, verbs)

  ---@type Page
  return {
    name = "",
    words = words,
  }
end

---@param page Page
function M.describe(page)
  return table.concat(page.words, " ")
end

---@param page Page
function M.hasSubject(page)
  return not not table.find(page.words, function(w)
    Word.isSubject(w)
  end)
end

---@param page Page
function M.hasAdverb(page)
  return not not table.find(page.words, function(w)
    Word.isAdverb(w)
  end)
end

---@param page Page
function M.hasVerb(page)
  return not not table.find(page.words, function(w)
    Word.isVerb(w)
  end)
end

return M
