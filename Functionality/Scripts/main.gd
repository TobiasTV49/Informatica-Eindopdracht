extends Node2D
const MELEE_ENEMY = preload("res://Functionality/Scenes/enemy.tscn")
const RANGED_ENEMY = preload("res://Functionality/Scenes/ranged_enemy.tscn")
const NECROMANCER = preload("res://Functionality/Scenes/necromancer_enemy.tscn")
const SKELETON_MINION = preload("res://Functionality/Scenes/skeleton_minion.tscn")
@onready var player: CharacterBody2D = $PlayerBody
@onready var spell_menu: Node2D = $CanvasLayer/SpellMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.player_death = false
	Global.enemy_killed.connect(enemy_killed)
	for i in $"enemy spawners".get_children(): #Hides the enemy spawners when starting
		i.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.player_health <= 0 and Global.player_death == false: #player is about to die
		Global.player_death = true
	
	if Global.player_death == false:
		$CanvasLayer/Coins.text = str(Global.PlayerCoins) + " Coins"
	
	if Global.WaveCompleted == true or Global.BossWaveCompleted == true:
		spell_menu.show()
	else:
		spell_menu.hide()
		
	if Global.DruidMenu == true:
		$CanvasLayer/DruidMenu.show()
	else:
		$CanvasLayer/DruidMenu.hide()
	update_names()

#Function that makes the waves
func start_wave(wave_number):
	var wave_array: Array
	var enemy
	for i in GameData.Waves[wave_number]: #Makes an array with all the enemies in the wave
		while i[1] > 0:
			wave_array.append(i[0])
			i[1] -= 1
	
	wave_array.shuffle()

	while wave_array.size() > 0: #Sets up all the enemies and calls the spawn_enemy function
		await get_tree().create_timer(2).timeout
		match wave_array[0]:
			"melee_enemy":
				enemy = MELEE_ENEMY.instantiate()
			"ranged_enemy":
				enemy = RANGED_ENEMY.instantiate()
			"necromancer":
				enemy = NECROMANCER.instantiate()
		spawn_enemy(enemy)
		wave_array.remove_at(0)
		print(wave_array)

#The actual spawning of the enemies is regulated with this function
func spawn_enemy(enemy):
	var enemy_spawners = get_tree().get_nodes_in_group("enemy_spawners")
	var spawner = enemy_spawners.pick_random() #Makes enemies appear from different, random points
	$Enemies.add_child(enemy)
	enemy.position = spawner.position

func _on_button_pressed() -> void:
	var melee_enemy = MELEE_ENEMY.instantiate()
	$Enemies.add_child(melee_enemy)

func enemy_killed():
	Global.PlayerCoins += Global.coinsPerEnemy
	if get_node("Enemies").get_child_count() < 1:
		Global.WaveCompleted = true
		Global.current_wave += 1

func _on_temporary_button_pressed():
	Global.BossWaveCompleted = true

func _on_temporary_button_2_pressed():
	Global.DruidMenu = true


func _on_wave_starter_pressed() -> void:
	print(Global.current_wave)
	start_wave(Global.current_wave)


func _on_button_2_pressed() -> void:
	var ranged_enemy = RANGED_ENEMY.instantiate()
	$Enemies.add_child(ranged_enemy)


func _on_button_3_pressed() -> void:
	var necromancer = NECROMANCER.instantiate()
	$Enemies.add_child(necromancer)

func _on_button_4_pressed() -> void:
	var skeleton_minion = SKELETON_MINION.instantiate()
	$Enemies.add_child(skeleton_minion)

func update_names():
	if Global.ActivePlayerSpells.size() > 0:
		$CanvasLayer/Active_1/Label.text = GameData.Spells[Global.ActivePlayerSpells[0][0]]["Name"]
	if Global.ActivePlayerSpells.size() > 1:
		$CanvasLayer/Active_2/Label.text = GameData.Spells[Global.ActivePlayerSpells[1][0]]["Name"]
	if Global.ActivePlayerSpells.size() > 2:
		$CanvasLayer/Active_3/Label.text = GameData.Spells[Global.ActivePlayerSpells[2][0]]["Name"]
