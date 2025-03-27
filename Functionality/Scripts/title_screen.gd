extends Control

func _ready() -> void:
	reset()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Functionality/Scenes/character_select.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()

func reset(): #Resets all Global variables as they should be
	Global.WaveCompleted = false
	Global.BossWaveCompleted = true
	Global.chosen_character = null
	Global.current_wave = 0
	Global.player_health = 50
	Global.player_death = false
	Global.player_position = null
	Global.enemy_position = null
	Global.nearest_enemy = null
	Global.PlayerSpells = []
	Global.ActivePlayerSpells = []
	Global.PlayerItems = []
	Global.PlayerCoins = 0
	Global.coinsPerEnemy = 2
	Global.DruidMenu = false
	Global.TimeStop = false
	Global.stunned = false
	Global.enemy_speed_mult = 1
	Global.player_range_mult = 1
	Global.player_movement_speed_mult = 1 
	Global.player_dodge = 2
	Global.player_damage_reduction_mult = 1
	Global.player_attack_speed_mult = 1 
	Global.player_damage_mult = 1
	Global.room_coords_x = [0, 640]
