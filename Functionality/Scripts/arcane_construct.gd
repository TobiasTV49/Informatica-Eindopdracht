extends CharacterBody2D

var enemies_in_range = 0
var bullet_load = preload("res://Functionality/Scenes/bullet.tscn")
var damage
var bullet_speed = 400
var player
const SPEED = 300 #very fast so it can keep up with the player

func _ready() -> void:
	$AttackTimer.start()
	player = get_tree().get_first_node_in_group("Player")
	

func _physics_process(delta: float) -> void:
	if Global.player_death == false:
		position = Vector2(25, -25)
		damage = GameData.Spells[3]["Damage"]
		var nearest_enemy = Global.get_nearest_enemy(self.position, false)
		if nearest_enemy != null:
			var direction = nearest_enemy.position.x - position.x
			if direction > 0:
				$ConstructSprite.flip_h = true
			else:
				$ConstructSprite.flip_h = false
		move_and_slide()

func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemies_in_range += 1


func _on_attack_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemies_in_range -= 1

func _on_attack_timer_timeout() -> void:
	if enemies_in_range > 0: #only shoots when there are enemies in attack range
		$AttackTimer.wait_time = 0.5 / Global.player_attack_speed_mult
		var bullet = bullet_load.instantiate()
		var player_bullets = get_tree().current_scene.get_node("player_bullets")
		var bullet_target = "enemy"
		var source = player.position + position
		player_bullets.add_child(bullet)
		Global.shoot.emit(bullet_target, source, damage, bullet_speed, 0.5)
