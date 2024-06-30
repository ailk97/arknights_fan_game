extends Node2D

var items_generated = false
var loot = ["Weapon2", "Weapon3", "Weapon4", "Weapon5", "Weapon6","Weapon7","Weapon8",
"Weapon9","Weapon10","Weapon11","Weapon12","Weapon13","Weapon14","Weapon15","Weapon16","Weapon17",
"Weapon18","Weapon19","Weapon20"]

func _ready():
	#if Events.new_save == true:
		#if items_generated == false:
	print("	Генерируем предметы...")
	randomize()
	var item_ = loot.pick_random()
	$InventoryGrid.create_and_add_item(item_)
	item_ = loot.pick_random()
	$InventoryGrid.create_and_add_item(item_)
	item_ = loot.pick_random()
	$InventoryGrid.create_and_add_item(item_)
	#items_generated = true
	print("	Генерация завершена!
	")

func drop_item():
	var _pisya = null
	var items_ = $InventoryGrid.get_item_count()
	#var dropping = 3
	for aboba in items_:
		randomize()
		var item_drop1 = preload("res://Inventory/ProtoItems/dropped_item.tscn")
		var item_drop = item_drop1.instantiate()
		get_parent().add_child(item_drop)
		$InventoryGrid.transfer($InventoryGrid.get_item_at(Vector2i(0,0)), item_drop.get_node("InventoryGrid"))
		$InventoryGrid.sort()
		item_drop.apply_text()
		item_drop.position.x = global_position.x + randi_range(-30, 30)
		item_drop.position.y = global_position.y + randi_range(-30, 30) + 42
		print(item_drop.position.x, " ", item_drop.position.y)
	#get_tree().get_first_node_in_group("player").dialog(_pisya)
	queue_free()
