extends Node2D
var ChosenSpell = 0

func _ready():
	RandomizeChoices()


func _process(delta):
	pass


func _on_spell_1_pressed() -> void:
	ChosenSpell = 1
	GoBack()
	


func _on_spell_2_pressed() -> void:
	ChosenSpell = 2
	GoBack()

func _on_spell_3_pressed() -> void:
	ChosenSpell = 3
	GoBack()

func RandomizeChoices():
	pass

func GoBack():
	Global.WaveCompleted = false
