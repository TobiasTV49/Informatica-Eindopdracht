extends CharacterBody2D

var shot: bool = false
var direction
@onready var player = get_tree().get_nodes_in_group("Player")[0]
var speed = 100

func _ready():
	Global.enemy_shoot.connect(enemy_shot_fired)
	visible = false

func _process(delta: float) -> void:
	if shot == true:
		var move_vector = Vector2(1, 0).rotated(rotation)
		velocity = move_vector * speed
	move_and_slide()


func enemy_shot_fired(bullet_target, source, bullet_name):
	Global.enemy_shoot.disconnect(enemy_shot_fired)
	position = source
	if bullet_target == "player" and get_parent().name == "enemy_bullets":
		look_at(player.position)
		self.set_meta("bullet_type", "enemy bullet")
		visible = true
		shot = true
	else:
		queue_free()
