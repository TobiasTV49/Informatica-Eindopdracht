extends Area2D
var player
var knockback = -200
var kback_body = null
var temp_s
var temp_a

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		temp_s = body.SPEED
		temp_a = body.attacking
		body.SPEED = knockback
		print("pushing: " + str(body.SPEED))
		body.attacking = false
		kback_body = body
		$knockBackDuration.start()
		body.SPEED = temp_s
		print("regular: " + str(body.SPEED))
		body.attacking = temp_a


func _on_knock_back_duration_timeout() -> void: #await not working so trying with precreated timer
	if kback_body != null:
		kback_body.SPEED = temp_s
		kback_body.attacking = temp_a
