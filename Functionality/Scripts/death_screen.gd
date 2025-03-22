extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$WaveAndCoins.text = "Wave " + str(Global.current_wave) + " Reached\n" + str(Global.PlayerCoins) + " Coins found"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Functionality/Scenes/title_screen.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
