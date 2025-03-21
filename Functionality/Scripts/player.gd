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
signal protection_break

func _ready():
	$AttackTimer.start()
	Global.damage_player.connect(damaged)
	protection_break.connect(protection_broken)
	Global.PlayerSpells.append([2, 0, 0]) #adding the arcane shove spell for testing
	Global.PlayerSpells.append([4, 0, 0]) #adding the summon golem spell for testing
	#Global.PlayerSpells.append([1, 0, 0]) #adding the divine protection spell for testing
	Global.PlayerSpells.append([3, 0, 0]) #adding the arcane construct spell for testing

func get_input(): #Pulls input directions and sets the velocity using them.
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed * Global.player_movement_speed_mult

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
		arcane_shove(0.5, 2 / Global.player_attack_speed_mult) #calls arcane shove. 1st value = effect lenght, 2nd value = effect cooldown
	
	if spell_list.has("Summon golem"):
		summon_golem()
	
	if spell_list.has("Divine protection"):
		divine_protection()
	
	if spell_list.has("Arcane constuct"):
		arcane_construct()
	
	if Global.stunned == false:
		move_and_slide() #Special function for characterbody2D that makes it schmove.
	


func _on_attack_timer_timeout() -> void:
	if enemies_in_range > 0 and spell_list.has("Magic missile"): #only shoots when there are enemies in attack range
		$AttackTimer.wait_time = 1 / Global.player_attack_speed_mult
		var bullet = bullet_load.instantiate()
		var player_bullets = get_tree().current_scene.get_node("player_bullets")
		var bullet_target = "enemy"
		var source = self.position
		player_bullets.add_child(bullet)
		bullet.position = position
		Global.shoot.emit(bullet_target, source, 10, 200, 1)
						  #target, source, damage, speed, scale


func damaged(damage):
	if shield_active == false:
		if Global.player_dodge <= randi_range(1,100):
			damage /= Global.player_damage_reduction_mult
			Global.player_health -= damage
			if Global.player_health < 1:
				self.queue_free()
		else:
			print("attack dodged")
	elif shield_active == true:
		protection_break.emit()

func arcane_construct():
	if construct_active == false:
		construct_active = true
		var construct = arcane_construct_load.instantiate()
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
	

func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemies_in_range += 1


func _on_attack_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemies_in_range -= 1
