extends Area2D
var targets = []

# Called when the node enters the scene tree for the first time.
func _ready():
	self.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = get_tree().get_nodes_in_group("Player")[0].position
	look_at(get_viewport().get_mouse_position())
	if Input.is_action_just_pressed("click"):
		ray_of_annihilation()

func ray_of_annihilation():
	self.hide()
	var damage = GameData.Spells[7]["Damage"]
	var x = 0
	while x < 10:
		for i in targets.size():
			Global.damage_enemy.emit(damage, targets[i])
		await get_tree().create_timer(0.05).timeout
		x += 1
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		targets.append(body)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		targets.erase(body)
