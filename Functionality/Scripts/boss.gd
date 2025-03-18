extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var player = get_tree().get_nodes_in_group("Player")[0]


func _physics_process(delta: float) -> void:
	$Dash.look_at(player.position)
	move_and_slide()
