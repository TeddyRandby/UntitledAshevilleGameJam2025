---@alias SubjectType "player" | "enemy"
---@alias AdverbType "very" | "strong" | "weak" | "fire" | "water" | "nature"
---@alias VerbType "damage" | "shield" | "strong" | "weak" | "fire" | "water" | "nature"
---@alias WordType SubjectType | AdverbType | VerbType

---@class Word
---@field type WordType
---@field synonym? string
---@field synonyms? string[]

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
	},
	{
		type = "strong",
	},
	{
		type = "weak",
	},
	{
		type = "fire",
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
