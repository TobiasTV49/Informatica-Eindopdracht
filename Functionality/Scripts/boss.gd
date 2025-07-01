extends CharacterBody2D

const max_health = 500
var SPEED = 600.0
var health
var eruption_spawn_areaX = [20, 620] #x-coords waarin eruptions kunnen spawnen
var eruption_spawn_areaY = [20, 340] #x-coords waarin eruptions kunnen spawnen
@onready var player = get_tree().get_nodes_in_group("Player")[0]
var dashing = false
var boss_bar = null
var phase = 1
var bullet_load = preload("res://Functionality/Scenes/bullet.tscn")

func _ready() -> void:
	health = max_health
	Global.damage_enemy.connect(damaged)
	$Dash/dashDamageBox/DamageBoxShape.disabled = true
	$Dash.visible = false
	$AttackTimer.start()
	$EruptionTimer.start()
	$ConstructSpawnTimer.start()
	boss_bar = get_parent().get_parent().get_node("CanvasLayer/BossBar")
	boss_bar.max_value = max_health
	await get_tree().create_timer(1).timeout
	boss_dash()


func _physics_process(delta: float) -> void:
	$Dash/DashEnd.position.x = $Dash/DashWarning.size.x
	if boss_bar != null:
		boss_bar.value = health
	
	if Global.TimeStop == true:
		$AttackTimer.paused = true
		$EruptionTimer.paused = true
		$ConstructSpawnTimer.paused = true
	else:
		$AttackTimer.paused = false
		$EruptionTimer.paused = false
		$ConstructSpawnTimer.paused = false
	
	var direction = player.position.x - position.x
	if direction > 0:
		$bossUpperBody.flip_h = false
	else:
		$bossUpperBody.flip_h = true
	
	if health <= (max_health/2):
		phase = 2
		get_parent().get_parent().get_node("CanvasModulate").color = Color(1.0, 0.5, 0.0)
	else:
		phase = 1
		get_parent().get_parent().get_node("CanvasModulate").color = Color(1.25, 0.75, 0.2)
	
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
		if Global.PlayerSpells[0][2] == 1:
			var bullet = bullet_load.instantiate()
			var player_bullets = get_tree().current_scene.get_node("player_bullets")
			var bullet_target = "enemy"
			var source = self.position
			player_bullets.add_child(bullet)
			bullet.position = position
			$HitBox/HitBoxShape.call_deferred("set","disabled",true)
			Global.shoot.emit(bullet_target, source, GameData.Spells[0]["Damage"], 200, 1, true)
			await get_tree().create_timer(0.2).timeout
			$HitBox/HitBoxShape.call_deferred("set","disabled",false)

func damaged(damage, target):
	if target == self:
		health -= damage
		Global.DamageNumbers(damage, self.position)
		if health < 1:
			Global.final_boss_beaten = true
			player.queue_free()
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
	if Global.TimeStop == false:
		velocity = direction * SPEED * Global.enemy_speed_mult
	await get_tree().create_timer(0.5).timeout
	velocity = Vector2(0, 0)
	$Dash/dashDamageBox/DamageBoxShape.disabled = true
	dashing = false
	if Global.player_death == false:
		$AttackTimer.start()
		
func spawn_constructs():
	var spawn_pos: Array = [self.position + Vector2(80, 0), self.position + Vector2(-80, 0)]
	for i in range(0, 2): #spawns 2 constructs
		var construct = preload("res://Functionality/Scenes/ranged_enemy.tscn").instantiate()
		construct.get_node("enemy_sprite").texture = load("res://Assets/gorillaBrawnBuff.png") #gorilla brawn texture is TEMPORARY obviously
		construct.get_node("eyeball").visible = false
		construct.get_node("Collision").disabled = true
		construct.get_node("Attacktimer").wait_time = 2.5
		construct.bullet_type = "flame_bullet"
		get_parent().add_child(construct)
		construct.position = spawn_pos[0]
		if construct.position.x < Global.room_coords_x[0] or construct.position.x > Global.room_coords_x[1]: #deletes the construct if it spawns outside the room borders
			construct.queue_free()
		spawn_pos.remove_at(0)
		
func _on_dash_damage_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.damage_player.emit(25)


func _on_attack_timer_timeout() -> void:
	if dashing == false and Global.TimeStop == false:
		$AttackTimer.stop()
		boss_dash()


func _on_eruption_timer_timeout() -> void:
	if phase == 2 and Global.TimeStop == false:
		spawn_eruption() #spawns 2 eruptions every x seconds when the boss has < 1/2 max health
		spawn_eruption()


func _on_construct_spawn_timer_timeout() -> void:
	print("spawning constructs")
	spawn_constructs()
