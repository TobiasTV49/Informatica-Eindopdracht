extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in Global.PlayerSpells.size():
		var button = Button.new()
		button.text = GameData.Spells[Global.PlayerSpells[i][0]]["Name"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
