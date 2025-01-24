extends Area2D

var enemy_array = []
var shot: bool
var enemy

func _process(delta: float) -> void:
	if shot == false:
		var direction = Global.player_position - Global.enemy_position

func bullet() -> void:
	shot = true
	position = Global.player_position
	look_at(min(direction.length()))
