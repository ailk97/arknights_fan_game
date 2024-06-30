extends Area2D
var type = "area"
# Called when the node enters the scene tree for the first time.
func action():
	Events.can_use = false
	var player = get_tree().get_nodes_in_group("player")
	
	await blackScreen(player)
	
	Events.PlayerSave(player)
	
	##print(player)
	##var packedData = PackedScene.new()
	##packedData.pack(player[0])
	##ResourceSaver.save(packedData, "Save/packed_data.tscn")
	#
	##get_item_at(Vector2i(0,0)).get_property("id")
	#var mainWeapon
	#var Helmet
	#var Body
	#if not player[0].get_node("ui/InventoryPanel/Panel/Equipment/MainWeapon2").get_item_at(Vector2i(0,0)) == null:
		#mainWeapon = player[0].get_node("ui/InventoryPanel/Panel/Equipment/MainWeapon2").get_item_at(Vector2i(0,0)).get_property("id")
	#if not player[0].get_node("ui/InventoryPanel/Panel/Equipment/Helmet2").get_item_at(Vector2i(0,0)) == null:
		#Helmet = player[0].get_node("ui/InventoryPanel/Panel/Equipment/Helmet2").get_item_at(Vector2i(0,0)).get_property("id")
	#if not player[0].get_node("ui/InventoryPanel/Panel/Equipment/BodyArmor2").get_item_at(Vector2i(0,0)) == null:
		#Body = player[0].get_node("ui/InventoryPanel/Panel/Equipment/BodyArmor2").get_item_at(Vector2i(0,0)).get_property("id")
	#var EquipItems = {"Weapon":mainWeapon, "Helmet":Helmet, "BodyArmor":Body}
	#var EquipData = PackedDataContainer.new()
	#EquipData.pack(EquipItems)
	#ResourceSaver.save(EquipData, "Save/EquipData.res")
	#
	#var Сhar = {"Str":player[0].strength,
				#"Agi":player[0].agility,
				#"Int":player[0].intellect,
				#"HP":player[0].health,
				#"OR":player[0].originium,
				#"Lvl":player[0].level,
				#"Exp":player[0].experience,
				#"Lvl_points":player[0].points}
	#var СharData = PackedDataContainer.new()
	#СharData.pack(Сhar)
	#ResourceSaver.save(СharData, "Save/СharData.res")
	
	owner.remove_child(player[0])
	#print(player_delete)
	
	var dungeon1Data = owner
	var dungeon1PackedData = PackedScene.new()
	dungeon1PackedData.pack(dungeon1Data)
	ResourceSaver.save(dungeon1PackedData, "user://Save/dungeon1PackedData.tscn")
	
	if Events.spawn_generated == false:
		SceneLoader.sceneChange("res://1.tscn")
		#get_tree().change_scene_to_packed(Events.spawn)
		Events.spawn = true
	else:
		SceneLoader.sceneChange("user://Save/spawnPackedData.tscn")
		#get_tree().change_scene_to_file("user://Save/spawnPackedData.tscn")

func blackScreen(player):
	var _blackScren = player[0].get_node("ui/blackScreen")
	_blackScren.modulate.a = 0
	while not _blackScren.modulate.a >= 1:
		_blackScren.modulate.a += 0.05
		await get_tree().create_timer(0.01).timeout
