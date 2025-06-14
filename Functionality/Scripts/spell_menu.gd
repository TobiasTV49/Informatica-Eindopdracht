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
var active = true


func _ready():
	pass

func _process(delta):
	var x = 0
	if Global.WaveCompleted == true and lock == false:
		active = false
		for i in GameData.Spells:
			CheckPlayerSpells(i)
			if inside == true:
				UpgradeSpells.append(i)
			elif inside == false:
				NewSpells.append(i)
		while Spells.count(-1) > 0: #returns three random spells to the array Spells
			RandomizeChoices(x)
			x = Spells.find(-1) # x = the first -1 in the array
		UpdateNames()
		lock = true
	if Global.BossWaveCompleted == true and lock == false:
		active = true
		for i in GameData.Spells:
			CheckActivePlayerSpells(i)
			if inside == true:
				UpgradeSpells.append(i)
			elif inside == false:
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
	if randi_range(1, 10) > 4 and UpgradeSpells.size() != 0 or NewSpells.size() == 0:
		check = randi_range(0, UpgradeSpells.size() - 1)
		if UpgradeSpells[check] not in Spells:
			Spells[x] = UpgradeSpells[check]
			if active == false:
				CheckSideupgrades(x)
			else:
				CheckActiveSideupgrades(x)
			if active == false:
				CheckPlayerSpells(Spells[x])
			else:
				CheckActivePlayerSpells(Spells[x])
			if active == true:
				if sideupgrade == false and inside == true:
					Sideupgrades[x] = randi_range(1, 2)
			else:
				if 1 == randi_range(1,5) and sideupgrade == false and inside == true:
					Sideupgrades[x] = randi_range(1, 2)
	else:
		check = randi_range(0, NewSpells.size() - 1)
		if NewSpells[check] not in Spells:
			Spells[x] = NewSpells[check]

func GoBack():
	var gotten = null
	var sideupgrade = 0
	lock = false
	UpgradeSpells = []
	NewSpells = []
	if active == false:
		Global.WaveCompleted = false
	else:
		Global.BossWaveCompleted = false
	if active == false:
		for i in Global.PlayerSpells.size():
			if Global.PlayerSpells[i][0] == ChosenSpell:
				var x = 0
				while x < 3:
					if Spells[x] == ChosenSpell and Sideupgrades[x] != null:
						sideupgrade = Sideupgrades[x]
					x += 1
				if sideupgrade == 0:
					Global.PlayerSpells[i][1] += 1
				else:
					Global.PlayerSpells[i][2] = Sideupgrades[Spells.find(ChosenSpell)]
				gotten = true
	else:
		for i in Global.ActivePlayerSpells.size():
			if Global.ActivePlayerSpells[i][0] == ChosenSpell:
				var x = 0
				while x < 3:
					if Spells[x] == ChosenSpell and Sideupgrades[x] != null:
						sideupgrade = Sideupgrades[x]
					x += 1
				if sideupgrade == 0:
					Global.ActivePlayerSpells[i][1] += 1
				else:
					Global.ActivePlayerSpells[i][2] = Sideupgrades[Spells.find(ChosenSpell)]
				gotten = true
	if gotten != true:
		if active == false:
			Global.PlayerSpells.append([ChosenSpell, 0, 0, true])
		else:
			Global.ActivePlayerSpells.append([ChosenSpell, 0, 0])
	Spells = [-1, -1, -1]
	Sideupgrades = [null, null, null]
	Global.pre_wave.emit()


func UpdateNames():
	$SpellMenu_BG/Spell1.text = spell_text(0)
	if Sideupgrades[0] != null:
		$SpellMenu_BG/Spell1.text += "\n sidegrade " + str(Sideupgrades[0])
	$SpellMenu_BG/Spell2.text = spell_text(1)
	if Sideupgrades[1] != null:
		$SpellMenu_BG/Spell2.text += "\n sidegrade " + str(Sideupgrades[1])
	$SpellMenu_BG/Spell3.text = spell_text(2)
	if Sideupgrades[2] != null:
		$SpellMenu_BG/Spell3.text += "\n sidegrade " + str(Sideupgrades[2])

func spell_text(spell_number):
	var name: String = GameData.Spells[Spells[spell_number]]["Name"]
	var level_stats: Array
	var string_parts: Array
	var final_string: String = name
	for i in GameData.Spells[Spells[spell_number]]["Levelup"]:
		level_stats.append([i[0], i[1]])
	if Spells[spell_number] in UpgradeSpells:
		for i in level_stats:
			var key = str(i[0])
			if key == "Duration":
				print(GameData.Spells[Spells[spell_number]][key])
			var temp_string = "\n" + key + " = " + str(GameData.Spells[Spells[spell_number]][key]) + " + " + str(i[1])
			if string_parts.has(temp_string) == false:
				string_parts.append(temp_string)
	
	for i in string_parts:
		final_string += i
	
	return final_string

func CheckPlayerSpells(i):
	var lock = false
	if GameData.Spells[i]["Active"] == active:
		for x in Global.PlayerSpells.size():
			if i == Global.PlayerSpells[x][0] and lock == false:
				inside = true
				lock = true
				return inside
			else:
				inside = false
	else:
		inside = null

func CheckActivePlayerSpells(i):
	var lock = false
	if GameData.Spells[i]["Active"] == active:
		for x in Global.ActivePlayerSpells.size():
			if i == Global.ActivePlayerSpells[x][0] and lock == false:
				inside = true
				lock = true
				return inside
			else:
				inside = false
		if Global.ActivePlayerSpells.size() == 0:
			inside = false
	else:
		inside = null

func CheckSideupgrades(x):
	var lock = false
	for i in Global.PlayerSpells.size():
		if Global.PlayerSpells[i][0] == Spells[x] and lock == false:
			lock = true
			if Global.PlayerSpells[i][2] == 0:
				sideupgrade = false
			else:
				sideupgrade = true

func CheckActiveSideupgrades(x):
	var lock = false
	for i in Global.ActivePlayerSpells.size():
		if Global.ActivePlayerSpells[i][0] == Spells[x] and lock == false:
			lock = true
			if Global.ActivePlayerSpells[i][2] == 0:
				sideupgrade = false
			else:
				sideupgrade = true
