extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$YouDied.add_theme_color_override("font_color", Color(255, 0, 0))
	$WaveAndCoins.text = "Wave " + str(Global.current_wave) + " Reached\n" + str(Global.PlayerCoins) + " Coins found"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Global.final_boss_beaten == true:
		$YouDied.text = "You Won!"
		$YouDied.add_theme_color_override("font_color", Color(0, 255, 0))



func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Functionality/Scenes/title_screen.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
