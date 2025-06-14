extends CharacterBody2D

@export var speed = 50
var bullet_load = preload("res://Functionality/Scenes/bullet.tscn")
var arcane_shove_load = preload("res://Functionality/Scenes/arcane_shove.tscn")
var magical_golem_load = preload("res://Functionality/Scenes/magical_golem.tscn")
var protection_load = preload("res://Functionality/Scenes/divine_protection.tscn")
var arcane_construct_load = preload("res://Functionality/Scenes/arcane_construct.tscn")
var spell_list: Array
var shove_active = false
var construct_active = false
var golem_active = false
var shield_active = false
var shield_spawnable = true
var enemies_in_range = 0
var protection
var using_active = false
signal protection_break

func _ready():
	$AttackTimer.start()
	Global.damage_player.connect(damaged)
	Global.active_used.connect(active_used)
	protection_break.connect(protection_broken)
	#Global.PlayerSpells.append([2, 0, 0]) #adding the arcane shove spell for testing
	#Global.PlayerSpells.append([4, 0, 0]) #adding the summon golem spell for testing
	#Global.PlayerSpells.append([1, 0, 0]) #adding the divine protection spell for testing
	#Global.PlayerSpells.append([3, 0, 0]) #adding the arcane construct spell for testing

func get_input(): #Pulls input directions and sets the velocity using them.
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed * Global.player_movement_speed_mult
	if input_direction.x > 0:
		$playerUpperBody.flip_h = false
		$playerLowerBody.flip_h = false
	elif input_direction.x < 0:
		$playerUpperBody.flip_h = true
		$playerLowerBody.flip_h = true
	
		
func _physics_process(delta):
	get_input() #I wonder what this could do, i really have no clue.
	$ProgressBar.value = Global.player_health
	
	if velocity != Vector2(0, 0):
		$playerLowerBody.play("running")
		if using_active == false:
			$playerUpperBody.play("run")
	else:
		$playerLowerBody.play("idle")
		if using_active == false:
			$playerUpperBody.play("idle")
	
	for i in Global.PlayerSpells.size(): #puts the names of all unlocked spells in an array
		var index = Global.PlayerSpells[i][0]
		if spell_list.has(GameData.Spells[index]["Name"]) == false:
			spell_list.append(GameData.Spells[index]["Name"])
	
	
	if spell_list.has("Arcane shove") and check_spell_active("Arcane shove") == true:
		arcane_shove(0.5, 2 / Global.player_attack_speed_mult) #calls arcane shove. 1st value = effect lenght, 2nd value = effect cooldown
	
	if spell_list.has("Summon golem") and check_spell_active("Summon golem") == true:
		summon_golem()
	
	if spell_list.has("Divine protection") and check_spell_active("Divine protection") == true:
		divine_protection()
	
	if spell_list.has("Arcane construct") and check_spell_active("Arcane construct") == true:
		arcane_construct()
	
	if Global.stunned == false:
		move_and_slide() #Special function for characterbody2D that makes it schmove.
	


func _on_attack_timer_timeout() -> void:
	if enemies_in_range > 0 and spell_list.has("Magic missile") and check_spell_active("Magic missile") == true: #only shoots when there are enemies in attack range
		$AttackTimer.wait_time = 1 / Global.player_attack_speed_mult
		var bullet = bullet_load.instantiate()
		var player_bullets = get_tree().current_scene.get_node("player_bullets")
		var bullet_target = "enemy"
		var source = self.position
		player_bullets.add_child(bullet)
		bullet.position = position
		Global.shoot.emit(bullet_target, source, GameData.Spells[0]["Damage"], 200, 1)
						  #target, source, damage, speed, scale

func active_used():
	using_active = true
	if velocity == Vector2(0, 0):
		$playerUpperBody.play("active_idle")
		await $playerUpperBody.animation_finished
	else:
		$playerUpperBody.play("active_run")
		await $playerUpperBody.animation_finished
	using_active = false

func damaged(damage):
	if shield_active == false:
		if Global.player_dodge <= randi_range(1,100):
			damage /= Global.player_damage_reduction_mult
			Global.player_health -= damage
			if Global.player_health < 1:
				Global.player_death = true
				self.queue_free()
			Global.DamageNumbers(damage, self.position)
		else:
			print("attack dodged")
	elif shield_active == true:
		protection_break.emit()

func arcane_construct():
	if construct_active == false:
		construct_active = true
		var construct = arcane_construct_load.instantiate()
		construct.visible = true
		add_child(construct)
	

func arcane_shove(lenght: float, cooldown: float):
	if shove_active == false:
		shove_active = true
		var arcane_shove = arcane_shove_load.instantiate()
		add_child(arcane_shove)
		print(GameData.Spells[2]["Knockback"])
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
	if shield_spawnable == true and shield_active == false:
		protection = protection_load.instantiate()
		add_child(protection)
		shield_active = true
		shield_spawnable = false
	elif shield_active == true:
		protection.position = Vector2(0, 0)
	
func protection_broken():
	var cooldown = GameData.Spells[1]["Cooldown"] / Global.player_attack_speed_mult #cooldown in seconds
	protection.queue_free()
	shield_active = false
	await get_tree().create_timer(cooldown).timeout
	shield_spawnable = true
	
func _on_tree_exited():
	Global.player_death_signal.emit()
	Global.player_death = true

func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemies_in_range += 1


func _on_attack_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemies_in_range -= 1

func check_spell_active(name):
	for i in Global.PlayerSpells.size():
		if name == GameData.Spells[Global.PlayerSpells[i][0]]["Name"]:
			return Global.PlayerSpells[i][3]
