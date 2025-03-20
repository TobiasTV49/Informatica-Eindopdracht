extends Node

var WaveCompleted = false
var BossWaveCompleted = true
var chosen_character = null
var current_wave = 0
var player_health: int = 50
var player_death: bool
var player_position = null
var enemy_position = null
var nearest_enemy = null
var PlayerSpells = []
var ActivePlayerSpells = []
var PlayerItems = []
var PlayerCoins = 300
var coinsPerEnemy = 10
var DruidMenu = false
var TimeStop = false
var stunned = false
var enemy_speed_mult:float = 1
var player_range_mult:float = 1
var player_movement_speed_mult:float = 1 
var player_dodge = 2
var player_damage_reduction_mult:float = 1
var player_attack_speed_mult:float = 1 
var player_damage_mult:float = 1
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

func GetSpellIndex(spell):
	for i in Global.ActivePlayerSpells.size():
		if spell == Global.ActivePlayerSpells[i][0]:
			return i

func GetItemIndex(item):
	for i in Global.PlayerItems.size():
		if item == Global.PlayerItems[i][0]:
			return i

func CheckPlayerItems(i):
	var lock = false
	var inside = false
	for x in Global.PlayerItems.size():
		if i == Global.PlayerItems[x][0] and lock == false:
			inside = true
			return inside
		else:
			inside = false
			return inside
