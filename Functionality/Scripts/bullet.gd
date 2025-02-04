extends CharacterBody2D

var enemy_array: Array
var shot: bool = false
var enemy
var direction
var nearest_enemy = null
const SPEED = 200

func _ready():
	Global.shoot.connect(shot_fired)
	visible = false

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
		
		if shot == true:
			var move_vector = Vector2(1, 0).rotated(rotation)
			velocity = move_vector * SPEED
	else:
		queue_free()
	move_and_slide()
			
		#direction = Global.player_position - Global.enemy_position

func shot_fired():
	if Global.player_health > 0:
		position = $"../Player".position
	if nearest_enemy != null:
		look_at(nearest_enemy.position)
		visible = true
		shot = true
		Global.shoot.disconnect(shot_fired)


func bullet() -> void:
	shot = true
	position = Global.player_position
	look_at(min(direction.length()))
