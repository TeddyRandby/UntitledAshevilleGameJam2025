---@alias SubjectType "player" | "enemy"
---@alias AdverbType "very" | "strong" | "weak" | "fire" | "water" | "nature"
---@alias VerbType "damage" | "shield" | "strong" | "weak" | "fire" | "water" | "nature"
---@alias WordType SubjectType | AdverbType | VerbType

---@class Word
---@field type WordType
---@field value? number
---@field apply? fun(val: number, cs: SpellConsequence[]): number
---@field synonym? string
---@field synonyms? string[]
---

---@type Word[]
return {
	{
		type = "player",
	},
	{
		type = "enemy",
	},
	{
		type = "very",
    apply = function(v)
      return v * 2
    end,
	},
	{
		type = "strong",
    value = 1,
    apply = function(v)
      return v * 2
    end,
	},
	{
		type = "weak",
    value = 1,
    apply = function(v)
      return v / 2
    end,
	},
	{
		type = "fire",
    value = 10,
    apply = function(v, cs)
      ---@type SpellConsequence
      local c = {
        -- TODO: Don't hardcode nemey here
        subject = "enemy",
        type = "fire",
        value = 2,
      }

      table.insert(cs, c)

      return v
    end,
		synonyms = {
			"fire",
			"ember",
			"blaze",
			"cinder",
			"ash",
			"inferno",
			"burn",
			"torch",
			"scorch",
			"smolder",
		},
	},
	{
		type = "water",
    value = 10,
    apply = function(v, cs)
      ---@type SpellConsequence
      local c = {
        -- TODO: Don't hardcode subject here
        subject = "player",
        type = "water",
        value = 2,
      }

      table.insert(cs, c)

      return v
    end,
		synonyms = {
			"aqua",
			"drench",
			"soak",
			"douse",
			"splash",
			"flood",
			"waterlog",
			"saturate",
			"drown",
			"swamp",
		},
	},
	{
		type = "nature",
    apply = function(v, cs)
      ---@type SpellConsequence
      local c = {
        -- TODO: Don't hardcode subject here
        subject = "player",
        type = "nature",
        value = 2,
      }

      table.insert(cs, c)

      return v
    end,
    value = 10,
		synonyms = {
			"sprout",
			"nature",
			"plant",
			"bud",
			"burgeon",
			"begetate",
			"seed",
			"bloom",
			"blossom",
			"flower",
		},
	},
	{
		type = "damage",
    value = 10,
		synonyms = {
			"ray",
			"punch",
			"smash",
			"crush",
			"blast",
			"beam",
			"burst",
			"slash",
			"cleave",
			"slice",
		},
	},
	{
		type = "shield",
    value = 10,
		synonyms = {
			"protect",
			"guard",
			"keep",
			"preserve",
			"ward",
			"screen",
			"bulwark",
			"wall",
			"palisade",
			"cover",
		},
	},
}
