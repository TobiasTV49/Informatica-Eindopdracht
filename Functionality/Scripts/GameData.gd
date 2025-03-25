extends Node
var Spells = {
	0: {
		"Name" = "Magic missile",
		"Damage" = 10,
		"Levelup" = [["Damage", 3, 10]], #what scales, how much it scales with and what the base stat is
		"Active" = false,
	},
	1: {
		"Name" = "Divine protection",
		"Cooldown" = 20, #cooldown in seconds
		"Levelup" = [["Cooldown", -2, 20]],
		"Active" = false,
	},
	2: {
		"Name" = "Arcane shove",
		"Damage" = 10,
		"Knockback" = -200, #the speed at which the enemy moves back
		"Levelup" = [["Knockback", -25, -200]],
		"Active" = false,
	},
	3: {
		"Name" = "Arcane construct",
		"Damage" = 3,
		"Levelup" = [["Damage", 1, 3]],
		"Active" = false,
	},
	4: {
		"Name" = "Summon golem",
		"Damage" = 15,
		"Levelup" = [["Damage", 3, 15]],
		"Active" = false,
	},
	5: {
		"Name" = "Meteor strike",
		"Damage" = 25,
		"Levelup" = [["Damage", 7, 25]],
		"Active" = true,
		"Cooldown" = 5,
	},
	6: {
		"Name" = "Time stop",
		"Duration" = 5,
		"Levelup" = [["Duration", 1, 5]],
		"Active" = true,
		"Cooldown" = 10,
	},
	7: {
		"Name" = "Ray of annihilation",
		"Damage" = 0.75,
		"Duration" = 3,
		"Levelup" = [["Damage", 0.25, 0.75], ["Duration", 0.5, 3]],
		"Active" = true,
		"Cooldown" = 8,
	},
}
var Items = {
	0: {
		"Name" = "Healing Balm",
		"Cost" = 10,
		"Icon" = load("res://Assets/healthPotion.png")
	},
	1: {
		"Name" = "Hawk's sight",
		"Cost" = 20,
		"Effect" = 0.1,
		"Icon" = load("res://Assets/hawkSightBuff.png")
	},
	2: {
		"Name" = "Panther's dexterity",
		"Cost" = 25,
		"Effect" = 0.1,
		"Icon" = load("res://Assets/pantherDexterityBuff.png")
	},
	3: {
		"Name" = "Armadillo's resistance",
		"Cost" = 15,
		"Effect" = 0.1,
		"Icon" = load("res://Assets/armadilloResistanceBuff.png")
	},
	4: {
		"Name" = "Hummingbird's haste",
		"Cost" = 10,
		"Effect" = 0.1,
		"Icon" = load("res://Assets/hummingbirdHasteBuff.png")
	},
	5: {
		"Name" = "Gorilla's brawn",
		"Cost" = 30,
		"Effect" = 0.1,
		"Icon" = load("res://Assets/gorillaBrawnBuff.png")
	}
}

var Waves = {
	0: [["melee_enemy", 3], ["ranged_enemy", 2]],
	1: [["melee_enemy", 5], ["ranged_enemy", 1], ["necromancer", 1]],
	2: [["melee_enemy", 5], ["ranged_enemy", 5], ["necromancer", 1]],
	3: [["melee_enemy", 4], ["ranged_enemy", 4], ["necromancer", 2]],
	4: [["melee_enemy", 10], ["necromancer", 4]]
}

var Wizards = {
	0: {
		"Name" = "Wizard Wizard",
		"Starting weapon" = 0, #magic missile
		"Bonusses" = [["player_damage_mult", 1.05]], #the wizards' positive and negative perks
	},
	1: {
		"Name" = "Artificer Wizard",
		"Starting weapon" = 3, #arcane construct
		"Bonusses" = [["player_attack_speed_mult", 1.25], ["player_movement_speed_mult", 0.75]], #the wizards' positive and negative perks
	},
	2: {
		"Name" = "Necromancer Wizard",
		"Starting weapon" = 4, #summon golem
		"Bonusses" = [["player_damage_mult", 1.25], ["player_damage_reduction_mult", 0.75]], #the wizards' positive and negative perks
	},
	3: {
		"Name" = "Rogue Wizard",
		"Starting weapon" = 0, #magic missile
		"Bonusses" = [["player_movement_speed_mult", 1.25], ["player_dodge", 10], ["player_damage_reduction_mult", 0.85], ["player_range_mult", 0.75]], #the wizards' positive and negative perks
	},
}
