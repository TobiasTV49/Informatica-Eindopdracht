extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = get_tree().get_nodes_in_group("Player")[0].position
	if Input.is_action_just_pressed("click"):
		time_stop()

func time_stop():
	self.hide()
	Global.TimeStop = true
	await get_tree().create_timer(4).timeout
	Global.TimeStop = false
	queue_free()
