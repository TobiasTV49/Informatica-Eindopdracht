extends Node2D
var ChosenSpell = null
var Spell = null
var Spells = []

func _ready():
	var x = 0
	Spells.size = 3
	while Spells.count(0) < 3:
		RandomizeChoices(x)
		x += 1
	print(Spells)


func _process(delta):
	pass


func _on_spell_1_pressed() -> void:
	ChosenSpell = 0
	GoBack()
	


func _on_spell_2_pressed() -> void:
	ChosenSpell = 1
	GoBack()

func _on_spell_3_pressed() -> void:
	ChosenSpell = 2
	GoBack()

func RandomizeChoices(x):
	var count = GameData.Spells.size() - 1
	var check = randi_range(0, count)
	if check not in Spells:
		Spells[x] = check

func GoBack():
	Global.WaveCompleted = false
