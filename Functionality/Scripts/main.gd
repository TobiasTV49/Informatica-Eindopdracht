extends Node2D
const MELEE_ENEMY = preload("res://Functionality/Scenes/enemy.tscn")
const RANGED_ENEMY = preload("res://Functionality/Scenes/ranged_enemy.tscn")
const NECROMANCER = preload("res://Functionality/Scenes/necromancer_enemy.tscn")
const SKELETON_MINION = preload("res://Functionality/Scenes/skeleton_minion.tscn")
const BOSS = preload("res://Functionality/Scenes/boss.tscn")
var meteor_strike_load = preload("res://Functionality/Scenes/meteor_strike.tscn")
var time_stop_load = preload("res://Functionality/Scenes/time_stop.tscn")
var ray_of_annihilation_load =  preload("res://Functionality/Scenes/ray_of_annihilation.tscn")
var active = [false, false, false]
var timer = [false, false, false]
var druid_timer = 0
var active_input = null
var boss_waves = [2, 5] #all boss waves will be in this array, but we only have 1 boss right now
@onready var player: CharacterBody2D = $PlayerBody
@onready var spell_menu: Node2D = $CanvasLayer/SpellMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.player_death = false
	Global.enemy_killed.connect(enemy_killed)
	Global.wave_start.connect(start_wave)
	Global.player_death_signal.connect(player_death)
	$CanvasLayer/BossBar.visible = false
	$CanvasLayer/WaveCounter.text = "Wave " + str(Global.current_wave + 1)
	for i in $"enemy spawners".get_children(): #Hides the enemy spawners when starting
		i.visible = false
	for i in get_tree().get_nodes_in_group("admin buttons"):
		i.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.player_health <= 0 and Global.player_death == false: #player is about to die
		Global.player_death = true
		get_tree().change_scene_to_file("res://Functionality/Scenes/death_screen.tscn")
	
	if Global.player_death == false:
		$CanvasLayer/Coins.text = str(Global.PlayerCoins) + " Coins"
	
	if Input.is_action_just_pressed("admin buttons"): #toggles the admin menu (key = M)
		if $CanvasLayer/Button.visible == true:
			for i in get_tree().get_nodes_in_group("admin buttons"):
				i.visible = false
		else:
			for i in get_tree().get_nodes_in_group("admin buttons"):
				i.visible = true
	
	if Global.WaveCompleted == true or Global.BossWaveCompleted == true:
		spell_menu.show()
	else:
		spell_menu.hide()
		
	if Global.DruidMenu == true:
		$CanvasLayer/DruidMenu.show()
	else:
		$CanvasLayer/DruidMenu.hide()
	if Input.is_action_just_pressed("1"):
		if Global.ActivePlayerSpells.size() > 0 and active[0] == false:
			var UsedActive = Global.ActivePlayerSpells[0][0]
			active[0] = true
			$CanvasLayer/Active_1/Timer.wait_time = GameData.Spells[UsedActive]["Cooldown"]
			UseActive(UsedActive)
			while not Input.is_action_just_pressed("click"):
				await get_tree().process_frame
			timer[0] = true
			$CanvasLayer/Active_1/Timer.start()
			await $CanvasLayer/Active_1/Timer.timeout
			active[0] = false
			timer[0] = false
			$CanvasLayer/Active_1/Timer.stop()
	elif Input.is_action_just_pressed("2") and active[1] == false:
		if Global.ActivePlayerSpells.size() > 1:
			var UsedActive = Global.ActivePlayerSpells[1][0]
			active[1] = true
			$CanvasLayer/Active_2/Timer.wait_time = GameData.Spells[UsedActive]["Cooldown"]
			UseActive(UsedActive)
			while not Input.is_action_just_pressed("click"):
				await get_tree().process_frame
			timer[1] = true
			$CanvasLayer/Active_2/Timer.start()
			await $CanvasLayer/Active_2/Timer.timeout
			active[1] = false
			timer[1] = false
			$CanvasLayer/Active_2/Timer.stop()
	elif Input.is_action_just_pressed("3"):
		if Global.ActivePlayerSpells.size() > 2 and active[2] == false:
			var UsedActive = Global.ActivePlayerSpells[2][0]
			active[2] = true
			$CanvasLayer/Active_3/Timer.wait_time = GameData.Spells[UsedActive]["Cooldown"]
			UseActive(UsedActive)
			while not Input.is_action_just_pressed("click"):
				await get_tree().process_frame
			timer[2] = true
			$CanvasLayer/Active_3/Timer.start()
			await $CanvasLayer/Active_3/Timer.timeout
			active[2] = false
			timer[2] = false
			$CanvasLayer/Active_3/Timer.stop()
	update_stats()
	update_names()

func roll_dice():
	$CanvasLayer/Dice.roll_dice.emit()

#Function that makes the waves
func start_wave(wave_number):
	while Global.DruidMenu == true:
		await get_tree().process_frame
	roll_dice() #temporary location for the dice rollin'
	if boss_waves.has(wave_number):
		start_boss_wave()
		print("starting boss wave")
	else:
		var wave_array: Array
		var enemy
		for i in GameData.Waves[wave_number]: #Makes an array with all the enemies in the wave
			while i[1] > 0:
				wave_array.append(i[0])
				i[1] -= 1
		
		wave_array.shuffle()
		$CanvasLayer/WaveCounter.text = "Wave " + str(Global.current_wave + 1)
		$CanvasLayer/WaveCounter/ProgressBar.max_value = wave_array.size()
		$CanvasLayer/WaveCounter/ProgressBar.value = wave_array.size()

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
	$CanvasLayer/WaveCounter/ProgressBar.value -= 1
	if get_node("Enemies").get_child_count() < 1:
		Global.WaveCompleted = true
		Global.current_wave += 1
		druid_timer += 1
		if druid_timer == 2 and 1 == randi_range(1, 3):
			Global.DruidMenu = true
			druid_timer = 0
		elif druid_timer == 3 and 1 == randi_range(1, 2):
			Global.DruidMenu = true
			druid_timer = 0
		elif druid_timer == 4:
			Global.DruidMenu = true
			druid_timer = 0


func _on_temporary_button_pressed():
	Global.BossWaveCompleted = true

func _on_temporary_button_2_pressed():
	Global.DruidMenu = true


func _on_wave_starter_pressed() -> void:
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

func _on_button_5_pressed() -> void:
	start_boss_wave()

func update_stats():
	for i in Global.PlayerSpells:
		for x in GameData.Spells[i[0]]["Levelup"]:
			var upgradestat = x[0]
			var upgradeamount = x[1]
			var basestat = x[2]
			GameData.Spells[i[0]][upgradestat] = basestat + upgradeamount * i[1]

func update_names():
	if Global.ActivePlayerSpells.size() > 0:
		$CanvasLayer/Active_1/Label.text = str(GameData.Spells[Global.ActivePlayerSpells[0][0]]["Name"])
		if timer[0] == true:
			$CanvasLayer/Active_1/Label.text += "\n" + str(int($CanvasLayer/Active_1/Timer.get_time_left()))
	if Global.ActivePlayerSpells.size() > 1:
		$CanvasLayer/Active_2/Label.text = str(GameData.Spells[Global.ActivePlayerSpells[1][0]]["Name"])
		if timer[1] == true:
			$CanvasLayer/Active_2/Label.text += "\n" + str(int($CanvasLayer/Active_2/Timer.get_time_left()))
	if Global.ActivePlayerSpells.size() > 2:
		$CanvasLayer/Active_3/Label.text = str(GameData.Spells[Global.ActivePlayerSpells[2][0]]["Name"])
		if timer[2] == true:
			$CanvasLayer/Active_3/Label.text += "\n" + str(int($CanvasLayer/Active_3/Timer.get_time_left()))


func _on_bullet_killer_left_body_entered(body: Node2D) -> void: #deletes bullet that are out of the screen
	if body.is_in_group("bullets"):
		body.queue_free()

func player_death():
	get_tree().change_scene_to_file("res://Functionality/Scenes/death_screen.tscn")

func start_boss_wave():
	$CanvasLayer/WaveCounter.visible = false
	for i in range(0, 35):
		$Player/Camera2D.zoom -= Vector2(0.005, 0.005)
		await get_tree().create_timer(0.05).timeout
	var boss = BOSS.instantiate()
	$Enemies.add_child(boss)
	$CanvasLayer/BossBar.visible = true
	$CanvasLayer/WaveCounter.text = "The Molten Guardian"
	$CanvasLayer/WaveCounter.add_theme_color_override("font_color", Color(255, 0, 0))
	$CanvasLayer/WaveCounter.visible = true
	$CanvasLayer/WaveCounter/ProgressBar.visible = false
	boss.position = Vector2(360, 64)

func UseActive(UsedActive):
	if UsedActive == 5:
		get_tree().current_scene.add_child(meteor_strike_load.instantiate())
	if UsedActive == 6:  
		get_tree().current_scene.add_child(time_stop_load.instantiate())
	elif UsedActive == 7:  
		get_tree().current_scene.add_child(ray_of_annihilation_load.instantiate())
