extends CharacterBody2D

var attacking
@onready var player: CharacterBody2D = $"../Player"

const SPEED = 25

func _ready() -> void:
	attacking = false

func _physics_process(delta: float) -> void:
	if Global.player_death == false:
		#look_at(player.position)
		if attacking == false:
			velocity = (player.position - position).normalized() * SPEED
		elif attacking == true:
			velocity = Vector2(0, 0)
			await get_tree().create_timer(1).timeout
			Global.player_health -= 25

	move_and_slide()


func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		attacking = true

func _on_attack_range_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		attacking = false
