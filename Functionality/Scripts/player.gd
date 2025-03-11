extends CharacterBody2D

@export var speed = 50
var bullet_load = preload("res://Functionality/Scenes/bullet.tscn")
var arcane_shove_load = preload("res://Functionality/Scenes/arcane_shove.tscn")
var magical_golem_load = preload("res://Functionality/Scenes/magical_golem.tscn")
var meteor_strike_load = preload("res://Functionality/Scenes/meteor_strike.tscn")
var ray_of_annihilation_load =  preload("res://Functionality/Scenes/ray_of_annihilation.tscn")
var spell_list: Array
var shove_active = false
var golem_active = false
var shield_active = false
var meteor_strike_active = false
var ray_of_annihilation_active = false
var enemies_in_range = 0

func _ready():
	$AttackTimer.start()
	Global.damage_player.connect(damaged)
	Global.PlayerSpells.append([2, 0, 0]) #adding the arcane shove spell for testing
	Global.PlayerSpells.append([4, 0, 0]) #adding the summon golem spell for testing

func get_input(): #Pulls input directions and sets the velocity using them.
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	if Global.player_death == true:
		self.queue_free()
	get_input() #I wonder what this could do, i really have no clue.
	$ProgressBar.value = Global.player_health
	
	for i in Global.PlayerSpells.size(): #puts the names of all unlocked spells in an array
		var index = Global.PlayerSpells[i][0]
		if spell_list.has(GameData.Spells[index]["Name"]) == false:
			spell_list.append(GameData.Spells[index]["Name"])
	
	if spell_list.has("Arcane shove"):
		arcane_shove(0.5, 2) #calls arcane shove. 1st value = effect lenght, 2nd value = effect cooldown
	
	if spell_list.has("Summon golem"):
		summon_golem()
	
	#if spell_list.has("Divine protection"):
		#divine_protection()
	
	if Input.is_action_just_pressed("1"):
		if Global.ActivePlayerSpells.size() > 0:
			var UsedActive = Global.ActivePlayerSpells[0][0]
			UseActive(UsedActive)
	elif Input.is_action_just_pressed("2"):
		if Global.ActivePlayerSpells.size() > 1:
			var UsedActive = Global.ActivePlayerSpells[1][0]
			UseActive(UsedActive)
	elif Input.is_action_just_pressed("3"):
		if Global.ActivePlayerSpells.size() > 2:
			var UsedActive = Global.ActivePlayerSpells[2][0]
			UseActive(UsedActive)
	
	move_and_slide() #Special function for characterbody2D that makes it schmove.
	


func _on_attack_timer_timeout() -> void:
	if enemies_in_range > 0: #only shoots when there are enemies in attack range
		var bullet = bullet_load.instantiate()
		var player_bullets = get_tree().current_scene.get_node("player_bullets")
		var bullet_target = "enemy"
		var source = self.position
		player_bullets.add_child(bullet)
		bullet.position = position
		Global.shoot.emit(bullet_target, source)


func damaged(damage):
	Global.player_health -= damage
	if Global.player_health < 1:
		self.queue_free()

func arcane_shove(lenght: float, cooldown: float):
	if shove_active == false:
		shove_active = true
		var arcane_shove = arcane_shove_load.instantiate()
		add_child(arcane_shove)
		arcane_shove.get_node("Animator").play("grow")
		await get_tree().create_timer(lenght).timeout
		arcane_shove.queue_free()
		await get_tree().create_timer(cooldown).timeout
		shove_active = false

func summon_golem():
	if golem_active == false:
		golem_active = true
		var golem = magical_golem_load.instantiate()
		get_parent().add_child(golem) #spawns the golem as a child of the main scene
		golem.position = position
		golem.position.y += 50

func divine_protection():
	var protection = preload("res://Functionality/Scenes/divine_protection.tscn").instantiate()
	if shield_active == false:
		add_child(protection)
	
	
	

func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemies_in_range += 1


func _on_attack_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemies_in_range -= 1

func UseActive(UsedActive):
	if UsedActive == 5 and meteor_strike_active == false:  
		meteor_strike_active = true
		get_tree().current_scene.add_child(meteor_strike_load.instantiate())
		await get_tree().create_timer(5).timeout
		meteor_strike_active = false
	elif UsedActive == 7 and ray_of_annihilation_active == false:  
		ray_of_annihilation_active = true
		get_tree().current_scene.add_child(ray_of_annihilation_load.instantiate())
		await get_tree().create_timer(8).timeout
		ray_of_annihilation_active = false
