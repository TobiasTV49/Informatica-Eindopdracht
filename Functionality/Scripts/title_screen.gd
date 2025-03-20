extends Control


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Functionality/Scenes/character_select.tscn")


func _on_quit_pressed() -> void:
	queue_free()
