extends CharacterBody2D

var enemy_array: Array
var shot: bool = false
var enemy
var direction
var nearest_enemy = null
const SPEED = 50


func _process(delta: float) -> void:
	enemy_array = get_tree().get_nodes_in_group("enemies")
	if enemy_array.size() > 0:
		if nearest_enemy == null:
			nearest_enemy = enemy_array[0]
		for i in enemy_array:
			var temp_distance = position.distance_to(i.position)
			if temp_distance < position.distance_to(nearest_enemy.position):
				nearest_enemy.scale = Vector2(1, 1)
				nearest_enemy = i
		
		if nearest_enemy != null:
			nearest_enemy.scale = Vector2(0.75, 0.75)
			
		if Input.is_action_just_pressed("temp_fire"):
			shot = true
		
		if shot == false:
			look_at(nearest_enemy.position)
			if Global.player_health > 0:
				position = $"../Player".position
		
	if shot == true:
		print(rotation)
		var move_vector = Vector2(1, 0).rotated(rotation)
		velocity = move_vector * SPEED
	
	move_and_slide()
			
		#direction = Global.player_position - Global.enemy_position



func bullet() -> void:
	shot = true
	position = Global.player_position
	look_at(min(direction.length()))
