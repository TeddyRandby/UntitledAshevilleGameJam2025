local M = {}

---@alias SubjectType "player" | "enemy"
---@alias AdverbType "strong" | "weak" | "precise" | "clumsy" | "fire" | "water" | "nature"
---@alias VerbType "damage" | "shield"
---@alias WordType SubjectType | AdverbType | VerbType

---@class Page
---@field subjects SubjectType[]
---@field adverbs AdverbType[]
---@field verbs VerbType[]
---@field words WordType[]
---@field name string

---@type SubjectType[]
M.SubjectTypes = { "player", "enemy" }

---@type AdverbType[]
M.AdverbTypes = { "strong", "weak", "precise", "clumsy", "fire", "water", "nature" }

---@type VerbType[]
M.VerbTypes = { "damage", "shield" }

---@type WordType[]
M.WordTypes = {}
table.append(M.WordTypes, M.SubjectTypes)
table.append(M.WordTypes, M.VerbTypes)
table.append(M.WordTypes, M.AdverbTypes)

---@type WordType[]
M.UniformWordTypes = {}
table.append(M.WordTypes, M.SubjectTypes)
table.append(M.WordTypes, M.SubjectTypes)
table.append(M.WordTypes, M.SubjectTypes)
table.append(M.WordTypes, M.SubjectTypes)
table.append(M.WordTypes, M.AdverbTypes)
table.append(M.WordTypes, M.VerbTypes)
table.append(M.WordTypes, M.VerbTypes)
table.append(M.WordTypes, M.VerbTypes)
table.append(M.WordTypes, M.VerbTypes)

---@param n integer
---@param dst? table
---@return SubjectType[]
function M.subject(n, dst)
	return table.replacement_sample(M.SubjectTypes, n, dst)
end

---@param n integer
---@param dst? table
---@return AdverbType[]
function M.adverb(n, dst)
	return table.replacement_sample(M.AdverbTypes, n, dst)
end

---@param n integer
---@param dst? table
---@return VerbType[]
function M.verb(n, dst)
	return table.replacement_sample(M.VerbTypes, n, dst)
end

---@param n integer
---@param dst? table
---@return WordType[]
function M.word(n, dst)
	return table.replacement_sample(M.UniformWordTypes, n, dst)
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
		subjects = subjects,
		adverbs = adverbs,
		verbs = verbs,
		words = words,
	}
end

---@param page Page
function M.describe(page)
  return table.concat(page.words, " ")
end

return M
