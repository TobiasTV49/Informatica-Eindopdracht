extends Node2D
var redraw = false
var x = 0
var count = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in Global.PlayerSpells.size():
		var button = Button.new()
		button.text = GameData.Spells[Global.PlayerSpells[i][0]]["Name"]
		button.position.y = 150
		button.position.x = 160 + i * 100 - $ColorRect/HScrollBar.value
		button.size.x = 75
		button.size.y = 30
		add_child(button)
		button.pressed.connect(func(): _on_spell_pressed(button.text))
		kys(button)
		if Global.PlayerSpells[i][3] == true:
			_make_label(button.position, button.size, 255, "\n active")
		else:
			_make_label(button.position, button.size, 255, "\n inactive")
	if _count() >= 3:
		Global.penalty = (_count() - 2) * 0.05
	$ColorRect/Button.text = "Continue \n penalty = " + str(Global.penalty)
	for i in GameData.Waves[Global.current_wave].size():
		$ColorRect/Label.text += GameData.Waves[Global.current_wave][i][0] + " " + str(GameData.Waves[Global.current_wave][i][1]) + "x, "

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	Global.wave_start.emit(Global.current_wave)
	Global.player_damage_mult -= Global.penalty
	queue_free()

func _on_spell_pressed(name):
	for i in Global.PlayerSpells.size():
		if name == GameData.Spells[Global.PlayerSpells[i][0]]["Name"]:
			if Global.PlayerSpells[i][3] == true:
				Global.PlayerSpells[i][3] = false
			else:
				Global.PlayerSpells[i][3] = true
	if _count() >= 3:
		Global.penalty = (_count() - 2) * 0.05
	_on_h_scroll_bar_value_changed($ColorRect/HScrollBar.value)

func kys(button):
	x += 1
	if x >= Global.PlayerSpells.size() - 1:
		redraw = false
	while redraw == false:
		await get_tree().process_frame
	button.queue_free()

func _on_h_scroll_bar_value_changed(value):
	redraw = true
	await get_tree().process_frame
	for i in Global.PlayerSpells.size():
		var button = Button.new()
		button.text = GameData.Spells[Global.PlayerSpells[i][0]]["Name"] 
		button.position.y = 150
		button.position.x = 160 + i * 100 - $ColorRect/HScrollBar.value * 2
		button.size.x = 75
		button.size.y = 30
		if button.position.x < 160:
			button.self_modulate.a8 = 255 + i * 335 - $ColorRect/HScrollBar.value * 8
		else:
			button.self_modulate.a8 = 255
		add_child(button)
		button.pressed.connect(func(): _on_spell_pressed(button.text))
		kys(button)
		if button.position.x < 90:
			button.disabled = true
		if Global.PlayerSpells[i][3] == true:
			_make_label(button.position, button.size, button.self_modulate.a8, "\n active")
		else:
			_make_label(button.position, button.size, button.self_modulate.a8, "\n inactive")
		$ColorRect/Button.text = "Continue \n penalty = " + str(Global.penalty)

func _make_label(position, size, modulation, active):
	redraw = true
	var label = Label.new()
	label.text = active
	label.position = position
	label.size = size
	label.self_modulate.a8 = modulation
	add_child(label)
	kys(label)

func _count():
	count = 0
	for i in Global.PlayerSpells.size():
		if Global.PlayerSpells[i][3] == true:
			count += 1
	return count
