extends CharacterBody2D

@export var speed = 50
var bullet_load = preload("res://Functionality/Scenes/bullet.tscn")
var arcane_shove_load = preload("res://Functionality/Scenes/arcane_shove.tscn")
var magical_golem_load = preload("res://Functionality/Scenes/magical_golem.tscn")
var spell_list: Array
var shove_active = false
var golem_active = false

func _ready():
	$AttackTimer.start()
	Global.PlayerSpells.append([2, 0, 0]) #adding the arcane shove spell for testing
	Global.PlayerSpells.append([4, 0, 0])

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
	
	move_and_slide() #Special function for characterbody2D that makes it schmove.
	



func _on_attack_timer_timeout() -> void:
	var bullet = bullet_load.instantiate()
	var player_bullets = get_tree().current_scene.get_node("player_bullets")
	var bullet_target = "enemy"
	var source = self.position
	player_bullets.add_child(bullet)
	bullet.position = position
	Global.shoot.emit(bullet_target, source)


func _on_player_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("damages_player"):
		body.queue_free()
		Global.player_health -= 10
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
		add_child(golem)
		golem.position = position
		golem.position.y -= 16
