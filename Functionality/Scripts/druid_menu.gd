extends Node2D
var lock = false
var ChosenItem = null
var Item = null
var Items = [0, -1, -1, -1, -1, -1]
var Bought = [false, false, false, false, false, false]

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var x = Items.find(-1)
	if Global.DruidMenu == true and lock == false:
		while Items.count(-1) > 0:
			RandomizeChoices(x)
			x = Items.find(-1)
		UpdateNames()
		lock = true
	if Global.DruidMenu == true:
		UpdateSlots()

func _on_item_1_pressed() -> void:
	ChosenItem = Items[0]
	Global.player_health += 15
	Checkout()
	Bought[0] = true

func _on_item_2_pressed() -> void:
	ChosenItem = Items[1]
	Checkout()
	Bought[1] = true

func _on_item_3_pressed() -> void:
	ChosenItem = Items[2]
	Checkout()
	Bought[2] = true

func _on_item_4_pressed() -> void:
	ChosenItem = Items[3]
	Checkout()
	Bought[3] = true

func _on_item_5_pressed() -> void:
	ChosenItem = Items[4]
	Checkout()
	Bought[4] = true

func _on_item_6_pressed() -> void:
	ChosenItem = Items[5]
	Checkout()
	Bought[5] = true

func _on_close_pressed():
	Global.DruidMenu = false
	lock = false
	Items = [0, -1, -1, -1, -1, -1]
	Bought = [false, false, false, false, false, false]
	update_item_stats()

func RandomizeChoices(x):
	var check = null
	check = randi_range(0, GameData.Items.size() - 1)
	if check not in Items:
		Items[x] = check

func UpdateNames():
	$DruidMenu_BG/Item1.text = str(GameData.Items[Items[0]]["Name"]) + "\n" + str(GameData.Items[Items[0]]["Cost"])
	$DruidMenu_BG/Item2.text = str(GameData.Items[Items[1]]["Name"]) + "\n" + str(GameData.Items[Items[1]]["Cost"])
	$DruidMenu_BG/Item3.text = str(GameData.Items[Items[2]]["Name"]) + "\n" + str(GameData.Items[Items[2]]["Cost"])
	$DruidMenu_BG/Item4.text = str(GameData.Items[Items[3]]["Name"]) + "\n" + str(GameData.Items[Items[3]]["Cost"])
	$DruidMenu_BG/Item5.text = str(GameData.Items[Items[4]]["Name"]) + "\n" + str(GameData.Items[Items[4]]["Cost"])
	$DruidMenu_BG/Item6.text = str(GameData.Items[Items[5]]["Name"]) + "\n" + str(GameData.Items[Items[5]]["Cost"])

func UpdateSlots():
	if GameData.Items[Items[0]]["Cost"] > Global.PlayerCoins or Bought[0] == true:
		$DruidMenu_BG/Item1.disabled = true
	else:
		$DruidMenu_BG/Item1.disabled = false
	if GameData.Items[Items[1]]["Cost"] > Global.PlayerCoins or Bought[1] == true:
		$DruidMenu_BG/Item2.disabled = true
	else:
		$DruidMenu_BG/Item2.disabled = false
	if GameData.Items[Items[2]]["Cost"] > Global.PlayerCoins or Bought[2] == true:
		$DruidMenu_BG/Item3.disabled = true
	else:
		$DruidMenu_BG/Item3.disabled = false
	if GameData.Items[Items[3]]["Cost"] > Global.PlayerCoins or Bought[3] == true:
		$DruidMenu_BG/Item4.disabled = true
	else:
		$DruidMenu_BG/Item4.disabled = false
	if GameData.Items[Items[4]]["Cost"] > Global.PlayerCoins or Bought[4] == true:
		$DruidMenu_BG/Item5.disabled = true
	else:
		$DruidMenu_BG/Item5.disabled = false
	if GameData.Items[Items[5]]["Cost"] > Global.PlayerCoins or Bought[5] == true:
		$DruidMenu_BG/Item6.disabled = true
	else:
		$DruidMenu_BG/Item6.disabled = false

func Checkout():
	if Global.PlayerCoins >= GameData.Items[ChosenItem]["Cost"]:
		Global.PlayerCoins -= GameData.Items[ChosenItem]["Cost"]
		var gotten = false
		for i in Global.PlayerItems.size():
			if Global.PlayerItems[i][0] == ChosenItem:
				Global.PlayerItems[i][1] += 1
				gotten = true
		if gotten == false:
			Global.PlayerItems.append([ChosenItem, 1])
	else:
		print("You don't have enough money")

func update_item_stats():
	if Global.PlayerItems.size() > 0:
		if Global.CheckPlayerItems(1) == true:
			Global.player_range_mult = 1 + (GameData.Items[1]["Effect"] * Global.PlayerItems[Global.GetItemIndex(1)][1])
		if Global.CheckPlayerItems(2) == true:
			Global.player_movement_speed_mult = 1 + (GameData.Items[2]["Effect"] * Global.PlayerItems[Global.GetItemIndex(2)][1])
			Global.player_dodge = 2 + (2 * Global.PlayerItems[Global.GetItemIndex(2)][1])
		if Global.CheckPlayerItems(3) == true:
			Global.player_damage_reduction_mult = 1 + (GameData.Items[3]["Effect"] * Global.PlayerItems[Global.GetItemIndex(3)][1])
		if Global.CheckPlayerItems(4) == true:
			Global.player_attack_speed_mult = 1 + (GameData.Items[4]["Effect"] * Global.PlayerItems[Global.GetItemIndex(4)][1])
		if Global.CheckPlayerItems(5) == true:
			Global.player_damage_mult = 1 + (GameData.Items[5]["Effect"] * Global.PlayerItems[Global.GetItemIndex(5)][1])
