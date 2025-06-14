extends Node2D
var redraw = false
var x = 0
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	Global.wave_start.emit(Global.current_wave)
	queue_free()

func _on_spell_pressed(name):
	for i in Global.PlayerSpells.size():
		if name == GameData.Spells[Global.PlayerSpells[i][0]]["Name"]:
			if Global.PlayerSpells[i][3] == true:
				Global.PlayerSpells[i][3] = false
			else:
				Global.PlayerSpells[i][3] = true

func kys(button):
	while redraw == false:
		await get_tree().process_frame
	x += 1
	if x >= Global.PlayerSpells.size():
		redraw = false
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
		button.self_modulate.a8 = 255 - $ColorRect/HScrollBar.value * 8
		add_child(button)
		button.pressed.connect(func(): _on_spell_pressed(button.text))
		kys(button)
		if button.position.x < 90:
			button.disabled = true
