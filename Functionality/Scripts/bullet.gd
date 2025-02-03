extends Area2D

var enemy_array: Array
var shot: bool = false
var enemy
var direction
var nearest_enemy = null


func _process(delta: float) -> void:
	enemy_array = get_tree().get_nodes_in_group("enemies") #dit is denk ik beter dan: = []
	if enemy_array.size() > 0:
		if nearest_enemy == null:
			nearest_enemy = enemy_array[0]
		for i in enemy_array:
			var temp_distance = position.distance_to(i.position)
			if temp_distance < position.distance_to(nearest_enemy.position):
				nearest_enemy.scale = Vector2(1, 1)
				nearest_enemy = i
		
		if nearest_enemy != null:
			pass
			nearest_enemy.scale = Vector2(0.75, 0.75)
	
	if shot == false:
		if Global.player_health > 0:
			position = $"../Player".position
		#direction = Global.player_position - Global.enemy_position

func bullet() -> void:
	shot = true
	position = Global.player_position
	look_at(min(direction.length()))
