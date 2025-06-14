extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in Global.PlayerSpells.size():
		print(Global.PlayerSpells)
		var button = Button.new()
		button.text = GameData.Spells[Global.PlayerSpells[i][0]]["Name"]
		button.position.y = 150
		button.position.x = 0 + i * 100
		button.size.x = 75
		button.size.y = 30
		add_child(button)
		button.pressed.connect(func(): _on_spell_pressed(button.text))

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
