extends Node2D
var ChosenSpell = null
var Spell = null
var Spells = [-1, -1, -1]
var Level = null

func _ready():
	var x = 0
	while Spells.count(-1) > 0: #returns three random spells to the array Spells
		RandomizeChoices(x)
		x = Spells.find(-1) # x = the first -1 in the array


func _process(delta):
	pass


func _on_spell_1_pressed() -> void:
	ChosenSpell = Spells[0]
	GoBack()

func _on_spell_2_pressed() -> void:
	ChosenSpell = Spells[1]
	GoBack()

func _on_spell_3_pressed() -> void:
	ChosenSpell = Spells[2]
	GoBack()

func RandomizeChoices(x):
	var count = GameData.Spells.size() - 1 #how many spells are in the game
	var check = randi_range(0, count) 
	if check not in Spells:
		Spells[x] = check

func GoBack():
	Global.WaveCompleted = false
	for i in Global.PlayerSpells:
		if Global.PlayerSpells[i][0] == ChosenSpell:
			Level = Global.PlayerSpells[i][1]
	Global.PlayerSpells.append([ChosenSpell, Level])
