extends Area2D
var targets = []
var shot = false
var aim = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = get_tree().get_nodes_in_group("Player")[0].position
	if shot == false or aim == true:
		look_at(get_viewport().get_mouse_position())
	if Input.is_action_just_pressed("click"):
		ray_of_annihilation()

func ray_of_annihilation():
	shot = true
	var damage = GameData.Spells[7]["Damage"]
	var index = Global.GetSpellIndex(7)
	var hits = 30
	if Global.ActivePlayerSpells[index][2] == 1:
		aim = true
		damage *= 0.75
		hits = 40
	elif Global.ActivePlayerSpells[index][2] == 2:
		damage *= 1.75
		Global.stunned = true
	var x = 0
	print(damage)
	while x < hits:
		for i in targets.size():
			Global.damage_enemy.emit(damage, targets[i])
		await get_tree().create_timer(0.05).timeout
		x += 1
	Global.stunned = false
	self.hide()
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		targets.append(body)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		targets.erase(body)
