extends Area2D
var targets = []
var damage = GameData.Spells[5]["Damage"]
var lock = false

func _ready() -> void:
	self.show()
	var index = Global.GetSpellIndex(5)
	if Global.ActivePlayerSpells[index][2] == 1:
		self.scale.x = 1.25 * Global.player_range_mult
		self.scale.y = 1.25 * Global.player_range_mult
		damage *= 0.75 * Global.player_damage_mult
	elif Global.ActivePlayerSpells[index][2] == 2:
		self.scale.x = 0.75 * Global.player_range_mult
		self.scale.y = 0.75 * Global.player_range_mult
		damage *= 1.5 * Global.player_damage_mult

func _process(delta: float) -> void:
	var mousepos = get_viewport().get_camera_2d().get_global_mouse_position()
	self.position = Vector2(mousepos.x, mousepos.y)
	if Input.is_action_just_pressed("click") and lock == false:
		lock = true
		meteor_strike()

func meteor_strike():
	self.hide()
	for i in targets.size():
		Global.damage_enemy.emit(damage, targets[i])
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		targets.append(body)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		targets.erase(body)
