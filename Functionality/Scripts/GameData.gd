extends Node
var Spells = {
	0: {
		"Name" = "Magic missile",
		"Damage" = 30,
		"Active" = false,
	},
	1: {
		"Name" = "Divine protection",
		"Damage" = 0,
		"Active" = false,
	},
	2: {
		"Name" = "Arcane shove",
		"Damage" = 5,
		"Active" = false,
	},
	3: {
		"Name" = "Arcane construct",
		"Damage" = 0,
		"Active" = false,
	},
	4: {
		"Name" = "Summon golem",
		"Damage" = 0,
		"Active" = false,
	},
	5: {
		"Name" = "Meteor strike",
		"Damage" = 25,
		"Active" = true,
	},
	6: {
		"Name" = "Time stop",
		"Damage" = 0,
		"Active" = true,
	},
	7: {
		"Name" = "Ray of annihilation",
		"Damage" = 5,
		"Active" = true,
	},
}
var Items = {
	0: {
		"Name" = "Healing Balm",
		"Cost" = 10,
	},
	1: {
		"Name" = "Hawk's sight",
		"Cost" = 20,
	},
	2: {
		"Name" = "Panther's dexterity",
		"Cost" = 25,
	},
	3: {
		"Name" = "Armadillo's resistance",
		"Cost" = 15,
	},
	4: {
		"Name" = "Hummingbird's haste",
		"Cost" = 10,
	},
	5: {
		"Name" = "Gorilla's brawn",
		"Cost" = 30,
	}
}

var Waves = {
	0: [["melee_enemy", 3], ["ranged_enemy", 2]],
	1: [["melee_enemy", 5], ["ranged_enemy", 1]]
}
