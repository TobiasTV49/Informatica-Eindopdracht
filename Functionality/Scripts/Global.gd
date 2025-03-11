extends Node

var WaveCompleted = false
var BossWaveCompleted = true
var current_wave = 0
var player_health: int = 50
var player_death: bool
var player_position = null
var enemy_position = null
var nearest_enemy = null
var PlayerSpells = []
var PlayerItems = []
var PlayerCoins = 300
var coinsPerEnemy = 10
var DruidMenu = false
signal shoot
signal enemy_shoot
signal enemy_killed()
signal knockback(speed, duration, body)
signal damage_enemy(damage, enemy)
signal damage_player(damage)

func get_index_from_name(name, dictionary):
	for i in range(dictionary.size()):
		if dictionary[i]["Name"] == name:
			return i

func get_nearest_enemy(source):
	var enemy_array = get_tree().get_nodes_in_group("enemies")
	if enemy_array.size() > 0:
		if Global.nearest_enemy == null:
			Global.nearest_enemy = enemy_array[0]
		for i in enemy_array:
			var temp_distance = source.distance_to(i.position)
			if temp_distance < source.distance_to(Global.nearest_enemy.position):
				Global.nearest_enemy = i
