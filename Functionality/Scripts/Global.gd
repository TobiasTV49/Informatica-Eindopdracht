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
var coinsPerEnemy = 2
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
var room_coords_x = [0, 640]
var final_boss_beaten: bool = false
var penalty = 0


signal shoot
signal enemy_shoot
signal enemy_killed()
signal knockback(speed, duration, body)
signal damage_enemy(damage, enemy)
signal damage_player(damage)
signal wave_start()
signal active_used
signal player_death_signal
signal pre_wave

func get_index_from_name(name, dictionary):
	for i in range(dictionary.size()):
		if dictionary[i]["Name"] == name:
			return i

func get_nearest_enemy(source, bounce):
	var enemy_array = get_tree().get_nodes_in_group("enemies")
	var array = []
	if enemy_array.size() > 0:
		Global.nearest_enemy = true
		for i in enemy_array:
			var temp_distance: int = source.distance_to(i.position)
			array.append(temp_distance)
		if bounce == false:
			return enemy_array[array.find(array.min())]
		else:
			array.remove_at(array.find(array.min()))
			return enemy_array[array.find(array.min())]
	else:
		Global.nearest_enemy = null
		return null


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

func DamageNumbers(damage, position):
	var text = Label.new()
	text.text = str(damage)
	text.position = position
	get_tree().current_scene.add_child(text)
	var x = 0
	while x < 20:
		await get_tree().create_timer(0.05).timeout
		if Global.player_death == false: #was crashing so i needed to add some locks
			text.position.y -= 2
			text.self_modulate.a -= 0.1
		x += 1
	if Global.player_death == false:
		text.queue_free()
