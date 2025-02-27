extends Area2D
var player
var knockback = -200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		var temp_s = body.SPEED
		var temp_a = body.attacking
		body.SPEED = knockback
		body.attacking = false
		await get_tree().create_timer(0.5).timeout
		body.SPEED = temp_s
		body.attacking = temp_a
