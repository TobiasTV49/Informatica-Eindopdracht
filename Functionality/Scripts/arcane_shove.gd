extends Area2D
var duration = 0.5

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		Global.knockback.emit(GameData.Spells[2]["Knockback"], duration, body)
		Global.damage_enemy.emit(GameData.Spells[2]["Damage"], body)
