extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Button1.text = GameData.Wizards[0]["Name"]
	$Button2.text = GameData.Wizards[1]["Name"]
	$Button3.text = GameData.Wizards[2]["Name"]
	$Button4.text = GameData.Wizards[3]["Name"]
	$Button5.text = GameData.Wizards[3]["Name"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_1_pressed():
	Global.chosen_character = 0
	leave()


func _on_button_2_pressed():
	Global.chosen_character = 1
	leave()


func _on_button_3_pressed():
	Global.chosen_character = 2
	leave()


func _on_button_4_pressed():
	Global.chosen_character = 3
	leave()


func _on_button_5_pressed():
	Global.chosen_character = 4
	leave()

func leave():
	for i in GameData.Wizards[Global.chosen_character]["Bonusses"]:
		if i[0] == "player_range_mult":
			Global.player_range_mult = i[1]
		elif i[0] == "player_movement_speed_mult":
			Global.player_movement_speed_mult = i[1]
		elif i[0] == "player_dodge":
			Global.player_dodge = i[1]
		elif i[0] == "player_damage_reduction_mult":
			Global.player_damage_reduction_mult = i[1]
		elif i[0] == "player_attack_speed_mult":
			Global.player_attack_speed_mult = i[1]
		elif i[0] == "player_damage_mult":
			Global.player_damage_mult = i[1]
	Global.PlayerSpells.append([GameData.Wizards[Global.chosen_character]["Starting weapon"], 0, 0, true])
	get_tree().change_scene_to_file("res://Functionality/Scenes/main.tscn")
