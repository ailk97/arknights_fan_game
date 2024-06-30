extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#
#
#func _on_ctrl_inventory_grid_ex_selection_changed():
	#var item3 = $ui/Shop/CtrlInventoryGridEx.get_selected_inventory_item()
	#var hz1; var hz2; var hz3; var hz4; var hz5; var hz6
	#if not item3 == null:
		#$ui/Shop/Item_Per/ItemName.text = item3.get_property("name")
		## Первый слот #
		#if item3.get_property("dmg"):
			#$ui/Shop/Item_Per/Pers1/Per1.text = "Урон: " + str(item3.get_property("dmg"))
			#hz1 = "dmg"
		#elif item3.get_property("pdef"):
			#$ui/Shop/Item_Per/Pers1/Per1.text = "Физ.Защита: " + str(item3.get_property("pdef"))
			#hz1 = "pdef"
		#elif item3.get_property("mdef"):
			#$ui/Shop/Item_Per/Pers1/Per1.text = "Маг.Защита: " + str(item3.get_property("mdef"))
			#hz1 = "mdef"
		#else:
			#$ui/Shop/Item_Per/Pers1/Per1.text = ""
			#hz1 = null
		## Второй слот #
		#if item3.get_property("pdef") and not hz1 == "pdef":
			#$ui/Shop/Item_Per/Pers1/Per2.text = "Физ.Защита: " + str(item3.get_property("pdef"))
			#hz2 = "pdef"
		#elif item3.get_property("mdef") and not hz1 == "mdef":
			#$ui/Shop/Item_Per/Pers1/Per2.text = "Маг.Защита: " + str(item3.get_property("mdef"))
			#hz2 = "mdef"
		#else:
			#$ui/Shop/Item_Per/Pers1/Per2.text = ""
			#hz2 = null
		## Третий слот #
		#if item3.get_property("mdef") and not hz2 == "mdef" and not hz1 == "mdef":
			#$ui/Shop/Item_Per/Pers1/Per3.text = "Маг.Защита: " + str(item3.get_property("mdef"))
			#hz3 = "mdef"
		#else:
			#$ui/Shop/Item_Per/Pers1/Per3.text = ""
			#hz3 = null
		##
		##
		##
		#if item3.get_property("str"):
			#$ui/Shop/Item_Per/Pers2/Per1.text = "Сила: " + str(item3.get_property("str"))
			#hz4 = "str"
		#elif item3.get_property("agi"):
			#$ui/Shop/Item_Per/Pers2/Per1.text = "Ловкость: " + str(item3.get_property("agi"))
			#hz4 = "agi"
		#elif item3.get_property("int"):
			#$ui/Shop/Item_Per/Pers2/Per1.text = "Интеллект: " + str(item3.get_property("int"))
			#hz4 = "int"
		#else:
			#$ui/Shop/Item_Per/Pers2/Per1.text = ""
			#hz4 = null
		#if item3.get_property("agi") and not hz4 == "agi":
			#$ui/Shop/Item_Per/Pers2/Per2.text = "Ловкость: " + str(item3.get_property("agi"))
			#hz5 = "agi"
		#elif item3.get_property("int") and not hz4 == "int":
			#$ui/Shop/Item_Per/Pers2/Per2.text = "Интеллект: " + str(item3.get_property("int"))
			#hz5 = "int"
		#else:
			#$ui/Shop/Item_Per/Pers2/Per2.text = ""
			#hz5 = null
		#if item3.get_property("int") and not hz4 == "int" and not hz5 == "int":
			#$ui/Shop/Item_Per/Pers2/Per3.text = "Интеллект: " + str(item3.get_property("int"))
			#hz6 = "int"
		#else:
			#$ui/Shop/Item_Per/Pers2/Per3.text = ""
			#hz6 = null
	#else:
		#$ui/Shop/Item_Per/ItemName.text = ""
		#$ui/Shop/Item_Per/Pers1/Per1.text = ""
		#$ui/Shop/Item_Per/Pers1/Per2.text = ""
		#$ui/Shop/Item_Per/Pers1/Per3.text = ""
		#$ui/Shop/Item_Per/Pers1/Per4.text = ""
		#$ui/Shop/Item_Per/Pers2/Per1.text = ""
		#$ui/Shop/Item_Per/Pers2/Per2.text = ""
		#$ui/Shop/Item_Per/Pers2/Per3.text = ""
		#$ui/Shop/Item_Per/Pers2/Per4.text = ""


func _on_ctrl_inventory_grid_ex_item_mouse_entered(item):
	var item3 = item
	var hz1; var hz2; var hz3; var hz4; var hz5; var hz6
	if item3.get_property("name"):
		$ui/Shop/Item_Per/ItemName.text = item3.get_property("name")
		# Первый слот #
		if item3.get_property("dmg"):
			$ui/Shop/Item_Per/Pers1/Per1.text = "Урон: " + str(item3.get_property("dmg"))
			hz1 = "dmg"
		elif item3.get_property("pdef"):
			$ui/Shop/Item_Per/Pers1/Per1.text = "Физ.Защита: " + str(item3.get_property("pdef"))
			hz1 = "pdef"
		elif item3.get_property("mdef"):
			$ui/Shop/Item_Per/Pers1/Per1.text = "Маг.Защита: " + str(item3.get_property("mdef"))
			hz1 = "mdef"
		else:
			$ui/Shop/Item_Per/Pers1/Per1.text = ""
			hz1 = null
		# Второй слот #
		if item3.get_property("pdef") and not hz1 == "pdef":
			$ui/Shop/Item_Per/Pers1/Per2.text = "Физ.Защита: " + str(item3.get_property("pdef"))
			hz2 = "pdef"
		elif item3.get_property("mdef") and not hz1 == "mdef":
			$ui/Shop/Item_Per/Pers1/Per2.text = "Маг.Защита: " + str(item3.get_property("mdef"))
			hz2 = "mdef"
		else:
			$ui/Shop/Item_Per/Pers1/Per2.text = ""
			hz2 = null
		# Третий слот #
		if item3.get_property("mdef") and not hz2 == "mdef" and not hz1 == "mdef":
			$ui/Shop/Item_Per/Pers1/Per3.text = "Маг.Защита: " + str(item3.get_property("mdef"))
			hz3 = "mdef"
		else:
			$ui/Shop/Item_Per/Pers1/Per3.text = ""
			hz3 = null
		#
		#
		#
		if item3.get_property("str"):
			$ui/Shop/Item_Per/Pers2/Per1.text = "Сила: " + str(item3.get_property("str"))
			hz4 = "str"
		elif item3.get_property("agi"):
			$ui/Shop/Item_Per/Pers2/Per1.text = "Ловкость: " + str(item3.get_property("agi"))
			hz4 = "agi"
		elif item3.get_property("int"):
			$ui/Shop/Item_Per/Pers2/Per1.text = "Интеллект: " + str(item3.get_property("int"))
			hz4 = "int"
		else:
			$ui/Shop/Item_Per/Pers2/Per1.text = ""
			hz4 = null
		if item3.get_property("agi") and not hz4 == "agi":
			$ui/Shop/Item_Per/Pers2/Per2.text = "Ловкость: " + str(item3.get_property("agi"))
			hz5 = "agi"
		elif item3.get_property("int") and not hz4 == "int":
			$ui/Shop/Item_Per/Pers2/Per2.text = "Интеллект: " + str(item3.get_property("int"))
			hz5 = "int"
		else:
			$ui/Shop/Item_Per/Pers2/Per2.text = ""
			hz5 = null
		if item3.get_property("int") and not hz4 == "int" and not hz5 == "int":
			$ui/Shop/Item_Per/Pers2/Per3.text = "Интеллект: " + str(item3.get_property("int"))
			hz6 = "int"
		else:
			$ui/Shop/Item_Per/Pers2/Per3.text = ""
			hz6 = null
	else:
		$ui/Shop/Item_Per/ItemName.text = ""
		$ui/Shop/Item_Per/Pers1/Per1.text = ""
		$ui/Shop/Item_Per/Pers1/Per2.text = ""
		$ui/Shop/Item_Per/Pers1/Per3.text = ""
		$ui/Shop/Item_Per/Pers1/Per4.text = ""
		$ui/Shop/Item_Per/Pers2/Per1.text = ""
		$ui/Shop/Item_Per/Pers2/Per2.text = ""
		$ui/Shop/Item_Per/Pers2/Per3.text = ""
		$ui/Shop/Item_Per/Pers2/Per4.text = ""
