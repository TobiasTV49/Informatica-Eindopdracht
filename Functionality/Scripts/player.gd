extends CharacterBody2D

@export var speed = 50



func get_input(): #Pulls input directions and sets the velocity using them.
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input() #I wonder what this could do, i really have no clue.
	move_and_slide() #Special function for characterbody2D that makes it schmove.
	Global.player_position = self
