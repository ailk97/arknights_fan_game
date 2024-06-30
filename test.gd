extends Panel

func _on_ctrl_inventory_grid_ex_inventory_item_activated(item):
	weapon_replace(item)

func weapon_replace(item):
	$Equipment/InventoryGrid.add_item(item)
	#$Equipment/MainWeapon.equipped_item = 0
