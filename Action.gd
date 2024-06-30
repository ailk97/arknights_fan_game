extends Area2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

var type = "dialog"

func action():
	#if get_parent().name == "ShopTest":
		#Events.dialogImage = "res://Игровые асеты/shopper.png"
	#else:
		#Events.dialogImage = "res://Игровые асеты/none.png"
	#print(get_parent().name)
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
