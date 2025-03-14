extends CharacterBody2D

var enemy_array: Array
var shot: bool = false
var enemy
var direction
@onready var player = get_tree().get_nodes_in_group("Player")[0]
var SPEED = 200
var bullet_damage: int

func _ready():
	Global.shoot.connect(shot_fired)
	visible = false

func _process(delta: float) -> void:
	enemy_array = get_tree().get_nodes_in_group("enemies")
	if enemy_array.size() > 0:
		Global.get_nearest_enemy(self.position)
		if shot == true:
			var move_vector = Vector2(1, 0).rotated(rotation)
			velocity = move_vector * SPEED
	else:
		queue_free()
	move_and_slide()


func shot_fired(bullet_target, source, damage, speed, bullet_scale):
	position = source
	bullet_damage = damage
	SPEED = speed
	scale = Vector2(bullet_scale, bullet_scale)
	Global.shoot.disconnect(shot_fired)
	Global.get_nearest_enemy(self.position)
	if bullet_target == "enemy" and Global.nearest_enemy != null:
		self.set_meta("bullet_type", "player bullet")
		look_at(Global.nearest_enemy.position)
		visible = true
		shot = true
	else:
		pass
