extends Node2D
var ChosenSpell = null
var Spell = null
var Spells = [-1, -1, -1]
var Level = null
var lock = false

func _ready():
	pass

func _process(delta):
	var x = 0
	if Global.WaveCompleted == true and lock == false:
		while Spells.count(-1) > 0: #returns three random spells to the array Spells
			RandomizeChoices(x)
			x = Spells.find(-1) # x = the first -1 in the array
		UpdateNames()
		lock = true

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
	var gotten = null
	lock = false
	Spells = [-1, -1, -1]
	Global.WaveCompleted = false
	for i in Global.PlayerSpells.size():
		if Global.PlayerSpells[i][0] == ChosenSpell:
			Global.PlayerSpells[i][1] += 1
			gotten = 1
	if gotten != 1:
		Global.PlayerSpells.append([ChosenSpell, 0])

func UpdateNames():
	$SpellMenu_BG/Spell1.text = GameData.Spells[Spells[0]]["Name"]
	$SpellMenu_BG/Spell2.text = GameData.Spells[Spells[1]]["Name"]
	$SpellMenu_BG/Spell3.text = GameData.Spells[Spells[2]]["Name"]
