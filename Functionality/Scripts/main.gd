extends Node2D
@onready var player: CharacterBody2D = $Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.player_death = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.player_health > 0 and Global.player_death == false: #player is alive
		if player.position.y > 0: #this is for testing the following system
			$Player.position.y -= 1
	elif Global.player_health <= 0 and Global.player_death == false: #player is about to die
		Global.player_death = true
		player.queue_free()