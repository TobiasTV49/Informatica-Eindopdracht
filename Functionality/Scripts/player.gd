extends CharacterBody2D

@export var speed = 50
var bullet_load = preload("res://Functionality/Scenes/bullet.tscn")

func _ready():
	$AttackTimer.start()

func get_input(): #Pulls input directions and sets the velocity using them.
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	if Global.player_death == true:
		self.queue_free()
	get_input() #I wonder what this could do, i really have no clue.
	$ProgressBar.value = Global.player_health
	
	move_and_slide() #Special function for characterbody2D that makes it schmove.
	



func _on_attack_timer_timeout() -> void:
	var bullet = bullet_load.instantiate()
	get_parent().add_child(bullet)
	Global.shoot.emit()
