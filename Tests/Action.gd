extends Area2D
var type = "area"
# Called when the node enters the scene tree for the first time.
func action():
	Events.can_use = false
	var player = get_tree().get_nodes_in_group("player")
	
	await blackScreen(player)
	
	Events.PlayerSave(player)
	
	#var ability1; var ability2
	#if not player[0].get_node("ui/AbilityPanel").AbilityActive1 == null:
		#ability1 = "ui/AbilityPanel/Panel/" + player[0].get_node("ui/AbilityPanel").AbilityActive1.type + "/" + player[0].get_node("ui/AbilityPanel").AbilityActive1.id
	#if not player[0].get_node("ui/AbilityPanel").AbilityActive2 == null:
		#ability2 = "ui/AbilityPanel/Panel/" + player[0].get_node("ui/AbilityPanel").AbilityActive2.type + "/" + player[0].get_node("ui/AbilityPanel").AbilityActive2.id
	#var Ability = {"Ability1" : ability1, "Ability2" : ability2}
	#print("Ability", Ability)
	#var AbilityData = PackedDataContainer.new()
	#AbilityData.pack(Ability)
	#ResourceSaver.save(AbilityData, "Save/AbilityData.res")
	#
	#var InvData = player[0].get_node("ui/InventoryPanel/Panel/Inventory/InventoryGrid").serialize()
	#var InvPack = JSON.new()
	#InvPack.set_data(InvData)
	#ResourceSaver.save(InvPack, "Save/InvPack.json")
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
	
	var spawnData = owner
	var spawnPackedData = PackedScene.new()
	spawnPackedData.pack(spawnData)
	ResourceSaver.save(spawnPackedData, "user://Save/spawnPackedData.tscn")
	
	
	if Events.dungeon1_generated == false:
		#var dungeon1 = preload("res://Tests/generateTest.tscn")
		SceneLoader.sceneChange("res://Tests/generateTest.tscn")
		#get_tree().change_scene_to_packed(dungeon1)
	else:
		SceneLoader.sceneChange("user://Save/dungeon1PackedData.tscn")
		#get_tree().change_scene_to_file("user://Save/dungeon1PackedData.tscn")

func blackScreen(player):
	var _blackScren = player[0].get_node("ui/blackScreen")
	_blackScren.modulate.a = 0
	while not _blackScren.modulate.a >= 1:
		_blackScren.modulate.a += 0.05
		await get_tree().create_timer(0.01).timeout
