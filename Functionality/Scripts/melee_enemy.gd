extends CharacterBody2D

var attacking
const SPEED = 25
var damage = 10
@onready var player = get_tree().get_nodes_in_group("Player")[0]

func _ready() -> void:
	attacking = false

func _physics_process(delta: float) -> void:
	if Global.player_death == false:
		#look_at(player.position)
		if attacking == false:
			velocity = (player.position - position).normalized() * SPEED
		else:
			velocity = Vector2(0, 0)

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
	print("meleeAttack")
	Global.player_health -= damage
