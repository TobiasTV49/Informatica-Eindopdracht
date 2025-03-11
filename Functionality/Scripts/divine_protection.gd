extends Node2D
var player

func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]

func _process(delta: float) -> void:
	position = player.position

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("damages_player"):
		body.queue_free()
		self.queue_free()
		await get_tree().create_timer(5).timeout
		print("balls")
