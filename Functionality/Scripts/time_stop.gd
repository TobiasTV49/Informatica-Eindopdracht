extends Area2D

var lock = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = get_tree().get_nodes_in_group("Player")[0].position
	if Input.is_action_just_pressed("click") and lock == false:
		lock = true
		time_stop()

func time_stop():
	self.hide()
	var index = Global.GetSpellIndex(6)
	if Global.ActivePlayerSpells[index][2] == 1:
		print(Global.enemy_speed_mult)
		Global.enemy_speed_mult /= 2
		print(Global.enemy_speed_mult)
		await get_tree().create_timer(6).timeout
		Global.enemy_speed_mult *= 2
	elif Global.ActivePlayerSpells[index][2] == 2:
		Global.player_attack_speed_mult *= 2
		Global.player_movement_speed_mult *= 2
		await get_tree().create_timer(6).timeout
		Global.player_attack_speed_mult /= 2
		Global.player_movement_speed_mult /= 2
	elif Global.ActivePlayerSpells[index][2] == 0:
		Global.TimeStop = true
		await get_tree().create_timer(4).timeout
		Global.TimeStop = false
	queue_free()
	
