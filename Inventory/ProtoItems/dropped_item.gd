extends Node2D

@onready var inventory = $InventoryGrid
#@onready var item = $InventoryGrid/_Node_49668
var item
var MouseOver = false
var LeftButton
var pickup_radius
var player_inventory
var player_inventory1

# Called when the node enters the scene tree for the first time.
func apply_text():
	item = inventory.get_item_at(Vector2i(0,0))
	$item_shit/item.texture = load(item.get_property("image"))

func can_pickup():
	print("
		⟳ Пытаемся подобрать предмет... ⟳")
	player_inventory1 = player_inventory.get_node("ui/InventoryPanel/Panel/Inventory/InventoryGrid")
	if pickup_radius == true:
		#print(player_inventory1.find_free_place(item))
		if player_inventory1.find_free_place(item).success == true:
			print("	✔ Удалось подобрать предмет! ✔
			")
			player_inventory.get_node("Equip").play()
			#print(player_inventory.find_free_place(item))
			inventory.transfer_to(item, player_inventory1, player_inventory1.find_free_place(item).position)
			queue_free()
		else:
			print("	◬ Неудалось подобрать предмет: нету места! ◬
			")

func _input(_event):
	if Input.is_action_just_pressed("pickup"):
		if MouseOver == true:
			can_pickup()
	#if event is InputEventMouseButton:
		#LeftButton = event.pressed
		#if LeftButton == false:
			#if MouseOver == true:
				#can_pickup()

func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group("player"):
		pickup_radius = true
		player_inventory = area.owner
func _on_area_2d_area_exited(area):
	if area.get_parent().is_in_group("player"):
		pickup_radius = false


func _on_item_shit_mouse_entered():
	if pickup_radius == true:
		$Panel.visible = true
		$item_shit/item.use_parent_material = false
		MouseOver = true
func _on_item_shit_mouse_exited():
	$Panel.visible = false
	$item_shit/item.use_parent_material = true
	MouseOver = false
