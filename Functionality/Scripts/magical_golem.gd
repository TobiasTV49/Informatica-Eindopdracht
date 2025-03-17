extends CharacterBody2D


var SPEED = 50
var attacking = false
var nearest_enemy
var target
var damage = 15
var player

func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]


func _physics_process(delta: float) -> void:
	if Global.player_death == false:
		get_nearest_enemy()
		if nearest_enemy != null and player.enemies_in_range > 0:
			var direction = nearest_enemy.position.x - position.x
			if direction > 0:
				$golem_sprite.flip_h = false
			else:
				$golem_sprite.flip_h = true
			
			if attacking == false:
				velocity = (nearest_enemy.position - position).normalized() * SPEED * Global.player_speed_mult
		else:
			var direction = player.position.x - position.x
			if direction > 0:
				$golem_sprite.flip_h = false
			else:
				$golem_sprite.flip_h = true
			
			if position.distance_to(player.position) > 50:
				velocity = (player.position - position).normalized() * SPEED * Global.player_speed_mult

	move_and_slide()

func get_nearest_enemy():
	var enemy_array = get_tree().get_nodes_in_group("enemies")
	if enemy_array.size() > 0:
		if nearest_enemy == null:
			nearest_enemy = enemy_array[0]
		for i in enemy_array:
			var temp_distance = position.distance_to(i.position)
			if temp_distance < position.distance_to(nearest_enemy.position):
				nearest_enemy = i
	else:
		velocity = Vector2(0, 0)


func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		attacking = true
		target = body
		$Attacktimer.start()

func _on_attack_range_body_exited(body: Node2D) -> void:
	if body == target:
		attacking = false
		$Attacktimer.stop()

func _on_attacktimer_timeout() -> void:
	$Attacktimer.wait_time = 1 / Global.player_speed_mult
	Global.damage_enemy.emit(damage, target)
