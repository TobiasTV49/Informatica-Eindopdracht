extends Area2D
var targets = []

func _ready() -> void:
	self.show()

func _process(delta: float) -> void:
	var mousepos = get_viewport().get_mouse_position()
	self.position = Vector2(mousepos.x * 0.80, mousepos.y * 0.80)
	if Input.is_action_just_pressed("click"):
		meteor_strike()

func meteor_strike():
	self.hide()
	var damage = GameData.Spells[5]["Damage"]
	for i in targets.size():
		Global.damage_enemy.emit(damage, targets[i])
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		targets.append(body)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		targets.erase(body)
