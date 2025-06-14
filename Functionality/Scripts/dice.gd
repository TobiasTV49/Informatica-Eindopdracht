extends AnimatedSprite2D
const DICE_SIDES = 20
signal roll_dice

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	roll_dice.connect(roll)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func roll():
	$"../DiceAnimation".play("RESET")
	visible = true
	var outcome
	for i in range(0, 10):
		await get_tree().create_timer(0.1).timeout
		var x = randi_range(1, DICE_SIDES)
		play(str(x))
	
	outcome = get_animation()
	play(outcome)
	modifier(outcome)

func modifier(outcome):
	var critical_fail: Array = ["1"]
	var fail: Array = ["2", "3", "4", "5"]
	var moderate_fail: Array = ["6", "7", "8", "9"]
	var neutral: Array = ["10"]
	var moderate_succes: Array = ["11", "12", "13", "14"]
	var succes: Array = ["15", "16", "17", "18", "19"]
	var critical_succes: Array = ["20"]
	
	#checks which category the outcome falls into, and applies the correct modifier
	if critical_fail.has(outcome):
		pass
	elif fail.has(outcome):
		pass
	elif moderate_fail.has(outcome):
		pass
	elif neutral.has(outcome):
		pass
	elif moderate_succes.has(outcome):
		pass
	elif succes.has(outcome):
		pass
	elif critical_succes.has(outcome):
		pass
	
	await get_tree().create_timer(2).timeout
	$"../DiceAnimation".play("Dice")
