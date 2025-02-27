extends Node

var WaveCompleted = true
var current_wave = 0
var player_health: int = 50
var player_death: bool
var player_position = null
var enemy_position = null
var nearest_enemy = null
var PlayerSpells = []
var PlayerItems = []
var PlayerCoins = 300
var DruidMenu = false
signal shoot
signal enemy_shoot
signal enemy_killed()

func get_index_from_name(name, dictionary):
	for i in range(dictionary.size()):
		if dictionary[i]["Name"] == name:
			return i
