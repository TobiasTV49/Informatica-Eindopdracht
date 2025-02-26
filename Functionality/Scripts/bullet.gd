extends CharacterBody2D

var enemy_array: Array
var shot: bool = false
var enemy
var direction
@onready var player = get_tree().get_nodes_in_group("Player")[0]
const SPEED = 200

func _ready():
	Global.shoot.connect(shot_fired)
	visible = false

func _process(delta: float) -> void:
	enemy_array = get_tree().get_nodes_in_group("enemies")
	if enemy_array.size() > 0:
		get_nearest_enemy()
		if shot == true:
			var move_vector = Vector2(1, 0).rotated(rotation)
			velocity = move_vector * SPEED
		
	else:
		queue_free()
	move_and_slide()

func get_nearest_enemy():
	enemy_array = get_tree().get_nodes_in_group("enemies")
	if enemy_array.size() > 0:
		if Global.nearest_enemy == null:
			Global.nearest_enemy = enemy_array[0]
		for i in enemy_array:
			var temp_distance = position.distance_to(i.position)
			if temp_distance < position.distance_to(Global.nearest_enemy.position):
				Global.nearest_enemy.scale = Vector2(1, 1)
				Global.nearest_enemy = i

func shot_fired(bullet_target, source):
	position = source
	Global.shoot.disconnect(shot_fired)
	get_nearest_enemy()
	if bullet_target == "enemy" and Global.nearest_enemy != null:
		self.set_meta("bullet_type", "player bullet")
		look_at(Global.nearest_enemy.position)
		visible = true
		shot = true
	else:
		pass
