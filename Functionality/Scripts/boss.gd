extends CharacterBody2D

const max_health = 300
var SPEED = 600.0
var health
var eruption_spawn_areaX = [20, 620] #x-coords waarin eruptions kunnen spawnen
var eruption_spawn_areaY = [20, 340] #x-coords waarin eruptions kunnen spawnen
@onready var player = get_tree().get_nodes_in_group("Player")[0]
var dashing = false
var boss_bar = null

func _ready() -> void:
	health = max_health
	Global.damage_enemy.connect(damaged)
	$Dash/dashDamageBox/DamageBoxShape.disabled = true
	await get_tree().create_timer(2).timeout
	$AttackTimer.start()
	$EruptionTimer.start()
	boss_bar = get_parent().get_parent().get_node("CanvasLayer/BossBar")
	print(boss_bar.name)
	boss_bar.max_value = max_health


func _physics_process(delta: float) -> void:
	$Dash/DashEnd.position.x = $Dash/DashWarning.size.x
	if boss_bar != null:
		boss_bar.visible = true
		boss_bar.value = health
	
	move_and_slide()

func spawn_eruption():
	var eruption = preload("res://Functionality/Scenes/eruption.tscn").instantiate()
	get_parent().add_child(eruption)
	eruption.position.x = randi_range(eruption_spawn_areaX[0], eruption_spawn_areaX[1])
	eruption.position.y = randi_range(eruption_spawn_areaY[0], eruption_spawn_areaY[1])

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.get_meta("bullet_type") == "player bullet":
		body.queue_free()
		damaged(body.bullet_damage, self)

func damaged(damage, target):
	if target == self:
		health -= damage
		if health < 1:
			self.queue_free()

func boss_dash():
	dashing = true
	SPEED = $Dash/DashWarning.size.x * 2
	$Dash.look_at(player.position)
	$Dash.visible = true
	var direction = (player.position - position).normalized()
	await get_tree().create_timer(1.5).timeout
	$Dash.visible = false
	$Dash/dashDamageBox/DamageBoxShape.disabled = false
	velocity = direction * SPEED * Global.enemy_speed_mult
	await get_tree().create_timer(0.5).timeout
	velocity = Vector2(0, 0)
	$Dash/dashDamageBox/DamageBoxShape.disabled = true
	dashing = false
	if Global.player_death == false:
		$AttackTimer.start()
		


func _on_dash_damage_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("balls")
		Global.damage_player.emit(25)


func _on_attack_timer_timeout() -> void:
	if dashing == false and Global.TimeStop == false:
		$AttackTimer.stop()
		boss_dash()


func _on_eruption_timer_timeout() -> void:
	spawn_eruption()
