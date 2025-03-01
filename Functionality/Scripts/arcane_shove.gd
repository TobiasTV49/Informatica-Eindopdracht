extends Area2D
var knockback = -200
var duration = 0.5

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		Global.knockback.emit(knockback, duration, body)
