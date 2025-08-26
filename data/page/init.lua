local M = {}

local Word = require("data.word")

---@class Page
---@field words Word[]
---@field name string
---
---@param options WordType[]
---@param n integer
---@param dst? table
function M._construct(options, n, dst)
	local type = table.replacement_sample(options, n, dst)
	return table.map(type, function(t)
		local template = Word[t]
		assert(template ~= nil, "Invalid word type: " .. t)
		local word = table.copy(template)
		word.synonym = Word.synonym(t)
		print(word.synonym)
		return word
	end)
end

---@param n integer
---@param dst? table
---@return SubjectType[]
function M.subject(n, dst)
	return M._construct(Word.SubjectTypes, n, dst)
end

---@param n integer
---@param dst? table
---@return AdverbType[]
function M.adverb(n, dst)
	return M._construct(Word.AdverbTypes, n, dst)
end

---@param n integer
---@param dst? table
---@return VerbType[]
function M.verb(n, dst)
	return M._construct(Word.VerbTypes, n, dst)
end

---@param n integer
---@param dst? table
---@return WordType[]
function M.word(n, dst)
	return table.replacement_sample(Word.UniformWordTypes, n, dst)
end

---@param n integer
function M.create_uniform(n)
	local rng = Engine.rng:random(1, 3)

	if rng <= 1 then
		return M.create(1, 0, 0)
	elseif rng <= 2 then
		return M.create(0, 1, 0)
	elseif rng <= 3 then
		return M.create(0, 0, 1)
	else
		assert(false, "INVALID RANDOM THINGY")
	end
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

	local name = table.concat(
		table.map(words, function(w)
			return w.synonym
		end),
		"\n"
	)

	---@type Page
	return {
		name = name,
		words = words,
	}
end

---@param page Page
function M.describe(page)
	return page.name
end

---@param page Page
function M.hasSubject(page)
	return not not table.find(page.words, function(w)
		return Word.isSubject(w)
	end)
end

---@param page Page
function M.hasAdverb(page)
	return not not table.find(page.words, function(w)
		return Word.isAdverb(w)
	end)
end

---@param page Page
function M.hasVerb(page)
	return not not table.find(page.words, function(w)
		return Word.isVerb(w)
	end)
end

return M
