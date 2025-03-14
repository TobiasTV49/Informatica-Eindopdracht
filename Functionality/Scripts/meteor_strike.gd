extends Area2D
var targets = []
var damage = GameData.Spells[5]["Damage"]

func _ready() -> void:
	self.show()
	var index = Global.GetSpellIndex(5)
	if Global.ActivePlayerSpells[index][2] == 1:
		self.scale.x = 1.25
		self.scale.y = 1.25
		damage *= 0.75
	elif Global.ActivePlayerSpells[index][2] == 2:
		self.scale.x = 0.75
		self.scale.y = 0.75
		damage *= 1.5

func _process(delta: float) -> void:
	var mousepos = get_viewport().get_mouse_position()
	self.position = Vector2(mousepos.x * 0.80, mousepos.y * 0.80)
	if Input.is_action_just_pressed("click"):
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
