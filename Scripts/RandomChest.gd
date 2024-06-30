extends Area2D

var type = "chest"

func action():
	#Events.openChest_random(get_parent().get_node("InventoryGrid").serialize(), get_parent())
	get_parent().drop_item()
