extends Control

func _ready() -> void:
	reset()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Functionality/Scenes/character_select.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()

func reset(): #this function will reset all the variables, but i couldnt be bothered right now <3
	pass
