extends Area2D

var type = "chest"

func action():
	Events.openning_chest = true
	Events.openChest()
