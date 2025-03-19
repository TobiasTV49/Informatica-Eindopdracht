extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$EruptionArea/EruptionAreaShape.disabled = true
	await get_tree().create_timer(2).timeout
	$EruptionArea/EruptionAreaShape.disabled = false
	$EruptionSprite.modulate = Color(255, 50, 50, 100)
	await get_tree().create_timer(1).timeout
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_eruption_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.damage_player.emit(15)
