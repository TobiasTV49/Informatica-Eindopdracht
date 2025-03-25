extends CharacterBody2D

var attacking = false
var SPEED = 15
var damage = 10
var health = 75
var kback = false
var locked = false
@onready var player = get_tree().get_nodes_in_group("Player")[0]
var bullet_load = preload("res://Functionality/Scenes/enemy_bullet.tscn")
var minions: Array
const SKELETON_MINION = preload("res://Functionality/Scenes/skeleton_minion.tscn")

func _ready() -> void:
	$ProgressBar.max_value = health
	Global.knockback.connect(knocked_back)
	Global.damage_enemy.connect(damaged)

func _physics_process(delta: float) -> void:
	$ProgressBar.value = health
	if Global.player_death == false:
		var direction = player.position.x - position.x
		if direction > 0:
			$enemy_sprite.flip_h = false
		else:
			$enemy_sprite.flip_h = true
			
		if attacking == false:
			velocity = (player.position - position).normalized() * SPEED * Global.enemy_speed_mult
	if Global.TimeStop == false:
		move_and_slide()


func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		attacking = true
		velocity = Vector2(0, 0)
		$Attacktimer.start()
		$SpawnTimer.start()

func _on_attack_range_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		attacking = false
		$Attacktimer.stop()
		$SpawnTimer.stop()


func _on_attacktimer_timeout() -> void:
	if Global.TimeStop == false:
		$Attacktimer.wait_time = 1.5 / Global.enemy_speed_mult
		var bullet = bullet_load.instantiate()
		var enemy_bullets = get_tree().current_scene.get_node("enemy_bullets")
		enemy_bullets.add_child(bullet)
		Global.enemy_shoot.emit("player", self.position, bullet.name, damage)
	
func knocked_back(knockback, length, body):
	if body == self and kback == false:
		kback = true
		var temp_s = SPEED
		var temp_a = attacking
		SPEED = knockback
		attacking = false
		await get_tree().create_timer(length).timeout
		kback = false
		SPEED = temp_s
		attacking = temp_a

func _on_hit_box_body_entered(body: Node2D) -> void:
	locked = false
	await get_tree().create_timer(0.05).timeout
	if is_instance_valid(body) == true:
		if body.get_meta("bullet_type") == "player bullet" and locked == false:
			body.queue_free()
			damaged(body.bullet_damage, self)
		
func damaged(damage, target):
	if target == self:
		health -= damage
		if health < 1:
			self.queue_free()
			for i in minions: #kills all the minions when the necromancer dies
				if i != null:
					i.queue_free()
					Global.enemy_killed.emit()

func _on_tree_exited() -> void:
	Global.enemy_killed.emit()


func _on_hit_box_body_exited(body: Node2D) -> void:
	locked = true


func _on_spawn_timer_timeout() -> void:
	if Global.TimeStop == false:
		$SpawnTimer.wait_time = 3 / Global.enemy_speed_mult
		var minion = SKELETON_MINION.instantiate()
		var spawn_pos: Array = [self.position + Vector2(40, 0), self.position + Vector2(-40, 0), self.position + Vector2(0, 40), self.position + Vector2(0, 40)]
		minions.append(minion)
		get_parent().add_child(minion)
		minion.position = spawn_pos.pick_random()
