extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if name == "DungeonTest":
		$Action.set_script(load("res://Tests/Action.gd"))
	elif name == "DungeonExit":
		$Action.set_script(load("res://Tests/DugneonExit1.gd"))
