extends CharacterBody2D

var attacking
var SPEED = 25
var damage = 10
var health = 50
var kback = false
@onready var player = get_tree().get_nodes_in_group("Player")[0]

func _ready() -> void:
	attacking = false
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
			velocity = (player.position - position).normalized() * SPEED
	if Global.TimeStop == false:
		move_and_slide()


func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		attacking = true
		$Attacktimer.start()

func _on_attack_range_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		attacking = false
		$Attacktimer.stop()


func _on_attacktimer_timeout() -> void:
	if Global.TimeStop == false:
		Global.damage_enemy.emit(damage)


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.get_meta("bullet_type") == "player bullet":
		body.queue_free()
		damaged(body.bullet_damage, self)

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

func damaged(damage, target):
	if target == self:
		health -= damage
		if health < 1:
			self.queue_free()

func _on_tree_exited() -> void:
	Global.enemy_killed.emit()
