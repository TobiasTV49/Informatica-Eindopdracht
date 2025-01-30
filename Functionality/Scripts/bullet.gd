extends Area2D

var enemy_array: Array
var shot: bool = true #i made it true to make the code runnable for now
var enemy
var direction

func _process(delta: float) -> void:
	enemy_array = get_tree().get_nodes_in_group("enemies") #dit is denk ik beter dan: = []
	if shot == false:
		direction = Global.player_position - Global.enemy_position

func bullet() -> void:
	shot = true
	position = Global.player_position
	look_at(min(direction.length()))
