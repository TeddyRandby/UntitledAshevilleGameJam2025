local M = {}

---@alias SubjectType "player" | "enemy"
---@alias AdverbType "strong" | "weak" | "very" | "fire" | "water" | "nature"
---@alias VerbType "damage" | "shield"
---@alias WordType SubjectType | AdverbType | VerbType

---@type SubjectType[]
M.SubjectTypes = { "player", "enemy" }

---@type AdverbType[]
M.AdverbTypes = { "strong", "weak", "very", "fire", "water", "nature" }

---@type VerbType[]
M.VerbTypes = { "damage", "shield" }

---@type WordType[]
M.WordTypes = {}
table.append(M.WordTypes, M.SubjectTypes)
table.append(M.WordTypes, M.VerbTypes)
table.append(M.WordTypes, M.AdverbTypes)

---@type WordType[]
M.UniformWordTypes = {}
table.append(M.UniformWordTypes, M.SubjectTypes)
table.append(M.UniformWordTypes, M.SubjectTypes)
table.append(M.UniformWordTypes, M.SubjectTypes)
table.append(M.UniformWordTypes, M.AdverbTypes)
table.append(M.UniformWordTypes, M.VerbTypes)
table.append(M.UniformWordTypes, M.VerbTypes)
table.append(M.UniformWordTypes, M.VerbTypes)

---@param word WordType
function M.isSubject(word)
  return word == "player" or word == "enemy"
end

---@param word WordType
function M.isAdverb(word)
  return word == "fire" or word == "water" or word == "nature" or word == "strong" or word == "weak" or word == "very"
end

---@param word WordType
function M.isVerb(word)
  return word == "damage"
      or word == "shield"
      or word == "fire"
      or word == "water"
      or word == "nature"
      or word == "strong"
      or word == "weak"
end

---@param word WordType
function M.wordPriority(word)
  if M.isSubject(word) then
    return 1
  elseif M.isAdverb(word) then
    return 2
  elseif M.isVerb(word) then
    return 3
  else
    assert(false, "Invalid word")
  end
end

---@param words WordType[]
function M.describe(words)
  local sorted = table.copy(words)

  table.sort(sorted, function(a, b)
    return M.wordPriority(a) < M.wordPriority(b)
  end)

  return table.concat(sorted)
end

return M
