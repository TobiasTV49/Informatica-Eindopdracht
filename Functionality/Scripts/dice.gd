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
	var outcome
	outcome = randi_range(1, DICE_SIDES)
	$Label.text = "Dice: " + str(outcome)
	return outcome
