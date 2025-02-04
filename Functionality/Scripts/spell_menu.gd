extends Node2D
var ChosenSpell = null
var Spell = null
var Spells = [-1, -2, -1, -2, -1, -2]
var Level = null
var lock = false
var UpgradeSpells = []
var NewSpells = []
var inside = false
var sideupgrade = false
var index = null


func _ready():
	pass

func _process(delta):
	var x = 0
	if Global.WaveCompleted == true and lock == false:
		for i in GameData.Spells:
			CheckPlayerSpells(i)
			if inside == true:
				UpgradeSpells.append(i)
			else:
				NewSpells.append(i)
		while Spells.count(-1) > 0: #returns three random spells to the array Spells
			RandomizeChoices(x)
			x = Spells.find(-1) # x = the first -1 in the array
		UpdateNames()
		lock = true

func _on_spell_1_pressed() -> void:
	ChosenSpell = Spells[0]
	GoBack()

func _on_spell_2_pressed() -> void:
	ChosenSpell = Spells[2]
	GoBack()

func _on_spell_3_pressed() -> void:
	ChosenSpell = Spells[4]
	GoBack()

func RandomizeChoices(x):
	var check = null
	if randi_range(1, 10) > 4:
		check = randi_range(0, UpgradeSpells.size() - 1)
		if check not in Spells:
			Spells[x] = check
			CheckSideupgrades()
			GetSpellIndex(Spells[x])
			var i = index
			CheckPlayerSpells(i)
			if 1 == 1 and sideupgrade == false and inside == true:
				Spells[x + 1] = randi_range(1, 2)
	else:
		check = randi_range(0, NewSpells.size() - 1)
		if check not in Spells:
			Spells[x] = check

func GoBack():
	var gotten = null
	var sideupgrade = 0
	lock = false
	UpgradeSpells = []
	NewSpells = []
	Global.WaveCompleted = false
	for i in Global.PlayerSpells.size():
		if Global.PlayerSpells[i][0] == ChosenSpell:
			var x = 0
			while x < 6:
				if Spells[x] == ChosenSpell and Spells[x + 1] != -2:
					sideupgrade = x
				x += 2
			if sideupgrade == 0:
				Global.PlayerSpells[i][1] += 1
			else:
				Global.PlayerSpells[i][2] = Spells[Spells.find(ChosenSpell) + 1]
			gotten = true
	if gotten != true:
		Global.PlayerSpells.append([ChosenSpell, 0, 0])
	print(Spells)
	print(Global.PlayerSpells)
	Spells = [-1, -2, -1, -2, -1, -2]
									#spell, level, sideupgrade

func UpdateNames():
	$SpellMenu_BG/Spell1.text = GameData.Spells[Spells[0]]["Name"]
	if Spells[1] != -2:
		$SpellMenu_BG/Spell1.text += "\n sidegrade"
	$SpellMenu_BG/Spell2.text = GameData.Spells[Spells[2]]["Name"]
	if Spells[3] != -2:
		$SpellMenu_BG/Spell2.text += "\n sidegrade"
	$SpellMenu_BG/Spell3.text = GameData.Spells[Spells[4]]["Name"]
	if Spells[5] != -2:
		$SpellMenu_BG/Spell3.text += "\n sidegrade"

func CheckPlayerSpells(i):
	for x in Global.PlayerSpells.size():
		if i in Global.PlayerSpells[x]:
			inside = true
		else:
			inside = false

func CheckSideupgrades():
	for i in Global.PlayerSpells.size():
		if Global.PlayerSpells[i][2] == 0:
			sideupgrade = false
		else:
			sideupgrade = true

func GetSpellIndex(spell):
	for i in GameData.Spells:
		if i == spell:
			index = i
