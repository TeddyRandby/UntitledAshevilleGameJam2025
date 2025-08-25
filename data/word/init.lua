local M = {}

local WordTypes = require("data.word.types")

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

for _, v in ipairs(WordTypes) do
	M[v.type] = v
end

---@type WordType[]
M.UniformWordTypes = {}
table.append(M.UniformWordTypes, M.SubjectTypes)
table.append(M.UniformWordTypes, M.SubjectTypes)
table.append(M.UniformWordTypes, M.SubjectTypes)
table.append(M.UniformWordTypes, M.AdverbTypes)
table.append(M.UniformWordTypes, M.VerbTypes)
table.append(M.UniformWordTypes, M.VerbTypes)
table.append(M.UniformWordTypes, M.VerbTypes)

---@param word Word
function M.isSubject(word)
	local word_type = word.type
	return word_type == "player" or word_type == "enemy"
end

---@param word Word
function M.isAdverb(word)
	local word_type = word.type
	return word_type == "fire"
		or word_type == "water"
		or word_type == "nature"
		or word_type == "strong"
		or word_type == "weak"
		or word_type == "very"
end

---@param word Word
function M.isVerb(word)
	local word_type = word.type
	return word_type == "damage"
		or word_type == "shield"
		or word_type == "fire"
		or word_type == "water"
		or word_type == "nature"
		or word_type == "strong"
		or word_type == "weak"
end

---@param word Word
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

---@param words Word[]
function M.describe(words)
	local sorted = table.copy(words)

	table.sort(sorted, function(a, b)
		return M.wordPriority(a) < M.wordPriority(b)
	end)

	return table.concat(sorted)
end

---@param word_type WordType
---@return WordType
function M.synonym(word_type)
	---@type Word
	local word = M[word_type]
	assert(word ~= nil, "Invalid word: " .. word_type)

	if word.synonyms == nil then
		return word.type
	else
		return table.replacement_sample(word.synonyms, 1)[1]
	end
end

---@param word Word
---@return string
function M.toSynonym(word)
  return word.synonym
end

return M
