extends CharacterBody2D

@export var speed = 50
var bullet_load = preload("res://Functionality/Scenes/bullet.tscn")
var arcane_shove_load = preload("res://Functionality/Scenes/arcane_shove.tscn")
var spell_list: Array

func _ready():
	$AttackTimer.start()
	Global.PlayerSpells.append([2, 0, 0])

func get_input(): #Pulls input directions and sets the velocity using them.
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	if Global.player_death == true:
		self.queue_free()
	get_input() #I wonder what this could do, i really have no clue.
	$ProgressBar.value = Global.player_health
	
	for i in Global.PlayerSpells.size():
		var index = Global.PlayerSpells[i][0]
		if spell_list.has(GameData.Spells[index]["Name"]) == false:
			spell_list.append(GameData.Spells[index]["Name"])
	
	if spell_list.has("Arcane shove"):
		var cooldown = 3
		await get_tree().create_timer(cooldown).timeout
		arcane_shove(1)
	
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

func arcane_shove(lenght: float):
	var arcane_shove = arcane_shove_load.instantiate()
	add_child(arcane_shove)
	await get_tree().create_timer(lenght).timeout
	arcane_shove.queue_free()
