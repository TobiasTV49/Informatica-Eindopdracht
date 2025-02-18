extends Node2D
var ChosenSpell = null
var Spell = null
var Spells = [-1, -1, -1]
var Sideupgrades = [null, null, null]
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
	ChosenSpell = Spells[1]
	GoBack()

func _on_spell_3_pressed() -> void:
	ChosenSpell = Spells[2]
	GoBack()

func RandomizeChoices(x):
	var check = null
	if randi_range(1, 10) > 4 and UpgradeSpells.size() != 0:
		check = randi_range(0, UpgradeSpells.size() - 1)
		if check not in Spells:
			Spells[x] = UpgradeSpells[check]
			CheckSideupgrades(x)
			GetSpellIndex(Spells[x])
			var i = index
			CheckPlayerSpells(i)
			if randi_range(1, 10) == 1 and sideupgrade == false and inside == true:
				Sideupgrades[x] = randi_range(1, 2)
	else:
		check = randi_range(0, NewSpells.size() - 1)
		if check not in Spells:
			Spells[x] = NewSpells[check]

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
			while x < 3:
				if Spells[x] == ChosenSpell and Sideupgrades[x] != null:
					sideupgrade = x
				x += 1
			if sideupgrade == 0:
				Global.PlayerSpells[i][1] += 1
			else:
				Global.PlayerSpells[i][2] = Sideupgrades[Spells.find(ChosenSpell)]
			gotten = true
	if gotten != true:
		Global.PlayerSpells.append([ChosenSpell, 0, 0])
	Spells = [-1, -1, -1]
	Sideupgrades = [null, null, null]
									#spell, level, sideupgrade

func UpdateNames():
	$SpellMenu_BG/Spell1.text = GameData.Spells[Spells[0]]["Name"]
	if Sideupgrades[0] != null:
		$SpellMenu_BG/Spell1.text += "\n sidegrade"
	$SpellMenu_BG/Spell2.text = GameData.Spells[Spells[1]]["Name"]
	if Sideupgrades[1] != null:
		$SpellMenu_BG/Spell2.text += "\n sidegrade"
	$SpellMenu_BG/Spell3.text = GameData.Spells[Spells[2]]["Name"]
	if Sideupgrades[2] != null:
		$SpellMenu_BG/Spell3.text += "\n sidegrade"

func CheckPlayerSpells(i):
	var lock = false
	for x in Global.PlayerSpells.size():
		if i == Global.PlayerSpells[x][0] and lock == false:
			inside = true
			lock = true
			return inside
		else:
			inside = false

func CheckSideupgrades(x):
	var lock = false
	for i in Global.PlayerSpells.size():
		if Global.PlayerSpells[i][0] == Spells[x] and lock == false:
			lock = true
			if Global.PlayerSpells[i][2] == 0:
				sideupgrade = false
			else:
				sideupgrade = true

func GetSpellIndex(spell):
	for i in GameData.Spells:
		if i == spell:
			index = i
