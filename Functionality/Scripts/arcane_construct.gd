extends CharacterBody2D

var enemies_in_range = 0
var bullet_load = preload("res://Functionality/Scenes/bullet.tscn")
var damage = 2
var bullet_speed = 400
var player
const SPEED = 300 #very fast so it can keep up with the player

func _ready() -> void:
	$AttackTimer.start()
	player = get_tree().get_first_node_in_group("Player")
	

func _physics_process(delta: float) -> void:
	position = player.position + Vector2(25, -25)

	move_and_slide()

func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemies_in_range += 1


func _on_attack_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemies_in_range -= 1

func _on_attack_timer_timeout() -> void:
	if enemies_in_range > 0: #only shoots when there are enemies in attack range
		var bullet = bullet_load.instantiate()
		var player_bullets = get_tree().current_scene.get_node("player_bullets")
		var bullet_target = "enemy"
		var source = self.position
		player_bullets.add_child(bullet)
		bullet.position = position
		Global.shoot.emit(bullet_target, source, damage, bullet_speed, 0.5)
		print("balls")
