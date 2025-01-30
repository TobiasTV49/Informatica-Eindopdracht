extends Node2D
const MELEE_ENEMY = preload("res://Functionality/Scenes/enemy.tscn")
@onready var player: CharacterBody2D = $PlayerBody
@onready var spell_menu: Node2D = $CanvasLayer/SpellMenu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.player_death = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.player_health <= 0 and Global.player_death == false: #player is about to die
		Global.player_death = true
		#player.queue_free()
	if Global.WaveCompleted == true:
		spell_menu.show()
	else:
		spell_menu.hide()


func _on_button_pressed() -> void:
	var melee_enemy = MELEE_ENEMY.instantiate()
	$Enemies.add_child(melee_enemy)
